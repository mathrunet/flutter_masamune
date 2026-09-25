// Dart imports:
import "dart:io";

// Project imports:
import "package:katana_cli/action/cloudflare/cloudflare_source_utils.dart";
import "package:katana_cli/action/cloudflare/pages.dart";
import "package:katana_cli/katana_cli.dart";

/// Cloudflare deployment process.
///
/// Deploys the edge Worker (`cloudflare/wrangler.jsonc`) and, when
/// [cloudflare]->[workers]->[region]->[enable] is `true`, the region Worker
/// (`cloudflare/wrangler.region.jsonc`) in this order. When
/// [cloudflare]->[pages]->[enable] is `true`, the public directory
/// ([cloudflare]->[pages]->[public_dir], `cloudflare/pages` by default) is
/// deployed to Cloudflare Pages as is afterwards.
///
/// As with Firebase Hosting, Flutter web is never built here. Build it
/// separately (e.g. in CI) and copy the output into the public directory.
/// Static files placed in the same directory (such as
/// `.well-known/apple-app-site-association`, `_headers` or `_redirects`) are
/// deployed together.
///
/// Cloudflareのデプロイ処理を行います。
///
/// edge Worker（`cloudflare/wrangler.jsonc`）をデプロイし、
/// [cloudflare]->[workers]->[region]->[enable]が`true`の場合はregion Worker
/// （`cloudflare/wrangler.region.jsonc`）をその後にデプロイします。
/// [cloudflare]->[pages]->[enable]が`true`の場合は、その後に公開ディレクトリ
/// （[cloudflare]->[pages]->[public_dir]、既定は`cloudflare/pages`）を
/// そのままCloudflare Pagesへデプロイします。
///
/// Firebase Hostingと同様に、ここではFlutter Webのビルドを行いません。
/// CIなどで別途ビルドし、成果物を公開ディレクトリへコピーしてください。
/// 同じディレクトリに置いた静的ファイル（`.well-known/apple-app-site-association`、
/// `_headers`、`_redirects`など）も一緒にデプロイされます。
class CloudflareDeployCliAction extends CliCommand with CliActionMixin {
  /// Cloudflare deployment process.
  ///
  /// Cloudflareのデプロイ処理を行います。
  const CloudflareDeployCliAction();

