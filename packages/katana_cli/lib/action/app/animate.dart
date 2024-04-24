// Project imports:
import 'package:katana_cli/katana_cli.dart';

/// Add a module for using animation.
///
/// アニメーションを利用するためのモジュールを追加します。
class AppAnimateCliAction extends CliCommand with CliActionMixin {
  /// Add a module for using animation.
  ///
  /// アニメーションを利用するためのモジュールを追加します。
  const AppAnimateCliAction();

  @override
  String get description =>
      "Add a module for using animation. アニメーションを利用するためのモジュールを追加します。";

  @override
  bool checkEnabled(ExecContext context) {
    final value = context.yaml.getAsMap("app").getAsMap("animate");
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
        "masamune_animate",
      ],
    );
  }
}
