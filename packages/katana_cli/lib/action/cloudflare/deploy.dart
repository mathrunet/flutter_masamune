// Dart imports:
import "dart:io";

// Project imports:
import "package:katana_cli/action/cloudflare/cloudflare_source_utils.dart";
import "package:katana_cli/katana_cli.dart";

/// Cloudflare deployment process.
///
/// Cloudflareのデプロイ処理を行います。
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
    final workerIndex = File("cloudflare/src/index.ts");
    if (firebaseProjectId.isNotEmpty && workerIndex.existsSync()) {
      CloudflareSourceUtils.validateFirebaseProjectId(
        await workerIndex.readAsString(),
        firebaseProjectId,
      );
      final wranglerFile = File("cloudflare/wrangler.jsonc");
      if (!wranglerFile.existsSync()) {
        throw StateError(
            "cloudflare/wrangler.jsonc is required for deployment.");
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
          "Wrangler $flavor FLAVOR/FIREBASE_PROJECT_ID does not match the selected Firebase project.",
        );
      }
    }
    // ignore: avoid_print
    print("Cloudflare deploy target: $flavor ($projectId)");
    final existing = await Process.run(
      wrangler,
      ["deployments", "list", "--json", "--env", flavor],
      workingDirectory: "cloudflare",
      runInShell: true,
    );
    if (existing.exitCode != 0) {
      error(
        "Cloudflare Worker `$projectId` does not exist or is not accessible. "
        "Katana will not create it automatically.",
      );
      return;
    }
    await command(
      "Run cloudflare deploy",
      [
        wrangler,
        "deploy",
        "--env",
        flavor,
      ],
      workingDirectory: "cloudflare",
    );
  }

  String? _wranglerVariable(String vars, String name) {
    final matches = RegExp('"${RegExp.escape(name)}"\\s*:\\s*"([^"]*)"')
        .allMatches(vars)
        .toList();
    return matches.length == 1 ? matches.single.group(1) : null;
  }
}