  @override
  String get description =>
      "Deploy Cloudflare based on the information in `katana.yaml`. Also, make `wrangler` commands available. `katana.yaml`の情報を元にCloudflareのデプロイ処理を行います。また、`wrangler`のコマンドを利用可能にしてください。";

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
    final wrangler = bin.get("wrangler", "wrangler");
    final flavor = context.flavorContext?.flavor.name ?? "prod";
    final cloudflare = context.yaml.getAsMap("cloudflare");
    final enabledWorkers = cloudflare.getAsMap("workers").get("enable", false);
    final enabledPages = cloudflare.getAsMap("pages").get("enable", false);
    if (enabledWorkers) {
      await _deployWorkers(context, wrangler: wrangler, flavor: flavor);
    }
    if (enabledPages) {
      await _deployPages(context, wrangler: wrangler, flavor: flavor);
    }
  }

  Future<void> _deployWorkers(
    ExecContext context, {
    required String wrangler,
    required String flavor,
  }) async {
    final projectId = context.yaml.getAsMap("cloudflare").get("project_id", "");
    final firebaseProjectId =
        context.yaml.getAsMap("firebase").get("project_id", "");
    final regionEnabled = isCloudflareRegionWorkerEnabled(context.yaml);
    final targets = <_CloudflareDeployTarget>[
      _CloudflareDeployTarget(
        entry: cloudflareEdgeEntryPath,
        config: null,
        workerName: projectId,
      ),
      if (regionEnabled)
        _CloudflareDeployTarget(
          entry: cloudflareRegionEntryPath,
          config: cloudflareRegionWranglerConfig,
          workerName: "$projectId-region",
        ),
    ];
    if (regionEnabled && !File(cloudflareRegionEntryPath).existsSync()) {
      error(
        "The file `$cloudflareRegionEntryPath` does not exist. Run `katana apply` with [cloudflare]->[workers]->[region]->[enable] set to `true` first.",
      );
      return;
    }
    // Validate every target before deploying anything.
    for (final target in targets) {
      final workerEntry = File(target.entry);
      if (firebaseProjectId.isEmpty || !workerEntry.existsSync()) {
        continue;
      }
      CloudflareSourceUtils.validateFirebaseProjectId(
        await workerEntry.readAsString(),
        firebaseProjectId,
        path: target.entry,
      );
      final wranglerPath = "cloudflare/${target.config ?? "wrangler.jsonc"}";
      final wranglerFile = File(wranglerPath);
      if (!wranglerFile.existsSync()) {
        throw StateError("$wranglerPath is required for deployment.");
      }
      final source = await wranglerFile.readAsString();
      String? environment;
      WranglerEnvironmentSynchronizer.transformEnvironment(
        source,
        flavor: flavor,
        transform: (value) {
          environment = value;
          return value;
        },
      );
      final vars = RegExp(r'"vars"\s*:\s*\{([^}]*)\}')
          .firstMatch(environment ?? "")
          ?.group(1);
      if (vars == null ||
          _wranglerVariable(vars, "FLAVOR") != flavor ||
          _wranglerVariable(vars, "FIREBASE_PROJECT_ID") != firebaseProjectId) {
        throw StateError(
          "Wrangler $flavor FLAVOR/FIREBASE_PROJECT_ID in $wranglerPath does not match the selected Firebase project.",
        );
      }
    }
    for (final target in targets) {
      final config = target.config;
      final configArguments =
          config == null ? const <String>[] : ["-c", config];
      // ignore: avoid_print
      print("Cloudflare deploy target: $flavor (${target.workerName})");
      final existing = await Process.run(
        wrangler,
        ["deployments", "list", "--json", ...configArguments, "--env", flavor],
        workingDirectory: "cloudflare",
        runInShell: true,
      );
      if (existing.exitCode != 0) {
        error(
          "Cloudflare Worker `${target.workerName}` does not exist or is not accessible. "
          "Katana will not create it automatically.",
        );
        return;
      }
      await command(
        config == null
            ? "Run cloudflare deploy"
            : "Run cloudflare deploy ($config)",
        [
          wrangler,
          "deploy",
          ...configArguments,
          "--env",
          flavor,
        ],
        workingDirectory: "cloudflare",
        // Stop before the region Worker when the edge Worker fails.
        catchError: regionEnabled,
        failOnStderr: false,
      );
    }
  }

  /// Deploys the public directory to Cloudflare Pages without building.
  ///
  /// ビルドを行わずに公開ディレクトリをCloudflare Pagesへデプロイします。
  Future<void> _deployPages(
    ExecContext context, {
    required String wrangler,
    required String flavor,
  }) async {
    final projectName = CloudflarePagesCliAction.resolveProjectName(
      context.yaml,
    );
    if (projectName.isEmpty) {
      error(
        "If [cloudflare]->[pages]->[enable] is enabled, please include [cloudflare]->[pages]->[project_name] or [cloudflare]->[project_id].",
      );
      return;
    }
    final publicDir = CloudflarePagesCliAction.resolvePublicDir(context.yaml);
    final directory = Directory(publicDir);
    if (!directory.existsSync() ||
        !directory
            .listSync(recursive: true, followLinks: false)
            .any((entity) => entity is File)) {
      throw StateError(
        "The Cloudflare Pages public directory `$publicDir` does not exist or is empty. "
        "Run `katana apply` and place the files to deploy (e.g. the output of `flutter build web` built separately) in it. "
        "Katana does not build Flutter web. "
        "Cloudflare Pagesの公開ディレクトリ`$publicDir`が存在しないか空です。 "
        "`katana apply`を実行し、デプロイするファイル（別途ビルドした`flutter build web`の成果物など）を配置してください。 "
        "KatanaはFlutter Webのビルドを行いません。",
      );
    }
    // ignore: avoid_print
    print("Cloudflare Pages deploy target: $flavor ($projectName)");
    await command(
      "Run cloudflare pages deploy",
      [
        wrangler,
        "pages",
        "deploy",
        publicDir,
        "--project-name",
        projectName,
        "--branch",
        "main",
        "--commit-dirty=true",
      ],
      catchError: true,
      failOnStderr: false,
    );
  }

  String? _wranglerVariable(String vars, String name) {
    final matches = RegExp('"${RegExp.escape(name)}"\\s*:\\s*"([^"]*)"')
        .allMatches(vars)
        .toList();
    return matches.length == 1 ? matches.single.group(1) : null;
  }
}

class _CloudflareDeployTarget {
  const _CloudflareDeployTarget({
    required this.entry,
    required this.config,
    required this.workerName,
  });

  final String entry;

  final String? config;

  final String workerName;
}
