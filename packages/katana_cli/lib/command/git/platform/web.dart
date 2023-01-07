import 'package:katana_cli/katana_cli.dart';

/// Gibhut Actions build for Web.
///
/// Web用のGibhut Actionsのビルド。
Future<void> buildWeb(
  ExecContext context, {
  required String gh,
}) async {
  await const GithubActionsIOSCliCode().generateFile("build_web.yaml");
}
