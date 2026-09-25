import "dart:convert";
import "dart:io";

import "package:katana_cli/action/cloudflare/init.dart";
import "package:katana_cli/action/cloudflare/storage.dart";
import "package:katana_cli/katana_cli.dart";

Future<void> main() async {
  _testUpsertAndRemoveRoutes();
  await _testInitCustomDomainRoutes();
  await _testStorageBucketAndCustomDomain();
  await _testStorageBackupFlavorEnable();
  stdout.writeln("Cloudflare custom domain regression checks passed");
}

/// upsertRoutes/removeRoutesは選択した環境だけを書き換え、冪等である。
void _testUpsertAndRemoveRoutes() {
  const source = '''
{
  "name": "app",
  "main": "src/edge.ts",
  "routes": [{ "pattern": "root.example.com/*" }]
}
''';
  var both = WranglerEnvironmentSynchronizer.synchronize(
    source,
    flavor: "dev",
    workerName: "app-dev",
    rootWorkerName: "app",
  );
  both = WranglerEnvironmentSynchronizer.synchronize(
    both,
    flavor: "prod",
    workerName: "app",
    rootWorkerName: "app",
  );
  final withDev = WranglerEnvironmentSynchronizer.upsertRoutes(
    both,
    flavor: "dev",
    customDomains: const ["api-edge-dev.example.com"],
  );
  _check(
    _env(withDev, "dev").contains(
          '{ "pattern": "api-edge-dev.example.com", "custom_domain": true }',
        ) &&
        !_env(withDev, "prod").contains("api-edge-dev.example.com") &&
        withDev.contains('"pattern": "root.example.com/*"'),
    "Routes must be added only to the dev environment: $withDev",
  );
  _check(
    WranglerEnvironmentSynchronizer.upsertRoutes(
          withDev,
          flavor: "dev",
          customDomains: const ["api-edge-dev.example.com"],
        ) ==
        withDev,
    "upsertRoutes must be idempotent.",
  );
  final replaced = WranglerEnvironmentSynchronizer.upsertRoutes(
    withDev,
    flavor: "dev",
    customDomains: const ["api-edge-dev2.example.com"],
  );
  _check(
    !_env(replaced, "dev").contains("api-edge-dev.example.com") &&
        _env(replaced, "dev").contains("api-edge-dev2.example.com"),
    "upsertRoutes must replace the whole routes array: $replaced",
  );
  final withVars = WranglerEnvironmentSynchronizer.upsertVariables(
    replaced,
    flavor: "dev",
    values: const {"FIREBASE_PROJECT_ID": "firebase-dev"},
  );
  _check(
    _env(withVars, "dev").contains("api-edge-dev2.example.com") &&
        _env(withVars, "dev").contains('"FIREBASE_PROJECT_ID": "firebase-dev"'),
    "Variables and routes must coexist in one environment: $withVars",
  );
  _decodeJsonc(withVars);
  final removed = WranglerEnvironmentSynchronizer.removeRoutes(
    withVars,
    flavor: "dev",
  );
  _check(
    !_env(removed, "dev").contains('"routes"') &&
        _env(removed, "dev")
            .contains('"FIREBASE_PROJECT_ID": "firebase-dev"') &&
        removed.contains('"pattern": "root.example.com/*"'),
    "removeRoutes must drop only the environment routes: $removed",
  );
  _decodeJsonc(removed);
  _check(
    WranglerEnvironmentSynchronizer.removeRoutes(removed, flavor: "dev") ==
        removed,
    "removeRoutes must be idempotent.",
  );
  final withProd = WranglerEnvironmentSynchronizer.upsertRoutes(
    removed,
    flavor: "prod",
    customDomains: const ["api-edge.example.com"],
  );
  final removedProd =
      WranglerEnvironmentSynchronizer.removeRoutes(withProd, flavor: "prod");
  _decodeJsonc(withProd);
  _decodeJsonc(removedProd);
  _check(
    !_env(removedProd, "prod").contains('"routes"'),
    "removeRoutes must handle the last property: $removedProd",
  );
}

