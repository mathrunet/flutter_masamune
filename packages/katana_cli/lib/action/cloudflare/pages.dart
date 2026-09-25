// Dart imports:
import "dart:io";

// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Cloudflare Pages configuration.
///
/// Creates the Pages project and attaches the custom domain based on
/// [cloudflare]->[pages] in `katana.yaml`. Like Firebase Hosting
/// (`firebase/hosting`), the public directory ([cloudflare]->[pages]->[public_dir],
/// `cloudflare/pages` by default) is created with a minimal `index.html` when
/// it does not exist. Katana never builds Flutter web; build it separately
/// (e.g. in CI) and copy the output into the public directory.
///
/// Cloudflare Pagesの設定を行います。
///
/// `katana.yaml`の[cloudflare]->[pages]を元にPagesプロジェクトを作成し、
/// カスタムドメインを接続します。Firebase Hosting（`firebase/hosting`）と同様に、
/// 公開ディレクトリ（[cloudflare]->[pages]->[public_dir]、既定は`cloudflare/pages`）が
/// 存在しない場合は最小限の`index.html`を含めて作成します。
/// KatanaはFlutter Webのビルドを行いません。CIなどで別途ビルドし、
/// 成果物を公開ディレクトリへコピーしてください。
class CloudflarePagesCliAction extends CliCommand with CliActionMixin {
  /// Cloudflare Pages configuration.
  ///
  /// Cloudflare Pagesの設定を行います。
  const CloudflarePagesCliAction();

  @override
  String get description =>
      "Create the Cloudflare Pages project and attach its custom domain based on `katana.yaml`. `katana.yaml`の情報を元にCloudflare Pagesプロジェクトを作成し、カスタムドメインを接続します。";

  @override
  bool checkEnabled(ExecContext context) {
    final cloudflare = context.yaml.getAsMap("cloudflare");
    final pages = cloudflare.getAsMap("pages");
    return pages.get("enable", false);
  }

  /// Resolves the Pages project name from [cloudflare]->[pages]->[project_name]
  /// or [cloudflare]->[project_id].
  ///
  /// [cloudflare]->[pages]->[project_name]または[cloudflare]->[project_id]から
  /// Pagesプロジェクト名を解決します。
  static String resolveProjectName(Map yaml) {
    final cloudflare = yaml.getAsMap("cloudflare");
    final pages = cloudflare.getAsMap("pages");
    final configured = pages.get("project_name", "").trim();
    if (configured.isNotEmpty) {
      return configured;
    }
    return cloudflare.get("project_id", "").trim();
  }

  /// Default public directory deployed to Pages.
  ///
  /// Pagesへデプロイする既定の公開ディレクトリ。
  static const defaultPublicDir = "cloudflare/pages";

  /// Resolves the public directory deployed to Pages from
  /// [cloudflare]->[pages]->[public_dir].
  ///
  /// Every file in this directory (Flutter web output copied by CI, and static
  /// files such as `.well-known/apple-app-site-association`, `_headers` or
  /// `_redirects`) is deployed as is.
  ///
  /// [cloudflare]->[pages]->[public_dir]からPagesへデプロイする公開ディレクトリを解決します。
  ///
  /// このディレクトリ内のファイル（CIでコピーしたFlutter Webの成果物や、
  /// `.well-known/apple-app-site-association`・`_headers`・`_redirects`などの静的ファイル）が
  /// そのままデプロイされます。
  static String resolvePublicDir(Map yaml) {
    final pages = yaml.getAsMap("cloudflare").getAsMap("pages");
    final configured = pages.get("public_dir", "").trim();
    return configured.isEmpty ? defaultPublicDir : configured;
  }

  /// Working directory for `wrangler pages` commands.
  ///
  /// `wrangler pages`コマンドの作業ディレクトリ。
  static String? get workingDirectory =>
      Directory("cloudflare").existsSync() ? "cloudflare" : null;

