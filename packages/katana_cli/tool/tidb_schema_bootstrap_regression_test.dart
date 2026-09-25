import "dart:convert";
import "dart:io";
import "package:katana_cli/action/cloudflare/turso.dart";
import "package:katana_cli/action/cloudflare/tidb.dart";
import "package:katana_cli/katana_cli.dart";

Future<void> main() async {
  check(tursoNativeColumnType("VECTOR(3)") == "F32_BLOB(3)",
      "native vector変換に失敗しました。");
  check(tursoNativeColumnType("JSON") == "JSON", "通常型を変更しました。");
  final original = Directory.current;
  final temporary = await Directory.systemTemp.createTemp("tidb_schema_cli_");
  try {
    Directory.current = temporary;
    Directory("lib/models").createSync(recursive: true);
    Map<String, dynamic> fragment(String name) => {
          "schemaDirPath": "tidb/schema",
          "schema": {
            "version": "1",
            "tables": [
              {
                "database": "main",
                "table": name,
                "columns": [
                  {"name": "id", "sqlType": "VARCHAR(255)", "nullable": false}
                ],
                "primaryKey": ["id"],
                "indexes": [],
                "vectorFields": []
              }
            ]
          },
        };
    for (final name in ["a", "b"]) {
      File("lib/models/$name.dart").writeAsStringSync("// 生成入力\n");
      File("lib/models/$name.tidb_schema")
          .writeAsStringSync(jsonEncode(fragment(name)));
    }
    finalizeTidbSchema();
    final schema = File("tidb/schema/schema.json");
    final initial = schema.readAsStringSync();
    finalizeTidbSchema();
    check(schema.readAsStringSync() == initial, "再生成でhashが変わりました。");
    File("lib/models/a.tidb_schema")
        .writeAsStringSync(jsonEncode(fragment("a2")));
    finalizeTidbSchema();
    check(
        (jsonDecode(schema.readAsStringSync())["tables"] as List)
                .map((e) => e["table"])
                .join(",") ==
            "a2,b",
        "未変更モデルが欠落しました。");
    File("lib/models/b.dart").deleteSync();
    finalizeTidbSchema();
    check((jsonDecode(schema.readAsStringSync())["tables"] as List).length == 1,
        "削除済み入力が残りました。");
    Directory("cloudflare/src").createSync(recursive: true);
    Directory(
            "cloudflare/node_modules/@mathrunet/masamune_cloudflare_tidb/dist")
        .createSync(recursive: true);
    File("cloudflare/node_modules/@mathrunet/masamune_cloudflare_tidb/dist/worker.js")
        .writeAsStringSync("");
    // 既存projectと同じく、旧参照先のmanifest importとschemaManifest指定を持つ入口から始める。
    File("cloudflare/src/edge.ts").writeAsStringSync(
        'import tidbSchemaManifest from "../../tidb/schema/schema.json";\n'
        'export default m.deploy([tidb.Functions.tidb({ schemaManifest: tidbSchemaManifest as tidb.SchemaManifest, rules: rules, databasePrefix: "dev_" },), other()]);\n');
    final wrangler = File("${temporary.path}/wrangler-fixture.sh");
    wrangler.writeAsStringSync(r'''
#!/bin/sh
set -eu
[ "$1" = "secret" ] && [ "$2" = "put" ]
[ "$4" = "--env" ] && [ "$5" = "prod" ]
case "$3" in TIDB_HOST|TIDB_USERNAME|TIDB_PASSWORD) ;; *) exit 1;; esac
IFS= read -r value
case "$3" in
  TIDB_HOST) [ "$value" = "fixture.invalid" ] ;;
  TIDB_USERNAME) [ "$value" = "runtime" ] ;;
  TIDB_PASSWORD) [ "$value" = "fixture" ] ;;
esac
printf '%s\n' "$3" >> secret-names.txt
'''
        .trimLeft());
    await Process.run("chmod", ["+x", wrangler.path]);
    final context = ExecContext(yaml: {
      "bin": {"wrangler": wrangler.path},
      "cloudflare": {
        "tidb": {"enable": true, "host": "fixture.invalid", "database": "main"}
      },
    }, secrets: {
      "cloudflare": {
        "tidb": {
          "username": {"prod": "runtime", "dev": "other"},
          "password": {"prod": "fixture", "dev": "other"},
          "migration_username": "admin",
          "migration_password": "never_send"
        }
      }
    }, args: const []);
    await const CloudflareTidbCliAction().exec(context);
    final first = File("cloudflare/src/edge.ts").readAsStringSync();
    await const CloudflareTidbCliAction().exec(context);
    check(File("cloudflare/src/edge.ts").readAsStringSync() == first,
        "再applyで登録が重複しました。");
    check(RegExp(r"tidb.Functions.tidb\(").allMatches(first).length == 1,
        "公開入口が重複しました。");
    check(first.contains('rules: rules, databasePrefix: "dev_"'),
        "既存の認可・prefix設定を失いました。");
    check(first.contains("}), other()"), "既存の後続functionとの区切りを失いました。");
    check(!first.contains("},),"), "末尾カンマ付きの引数を不正なspread式へ変換しました。");
    check(
        RegExp(r"^import tidbSchemaManifest from ", multiLine: true)
                .allMatches(first)
                .length ==
            1,
        "manifest importが重複しました。");
    check(
        first.contains('import tidbSchemaManifest from "./tidb_schema.json";'),
        "manifest importの参照先を生成物へ差し替えていません。");
    check(!first.contains("...("), "schemaManifest指定済みの引数をspread式で包みました。");
    check(!first.contains("never_send"), "管理者資格情報を公開コードへ出力しました。");
    check(File("cloudflare/secret-names.txt").readAsLinesSync().length == 6,
        "runtimeの3secret以外を投入しました。");
    await testTidbPreflight();
    stdout.writeln("TiDB schema統合・削除反映・apply再実行・管理者資格情報分離: 成功");
  } finally {
    Directory.current = original;
    await temporary.delete(recursive: true);
  }
}