/// initはedge/regionのWranglerへcustom_domainのroutesを書き、空なら削除する。
Future<void> _testInitCustomDomainRoutes() async {
  await _inTemporaryProject("katana-custom-domain-init-", (root) async {
    _writeWorkersProject();
    File("cloudflare/wrangler.jsonc")
        .writeAsStringSync('{\n  "name": "app",\n  "main": "src/edge.ts"\n}\n');
    final wrangler = _writeFakeWrangler(root);
    final yaml = <String, Object>{
      "bin": {"wrangler": wrangler.path},
      "firebase": {
        "project_id": {"dev": "firebase-dev", "prod": "firebase-prod"}
      },
      "cloudflare": {
        "project_id": {"dev": "app-dev", "prod": "app"},
        "workers": {
          "enable": true,
          "enable_firebase_auth": true,
          "custom_domain": <String, Object?>{
            "dev": "api-edge-dev.example.com",
            "prod": "api-edge.example.com",
          },
          "region": {
            "enable": true,
            "placement": {"dev": "aws:us-east-1", "prod": "aws:us-east-1"},
            "custom_domain": <String, Object?>{
              "dev": "api-region-dev.example.com",
              "prod": "api-region.example.com",
            },
          },
        },
      },
    };
    for (final flavor in ["dev", "prod", "dev"]) {
      await const CloudflareInitCliAction().exec(_context(yaml, flavor));
    }
    final edge = File("cloudflare/wrangler.jsonc").readAsStringSync();
    final region = File("cloudflare/wrangler.region.jsonc").readAsStringSync();
    _decodeJsonc(edge);
    _decodeJsonc(region);
    _check(
      _env(edge, "dev").contains(
            '{ "pattern": "api-edge-dev.example.com", "custom_domain": true }',
          ) &&
          _env(edge, "prod").contains(
            '{ "pattern": "api-edge.example.com", "custom_domain": true }',
          ) &&
          !_env(edge, "dev").contains("api-edge.example.com\"") &&
          !edge.contains("api-region"),
      "The edge Wrangler must contain per-flavor custom domains: $edge",
    );
    _check(
      _env(region, "dev").contains(
            '{ "pattern": "api-region-dev.example.com", "custom_domain": true }',
          ) &&
          _env(region, "prod").contains(
            '{ "pattern": "api-region.example.com", "custom_domain": true }',
          ) &&
          _env(region, "dev")
              .contains('"placement": { "region": "aws:us-east-1" }') &&
          !region.contains("api-edge"),
      "The region Wrangler must contain per-flavor custom domains: $region",
    );
    // 再適用で変化しない。
    await const CloudflareInitCliAction().exec(_context(yaml, "dev"));
    _check(
      File("cloudflare/wrangler.jsonc").readAsStringSync() == edge &&
          File("cloudflare/wrangler.region.jsonc").readAsStringSync() == region,
      "Re-applying custom domains must be idempotent.",
    );
    // devのドメインを外すとdevのroutesだけ削除される。
    final workers = (yaml["cloudflare"] as Map)["workers"] as Map;
    (workers["custom_domain"] as Map)["dev"] = "";
    ((workers["region"] as Map)["custom_domain"] as Map)["dev"] = null;
    await const CloudflareInitCliAction().exec(_context(yaml, "dev"));
    final edgeAfter = File("cloudflare/wrangler.jsonc").readAsStringSync();
    final regionAfter =
        File("cloudflare/wrangler.region.jsonc").readAsStringSync();
    _decodeJsonc(edgeAfter);
    _decodeJsonc(regionAfter);
    _check(
      !_env(edgeAfter, "dev").contains('"routes"') &&
          _env(edgeAfter, "prod").contains("api-edge.example.com") &&
          !_env(regionAfter, "dev").contains('"routes"') &&
          _env(regionAfter, "prod").contains("api-region.example.com"),
      "Clearing a custom domain must remove only that environment's routes: $edgeAfter\n$regionAfter",
    );
  });
}

