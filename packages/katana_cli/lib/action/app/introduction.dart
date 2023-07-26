// Project imports:
import 'package:katana_cli/katana_cli.dart';

/// Add a module to use the introduction.
///
/// 導入部分を利用するためのモジュールを追加します。
class AppIntroductionCliAction extends CliCommand with CliActionMixin {
  /// Add a module to use the introduction.
  ///
  /// 導入部分を利用するためのモジュールを追加します。
  const AppIntroductionCliAction();

  @override
  String get description =>
      "Add a module to use the introduction. 導入部分を利用するためのモジュールを追加します。";

  @override
  bool checkEnabled(ExecContext context) {
    final value = context.yaml.getAsMap("app").getAsMap("introduction");
    final enabled = value.get("enable", false);
    if (!enabled) {
      return false;
    }
    return true;
  }

  @override
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final flutter = bin.get("flutter", "flutter");
    await command(
      "Import packages.",
      [
        flutter,
        "pub",
        "add",
        "masamune_introduction",
      ],
    );
  }
}
