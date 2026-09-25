// Dart imports:
import "dart:convert";
import "dart:io";

// Project imports:
import "package:katana_cli/action/cloudflare/cloudflare_api.dart";
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
/// The custom domain is attached through the Cloudflare API (Pages domains
/// API) because Wrangler has no command for it. The API token is taken from
/// [cloudflare]->[api_token] in `katana_secrets.yaml`, the environment variable
/// `CLOUDFLARE_API_TOKEN`, or `wrangler auth token` in this order. When the
/// domain waits for its CNAME record and [cloudflare]->[zone_id] belongs to the
/// same account, a proxied CNAME record to `<project>.pages.dev` is created.
/// Missing permissions only produce a warning with the manual steps.
///
/// Cloudflare Pagesの設定を行います。
///
/// Wranglerにコマンドが無いため、カスタムドメインはCloudflare API（Pages domains API）で
/// 接続します。APIトークンは`katana_secrets.yaml`の[cloudflare]->[api_token]、
/// 環境変数`CLOUDFLARE_API_TOKEN`、`wrangler auth token`の順に取得します。
/// ドメインがCNAMEレコード待ちで、[cloudflare]->[zone_id]が同じアカウントにある場合は
/// `<project>.pages.dev`へのプロキシ有効なCNAMEレコードを作成します。
/// 権限が足りない場合は手動手順を警告として表示するだけで、処理は停止しません。
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
  /// [apiBaseUrl] replaces the Cloudflare API endpoint and [environment]
  /// replaces the process environment variables (for tests).
  ///
  /// Cloudflare Pagesの設定を行います。
  ///
  /// [apiBaseUrl]でCloudflare APIのエンドポイントを、[environment]で
  /// プロセスの環境変数を差し替えます（テスト用）。
  const CloudflarePagesCliAction({this.apiBaseUrl, this.environment});

  /// Environment variables. Defaults to [Platform.environment].
  ///
  /// 環境変数。既定は[Platform.environment]。
  final Map<String, String>? environment;

  /// Endpoint of the Cloudflare API. Defaults to
  /// `https://api.cloudflare.com/client/v4/`.
  ///
  /// Cloudflare APIのエンドポイント。既定は`https://api.cloudflare.com/client/v4/`。
  final String? apiBaseUrl;

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
        context,
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

  Future<void> _ensureDomain(
    ExecContext context, {
    required String wrangler,
    required String projectName,
    required String domain,
  }) async {
    label("Ensure Cloudflare Pages custom domain `$domain`.");
    final cloudflare = context.yaml.getAsMap("cloudflare");
    final token = await _resolveApiToken(context, wrangler: wrangler);
    if (token == null) {
      _warning(
        "No Cloudflare API token is available, so the custom domain `$domain` was not attached to Pages project `$projectName`. "
        "Set [cloudflare]->[api_token] in `katana_secrets.yaml` (or run `wrangler login`) and run `katana apply` again, "
        "or attach it manually in the dashboard (Workers & Pages > $projectName > Custom domains). "
        "Cloudflare APIトークンが取得できないため、カスタムドメイン`$domain`をPagesプロジェクト`$projectName`へ接続できませんでした。 "
        "`katana_secrets.yaml`の[cloudflare]->[api_token]を設定する（または`wrangler login`を実行する）かして`katana apply`を再実行するか、 "
        "ダッシュボード（Workers & Pages > $projectName > Custom domains）から手動で接続してください。",
      );
      return;
    }
    final api = CloudflareApi(
      token: token,
      baseUrl: apiBaseUrl == null ? null : Uri.parse(apiBaseUrl!),
    );
    try {
      final accountId = await _resolveAccountId(
        cloudflare,
        api: api,
        wrangler: wrangler,
        projectName: projectName,
      );
      if (accountId == null) {
        _warning(
          "Could not determine the Cloudflare account of Pages project `$projectName`, so `$domain` was not attached. "
          "Set [cloudflare]->[account_id] in `katana.yaml` and run `katana apply` again. "
          "Pagesプロジェクト`$projectName`のCloudflareアカウントを特定できないため、`$domain`を接続できませんでした。 "
          "`katana.yaml`の[cloudflare]->[account_id]を設定して`katana apply`を再実行してください。",
        );
        return;
      }
      final domains = await api.listPagesDomains(accountId, projectName);
      var current = domains.where((e) => e.name == domain).firstOrNull;
      if (current == null) {
        current = await api.addPagesDomain(accountId, projectName, domain);
        stdout.writeln(
          "\nAttached `$domain` to Cloudflare Pages project `$projectName`.",
        );
      }
      if (current.needsDnsRecord) {
        await _ensureCname(
          api,
          accountId: accountId,
          zoneId: _resolveZoneId(cloudflare),
          projectName: projectName,
          domain: domain,
        );
      }
    } on CloudflareApiException catch (e) {
      if (!e.isPermissionError) {
        rethrow;
      }
      _warning(
        "The Cloudflare API token is not allowed to ${e.operation} (HTTP ${e.statusCode}). "
        "Use an API token with `Account > Cloudflare Pages > Edit` in [cloudflare]->[api_token] of `katana_secrets.yaml` and run `katana apply` again, "
        "or attach `$domain` manually in the dashboard (Workers & Pages > $projectName > Custom domains). "
        "Cloudflare APIトークンに権限が無いため、操作（${e.operation}）に失敗しました（HTTP ${e.statusCode}）。 "
        "`Account > Cloudflare Pages > Edit`権限を持つAPIトークンを`katana_secrets.yaml`の[cloudflare]->[api_token]に設定して`katana apply`を再実行するか、 "
        "ダッシュボード（Workers & Pages > $projectName > Custom domains）から`$domain`を手動で接続してください。",
      );
    } finally {
      api.close();
    }
  }

  /// Creates the proxied CNAME record `<domain>` -> `<project>.pages.dev`
  /// when the zone belongs to the same account. Otherwise shows the manual
  /// steps as a warning.
  ///
  /// ゾーンが同じアカウントにある場合、プロキシ有効なCNAMEレコード
  /// `<domain>` -> `<project>.pages.dev`を作成します。それ以外は手動手順を警告します。
  Future<void> _ensureCname(
    CloudflareApi api, {
    required String accountId,
    required String zoneId,
    required String projectName,
    required String domain,
  }) async {
    var target = "$projectName.pages.dev";
    void manual(String reason, String reasonJa) {
      _warning(
        "$reason Create a proxied CNAME record `$domain` -> `$target` in the DNS of `$domain`. "
        "Pages activates the domain once the record exists. "
        "$reasonJa `$domain`のDNSにプロキシ有効なCNAMEレコード`$domain` -> `$target`を作成してください。 "
        "レコードが作成されるとPagesのドメインが有効になります。",
      );
    }

    try {
      target =
          await api.getPagesProjectSubdomain(accountId, projectName) ?? target;
      if (zoneId.isEmpty) {
        manual(
          "The custom domain `$domain` waits for its CNAME record and [cloudflare]->[zone_id] is not set.",
          "カスタムドメイン`$domain`はCNAMEレコード待ちですが、[cloudflare]->[zone_id]が設定されていません。",
        );
        return;
      }
      final zone = await api.getZone(zoneId);
      if (zone.accountId != accountId || !zone.contains(domain)) {
        manual(
          "The zone [cloudflare]->[zone_id] is not `$domain` in the same account as Pages project `$projectName`.",
          "[cloudflare]->[zone_id]のゾーンが、Pagesプロジェクト`$projectName`と同じアカウントの`$domain`のゾーンではありません。",
        );
        return;
      }
      final records = await api.listDnsRecords(zoneId, domain);
      if (records.any((e) => e.type == "CNAME" && e.content == target)) {
        return;
      }
      if (records.isNotEmpty) {
        manual(
          "A DNS record for `$domain` already exists but does not point to `$target`, so Katana does not overwrite it.",
          "`$domain`のDNSレコードが既に存在し`$target`を指していないため、Katanaは上書きしません。",
        );
        return;
      }
      await api.createProxiedCname(zoneId, name: domain, content: target);
      stdout.writeln(
          "\nCreated the proxied CNAME record `$domain` -> `$target`.");
    } on CloudflareApiException catch (e) {
      if (!e.isPermissionError) {
        rethrow;
      }
      manual(
        "The Cloudflare API token is not allowed to ${e.operation} (HTTP ${e.statusCode}). "
            "Grant `Zone > Zone > Read` and `Zone > DNS > Edit` to [cloudflare]->[api_token] and run `katana apply` again, or:",
        "Cloudflare APIトークンに権限が無いため、操作（${e.operation}）に失敗しました（HTTP ${e.statusCode}）。 "
            "[cloudflare]->[api_token]に`Zone > Zone > Read`と`Zone > DNS > Edit`の権限を付与して`katana apply`を再実行するか、次を行ってください。",
      );
    }
  }

  /// Resolves the Cloudflare API token without printing it.
  ///
  /// Cloudflare APIトークンを表示せずに解決します。
  Future<String?> _resolveApiToken(
    ExecContext context, {
    required String wrangler,
  }) async {
    final secret =
        context.secrets.getAsMap("cloudflare").get("api_token", "").trim();
    if (secret.isNotEmpty) {
      return secret;
    }
    final environment =
        (_environment["CLOUDFLARE_API_TOKEN"] ?? "").trim();
    if (environment.isNotEmpty) {
      return environment;
    }
    try {
      final result = await Process.run(
        wrangler,
        ["auth", "token", "--json"],
        workingDirectory: workingDirectory,
        runInShell: true,
      );
      if (result.exitCode != 0) {
        return null;
      }
      final decoded = jsonDecode(result.stdout.toString());
      final token = decoded is Map ? decoded["token"] : null;
      return token is String && token.trim().isNotEmpty ? token.trim() : null;
    } on Exception {
      return null;
    }
  }

  /// Resolves the account ID from [cloudflare]->[account_id],
  /// `CLOUDFLARE_ACCOUNT_ID`, `cloudflare/wrangler.jsonc` or `wrangler whoami`.
  /// With several accounts, the account that owns [projectName] is used.
  ///
  /// [cloudflare]->[account_id]、`CLOUDFLARE_ACCOUNT_ID`、`cloudflare/wrangler.jsonc`、
  /// `wrangler whoami`の順にアカウントIDを解決します。
  /// 複数のアカウントがある場合は[projectName]を所有するアカウントを使用します。
  Future<String?> _resolveAccountId(
    Map cloudflare, {
    required CloudflareApi api,
    required String wrangler,
    required String projectName,
  }) async {
    final configured = cloudflare.get("account_id", "").trim();
    if (configured.isNotEmpty) {
      return configured;
    }
    final environment =
        (_environment["CLOUDFLARE_ACCOUNT_ID"] ?? "").trim();
    if (environment.isNotEmpty) {
      return environment;
    }
    final wranglerJsonc = File("cloudflare/wrangler.jsonc");
    if (wranglerJsonc.existsSync()) {
      final match = RegExp(r'"account_id"\s*:\s*"([^"]+)"')
          .firstMatch(wranglerJsonc.readAsStringSync());
      if (match != null) {
        return match.group(1);
      }
    }
    final List<String> accounts;
    try {
      final result = await Process.run(
        wrangler,
        ["whoami", "--json"],
        workingDirectory: workingDirectory,
        runInShell: true,
      );
      if (result.exitCode != 0) {
        return null;
      }
      final decoded = jsonDecode(result.stdout.toString());
      final list = decoded is Map ? decoded["accounts"] : null;
      accounts = list is List
          ? list
              .whereType<Map>()
              .map((e) => e["id"]?.toString() ?? "")
              .where((e) => e.isNotEmpty)
              .toList()
          : const [];
    } on Exception {
      return null;
    }
    if (accounts.length <= 1) {
      return accounts.firstOrNull;
    }
    final owners = <String>[];
    for (final account in accounts) {
      try {
        await api.getPagesProjectSubdomain(account, projectName);
        owners.add(account);
      } on CloudflareApiException {
        continue;
      }
    }
    return owners.length == 1 ? owners.single : null;
  }

  String _resolveZoneId(Map cloudflare) {
    final configured = cloudflare.get("zone_id", "").trim();
    return configured.isNotEmpty
        ? configured
        : (_environment["CLOUDFLARE_ZONE_ID"] ?? "").trim();
  }

  Map<String, String> get _environment => environment ?? Platform.environment;

  void _warning(String message) {
    stderr.writeln("\nWarning: $message");
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
