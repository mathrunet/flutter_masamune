// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Add a module to use the force updater.
///
/// 強制アップデートを利用するためのモジュールを追加します。
class AppForceUpdaterCliAction extends CliCommand with CliActionMixin {
  /// Add a module to use the force updater.
  ///
  /// 強制アップデートを利用するためのモジュールを追加します。
  const AppForceUpdaterCliAction();

  @override
  String get description =>
      "Add a module to use the force updater. 強制アップデートを利用するためのモジュールを追加します。";

  @override
  bool checkEnabled(ExecContext context) {
    final value = context.yaml.getAsMap("app").getAsMap("force_updater");
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
        "masamune_force_updater",
      ],
    );
  }
}