/// storageはbucketとカスタムドメインを存在しない場合だけ作成し、
/// publicBaseUrlをWorker変数へ書き込む。
Future<void> _testStorageBucketAndCustomDomain() async {
  await _inTemporaryProject("katana-custom-domain-storage-", (root) async {
    _writeWorkersProject();
    File("cloudflare/wrangler.jsonc")
        .writeAsStringSync('{\n  "name": "app",\n  "main": "src/edge.ts"\n}\n');
    File("pubspec.yaml").writeAsStringSync(
      "name: test_app\ndependencies:\n  masamune_storage_cloudflare: any\n",
    );
    final wrangler = _writeFakeWrangler(root);
    final yaml = <String, Object>{
      "bin": {"wrangler": wrangler.path, "npm": wrangler.path},
      "cloudflare": {
        "project_id": {"dev": "app-dev", "prod": "app"},
        "zone_id": "zone-1",
        "workers": {"enable": true},
        "storage": {
          "enable": true,
          "bucket_name": {"dev": "app-dev", "prod": "app"},
          "custom_domain": {
            "dev": "https://Storage-dev.example.com/",
            "prod": "storage.example.com",
          },
          "backup": {
            "enable": {"dev": false, "prod": true},
            "bucket_name": {"dev": null, "prod": "app-backup"},
          },
        },
      },
    };
    const action = CloudflareStorageCliAction();
    await action.exec(_context(yaml, "dev"));
    await action.exec(_context(yaml, "dev"));
    var calls = _calls(root);
    _check(
      calls.where((call) => call == "r2 bucket create app-dev").length == 1 &&
          !calls.any((call) => call.contains("app-backup")),
      "The dev bucket must be created once and no backup bucket for dev: $calls",
    );
    _check(
      calls
              .where((call) =>
                  call ==
                  "r2 bucket domain add app-dev --domain storage-dev.example.com --zone-id zone-1")
              .length ==
          1,
      "The custom domain must be attached once with the zone ID: $calls",
    );
    _check(
      calls.indexOf("r2 bucket create app-dev") <
          calls.indexWhere((call) => call.startsWith("r2 bucket domain add")),
      "The bucket must be created before the custom domain: $calls",
    );
    final edge = File("cloudflare/src/edge.ts").readAsStringSync();
    _check(
      edge.contains("storage.Functions.storageCloudflare(") &&
          !edge.contains("publicBaseUrl"),
      "publicBaseUrl must not be embedded in edge.ts: $edge",
    );
    var source = File("cloudflare/wrangler.jsonc").readAsStringSync();
    _decodeJsonc(source);
    _check(
      _env(source, "dev").contains(
            '"STORAGE_PUBLIC_BASE_URL": "https://storage-dev.example.com"',
          ) &&
          !_env(source, "dev").contains("R2_BACKUP_BUCKET"),
      "The dev environment must expose the public base URL without backup: $source",
    );

    _clearCalls(root);
    await action.exec(_context(yaml, "prod"));
    calls = _calls(root);
    _check(
      calls.contains("r2 bucket create app") &&
          calls.contains("r2 bucket create app-backup") &&
          calls.contains(
            "r2 bucket domain add app --domain storage.example.com --zone-id zone-1",
          ) &&
          calls.indexOf("r2 bucket create app") <
              calls.indexWhere((call) => call.contains("notification")),
      "The prod buckets must be created before the backup notification: $calls",
    );
    source = File("cloudflare/wrangler.jsonc").readAsStringSync();
    _decodeJsonc(source);
    _check(
      _env(source, "prod").contains(
            '"STORAGE_PUBLIC_BASE_URL": "https://storage.example.com"',
          ) &&
          _env(source, "prod").contains('"bucket_name": "app-backup"') &&
          _env(source, "dev").contains(
            '"STORAGE_PUBLIC_BASE_URL": "https://storage-dev.example.com"',
          ) &&
          !_env(source, "dev").contains("R2_BACKUP_BUCKET"),
      "Each environment must keep its own public base URL and backup: $source",
    );

    // public_base_urlの明示指定はcustom_domainより優先する。
    final storage = (yaml["cloudflare"] as Map)["storage"] as Map;
    storage["public_base_url"] = {
      "dev": "https://cdn-dev.example.com",
      "prod": null
    };
    await action.exec(_context(yaml, "dev"));
    source = File("cloudflare/wrangler.jsonc").readAsStringSync();
    _check(
      _env(source, "dev").contains(
        '"STORAGE_PUBLIC_BASE_URL": "https://cdn-dev.example.com"',
      ),
      "An explicit public_base_url must take precedence: $source",
    );

    // zone_idが無い場合はドメイン接続前に停止する。
    _clearCalls(root);
    (yaml["cloudflare"] as Map)["zone_id"] = "";
    storage.remove("public_base_url");
    await action.exec(_context(yaml, "prod"));
    _check(
      isError && !_calls(root).any((call) => call.contains("domain add")),
      "A missing zone ID must be reported before attaching a domain: ${_calls(root)}",
    );
  });
}

/// backup.enableのdev/prod別指定でも、有効側だけにbackupの設定が入る。
Future<void> _testStorageBackupFlavorEnable() async {
  final yaml = <String, Object>{
    "cloudflare": {
      "storage": {
        "enable": true,
        "bucket_name": {"dev": "app-dev", "prod": "app"},
        "public_base_url": {
          "dev": "https://storage-dev.example.com",
          "prod": "https://storage.example.com",
        },
        "backup": {
          "enable": {"dev": false, "prod": true},
          "bucket_name": {"dev": null, "prod": "app-backup"},
        },
      },
    },
  };
  for (final flavor in ["dev", "prod"]) {
    final resolved = FlavorContext.resolve(
      yaml: yaml,
      secrets: const {},
      arguments: ["apply", "--flavor", flavor],
    );
    final backup = ((resolved.yaml["cloudflare"] as Map)["storage"]
        as Map)["backup"] as Map;
    _check(
      backup["enable"] == (flavor == "prod"),
      "backup.enable must resolve per flavor: $flavor -> ${backup["enable"]}",
    );
  }
}

