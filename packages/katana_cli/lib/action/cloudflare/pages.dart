// Dart imports:
import "dart:io";

// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Cloudflare Pages configuration.
///
/// Creates the Pages project and attaches the custom domain based on
/// [cloudflare]->[pages] in `katana.yaml`.
///
/// Cloudflare Pagesの設定を行います。
///
/// `katana.yaml`の[cloudflare]->[pages]を元にPagesプロジェクトを作成し、
/// カスタムドメインを接続します。
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

  /// Resolves the directory deployed to Pages.
  ///
  /// Pagesへデプロイするディレクトリを解決します。
  static String resolveBuildDir(Map yaml) {
    final pages = yaml.getAsMap("cloudflare").getAsMap("pages");
    final configured = pages.get("build_dir", "").trim();
    return configured.isEmpty ? "build/web" : configured;
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
