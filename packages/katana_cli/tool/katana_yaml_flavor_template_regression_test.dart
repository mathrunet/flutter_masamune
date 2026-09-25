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
  await _testWorkerFirebaseProjectsByFlavor();
  await _testTursoRegions();
  await _testRegionWorkerGeneration();
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
  _expectEnvironmentMap(yaml, ["cloudflare", "workers", "region", "placement"]);
  _expectSharedField(yaml, ["cloudflare", "workers", "smart_placement"]);
  _expectSharedField(yaml, ["cloudflare", "workers", "region", "enable"]);
  final templateCloudflare = yaml["cloudflare"] as Map;
  _expect(
    (templateCloudflare["workers"] as Map)["region"]["enable"] == false &&
        (templateCloudflare["turso"] as Map)["enable"] == false,
    "region Worker and Turso must stay disabled in the template.",
  );

  final resolved = FlavorContext.resolve(
    yaml: yaml,
    secrets: const {},
    arguments: const ["apply"],
  );
  _expect(
    resolved.flavor == KatanaFlavor.dev,
    "A generated environment-aware template must default to dev.",
  );
  for (final flavor in KatanaFlavor.values) {
    final context = FlavorContext.resolve(
      yaml: yaml,
      secrets: const {},
      arguments: ["apply", "--flavor", flavor.name],
    );
    final cloudflare = context.yaml["cloudflare"] as Map;
    final turso = cloudflare["turso"] as Map;
    final region = (cloudflare["workers"] as Map)["region"] as Map;
    _expect(region["placement"] == "aws:us-east-1",
        "region placement must resolve to a string for ${flavor.name}.");
    _expect(turso["groups"] is List,
        "turso.groups must resolve to a List for ${flavor.name}.");
    final groups = CloudflareTursoCliAction.parseTursoGroups(turso["groups"]);
    final expected = flavor == KatanaFlavor.dev
        ? {"dev-apac": "aws-ap-northeast-1"}
        : {
            "prod-apac": "aws-ap-northeast-1",
            "prod-us": "aws-us-east-1",
            "prod-eu": "aws-eu-west-1",
          };
    _expect(
      groups.length == expected.length &&
          groups
              .every((group) => expected[group["name"]] == group["location"]) &&
          turso["group"] == groups.first["name"],
      "turso.groups/group defaults are wrong for ${flavor.name}: $groups",
    );
  }
  for (final invalid in ["AWS_TOKYO", "aws--tokyo", 1]) {
    var rejected = false;
    try {
      CloudflareTursoCliAction.parseTursoGroups([
        {"name": "bad", "location": invalid}
      ]);
    } on FormatException {
      rejected = true;
    }
    _expect(rejected, "An invalid Turso location must be rejected: $invalid");
  }
}

