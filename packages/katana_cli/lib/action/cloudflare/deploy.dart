// Project imports:
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
    await command(
      "Run cloudflare deploy",
      [
        wrangler,
        "deploy",
      ],
      workingDirectory: "cloudflare",
    );
  }
}
