import "dart:convert";
import "dart:io";
import "package:katana_cli/action/cloudflare/d1.dart";
import "package:katana_cli/katana_cli.dart";

void check(bool value, String message) {
  if (!value) {
    throw StateError(message);
  }
}

Future<void> main() async {
  final original = Directory.current;
  final root = Directory.systemTemp.createTempSync("d1-schema-");
  try {
    Directory("${root.path}/lib").createSync();
    final table = {
      "database": "main",
      "table": "a",
      "columns": [],
      "primaryKey": ["id"],
      "indexes": [],
      "vectorFields": []
    };
    void fragment(String name) {
      File("${root.path}/lib/$name.dart").writeAsStringSync("// fixture");
      File("${root.path}/lib/$name.d1_schema").writeAsStringSync(jsonEncode({
        "schemaDirPath": "d1/schema",
        "schema": {
          "tables": [
            {...table, "table": name}
          ]
        }
      }));
    }

    fragment("a");
    fragment("b");
    finalizeD1Schema(root: root.path);
    Map schema() => jsonDecode(
        File("${root.path}/d1/schema/schema.json").readAsStringSync()) as Map;
    check((schema()["tables"] as List).length == 2, "複数モデルが欠落");
    final hash = schema()["sourceHash"];
    finalizeD1Schema(root: root.path);
    check(schema()["sourceHash"] == hash, "hashが不安定");
    File("${root.path}/lib/b.dart").deleteSync();
    finalizeD1Schema(root: root.path);
    check((schema()["tables"] as List).length == 1, "削除モデルが残存");
    File("${root.path}/lib/a.dart").deleteSync();
    finalizeD1Schema(root: root.path);
    check((schema()["tables"] as List).isEmpty, "全モデル削除が未反映");
    final config = updateD1Binding(
        '{"d1_databases":[{"binding":"OTHER","database_id":"keep"}]}',
        binding: "DB",
        id: "one",
        name: "fixture");
    final again =
        updateD1Binding(config, binding: "DB", id: "one", name: "fixture");
    check(config == again, "bindingが重複");
    check(
        (jsonDecode(again)["d1_databases"] as List).length == 2, "別bindingが消失");
    final vector = updateD1VectorBinding(
        '{"vectorize":[{"binding":"KEEP","index_name":"keep"}],"triggers":{"crons":["0 * * * *"]}}',
        binding: "V",
        name: "fixture");
    check(
        vector == updateD1VectorBinding(vector, binding: "V", name: "fixture"),
        "Vectorize binding/cronが重複");
    check((jsonDecode(vector)["vectorize"] as List).length == 2,
        "他のVectorize bindingが消失");
    check((jsonDecode(vector)["triggers"]["crons"] as List).length == 2,
        "既存cronが消失");
    final flavor = FlavorContext.resolve(yaml: {
      "cloudflare": {
        "d1": {
          "database_id": {"dev": "dev-id", "prod": "prod-id"},
          "database": {"dev": "dev_main", "prod": "main"}
        }
      }
    }, secrets: {}, arguments: [
      "migrate",
      "status",
      "--backend",
      "d1",
      "--flavor",
      "dev"
    ]);
    check(
        ((flavor.yaml["cloudflare"] as Map)["d1"] as Map)["database_id"] ==
            "dev-id",
        "flavor解決失敗");
    Directory.current = root;
    Directory("cloudflare/src").createSync(recursive: true);
    Directory("cloudflare/node_modules/@mathrunet/masamune_cloudflare_d1/dist")
        .createSync(recursive: true);
    File("cloudflare/node_modules/@mathrunet/masamune_cloudflare_d1/dist/worker.js")
        .writeAsStringSync("");
    File("cloudflare/src/edge.ts")
        .writeAsStringSync("export default m.deploy([]);");
    File("cloudflare/wrangler.jsonc")
        .writeAsStringSync('{"name":"fixture","main":"src/edge.ts"}');
    File("d1/schema/schema.json").writeAsStringSync(jsonEncode({
      "dialect": "sqlite",
      "tables": [
        {
          "database": "dev_main",
          "vectors": [
            {
              "field": "embedding",
              "binding": "V",
              "dimensions": 32,
              "metric": "cosine"
            }
          ]
        }
      ]
    }));
    final executable = File("${root.path}/wrangler-fixture.sh");
    executable.writeAsStringSync(r'''
#!/bin/sh
set -eu
case "$1 $2" in
 "d1 list") echo '[{"uuid":"00000000-0000-4000-8000-000000000004","name":"fixture"}]';;
 "vectorize list") if [ -f vector-created ]; then echo '[{"name":"fixture-vector"}]'; else echo '[]'; fi;;
 "vectorize create") touch vector-created; echo '{}';;
 "vectorize get") echo '{"name":"fixture-vector","config":{"dimensions":32,"metric":"cosine"}}';;
 *) exit 2;;
esac
'''
        .trimLeft());
    await Process.run("chmod", ["+x", executable.path]);
    final ctx = FlavorContext.resolve(yaml: {
      "bin": {"wrangler": executable.path},
      "cloudflare": {
        "project_id": "fixture",
        "d1": {
          "enable": true,
          "account_id": "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
          "database": "dev_main",
          "database_id": "00000000-0000-4000-8000-000000000004",
          "database_name": "fixture",
          "vectorize": {
            "dev": {"V": "fixture-vector"}
          }
        }
      }
    }, secrets: {}, arguments: [
      "apply",
      "--flavor",
      "dev"
    ]);
    final context =
        ExecContext(yaml: ctx.yaml, secrets: {}, args: [], flavorContext: ctx);
    await const CloudflareD1CliAction().exec(context);
    final worker = File("cloudflare/src/edge.ts").readAsStringSync();
    final wranglerSource = File("cloudflare/wrangler.jsonc").readAsStringSync();
    await const CloudflareD1CliAction().exec(context);
    check(worker == File("cloudflare/src/edge.ts").readAsStringSync(),
        "再applyでWorker登録が重複");
    check(
        wranglerSource == File("cloudflare/wrangler.jsonc").readAsStringSync(),
        "再applyでbinding/cronが重複");
    check(worker.contains("new d1.D1VectorSchedule("), "定期回収入口が欠落");
    check(wranglerSource.contains("fixture-vector"), "Vectorize bindingが欠落");
    stdout.writeln("D1 schema統合・削除・hash・binding冪等・環境解決: 成功");
  } finally {
    Directory.current = original;
    root.deleteSync(recursive: true);
  }
}
