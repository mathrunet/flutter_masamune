import "dart:convert";
import "dart:io";

import "package:katana_cli/action/cloudflare/cloudflare_source_utils.dart";
import "package:katana_cli/action/cloudflare/init.dart";
import "package:katana_cli/action/cloudflare/turso.dart";
import "package:katana_cli/katana.dart";
import "package:katana_cli/katana_cli.dart";
import "package:yaml/yaml.dart";

Future<void> main() async {
  await _testWorkersGeneration();
  await _testTursoRegions();
  final template = katanaYamlCode(true);
  final yaml = loadYaml(template) as Map;

  _expectEnvironmentMap(yaml, ["firebase", "project_id"]);
  _expectEnvironmentMap(yaml, ["cloudflare", "project_id"]);
  _expectSharedField(yaml, ["cloudflare", "turso", "organization"]);
  _expectEnvironmentMap(yaml, ["cloudflare", "turso", "group"]);
  _expectEnvironmentMap(yaml, ["cloudflare", "turso", "groups"]);
  _expectEnvironmentMap(yaml, ["cloudflare", "tidb", "host"]);
  _expectEnvironmentMap(yaml, ["cloudflare", "tidb", "database"]);
  _expectEnvironmentMap(yaml, ["cloudflare", "tidb", "cluster_id"]);
  _expectSharedField(yaml, ["cloudflare", "kv", "binding"]);
  _expectEnvironmentMap(yaml, ["cloudflare", "kv", "namespace_id"]);
  _expectSharedField(yaml, ["cloudflare", "storage", "bucket_name"]);
  _expectSharedField(yaml, ["cloudflare", "storage", "public_base_url"]);

  final resolved = FlavorContext.resolve(
    yaml: yaml,
    secrets: const {},
    arguments: const ["apply"],
  );
  _expect(
    resolved.flavor == KatanaFlavor.dev,
    "A generated environment-aware template must default to dev.",
  );
}

Future<void> _testWorkersGeneration() async {
  for (final projectId in [null, "firebase-test"]) {
    final template =
        CloudflareWorkersIndexCliCode(firebaseProjectId: projectId);
    final source = template.import("", "", "") + template.body("", "", "");
    final alias =
        RegExp(r'import \* as (\w+) from "@mathrunet/masamune_cloudflare"')
            .firstMatch(source)!
            .group(1)!;
    if (projectId != null) {
      _expect(source.contains("new $alias.FirebaseAuthAdapter("),
          "FirebaseAuthAdapterは宣言されたimport別名を使います。");
    }
    final inserted = CloudflareSourceUtils.insertDeployFunctions(
        source, ["    customFunction(),"]);
    _expect(inserted != null, "生成されたdeployへ共通関数を挿入できます。");
    final updated = const CloudflareTursoCliAction()
        .updateTursoFunctions(source, useSchemaManifest: false);
    _expect(updated != null, "生成されたdeployへTurso関数を挿入できます。");
    _expect(
        const CloudflareTursoCliAction()
                .updateTursoFunctions(updated!, useSchemaManifest: false) ==
            updated,
        "生成直後のTurso関数追加は冪等です。");
    // 型注釈だけを除去し、生成コードの括弧と実行時の参照をNodeで検証します。
    final executable = updated
        .replaceAll(RegExp(r"^import .*;$", multiLine: true), "")
        .replaceAll(" as $alias.RulesConfig", "")
        .replaceFirst("export default", "return");
    final result = await Process.run("node", [
      "-e",
      '''
const assert = require("node:assert/strict");
if (process.env.KATANA_TYPESCRIPT_MODULE) {
  const ts = require(process.env.KATANA_TYPESCRIPT_MODULE);
  const parsed = ts.createSourceFile("index.ts", ${jsonEncode(updated)}, ts.ScriptTarget.Latest, true, ts.ScriptKind.TS);
  assert.deepEqual(parsed.parseDiagnostics.map(d => ts.flattenDiagnosticMessageText(d.messageText, "\\n")), []);
}
const worker = {
  deploy: (functions, options) => ({ functions, options }),
  FirebaseAuthAdapter: class { constructor(options) { this.projectId = options.projectId; } },
};
const turso = { Functions: { turso: () => "query", tursoToken: () => "token" } };
const result = new Function(${jsonEncode(alias)}, "turso", "rules", ${jsonEncode(executable)})(worker, turso, {});
assert.deepEqual(result.functions, ["query", "token"]);
assert.equal(result.options.auth?.projectId ?? null, ${jsonEncode(projectId)});
''',
    ]);
    _expect(result.exitCode == 0, "生成コードの実行検証に失敗: ${result.stderr}");
  }
  for (final alias in ["m", "mc", "worker"]) {
    final source = '''
import * as $alias from "@mathrunet/masamune_cloudflare";
export default $alias.deploy([], { rules: {} });
''';
    final common = CloudflareSourceUtils.insertDeployFunctions(
        source, ["    customFunction(),"]);
    _expect(common?.contains("customFunction(),") ?? false,
        "共通挿入は既存のimport別名 $alias を保持します。");
    final turso = const CloudflareTursoCliAction()
        .updateTursoFunctions(source, useSchemaManifest: false);
    _expect(turso?.contains("turso.Functions.turso(") ?? false,
        "Turso挿入は既存のimport別名 $alias を保持します。");
  }
}

