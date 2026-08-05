import "dart:io";

import "package:katana_cli/action/cloudflare/storage.dart";
import "package:katana_cli/action/cloudflare/tidb_data_service_api.dart";
import "package:katana_cli/katana.dart";
import "package:katana_cli/katana_cli.dart";

Future<void> main() async {
  await _testTidbEndpointOwnership();
  await _testTidbOwnershipPersistenceOrder();

  final template = katanaYamlCode(true);
  _expectCount(template, "    backup:", 1);
  _expectCount(template, "      binding: R2_BACKUP_BUCKET", 1);
  _expectCount(template, "      max_concurrency:", 0);
  _expectCount(template, "      max_batch_size: 10", 1);
  _expectCount(template, "      dead_letter_queue:", 1);

  final originalDirectory = Directory.current;
  final temporary = await Directory.systemTemp.createTemp(
    "katana_cloudflare_storage_backup_",
  );
  try {
    Directory.current = temporary;
    await Directory("cloudflare/src").create(recursive: true);
    await File("cloudflare/src/index.ts").writeAsString("""
import * as mc from "@mathrunet/masamune_cloudflare";

export default mc.deploy([
]);
""");
    await File("cloudflare/wrangler.jsonc").writeAsString("""
{
  "name": "test-worker",
  "main": "src/index.ts",
  "upload_source_maps": true,
  "r2_buckets": [
    {
      "binding": "EXTRA_BUCKET",
      "bucket_name": "extra-bucket"
    }
  ],
  "queues": {
    "producers": [
      {
        "binding": "EXTRA_QUEUE",
        "queue": "extra-queue"
      }
    ]
  }
}
""");
    await File("pubspec.yaml").writeAsString("""
name: test_app
dependencies:
  masamune_storage_cloudflare: any
""");
    final npm = File("${temporary.path}/fake-npm.sh");
    await npm.writeAsString("""
#!/bin/sh
exit 0
""");
    final wrangler = File("${temporary.path}/fake-wrangler.sh");
    await wrangler.writeAsString("""
#!/bin/sh
STATE="\${0}.notification"
if [ "\$1" = "r2" ] && [ "\$2" = "bucket" ] && [ "\$3" = "notification" ] && [ "\$4" = "list" ]; then
  if [ -f "\$STATE" ]; then
    echo "my-app-storage-backup object-create Managed by katana: R2 backup"
  fi
  exit 0
fi
if [ "\$1" = "r2" ] && [ "\$2" = "bucket" ] && [ "\$3" = "notification" ] && [ "\$4" = "create" ]; then
  touch "\$STATE"
  exit 0
fi
exit 0
""");
    await Process.run("chmod", ["+x", npm.path, wrangler.path]);

    final context = ExecContext(
      yaml: {
        "bin": {
          "npm": npm.path,
          "wrangler": wrangler.path,
        },
        "cloudflare": {
          "storage": {
            "enable": true,
            "binding": "R2_BUCKET",
            "bucket_name": "my-app-bucket",
            "public_base_url": "https://assets.example.com",
            "backup": {
              "enable": true,
              "binding": "R2_BACKUP_BUCKET",
              "bucket_name": "my-app-bucket-backup",
              "queue_name": "my-app-storage-backup",
            },
          },
        },
      },
      args: const [],
    );
    const action = CloudflareStorageCliAction();
    await action.exec(context);
    await action.exec(context);

    final index = await File("cloudflare/src/index.ts").readAsString();
    _expectCount(index, "storage.Functions.storageCloudflare(", 1);
    _expectCount(index, "storage.Functions.storageCloudflareBackup(", 1);

    final wranglerSource =
        await File("cloudflare/wrangler.jsonc").readAsString();
    _expectCount(wranglerSource, '"binding": "EXTRA_BUCKET"', 1);
    _expectCount(wranglerSource, '"binding": "R2_BUCKET"', 1);
    _expectCount(wranglerSource, '"binding": "R2_BACKUP_BUCKET"', 1);
    _expectCount(wranglerSource, '"binding": "EXTRA_QUEUE"', 1);
    _expectCount(wranglerSource, '"queue": "my-app-storage-backup"', 1);
    _expectCount(wranglerSource, '"max_concurrency": 1', 1);
  } finally {
    Directory.current = originalDirectory;
    await temporary.delete(recursive: true);
  }
}