void check(bool condition, String message) {
  if (!condition) {
    throw StateError(message);
  }
}

/// 外部SQL操作より先にローカルの不足を検出する。
Future<void> testTidbPreflight() async {
  final node = File("${Directory.current.path}/node-fixture.sh");
  node.writeAsStringSync(r"""
#!/bin/sh
cat >/dev/null
printf invoked > node-invoked.txt
exit 1
"""
      .trimLeft());
  await Process.run("chmod", ["+x", node.path]);
  File("cloudflare/tidb.yaml").writeAsStringSync("""
cloudflare:
  tidb:
    runtime_users:
      prod:
        username: runtime
        password: fixture
        role: runtime_role
""");
  final package = File(
      "cloudflare/node_modules/@mathrunet/masamune_cloudflare_tidb/dist/worker.js");
  final index = File("cloudflare/src/edge.ts");
  final before = index.readAsStringSync();
  final context = ExecContext(yaml: {
    "bin": {"node": node.path},
    "cloudflare": {
      "tidb": {
        "enable": true,
        "host": "fixture.invalid",
        "database": "main",
        "cluster_id": "fixture-cluster"
      }
    },
  }, secrets: {
    "cloudflare": {
      "tidb": {"migration_username": "admin", "migration_password": "fixture"}
    },
  }, args: const []);
  for (final scenario in ["missing-package", "invalid-registration"]) {
    if (scenario == "missing-package") {
      package.deleteSync();
    } else {
      package.writeAsStringSync("");
      index.writeAsStringSync("export default {};\n");
    }
    final sourceBefore = index.readAsStringSync();
    await const CloudflareTidbCliAction().exec(context);
    check(!File("cloudflare/node-invoked.txt").existsSync(),
        "$scenario: ローカル前提不足なのに外部SQL操作を起動しました。");
    check(index.readAsStringSync() == sourceBefore,
        "$scenario: 失敗したapplyがWorkerを変更しました。");
    check(
        !File("cloudflare/tidb.yaml")
            .readAsStringSync()
            .contains("migration_users"),
        "$scenario: 失敗したapplyが資格情報状態を変更しました。");
  }
  index.writeAsStringSync(before);
}