File _writeFakeWrangler(Directory root) {
  final wrangler = File("${root.path}/fake-wrangler.sh");
  final calls = "${root.path}/wrangler-calls.txt";
  final buckets = "${root.path}/buckets.txt";
  final domains = "${root.path}/domains.txt";
  wrangler.writeAsStringSync("""
#!/bin/sh
printf '%s\\n' "\$*" >> "$calls"
case "\$*" in
  "secret put"*) IFS= read -r value; exit 0 ;;
  "r2 bucket list")
    if [ -f "$buckets" ]; then
      while IFS= read -r name; do printf 'name:           %s\\ncreation_date:  2026-01-01\\n\\n' "\$name"; done < "$buckets"
    fi
    exit 0 ;;
  "r2 bucket create "*) echo "\$4" >> "$buckets"; exit 0 ;;
  "r2 bucket domain list "*)
    if [ -f "$domains" ]; then
      while IFS= read -r line; do printf 'domain:  %s\\nenabled: Yes\\n' "\$line"; done < "$domains"
    fi
    exit 0 ;;
  "r2 bucket domain add "*) echo "\$7" >> "$domains"; exit 0 ;;
  "r2 bucket notification list "*)
    echo "rule_id: rule-1"; echo "queue_name: app-backup"; echo "event_type: PutObject, CompleteMultipartUpload, CopyObject"; exit 0 ;;
  deployments*) exit 0 ;;
esac
exit 0
""");
  Process.runSync("chmod", ["+x", wrangler.path]);
  return wrangler;
}

void _writeWorkersProject() {
  Directory("cloudflare/src").createSync(recursive: true);
  File("cloudflare/src/edge.ts").writeAsStringSync("""
import * as m from "@mathrunet/masamune_cloudflare";
export default m.deploy([
], { type: "edge" });
""");
  File("cloudflare/.gitignore").writeAsStringSync(".dev.vars*\n");
  File("cloudflare/package.json").writeAsStringSync(jsonEncode({
    "dependencies": {
      "hono": "1.0.0",
      "@mathrunet/masamune": "1.0.0",
      "@mathrunet/masamune_cloudflare": "1.0.0",
      "@mathrunet/masamune_cloudflare_storage": "1.0.0",
    },
  }));
  File("pubspec.yaml").writeAsStringSync(
    "name: test_app\ndependencies:\n  masamune_functions_cloudflare: any\n",
  );
}

ExecContext _context(Map<String, Object> yaml, String flavor) {
  final args = ["apply", "--flavor", flavor];
  final resolved = FlavorContext.resolve(
    yaml: yaml,
    secrets: const {},
    arguments: args,
  );
  return ExecContext(
    yaml: resolved.yaml,
    secrets: resolved.secrets,
    args: args,
    flavorContext: resolved,
  );
}

Future<void> _inTemporaryProject(
  String prefix,
  Future<void> Function(Directory root) body,
) async {
  final previous = Directory.current;
  final root = Directory.systemTemp.createTempSync(prefix);
  try {
    Directory.current = root;
    await body(root);
  } finally {
    Directory.current = previous;
    root.deleteSync(recursive: true);
  }
}

List<String> _calls(Directory root) {
  final file = File("${root.path}/wrangler-calls.txt");
  return file.existsSync() ? file.readAsLinesSync() : const [];
}

void _clearCalls(Directory root) {
  final file = File("${root.path}/wrangler-calls.txt");
  if (file.existsSync()) {
    file.deleteSync();
  }
}

String _env(String source, String flavor) {
  final managed = source.indexOf(WranglerEnvironmentSynchronizer.beginMarker);
  final section = source.substring(managed);
  final dev = section.indexOf('"dev"');
  final prod = section.indexOf('"prod"', dev < 0 ? 0 : dev + 1);
  if (flavor == "dev") {
    return dev < 0 ? "" : section.substring(dev, prod < 0 ? null : prod);
  }
  return prod < 0 ? "" : section.substring(prod);
}

/// コメントと末尾カンマを除いたJSONとして解釈できることを確認する。
Map _decodeJsonc(String source) {
  final stripped = source
      .replaceAll(RegExp(r"/\*[\s\S]*?\*/"), "")
      .replaceAll(RegExp(r"^\s*//.*$", multiLine: true), "")
      .replaceAllMapped(RegExp(r",(\s*[}\]])"), (match) => match[1]!);
  try {
    return jsonDecode(stripped) as Map;
  } on FormatException catch (error) {
    throw StateError("Generated Wrangler JSONC is invalid: $error\n$source");
  }
}

void _check(bool condition, String message) {
  if (!condition) {
    throw StateError(message);
  }
}