/// region有効時に、edge/regionの両Workerを生成・同期する。
Future<void> _testRegionWorkerGeneration() async {
  final previous = Directory.current;
  final temp = Directory.systemTemp.createTempSync("katana-region-worker-");
  try {
    Directory.current = temp;
    Directory("cloudflare/src").createSync(recursive: true);
    File("cloudflare/wrangler.jsonc").writeAsStringSync(
      const CloudflareWranglerCliCode(projectId: "worker-prod")
          .body("", "", ""),
    );
    File("cloudflare/.gitignore").writeAsStringSync(".dev.vars*\n");
    File("cloudflare/package.json").writeAsStringSync(jsonEncode({
      "dependencies": {
        "hono": "1.0.0",
        "@mathrunet/masamune": "1.0.0",
        "@mathrunet/masamune_cloudflare": "1.0.0",
      },
    }));
    File("pubspec.yaml").writeAsStringSync(
      "name: test_app\ndependencies:\n  masamune_functions_cloudflare: any\n",
    );
    final wrangler = File("${temp.path}/fake-wrangler.sh");
    wrangler.writeAsStringSync(
        "#!/bin/sh\nprintf '%s\\n' \"\$*\" >> ${temp.path}/wrangler-calls.txt\n");
    await Process.run("chmod", ["+x", wrangler.path]);
    final yaml = <String, Object>{
      "bin": {"wrangler": wrangler.path},
      "firebase": {
        "project_id": {"dev": "firebase-dev", "prod": "firebase-prod"}
      },
      "cloudflare": {
        "project_id": {"dev": "worker-dev", "prod": "worker-prod"},
        "workers": {
          "enable": true,
          "enable_firebase_auth": true,
          "smart_placement": true,
          "region": {
            "enable": true,
            "placement": {"dev": "aws:ap-northeast-1", "prod": "aws:us-east-1"},
          },
        },
      },
    };
    for (final flavor in ["dev", "prod", "dev"]) {
      final args = ["apply", "--flavor", flavor];
      final resolved = FlavorContext.resolve(
        yaml: yaml,
        secrets: const {},
        arguments: args,
      );
      await const CloudflareInitCliAction().exec(
        ExecContext(yaml: resolved.yaml, args: args, flavorContext: resolved),
      );
    }
    final region = File("cloudflare/wrangler.region.jsonc").readAsStringSync();
    final managedStart =
        region.indexOf(WranglerEnvironmentSynchronizer.beginMarker);
    final root = region.substring(0, managedStart);
    final managed = region.substring(managedStart);
    final dev =
        managed.substring(managed.indexOf('"dev"'), managed.indexOf('"prod"'));
    final prod = managed.substring(managed.indexOf('"prod"'));
    _expect(
      root.contains('"name": "worker-prod-region"') &&
          root.contains('"main": "src/region.ts"') &&
          root.contains('"placement": { "region": "aws:us-east-1" }') &&
          !root.contains('"assets"') &&
          !root.contains("smart"),
      "wrangler.region.jsonc root must pin the prod placement without assets/smart: $root",
    );
    _expect(
      dev.contains('"name": "worker-dev-region"') &&
          dev.contains('"FIREBASE_PROJECT_ID": "firebase-dev"') &&
          dev.contains('"placement": { "region": "aws:ap-northeast-1" }') &&
          !dev.contains("firebase-prod"),
      "The dev region environment is wrong: $dev",
    );
    _expect(
      prod.contains('"name": "worker-prod-region"') &&
          prod.contains('"FIREBASE_PROJECT_ID": "firebase-prod"') &&
          prod.contains('"placement": { "region": "aws:us-east-1" }') &&
          !prod.contains("firebase-dev"),
      "The prod region environment is wrong: $prod",
    );
    final edgeWrangler = File("cloudflare/wrangler.jsonc").readAsStringSync();
    _expect(
      edgeWrangler.contains('"main": "src/edge.ts"') &&
          edgeWrangler.contains('"name": "worker-prod"') &&
          !edgeWrangler.contains('"region":'),
      "The edge Wrangler must not receive the region placement.",
    );
    final regionEntry = File("cloudflare/src/region.ts").readAsStringSync();
    final edgeEntry = File("cloudflare/src/edge.ts").readAsStringSync();
    _expect(
      regionEntry.contains('type: "region"') &&
          regionEntry.contains("fixed-region backends") &&
          edgeEntry.contains('type: "edge"'),
      "Worker entrypoints must declare their kind.",
    );
    // 生成物は2回目以降のapplyで変わらない。
    final before = File("cloudflare/wrangler.region.jsonc").readAsStringSync();
    final args = ["apply", "--flavor", "dev"];
    final resolved =
        FlavorContext.resolve(yaml: yaml, secrets: const {}, arguments: args);
    await const CloudflareInitCliAction().exec(
      ExecContext(yaml: resolved.yaml, args: args, flavorContext: resolved),
    );
    _expect(
      File("cloudflare/wrangler.region.jsonc").readAsStringSync() == before,
      "Re-applying must keep wrangler.region.jsonc unchanged.",
    );
  } finally {
    Directory.current = previous;
    temp.deleteSync(recursive: true);
  }
}

