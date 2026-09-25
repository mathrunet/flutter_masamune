import "dart:convert";
import "dart:io";

import "package:katana_cli/action/cloudflare/deploy.dart";
import "package:katana_cli/action/cloudflare/init.dart";
import "package:katana_cli/action/cloudflare/tidb.dart";
import "package:katana_cli/katana_cli.dart";

/// edge/region Worker分割（生成・移行・TiDB振り分け・deploy）の回帰テスト。
Future<void> main() async {
  await _testLegacyEntryMigration();
  await _testLegacyEntryConflict();
  await _testRegionWorkerCreationAndTidb();
  await _testRegionDisabledKeepsEdge();
  stdout.writeln("Cloudflare region Worker regression checks passed");
}

void _check(bool condition, String message) {
  if (!condition) {
    throw StateError(message);
  }
}

Future<T> _inTemporaryProject<T>(
  String prefix,
  Future<T> Function(Directory root) body,
) async {
  final previous = Directory.current;
  final temp = await Directory.systemTemp.createTemp(prefix);
  try {
    Directory.current = temp;
    return await body(temp);
  } finally {
    Directory.current = previous;
    await temp.delete(recursive: true);
  }
}

/// Worker初期化済みプロジェクトの最小構成を作る。
void _writeWorkersProject() {
  Directory("cloudflare/src").createSync(recursive: true);
  File("cloudflare/.gitignore").writeAsStringSync(".dev.vars*\n");
  File("cloudflare/package.json").writeAsStringSync(jsonEncode({
    "dependencies": {
      "hono": "1.0.0",
      "@mathrunet/masamune": "1.0.0",
      "@mathrunet/masamune_cloudflare": "1.0.0",
      "@mathrunet/masamune_cloudflare_tidb": "3.7.5",
    },
  }));
  File("pubspec.yaml").writeAsStringSync("""
name: fixture
dependencies:
  masamune_functions_cloudflare: any
  masamune_model_tidb: any
  masamune_model_tidb_annotation: any
dev_dependencies:
  masamune_model_tidb_builder: any
""");
}

