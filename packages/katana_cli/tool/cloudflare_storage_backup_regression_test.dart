import "dart:io";

import "package:katana_cli/action/cloudflare/storage.dart";
import "package:katana_cli/action/cloudflare/tidb_data_service_api.dart";
import "package:katana_cli/katana.dart";
import "package:katana_cli/katana_cli.dart";

Future<void> main() async {
  await _testTidbEndpointOwnership();
  await _testTidbOwnershipPersistenceOrder();
  await _testWranglerResponseHandling();

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
import * as m from "@mathrunet/masamune_cloudflare";

export default m.deploy([
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
    await wrangler.writeAsString(r"""
#!/bin/sh
STATE="${0}.notification"
CREATE_COUNT="${0}.notification-create-count"
QUEUE_STATE="${0}.queues"
if [ "$1" = "queues" ] && [ "$2" = "create" ]; then
  if [ -f "$QUEUE_STATE" ] && grep -Fqx "$3" "$QUEUE_STATE"; then
    printf "\033[31mQueue name '%s' is already taken. [code: 11009]\033[0m\n" "$3" >&2
    exit 1
  fi
  echo "$3" >> "$QUEUE_STATE"
  exit 0
fi
if [ "$1" = "r2" ] && [ "$2" = "bucket" ] && [ "$3" = "notification" ] && [ "$4" = "list" ]; then
  if [ -f "${0}.fatal-list" ]; then
    echo "Authentication failed. [code: 10000]" >&2
    exit 1
  fi
  if [ -f "$STATE" ]; then
    echo "rule_id: rule-1"
    echo "queue_name: my-app-storage-backup"
    echo "event_type: PutObject, CompleteMultipartUpload, CopyObject"
    exit 0
  fi
  printf "\033[31mNo event notification config found for bucket 'my-app-bucket': no configurations found for bucket. [code: 11015]\033[0m\n" >&2
  exit 1
fi
if [ "$1" = "r2" ] && [ "$2" = "bucket" ] && [ "$3" = "notification" ] && [ "$4" = "create" ]; then
  touch "$STATE"
  echo created >> "$CREATE_COUNT"
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

    final notificationCreates = await File(
      "${wrangler.path}.notification-create-count",
    ).readAsLines();
    _expect(
      notificationCreates.length == 1,
      "The R2 object-create notification must be created exactly once.",
    );
    final createdQueues = await File("${wrangler.path}.queues").readAsLines();
    _expect(
      createdQueues.toSet().length == 2 && createdQueues.length == 2,
      "The backup Queue and DLQ must be reused on repeated apply runs.",
    );

    await File("${wrangler.path}.fatal-list").create();
    var rejectedUnexpectedListError = false;
    try {
      await action.exec(context);
    } on Exception catch (error) {
      rejectedUnexpectedListError = error.toString().contains(
            "Failed to list Cloudflare R2 notifications",
          );
    }
    _expect(
      rejectedUnexpectedListError,
      "Only Cloudflare API code 11015 may be treated as an empty list.",
    );

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

Future<void> _testWranglerResponseHandling() async {
  const equivalentRule = """
rule_id: rule-1
queue_name: my-app-storage-backup
event_type: PutObject, CompleteMultipartUpload, CopyObject
""";
  final acceptedQueue = await _runWranglerScenario(
    queueExitCode: 1,
    queueStderr:
        "\u001b[31mQUEUE NAME 'MY-APP-STORAGE-BACKUP' IS ALREADY TAKEN. [ CODE: 11009 ]\u001b[0m",
    listStdout: equivalentRule,
  );
  _expect(
    acceptedQueue.error == null && acceptedQueue.notificationCreates == 0,
    "ANSI/case variants of code 11009 for the target Queue must be reused.",
  );
  for (final testCase in const [
    (
      name: "code 11009 for another Queue",
      output: "Queue name 'other-queue' is already taken. [code: 11009]",
    ),
    (
      name: "the target message without code 11009",
      output: "Queue name 'my-app-storage-backup' is already taken.",
    ),
    (
      name: "an authentication failure",
      output: "Authentication failed. [code: 10000]",
    ),
  ]) {
    final result = await _runWranglerScenario(
      queueExitCode: 1,
      queueStderr: testCase.output,
      listStdout: equivalentRule,
    );
    _expect(
      result.error?.contains("Failed to create Cloudflare Queue") ?? false,
      "${testCase.name} must remain fatal.",
    );
  }

  final acceptedUnconfigured = await _runWranglerScenario(
    listExitCode: 1,
    listStderr:
        "\u001b[31mNO EVENT NOTIFICATION CONFIG FOUND for bucket 'my-app-bucket': "
        "NO CONFIGURATIONS FOUND FOR BUCKET. [ CODE: 11015 ]\u001b[0m",
  );
  _expect(
    acceptedUnconfigured.error == null &&
        acceptedUnconfigured.notificationCreates == 1,
    "Only the complete ANSI/case variant of the unconfigured 11015 response "
    "must continue to notification creation.",
  );
  for (final testCase in const [
    (
      name: "code 11015 without the event-config message",
      output: "No configurations found for bucket. [code: 11015]",
    ),
    (
      name: "code 11015 without the bucket-config message",
      output: "No event notification config found. [code: 11015]",
    ),
    (
      name: "an authentication failure",
      output: "Authentication failed. [code: 10000]",
    ),
    (
      name: "a missing bucket",
      output: "The specified bucket does not exist. [code: 10006]",
    ),
    (
      name: "a transport failure",
      output: "Network connection failed while contacting api.cloudflare.com",
    ),
  ]) {
    final result = await _runWranglerScenario(
      listExitCode: 1,
      listStderr: testCase.output,
    );
    _expect(
      (result.error?.contains("Failed to list Cloudflare R2 notifications") ??
              false) &&
          result.notificationCreates == 0,
      "${testCase.name} must remain fatal.",
    );
  }

  for (final testCase in const [
    (name: "canonical rule", output: equivalentRule),
    (
      name: "ANSI/case/space/action-order variants",
      output: "\u001b[36m- RULE_ID : rule-1\u001b[0m\n"
          "  QUEUE_NAME :   MY-APP-STORAGE-BACKUP   \n"
          "  EVENT_TYPE : CopyObject, putobject,  CompleteMultipartUpload\n",
    ),
  ]) {
    final result = await _runWranglerScenario(listStdout: testCase.output);
    _expect(
      result.error == null && result.notificationCreates == 0,
      "${testCase.name} must be recognized as an equivalent notification.",
    );
  }
  for (final testCase in const [
    (
      name: "another Queue",
      output: "rule_id: rule-1\n"
          "queue_name: other-queue\n"
          "event_type: PutObject, CompleteMultipartUpload, CopyObject\n",
    ),
    (
      name: "a missing action",
      output: "rule_id: rule-1\n"
          "queue_name: my-app-storage-backup\n"
          "event_type: PutObject, CopyObject\n",
    ),
    (
      name: "an additional action",
      output: "rule_id: rule-1\n"
          "queue_name: my-app-storage-backup\n"
          "event_type: PutObject, CompleteMultipartUpload, CopyObject, DeleteObject\n",
    ),
    (
      name: "a duplicated action",
      output: "rule_id: rule-1\n"
          "queue_name: my-app-storage-backup\n"
          "event_type: PutObject, CompleteMultipartUpload, CopyObject, CopyObject\n",
    ),
    (
      name: "actions split across different rules",
      output: "rule_id: rule-1\n"
          "queue_name: my-app-storage-backup\n"
          "event_type: PutObject\n"
          "rule_id: rule-2\n"
          "queue_name: other-queue\n"
          "event_type: CompleteMultipartUpload, CopyObject\n",
    ),
    (
      name: "legacy description/object-create text",
      output:
          "my-app-storage-backup object-create Managed by katana: R2 backup\n",
    ),
  ]) {
    final result = await _runWranglerScenario(listStdout: testCase.output);
    _expect(
      result.error == null && result.notificationCreates == 1,
      "${testCase.name} must not be mistaken for an equivalent notification.",
    );
  }
}

Future<_WranglerScenarioResult> _runWranglerScenario({
  int queueExitCode = 0,
  String queueStdout = "",
  String queueStderr = "",
  int listExitCode = 0,
  String listStdout = "",
  String listStderr = "",
}) async {
  final originalDirectory = Directory.current;
  final temporary = await Directory.systemTemp.createTemp(
    "katana_cloudflare_wrangler_response_",
  );
  try {
    Directory.current = temporary;
    await Directory("cloudflare/src").create(recursive: true);
    await File("cloudflare/src/index.ts").writeAsString("""
import * as m from "@mathrunet/masamune_cloudflare";

export default m.deploy([
]);
""");
    await File("cloudflare/wrangler.jsonc").writeAsString("""
{
  "name": "test-worker",
  "main": "src/index.ts"
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
    final fixtureBase = "${wrangler.path}.fixture";
    await wrangler.writeAsString(r"""
#!/bin/sh
FIXTURE="${0}.fixture"
if [ "$1" = "queues" ] && [ "$2" = "create" ]; then
  cat "$FIXTURE.queue.stdout"
  cat "$FIXTURE.queue.stderr" >&2
  exit "$(cat "$FIXTURE.queue.exit")"
fi
if [ "$1" = "r2" ] && [ "$2" = "bucket" ] && [ "$3" = "notification" ] && [ "$4" = "list" ]; then
  cat "$FIXTURE.list.stdout"
  cat "$FIXTURE.list.stderr" >&2
  exit "$(cat "$FIXTURE.list.exit")"
fi
if [ "$1" = "r2" ] && [ "$2" = "bucket" ] && [ "$3" = "notification" ] && [ "$4" = "create" ]; then
  echo created >> "$FIXTURE.notification-creates"
  exit 0
fi
exit 0
""");
    await Future.wait([
      File("$fixtureBase.queue.stdout").writeAsString(queueStdout),
      File("$fixtureBase.queue.stderr").writeAsString(queueStderr),
      File("$fixtureBase.queue.exit").writeAsString("$queueExitCode"),
      File("$fixtureBase.list.stdout").writeAsString(listStdout),
      File("$fixtureBase.list.stderr").writeAsString(listStderr),
      File("$fixtureBase.list.exit").writeAsString("$listExitCode"),
    ]);
    await Process.run("chmod", ["+x", npm.path, wrangler.path]);

    final context = ExecContext(
      yaml: {
        "bin": {"npm": npm.path, "wrangler": wrangler.path},
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
              "dead_letter_queue": "",
            },
          },
        },
      },
      args: const [],
    );
    String? error;
    try {
      await const CloudflareStorageCliAction().exec(context);
    } on Exception catch (caught) {
      error = caught.toString();
    }
    final createFile = File("$fixtureBase.notification-creates");
    return _WranglerScenarioResult(
      error: error,
      notificationCreates:
          createFile.existsSync() ? (await createFile.readAsLines()).length : 0,
    );
  } finally {
    Directory.current = originalDirectory;
    await temporary.delete(recursive: true);
  }
}

class _WranglerScenarioResult {
  const _WranglerScenarioResult({
    required this.error,
    required this.notificationCreates,
  });

  final String? error;
  final int notificationCreates;
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
