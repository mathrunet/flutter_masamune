// Dart imports:
import "dart:io";

// Project imports:
import "package:katana_cli/action/post/firebase_deploy_post_action.dart";
import "package:katana_cli/katana_cli.dart";

/// Cloudflare deployment process for Turso.
///
/// Cloudflare用のTursoのデプロイ処理を行います。
class CloudflareTursoCliAction extends CliCommand with CliActionMixin {
  /// Cloudflare deployment process for Turso.
  ///
  /// Cloudflare用のTursoのデプロイ処理を行います。
  const CloudflareTursoCliAction();

  @override
  String get description =>
      "We will perform the deployment process for TursoDB with Cloudflare. Please register with Turso (https://turso.tech/) in advance, and create an organization, a group, and an API token. Cloudflare用のTursoDBのデプロイ処理を行います。予めTruso（https://turso.tech/）に登録し、組織とグループ、APIトークンを作成してください。";

  @override
  bool checkEnabled(ExecContext context) {
    final cloudflare = context.yaml.getAsMap("cloudflare");
    final turso = cloudflare.getAsMap("turso");
    final enableTurso = turso.get("enable", false);
    return enableTurso;
  }

  @override
  Future<void> exec(ExecContext context) async {}
}