Future<void> _testWorkerFirebaseProjectsByFlavor() async {
  final previous = Directory.current;
  final temp = Directory.systemTemp.createTempSync("katana-worker-firebase-");
  try {
    Directory.current = temp;
    Directory("cloudflare/src").createSync(recursive: true);
    File("cloudflare/wrangler.jsonc").writeAsStringSync(
      '{"name":"worker-prod","main":"src/edge.ts"}',
    );
    File("cloudflare/.gitignore").writeAsStringSync(".dev.vars*\n");
    File("cloudflare/package.json").writeAsStringSync(jsonEncode({
      "dependencies": {
        "hono": "1.0.0",
        "@mathrunet/masamune": "1.0.0",
        "@mathrunet/masamune_cloudflare": "1.0.0",
      },
    }));
    File("pubspec.yaml").writeAsStringSync(
      "name: test_app\ndependencies:\n  masamune_functions_cloudflare: any\n",
    );
    final yaml = <String, Object>{
      "firebase": {
        "project_id": {"dev": "firebase-dev", "prod": "firebase-prod"}
      },
      "cloudflare": {
        "project_id": {"dev": "worker-dev", "prod": "worker-prod"},
        "workers": {"enable": true, "enable_firebase_auth": true},
      },
    };
    for (final flavor in ["dev", "prod"]) {
      final args = ["apply", "--flavor", flavor];
      final resolved = FlavorContext.resolve(
        yaml: yaml,
        secrets: const {},
        arguments: args,
      );
      await const CloudflareInitCliAction().exec(
        ExecContext(yaml: resolved.yaml, args: args, flavorContext: resolved),
      );
    }
    final source = File("cloudflare/src/edge.ts").readAsStringSync();
    _expect(
      source.contains("context.env?.FIREBASE_PROJECT_ID") &&
          !source.contains("firebase-dev") &&
          !source.contains("firebase-prod"),
      "初回に生成したWorkerは後続flavorへ固定されません。",
    );
    final wrangler = File("cloudflare/wrangler.jsonc").readAsStringSync();
    final dev = wrangler.substring(
      wrangler.indexOf('"dev"'),
      wrangler.indexOf('"prod"'),
    );
    final prod = wrangler.substring(wrangler.indexOf('"prod"'));
    _expect(
      dev.contains('"FIREBASE_PROJECT_ID": "firebase-dev"') &&
          !dev.contains("firebase-prod") &&
          prod.contains('"FIREBASE_PROJECT_ID": "firebase-prod"') &&
          !prod.contains("firebase-dev"),
      "Wranglerのdev/prodは別々のFirebase projectを指定します。",
    );
  } finally {
    Directory.current = previous;
    temp.deleteSync(recursive: true);
  }
}

Future<void> _testWorkersGeneration() async {
  for (final (entry, projectId) in [
    ("edge", null),
    ("edge", "firebase-test"),
    ("region", null),
    ("region", "firebase-test"),
  ]) {
    final template = CloudflareWorkersEntryCliCode(
        entry: entry, firebaseProjectId: projectId);
    _expect(template.name == entry && template.prefix == entry,
        "The entry template must be named after the entry.");
    final source = template.import("", "", "") + template.body("", "", "");
    final alias =
        RegExp(r'import \* as (\w+) from "@mathrunet/masamune_cloudflare"')
            .firstMatch(source)!
            .group(1)!;
    if (projectId != null) {
      _expect(source.contains("new $alias.FirebaseAuthAdapter("),
          "FirebaseAuthAdapterは宣言されたimport別名を使います。");
      _expect(
          source.contains(
                  "class EnvironmentFirebaseAuthAdapter extends $alias.WorkersAuthAdapterBase") &&
              source.contains("context.env?.FIREBASE_PROJECT_ID") &&
              source.contains("auth: new EnvironmentFirebaseAuthAdapter()") &&
              !source.contains('import { env } from "cloudflare:workers";') &&
              !source.contains('projectId: "$projectId"'),
          "生成Workerはリクエスト環境からFirebase project IDを読む必要があります。");
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
        .replaceAll("build(): MiddlewareHandler", "build()")
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
  WorkersAuthAdapterBase: class {},
  FirebaseAuthAdapter: class {
    constructor(options) { this.projectId = options.projectId; }
    build() { return () => this.projectId; }
  },
};
const turso = { Functions: { turso: () => "query", tursoToken: () => "token" } };
const result = new Function(${jsonEncode(alias)}, "turso", "rules", ${jsonEncode(executable)})(worker, turso, {});
assert.deepEqual(result.functions, ["query", "token"]);
assert.equal(result.options.type, ${jsonEncode(entry)});
async function verify() {
if (${projectId != null}) {
  for (const selected of ["firebase-dev", "firebase-prod"]) {
    const middleware = result.options.auth.build();
    assert.equal(await middleware({ env: { FIREBASE_PROJECT_ID: selected } }, () => {}), selected);
  }
  assert.equal(await result.options.auth.build()({ env: {}, text: (_, status) => status }, () => {}), 503);
}
}
verify().catch((error) => { console.error(error); process.exitCode = 1; });
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
    File("cloudflare/src/edge.ts").writeAsStringSync(source);
    File("cloudflare/wrangler.jsonc").writeAsStringSync(
        jsonEncode({"name": "test-worker", "main": "src/edge.ts"}));
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
    final firstIndex = File("cloudflare/src/edge.ts").readAsStringSync();
    final firstWrangler = File("cloudflare/wrangler.jsonc").readAsStringSync();
    await action.exec(context);
    _expect(firstIndex == File("cloudflare/src/edge.ts").readAsStringSync(),
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