// organizationやbindingは既存テンプレートで環境共通。DB識別子とは分けて検証する。
void _expectSharedField(Map root, List<String> path) {
  Object? current = root;
  for (final key in path) {
    if (current is! Map || !current.containsKey(key)) {
      throw StateError("Template field was not found: ${path.join(".")}");
    }
    current = current[key];
  }
  _expect(current is! Map, "環境共通fieldが環境別mapに変更されました。");
}

void _expectEnvironmentMap(Map root, List<String> path) {
  Object? current = root;
  for (final key in path) {
    if (current is! Map || !current.containsKey(key)) {
      throw StateError("Template field was not found: ${path.join(".")}");
    }
    current = current[key];
  }
  _expect(
    current is Map &&
        current.length == 2 &&
        current.containsKey("dev") &&
        current.containsKey("prod"),
    "Template field must contain only dev/prod: ${path.join(".")}",
  );
}

void _expect(bool condition, String message) {
  if (!condition) {
    throw StateError(message);
  }
}

Future<void> _testTursoRegions() async {
  const action = CloudflareTursoCliAction();
  const groups = [
    {
      "name": "prod-apac",
      "continents": ["AS", "OC"]
    },
    {
      "name": "prod-us",
      "continents": ["NA", "SA"]
    },
    {
      "name": "prod-eu",
      "continents": ["EU", "AF"]
    },
  ];
  final parsed = CloudflareTursoCliAction.parseTursoGroups(groups);
  _expect(parsed.length == 3, "3グループを保持します。");
  for (final invalid in [
    [groups.first, groups.first],
    [
      {
        "name": "bad",
        "continents": ["XX"]
      }
    ],
    [
      {
        "name": "a",
        "countries": ["JP"]
      },
      {
        "name": "b",
        "countries": ["JP"]
      }
    ],
  ]) {
    var rejected = false;
    try {
      CloudflareTursoCliAction.parseTursoGroups(invalid);
    } on FormatException {
      rejected = true;
    }
    _expect(rejected, "不正なグループ定義を拒否します。");
  }
  const source = r"""
import * as m from "@mathrunet/masamune_cloudflare";
import * as turso from "@mathrunet/masamune_cloudflare_turso";
const shared = { groups: [{ name: "prod-eu" }], resolveGroup: () => "prod-eu" };
export default m.deploy([
  turso.Functions.turso({ ...shared, autoCreateDatabase: false, resolveGroup: ({country}) => country === "JP" ? "prod-apac" : "prod-eu" }),
  turso.Functions.tursoToken(shared),
]);
""";
  final once = action.updateTursoFunctions(source, useSchemaManifest: true)!;
  final twice = action.updateTursoFunctions(once, useSchemaManifest: true)!;
  _expect(once == twice, "再適用は冪等である必要があります。");
  _expect(once.contains('country === "JP" ? "prod-apac" : "prod-eu"'),
      "resolverが失われています。");
  _expect(once.contains("autoCreateDatabase: false"), "自動作成の明示設定を保持します。");
  _expect(
      once.contains("turso.Functions.tursoToken(shared)"), "共通設定への参照を保持します。");
  _expect(
      once.contains("schemaManifest: tursoSchemaManifest"), "生成schemaを追加します。");

  final previous = Directory.current;
  final temp = Directory.systemTemp.createTempSync("katana-turso-regions-");
  try {
    Directory.current = temp;
    Directory("cloudflare/src").createSync(recursive: true);
    File("cloudflare/src/index.ts").writeAsStringSync(source);
    File("cloudflare/wrangler.jsonc").writeAsStringSync(
        jsonEncode({"name": "test-worker", "main": "src/index.ts"}));
    File("pubspec.yaml").writeAsStringSync(
        "name: test_app\ndependencies:\n  masamune_model_turso: any\n");
    File("cloudflare/package.json").writeAsStringSync(jsonEncode({
      "dependencies": {"@mathrunet/masamune_cloudflare_turso": "test"}
    }));
    final fake = File("${temp.path}/fake-wrangler.sh");
    fake.writeAsStringSync("#!/bin/sh\ncat >/dev/null\n");
    await Process.run("chmod", ["+x", fake.path]);
    final context = ExecContext(yaml: {
      "bin": {"wrangler": fake.path},
      "cloudflare": {
        "turso": {
          "enable": true,
          "organization": "test-org",
          "groups": groups,
          "platform_api_token": "test-only-token"
        }
      },
    }, args: const []);
    await action.exec(context);
    final firstIndex = File("cloudflare/src/index.ts").readAsStringSync();
    final firstWrangler = File("cloudflare/wrangler.jsonc").readAsStringSync();
    await action.exec(context);
    _expect(firstIndex == File("cloudflare/src/index.ts").readAsStringSync(),
        "再生成でresolverを変更しません。");
    _expect(
        firstWrangler == File("cloudflare/wrangler.jsonc").readAsStringSync(),
        "再生成で地域設定を変更しません。");
    final wrangler = jsonDecode(firstWrangler
        .replaceAll(RegExp(r"^\s*//.*$", multiLine: true), "")
        .replaceAllMapped(RegExp(r",(\s*[}\]])"), (match) => match[1]!)) as Map;
    final vars = (wrangler["env"] as Map)["prod"]["vars"] as Map;
    _expect((jsonDecode(vars["TURSO_GROUPS"] as String) as List).length == 3,
        "グループがWranglerに反映されていません。");
    _expect(vars["TURSO_GROUP"] == "", "group省略を許可します。");
  } finally {
    Directory.current = previous;
    temp.deleteSync(recursive: true);
  }
}
