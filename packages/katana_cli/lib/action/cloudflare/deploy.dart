// Dart imports:
import "dart:io";

// Project imports:
import "package:katana_cli/action/cloudflare/cloudflare_source_utils.dart";
import "package:katana_cli/katana_cli.dart";

/// Cloudflare deployment process.
///
/// Deploys the edge Worker (`cloudflare/wrangler.jsonc`) and, when
/// [cloudflare]->[workers]->[region]->[enable] is `true`, the region Worker
/// (`cloudflare/wrangler.region.jsonc`) in this order.
///
/// Cloudflareのデプロイ処理を行います。
///
/// edge Worker（`cloudflare/wrangler.jsonc`）をデプロイし、
/// [cloudflare]->[workers]->[region]->[enable]が`true`の場合はregion Worker
/// （`cloudflare/wrangler.region.jsonc`）をその後にデプロイします。
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
