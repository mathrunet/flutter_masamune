// Dart imports:
import "dart:io";

// Package imports:
import "package:yaml/yaml.dart";

// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Cloudflare initial configuration.
///
/// Cloudflareの初期設定を行います。
class CloudflareInitCliAction extends CliCommand with CliActionMixin {
  /// Cloudflare initial configuration.
  ///
  /// Cloudflareの初期設定を行います。
  const CloudflareInitCliAction();

  @override
  String get description =>
      "Initialize Cloudflare based on the information in `katana.yaml`. Also, make `wrangler` command available. `katana.yaml`の情報を元にCloudflareの初期設定を行います。また、`wrangler`のコマンドを利用可能にしてください。";

  @override
  bool checkEnabled(ExecContext context) {
    final cloudflare = context.yaml.getAsMap("cloudflare");
    final workers = cloudflare.getAsMap("workers");
    final enabledWorkers = workers.get("enable", false);
    final pages = cloudflare.getAsMap("pages");
    final enabledPages = pages.get("enable", false);
    return enabledWorkers || enabledPages;
  }

  @override
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final npm = bin.get("npm", "npm");
    final wrangler = bin.get("wrangler", "wrangler");
    final cloudflare = context.yaml.getAsMap("cloudflare");
    final workers = cloudflare.getAsMap("workers");
    final enabledWorkers = workers.get("enable", false);
    final enableFirebaseAuth = workers.get("enable_firebase_auth", false);
    final firebase = context.yaml.getAsMap("firebase");
    final firebaseProjectId = firebase.get("project_id", "");
    final pages = cloudflare.getAsMap("pages");
    final enabledPages = pages.get("enable", false);
    final pubspec = File("pubspec.yaml");
    final pubspecs = loadYaml(await pubspec.readAsString()) as Map;
    final projectId = pubspecs.get("name", "");
    if ((enabledWorkers || enabledPages) && projectId.isEmpty) {
      error(
          "Project ID is not specified. Please enter [project_id] in `katana.yaml`.");
      return;
    }
    if (enableFirebaseAuth && firebaseProjectId.isEmpty) {
      error(
        "Firebase project ID is not specified. Please enter [project_id] in `katana.yaml`.",
      );
      return;
    }
    final workerIndexFile = File("cloudflare/src/index.ts");
    final pagesIndexFile = File("cloudflare/public/index.html");
    final wranglerJsonc = File("cloudflare/wrangler.jsonc");
    final cloudflareDir = Directory("cloudflare");
    final workerRulesFile = File("cloudflare/src/rules.json");
    if (!cloudflareDir.existsSync()) {
      await cloudflareDir.create();
    }
    if (enabledWorkers || enabledPages) {
      if (!wranglerJsonc.existsSync()) {
        await command(
          "Initialize Cloudflare Workers",
          [wrangler, "init", projectId, "--yes", "--cwd=cloudflare"],
          runInShell: true,
        );
        // wranglerはcloudflare/{projectId}/配下にファイルを生成するため、cloudflare/直下に移動
        label("Rename files");
        final generatedDir = Directory("cloudflare/$projectId");
        await for (final entity
            in generatedDir.list(recursive: false, followLinks: false)) {
          final name = entity.path.split(Platform.pathSeparator).last;
          final targetPath = "${cloudflareDir.path}/$name";
          await entity.rename(targetPath);
        }
        await generatedDir.delete(recursive: true);
        await workerIndexFile.delete();
        await pagesIndexFile.delete();
      }
    }

    if (enabledWorkers) {
      final functionsDir = Directory("cloudflare/src/functions");
      if (!functionsDir.existsSync()) {
        await functionsDir.create();
      }
      if (!workerIndexFile.existsSync()) {
        await CloudflareWorkersIndexCliCode(
          firebaseProjectId: enableFirebaseAuth ? firebaseProjectId : null,
        ).generateFile("index.ts");
      }
      if (!workerRulesFile.existsSync()) {
        await const CloudflareWorkersRulesCliCode().generateFile("rules.json");
      }
      await const CloudflareWranglerCliCode().generateFile("wrangler.jsonc");
      await command(
        "Package installation.",
        [
          npm,
          "install",
          "hono",
          "@mathrunet/masamune",
          "@mathrunet/masamune_cloudflare"
        ],
        workingDirectory: "cloudflare",
        runInShell: true,
      );
      await addFlutterImport(
        [
          "masamune_functions_cloudflare",
        ],
      );
    }
    if (enabledPages) {
      if (!pagesIndexFile.existsSync()) {
        await const CloudflarePagesIndexCliCode().generateFile("index.html");
      }
    }
  }
}

/// Cloudflare Workers index.ts codebase.
///
/// Cloudflare Workersのindex.tsのコードベース。
class CloudflareWorkersIndexCliCode extends CliCode {
  /// Cloudflare Workers index.ts codebase.
  ///
  /// Cloudflare Workersのindex.tsのコードベース。
  const CloudflareWorkersIndexCliCode({
    this.firebaseProjectId,
  });

  /// Firebase project ID.
  /// This is required to enable Firebase Authentication.
  ///
  /// FirebaseのプロジェクトID。
  /// これを渡すとFirebase Authenticationを有効にします。
  final String? firebaseProjectId;