/// 呼び出し引数を記録するfake wrangler。
///
/// - `region-missing`があるとregion Workerの`deployments list`が失敗する。
/// - `edge-deploy-fail`があるとedge Workerの`deploy`が失敗する。
File _writeFakeWrangler(Directory root) {
  final wrangler = File("${root.path}/fake-wrangler.sh");
  final calls = "${root.path}/wrangler-calls.txt";
  wrangler.writeAsStringSync("""
#!/bin/sh
printf '%s\\n' "\$*" >> "$calls"
case "\$*" in *wrangler.region.jsonc*) region=1 ;; *) region=0 ;; esac
case "\$1" in
  secret)
    IFS= read -r value
    exit 0
    ;;
  deployments)
    if [ "\$region" = "1" ] && [ -f "${root.path}/region-missing" ]; then exit 1; fi
    exit 0
    ;;
  deploy)
    if [ "\$region" = "0" ] && [ -f "${root.path}/edge-deploy-fail" ]; then exit 1; fi
    if [ "\$region" = "1" ]; then rm -f "${root.path}/region-missing"; fi
    exit 0
    ;;
esac
exit 0
""");
  Process.runSync("chmod", ["+x", wrangler.path]);
  return wrangler;
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

Map<String, Object> _yaml(File wrangler, {required bool region}) {
  return {
    "bin": {"wrangler": wrangler.path},
    "firebase": {
      "project_id": {"dev": "firebase-dev", "prod": "firebase-prod"}
    },
    "cloudflare": {
      "project_id": {"dev": "app-dev", "prod": "app"},
      "workers": {
        "enable": true,
        "enable_firebase_auth": true,
        "region": {
          "enable": region,
          "placement": {"dev": "aws:ap-northeast-1", "prod": "aws:us-east-1"},
        },
      },
      "tidb": {
        "enable": true,
        "host": "fixture.invalid",
        "database": "main",
      },
    },
  };
}

const _secrets = {
  "cloudflare": {
    "tidb": {
      "username": {"dev": "runtime", "prod": "runtime"},
      "password": {"dev": "fixture", "prod": "fixture"},
    }
  }
};

ExecContext _context(Map<String, Object> yaml, String flavor) {
  final args = ["apply", "--flavor", flavor];
  final resolved = FlavorContext.resolve(
    yaml: yaml,
    secrets: _secrets,
    arguments: args,
  );
  return ExecContext(
    yaml: resolved.yaml,
    secrets: resolved.secrets,
    args: args,
    flavorContext: resolved,
  );
}

void _writeTidbSchema() {
  Directory("tidb/schema").createSync(recursive: true);
  File("tidb/schema/schema.json").writeAsStringSync(jsonEncode({
    "version": "1",
    "tables": [
      {"database": "main", "table": "items", "columns": []}
    ],
  }));
  Directory("cloudflare/node_modules/@mathrunet/masamune_cloudflare_tidb/dist")
      .createSync(recursive: true);
  File("cloudflare/node_modules/@mathrunet/masamune_cloudflare_tidb/dist/worker.js")
      .writeAsStringSync("");
}

/// 既存プロジェクトのindex.tsはedge.tsへ移行し、wrangler.jsoncのmainも追随する。
Future<void> _testLegacyEntryMigration() async {
  await _inTemporaryProject("katana-region-migrate-", (root) async {
    _writeWorkersProject();
    const legacy = """
import * as m from "@mathrunet/masamune_cloudflare";
import rules from "./rules.json";
export default m.deploy([
    customFunction(),
], { rules: rules as m.RulesConfig });
""";
    File("cloudflare/src/index.ts").writeAsStringSync(legacy);
    File("cloudflare/wrangler.jsonc").writeAsStringSync(
        '{\n  "name": "app",\n  "main": "src/index.ts",\n  "routes": ["example.invalid/*"]\n}\n');
    final wrangler = _writeFakeWrangler(root);
    await const CloudflareInitCliAction()
        .exec(_context(_yaml(wrangler, region: false), "prod"));
    _check(!File("cloudflare/src/index.ts").existsSync(),
        "index.ts must be moved to edge.ts.");
    _check(File("cloudflare/src/edge.ts").readAsStringSync() == legacy,
        "The migrated edge.ts must keep the existing source.");
    final source = File("cloudflare/wrangler.jsonc").readAsStringSync();
    _check(
        source.contains('"main": "src/edge.ts"') &&
            !source.contains("src/index.ts") &&
            source.contains('"routes": ["example.invalid/*"]'),
        "wrangler.jsonc main must point to src/edge.ts: $source");
    _check(!File("cloudflare/wrangler.region.jsonc").existsSync(),
        "region disabled projects must not get a region Worker.");
    _check(_calls(root).isEmpty,
        "Migration without region must not call wrangler: ${_calls(root)}");
  });
}

/// index.tsとedge.tsの両方がある場合は停止し、どちらも変更しない。
Future<void> _testLegacyEntryConflict() async {
  await _inTemporaryProject("katana-region-conflict-", (root) async {
    _writeWorkersProject();
    File("cloudflare/src/index.ts").writeAsStringSync("legacy\n");
    File("cloudflare/src/edge.ts").writeAsStringSync("edge\n");
    File("cloudflare/wrangler.jsonc")
        .writeAsStringSync('{"name": "app", "main": "src/index.ts"}');
    final wrangler = _writeFakeWrangler(root);
    var failed = false;
    try {
      await const CloudflareInitCliAction()
          .exec(_context(_yaml(wrangler, region: false), "prod"));
    } on StateError catch (e) {
      failed = e.message.contains("cloudflare/src/index.ts") &&
          e.message.contains("cloudflare/src/edge.ts");
    }
    _check(failed, "Both index.ts and edge.ts must stop with StateError.");
    _check(
        File("cloudflare/src/index.ts").readAsStringSync() == "legacy\n" &&
            File("cloudflare/src/edge.ts").readAsStringSync() == "edge\n" &&
            File("cloudflare/wrangler.jsonc")
                .readAsStringSync()
                .contains("src/index.ts"),
        "A conflict must not modify any entry or wrangler file.");
  });
}

/// region Workerの初回作成、TiDBのregion.tsへの振り分け、2ターゲットdeploy。
Future<void> _testRegionWorkerCreationAndTidb() async {
  await _inTemporaryProject("katana-region-tidb-", (root) async {
    _writeWorkersProject();
    _writeTidbSchema();
    // 既存edge WorkerにTiDBが登録されている状態から始める。
    File("cloudflare/src/edge.ts").writeAsStringSync("""
import * as m from "@mathrunet/masamune_cloudflare";
import rules from "./rules.json";
import tidbSchemaManifest from "./tidb_schema.json";
import * as tidb from "@mathrunet/masamune_cloudflare_tidb";
export default m.deploy([
    tidb.Functions.tidb({ schemaManifest: tidbSchemaManifest as tidb.SchemaManifest }),
    customFunction(),
], { type: "edge", rules: rules as m.RulesConfig });
""");
    File("cloudflare/wrangler.jsonc")
        .writeAsStringSync('{\n  "name": "app",\n  "main": "src/edge.ts"\n}\n');
    final wrangler = _writeFakeWrangler(root);
    final yaml = _yaml(wrangler, region: true);

    // 初回はregion Workerが存在しないためdeployで作成する。
    File("${root.path}/region-missing").writeAsStringSync("");
    await const CloudflareInitCliAction().exec(_context(yaml, "dev"));
    var calls = _calls(root);
    _check(
        calls.contains(
                "deployments list --json -c wrangler.region.jsonc --env dev") &&
            calls.contains("deploy -c wrangler.region.jsonc --env dev"),
        "The missing region Worker must be created by wrangler deploy: $calls");
    _check(
        !calls.any((call) =>
            call.startsWith("deploy") && !call.contains("wrangler.region")),
        "The edge Worker must not be created automatically: $calls");
    _check(File("cloudflare/src/region.ts").existsSync(),
        "region.ts must be generated.");
    _check(
        File("cloudflare/wrangler.region.jsonc")
            .readAsStringSync()
            .contains('"name": "app-dev-region"'),
        "wrangler.region.jsonc must contain the dev region Worker.");

    // 2回目は既存のためdeployしない。
    _clearCalls(root);
    await const CloudflareInitCliAction().exec(_context(yaml, "dev"));
    calls = _calls(root);
    _check(
        calls.length == 1 &&
            calls.single ==
                "deployments list --json -c wrangler.region.jsonc --env dev",
        "An existing region Worker must not be redeployed by init: $calls");

    // TiDBはregion.tsへ登録し、edge.tsから除去する。secretはregion設定へ入れる。
    _clearCalls(root);
    await const CloudflareTidbCliAction().exec(_context(yaml, "dev"));
    final region = File("cloudflare/src/region.ts").readAsStringSync();
    final edge = File("cloudflare/src/edge.ts").readAsStringSync();
    _check(
        region.contains("tidb.Functions.tidb(") &&
            region.contains(
                'import tidbSchemaManifest from "./tidb_schema.json";') &&
            region.contains('type: "region"'),
        "TiDB must be registered in region.ts: $region");
    _check(
        !edge.contains("tidb.Functions.tidb(") &&
            !edge.contains("masamune_cloudflare_tidb") &&
            !edge.contains("tidbSchemaManifest") &&
            edge.contains("customFunction(),") &&
            edge.contains('type: "edge"'),
        "TiDB must be removed from edge.ts without touching others: $edge");
    calls = _calls(root);
    final secrets = calls.where((call) => call.startsWith("secret put"));
    _check(
        secrets.length == 3 &&
            secrets.every((call) =>
                call.endsWith("--env dev -c wrangler.region.jsonc") &&
                RegExp(r"^secret put TIDB_(HOST|USERNAME|PASSWORD) ")
                    .hasMatch(call)),
        "TiDB secrets must target wrangler.region.jsonc: $calls");
    final regionAfterFirst = region;
    await const CloudflareTidbCliAction().exec(_context(yaml, "dev"));
    _check(
        File("cloudflare/src/region.ts").readAsStringSync() ==
                regionAfterFirst &&
            File("cloudflare/src/edge.ts").readAsStringSync() == edge,
        "Re-applying TiDB must be idempotent.");

    // deployはedge→regionの順に2ターゲットを処理する。
    _clearCalls(root);
    await const CloudflareDeployCliAction().exec(_context(yaml, "dev"));
    calls = _calls(root);
    _check(
        calls.join("\n") ==
            [
              "deployments list --json --env dev",
              "deploy --env dev",
              "deployments list --json -c wrangler.region.jsonc --env dev",
              "deploy -c wrangler.region.jsonc --env dev",
            ].join("\n"),
        "deploy must process edge and then region: $calls");

    // edgeが失敗したらregionは実行しない。
    _clearCalls(root);
    File("${root.path}/edge-deploy-fail").writeAsStringSync("");
    var failed = false;
    try {
      await const CloudflareDeployCliAction().exec(_context(yaml, "dev"));
    } on Exception {
      failed = true;
    }
    calls = _calls(root);
    _check(failed, "An edge deploy failure must stop the deployment.");
    _check(!calls.any((call) => call.contains("wrangler.region.jsonc")),
        "The region Worker must not be deployed after an edge failure: $calls");
    File("${root.path}/edge-deploy-fail").deleteSync();

    // region.tsがFirebase projectを別projectへ固定していれば、何もdeployしない。
    _clearCalls(root);
    final regionSource = File("cloudflare/src/region.ts").readAsStringSync();
    File("cloudflare/src/region.ts").writeAsStringSync(
        '$regionSource\nnew m.FirebaseAuthAdapter({ projectId: "other" });\n');
    var rejected = false;
    try {
      await const CloudflareDeployCliAction().exec(_context(yaml, "dev"));
    } on StateError catch (e) {
      rejected = e.message.contains("cloudflare/src/region.ts");
    }
    _check(rejected, "Firebase project validation must cover region.ts.");
    _check(_calls(root).isEmpty,
        "Validation failures must stop before any deploy: ${_calls(root)}");
    File("cloudflare/src/region.ts").writeAsStringSync(regionSource);
  });
}

/// region無効時はTiDBをedge.tsへ登録し、secretに`-c`を付けない。
Future<void> _testRegionDisabledKeepsEdge() async {
  await _inTemporaryProject("katana-region-disabled-", (root) async {
    _writeWorkersProject();
    _writeTidbSchema();
    File("cloudflare/src/edge.ts").writeAsStringSync("""
import * as m from "@mathrunet/masamune_cloudflare";
export default m.deploy([
], { type: "edge" });
""");
    File("cloudflare/wrangler.jsonc")
        .writeAsStringSync('{\n  "name": "app",\n  "main": "src/edge.ts"\n}\n');
    final wrangler = _writeFakeWrangler(root);
    final yaml = _yaml(wrangler, region: false);
    await const CloudflareInitCliAction().exec(_context(yaml, "prod"));
    _check(_calls(root).isEmpty,
        "Without region, init must not call wrangler: ${_calls(root)}");
    await const CloudflareTidbCliAction().exec(_context(yaml, "prod"));
    _check(
        File("cloudflare/src/edge.ts")
            .readAsStringSync()
            .contains("tidb.Functions.tidb("),
        "Without region, TiDB must stay in edge.ts.");
    _check(!File("cloudflare/src/region.ts").existsSync(),
        "Without region, region.ts must not be created.");
    final secrets =
        _calls(root).where((call) => call.startsWith("secret put")).toList();
    _check(
        secrets.length == 3 &&
            secrets.every((call) =>
                call.endsWith("--env prod") && !call.contains(" -c ")),
        "Without region, secrets must target wrangler.jsonc: $secrets");
    _clearCalls(root);
    await const CloudflareDeployCliAction().exec(_context(yaml, "prod"));
    _check(
        _calls(root).join("\n") ==
            ["deployments list --json --env prod", "deploy --env prod"]
                .join("\n"),
        "Without region, deploy must target only the edge Worker: ${_calls(root)}");
  });
}