  @override
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final wrangler = bin.get("wrangler", "wrangler");
    final cloudflare = context.yaml.getAsMap("cloudflare");
    final pages = cloudflare.getAsMap("pages");
    final projectName = resolveProjectName(context.yaml);
    final customDomain = pages.get("custom_domain", "").trim().toLowerCase();
    if (projectName.isEmpty) {
      error(
        "If [cloudflare]->[pages]->[enable] is enabled, please include [cloudflare]->[pages]->[project_name] or [cloudflare]->[project_id].",
      );
      return;
    }
    await _ensurePublicDir(resolvePublicDir(context.yaml));
    if (isLocalApply) {
      return;
    }
    await _ensureProject(wrangler: wrangler, projectName: projectName);
    if (customDomain.isNotEmpty) {
      await _ensureDomain(
        wrangler: wrangler,
        projectName: projectName,
        domain: customDomain,
      );
    }
  }

  /// Creates the public directory with a minimal `index.html` if it does not
  /// exist. Existing directories are never modified.
  ///
  /// 公開ディレクトリが存在しない場合、最小限の`index.html`を含めて作成します。
  /// 既存のディレクトリは変更しません。
  Future<void> _ensurePublicDir(String publicDir) async {
    final directory = Directory(publicDir);
    if (directory.existsSync()) {
      return;
    }
    label("Create Cloudflare Pages public directory `$publicDir`.");
    await directory.create(recursive: true);
    await File("$publicDir/index.html").writeAsString(_defaultIndexHtml);
  }

  static const _defaultIndexHtml = """
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

  Future<void> _ensureProject({
    required String wrangler,
    required String projectName,
  }) async {
    label("Ensure Cloudflare Pages project `$projectName`.");
    final list = await Process.run(
      wrangler,
      ["pages", "project", "list"],
      workingDirectory: workingDirectory,
      runInShell: true,
    );
    if (list.exitCode != 0) {
      stdout.write("${list.stdout}\n${list.stderr}");
      throw Exception("Failed to list Cloudflare Pages projects.");
    }
    if (_containsToken(list.stdout.toString(), projectName)) {
      return;
    }
    final create = await Process.run(
      wrangler,
      [
        "pages",
        "project",
        "create",
        projectName,
        "--production-branch",
        "main",
      ],
      workingDirectory: workingDirectory,
      runInShell: true,
    );
    final createOutput = "${create.stdout}\n${create.stderr}";
    if (createOutput.trim().isNotEmpty) {
      stdout.write(createOutput);
    }
    if (create.exitCode != 0) {
      throw Exception(
        "Failed to create Cloudflare Pages project `$projectName`.",
      );
    }
  }

  Future<void> _ensureDomain({
    required String wrangler,
    required String projectName,
    required String domain,
  }) async {
    label("Ensure Cloudflare Pages custom domain `$domain`.");
    final list = await Process.run(
      wrangler,
      ["pages", "domain", "list", "--project-name", projectName],
      workingDirectory: workingDirectory,
      runInShell: true,
    );
    if (list.exitCode != 0) {
      stdout.write("${list.stdout}\n${list.stderr}");
      throw Exception(
        "Failed to list Cloudflare Pages domains of `$projectName`.",
      );
    }
    if (_containsToken(list.stdout.toString().toLowerCase(), domain)) {
      return;
    }
    final add = await Process.run(
      wrangler,
      ["pages", "domain", "add", domain, "--project-name", projectName],
      workingDirectory: workingDirectory,
      runInShell: true,
    );
    final addOutput = "${add.stdout}\n${add.stderr}";
    if (addOutput.trim().isNotEmpty) {
      stdout.write(addOutput);
    }
    if (add.exitCode != 0) {
      throw Exception(
        "Failed to attach the custom domain `$domain` to Cloudflare Pages project `$projectName`.",
      );
    }
  }

  /// Whether [token] appears as a whole word in the table or JSON output.
  ///
  /// テーブルまたはJSON出力に[token]が単語として含まれるかどうか。
  bool _containsToken(String output, String token) {
    final stripped = output.replaceAll(RegExp(r"\x1B\[[0-?]*[ -/]*[@-~]"), "");
    return RegExp(
      "(^|[^A-Za-z0-9_.-])${RegExp.escape(token)}([^A-Za-z0-9_.-]|\$)",
      multiLine: true,
    ).hasMatch(stripped);
  }
}
