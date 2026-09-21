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
    File("cloudflare/src/index.ts")
        .writeAsStringSync("export default m.deploy([]);\n");
    final wrangler = File("${temporary.path}/wrangler-fixture.sh");
    wrangler.writeAsStringSync(r'''
#!/bin/sh
set -eu
[ "$1" = "secret" ] && [ "$2" = "put" ]
[ "$4" = "--env" ] && [ "$5" = "prod" ]
case "$3" in TIDB_HOST|TIDB_USERNAME|TIDB_PASSWORD) ;; *) exit 1;; esac
cat >/dev/null
printf '%s\n' "$3" >> secret-names.txt
'''
        .trimLeft());
    await Process.run("chmod", ["+x", wrangler.path]);
    final context = ExecContext(yaml: {
      "bin": {"wrangler": wrangler.path},
      "cloudflare": {
        "tidb": {"enable": true, "host": "fixture.invalid"}
      },
    }, secrets: {
      "cloudflare": {
        "tidb": {
          "username": "runtime",
          "password": "fixture",
          "migration_username": "admin",
          "migration_password": "never_send"
        }
      }
    }, args: const []);
    await const CloudflareTidbCliAction().exec(context);
    final first = File("cloudflare/src/index.ts").readAsStringSync();
    await const CloudflareTidbCliAction().exec(context);
    check(File("cloudflare/src/index.ts").readAsStringSync() == first,
        "再applyで登録が重複しました。");
    check(RegExp(r"tidb.Functions.tidb\(").allMatches(first).length == 1,
        "公開入口が重複しました。");
    check(!first.contains("never_send"), "管理者資格情報を公開コードへ出力しました。");
    check(File("cloudflare/secret-names.txt").readAsLinesSync().length == 6,
        "runtimeの3secret以外を投入しました。");
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