  @override
  String get name => "index";

  @override
  String get prefix => "index";

  @override
  String get directory => "cloudflare/src";

  @override
  String get description =>
      "Define the code for index.ts in Cloudflare Workers. Cloudflare Workersのindex.tsのコードを定義します。";

  @override
  String import(String path, String baseName, String className) {
    return """
import * as m from "@mathrunet/masamune_cloudflare";
import rules from "./rules.json";
""";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
// Define [m.Functions.xxxx] for the functions to be added to Workers.
//
// Workersに追加する機能を[m.Functions.xxxx]を定義してください。
export default m.deploy([
${firebaseProjectId != null ? """
], {
    rules: rules as m.RulesConfig,
    auth: new m.FirebaseAuthAdapter({
        projectId: "$firebaseProjectId",
    }),
}
""" : """
], {
    rules: rules as m.RulesConfig,
});
"""}
""";
  }
}

/// Cloudflare Pages index.html codebase.
///
/// Cloudflare Pagesのindex.htmlのコードベース。
class CloudflarePagesIndexCliCode extends CliCode {
  /// Cloudflare Pages index.html codebase.
  ///
  /// Cloudflare Pagesのindex.htmlのコードベース。
  const CloudflarePagesIndexCliCode();

  @override
  String get name => "index";

  @override
  String get prefix => "index";

  @override
  String get directory => "cloudflare/public";

  @override
  String get description =>
      "Define the code for index.html in Cloudflare Pages. Cloudflare Pagesのindex.htmlのコードを定義します。";

  @override
  String import(String path, String baseName, String className) {
    return """
""";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return r"""
<!doctype html>
<html lang="en">
	<head>
		<meta charset="UTF-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	</head>
	<body>
	</body>
</html>
""";
  }
}

/// Cloudflare Workers rules.json codebase.
///
/// Cloudflare Workersのrules.jsonのコードベース。
class CloudflareWorkersRulesCliCode extends CliCode {
  /// Cloudflare Workers rules.json codebase.
  ///
  /// Cloudflare Workersのrules.jsonのコードベース。
  const CloudflareWorkersRulesCliCode();

  @override
  String get name => "rules";

  @override
  String get prefix => "rules";

  @override
  String get directory => "cloudflare/src";

  @override
  String get description =>
      "Define the code for rules.json in Cloudflare Workers. Cloudflare Workersのrules.jsonのコードを定義します。";

  @override
  String import(String path, String baseName, String className) {
    return """
""";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return r"""
{
  "version": "1",
  "rules": {
  }
}
""";
  }
}

/// Cloudflare Wrangler.jsonc codebase.
///
/// Cloudflare Wrangler.jsoncのコードベース。
class CloudflareWranglerCliCode extends CliCode {
  /// Cloudflare Wrangler.jsonc codebase.
  ///
  /// Cloudflare Wrangler.jsoncのコードベース。
  const CloudflareWranglerCliCode();

  @override
  String get name => "wrangler";

  @override
  String get prefix => "wrangler";

  @override
  String get directory => "cloudflare";

  @override
  String get description =>
      "Define the code for wrangler.jsonc in Cloudflare. Cloudflareのwrangler.jsoncのコードを定義します。";

  @override
  String import(String path, String baseName, String className) {
    return """
""";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return r"""
/**
 * For more details on how to configure Wrangler, refer to:
 * https://developers.cloudflare.com/workers/wrangler/configuration/
 */
{
	"$schema": "node_modules/wrangler/config-schema.json",
	"name": "cloudflaretest",
	"main": "src/index.ts",
	"compatibility_date": "2026-06-29",
	"compatibility_flags": [
		"nodejs_compat",
		"global_fetch_strictly_public"
	],
	"assets": {
		// The path to the directory containing the `index.html` file to be served at `/`
		"directory": "./public"
	},
	"observability": {
		"logs": {
			"enabled": true,
			"invocation_logs": true
		},
		"traces": {
			"enabled": true
		}
	},
	"upload_source_maps": true
	/**
	 * Smart Placement
	 * https://developers.cloudflare.com/workers/configuration/smart-placement/#smart-placement
	 */
	// "placement": {  "mode": "smart" }
	/**
	 * Bindings
	 * Bindings allow your Worker to interact with resources on the Cloudflare Developer Platform, including
	 * databases, object storage, AI inference, real-time communication and more.
	 * https://developers.cloudflare.com/workers/runtime-apis/bindings/
	 */
	/**
	 * Environment Variables
	 * https://developers.cloudflare.com/workers/wrangler/configuration/#environment-variables
	 * Note: Use secrets to store sensitive data.
	 * https://developers.cloudflare.com/workers/configuration/secrets/
	 */
	// "vars": {  "MY_VARIABLE": "production_value" }
	/**
	 * Service Bindings (communicate between multiple Workers)
	 * https://developers.cloudflare.com/workers/wrangler/configuration/#service-bindings
	 */
	// "services": [  {   "binding": "MY_SERVICE",   "service": "my-service"  } ]
}
""";
  }
}
