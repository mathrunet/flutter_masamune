// Project imports:
import 'package:katana_cli/katana_cli.dart';

/// Add a module to use the app review.
///
/// アプリレビューを利用するためのモジュールを追加します。
class AppReviewCliAction extends CliCommand with CliActionMixin {
  /// Add a module to use the app review.
  ///
  /// アプリレビューを利用するためのモジュールを追加します。
  const AppReviewCliAction();

  @override
  String get description =>
      "Add a module to use the app review. アプリレビューを利用するためのモジュールを追加します。";

  @override
  bool checkEnabled(ExecContext context) {
    final value = context.yaml.getAsMap("app").getAsMap("app_review");
    final enabled = value.get("enable", false);
    if (!enabled) {
      return false;
    }
    return true;
  }

  @override
  Future<void> exec(ExecContext context) async {
    await addFlutterImport(
      [
        "masamune_app_review",
      ],
    );
  }
}