Future<void> _testTidbOwnershipPersistenceOrder() async {
  final source = await File("lib/action/cloudflare/tidb.dart").readAsString();
  _expectCount(source, "await _writeEndpointOwnershipState(", 3);
  for (final deployment in [
    '"Initialize Katana endpoint ownership.",',
    '"Synchronize Masamune endpoints before cutover.",',
    '"Deploy Masamune endpoints.");',
  ]) {
    final deploymentIndex = source.indexOf(deployment);
    final persistenceIndex = source.indexOf(
      "await _writeEndpointOwnershipState(",
      deploymentIndex,
    );
    _expect(
      deploymentIndex >= 0 && persistenceIndex > deploymentIndex,
      "Endpoint ownership must be persisted only after `$deployment`.",
    );
  }
  _expect(
    !source.contains("for (final entry in existing.entries)"),
    "Unowned Masamune endpoints must not be deleted by a global tag sweep.",
  );
}

Future<void> _testTidbEndpointOwnership() async {
  const removed = TidbManagedEndpointOwnership(
    name: "dataApps/app-1/endpoints/1",
    method: "POST",
    path: "/main/removed/delete",
  );
  const retained = TidbManagedEndpointOwnership(
    name: "dataApps/app-1/endpoints/2",
    method: "GET",
    path: "/main/retained/get",
  );
  const state = TidbEndpointOwnershipState(
    appId: "app-1",
    endpoints: [removed, retained],
  );

  final decoded = TidbEndpointOwnershipState.decode(state.encode());
  _expect(decoded.belongsTo("app-1"), "Ownership state lost its Data App.");
  _expect(
    !decoded.belongsTo("app-2"),
    "Ownership state must not cross Data Apps.",
  );
  final stale = decoded.staleEndpoints(
    currentAppId: "app-1",
    desiredKeys: {retained.key},
  ).toList();
  _expect(
    stale.length == 1 && stale.single.name == removed.name,
    "Only a previously deployed endpoint removed by the builder may be stale.",
  );
  _expect(
    decoded.staleEndpoints(
      currentAppId: "app-2",
      desiredKeys: const {},
    ).isEmpty,
    "Endpoints from a different Data App must never be stale.",
  );
  _expect(
    removed.matchesEndpoint({
      "name": removed.name,
      "method": "post",
      "path": removed.path,
    }),
    "Exact endpoint ownership was not recognized.",
  );
  _expect(
    !removed.matchesEndpoint({
      "name": "dataApps/app-1/endpoints/replaced",
      "method": removed.method,
      "path": removed.path,
    }),
    "A replaced remote resource must not inherit endpoint ownership.",
  );

  final api = _PagedTidbCloudManagementApi();
  try {
    final endpoints = await listTidbDataServicePages(
      api,
      "dataApps/app-1/endpoints",
      "endpoints",
    );
    _expect(
      endpoints.length == 101,
      "Endpoint ownership reconciliation must read every API page.",
    );
    _expect(
      api.pageTokens.length == 2 &&
          api.pageTokens.first == null &&
          api.pageTokens.last == "page-2",
      "Endpoint pagination tokens were not followed correctly.",
    );
  } finally {
    api.close();
  }
}

class _PagedTidbCloudManagementApi extends TidbCloudManagementApi {
  _PagedTidbCloudManagementApi() : super(publicKey: "test", privateKey: "test");

  final List<String?> pageTokens = [];

  @override
  Future<Map<String, dynamic>> dataService(
    String method,
    String path, {
    Map<String, String>? query,
    Object? body,
  }) async {
    final token = query?["pageToken"];
    pageTokens.add(token);
    if (token == null) {
      return {
        "endpoints": [
          for (var index = 0; index < 100; index++)
            {
              "name": "dataApps/app-1/endpoints/$index",
              "method": "GET",
              "path": "/main/items/$index",
            },
        ],
        "nextPageToken": "page-2",
      };
    }
    return {
      "endpoints": [
        {
          "name": "dataApps/app-1/endpoints/100",
          "method": "GET",
          "path": "/main/items/100",
        },
      ],
    };
  }
}

void _expect(bool condition, String message) {
  if (!condition) {
    throw StateError(message);
  }
}

void _expectCount(String source, String pattern, int expected) {
  final actual = RegExp(RegExp.escape(pattern)).allMatches(source).length;
  if (actual != expected) {
    throw StateError(
      "Expected `$pattern` $expected time(s), but found $actual.\n$source",
    );
  }
}
