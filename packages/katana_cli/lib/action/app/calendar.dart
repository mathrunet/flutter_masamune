// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Add a module to use the calendar.
///
/// カレンダーを利用するためのモジュールを追加します。
class AppCalendarCliAction extends CliCommand with CliActionMixin {
  /// Add a module to use the calendar.
  ///
  /// カレンダーを利用するためのモジュールを追加します。
  const AppCalendarCliAction();

  @override
  String get description =>
      "Add a module to use the calendar. カレンダーを利用するためのモジュールを追加します。";

  @override
  bool checkEnabled(ExecContext context) {
    final value = context.yaml.getAsMap("app").getAsMap("calendar");
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
        "masamune_calendar",
      ],
    );
  }
}
