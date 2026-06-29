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
    final workerIndexFile = File("cloudflare/src/index.ts");
    final pagesIndexFile = File("cloudflare/public/index.html");
    final wranglerJsonc = File("cloudflare/wrangler.jsonc");
    final cloudflareDir = Directory("cloudflare");
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
        await const CloudflareIndexCliCode().generateFile("index.ts");
      }
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
    }
    if (enabledPages) {
      if (!pagesIndexFile.existsSync()) {
        await const CloudflareHostingIndexCliCode().generateFile("index.html");
      }
    }
  }
}

/// Cloudflare Workers index.ts codebase.
///
/// Cloudflare Workersのindex.tsのコードベース。
class CloudflareIndexCliCode extends CliCode {
  /// Cloudflare Workers index.ts codebase.
  ///
  /// Cloudflare Workersのindex.tsのコードベース。
  const CloudflareIndexCliCode();

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
]);
""";
  }
}

/// Cloudflare Pages index.html codebase.
///
/// Cloudflare Pagesのindex.htmlのコードベース。
class CloudflareHostingIndexCliCode extends CliCode {
  /// Cloudflare Pages index.html codebase.
  ///
  /// Cloudflare Pagesのindex.htmlのコードベース。
  const CloudflareHostingIndexCliCode();

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
