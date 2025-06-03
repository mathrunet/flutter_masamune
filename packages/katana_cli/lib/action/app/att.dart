// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Prepare to display the `AppTrackingTransparency` permission dialog.
///
/// `AppTrackingTransparency`の許可ダイアログを表示するための準備をします。
class AppTrackingTransparencyCliAction extends CliCommand with CliActionMixin {
  /// Prepare to display the `AppTrackingTransparency` permission dialog.
  ///
  /// `AppTrackingTransparency`の許可ダイアログを表示するための準備をします。
  const AppTrackingTransparencyCliAction();

  @override
  String get description =>
      "Prepare to display the `AppTrackingTransparency` permission dialog. `AppTrackingTransparency`の許可ダイアログを表示するための準備をします。";

  @override
  bool checkEnabled(ExecContext context) {
    final value =
        context.yaml.getAsMap("app").getAsMap("app_tracking_transparency");
    final enabled = value.get("enable", false);
    if (!enabled) {
      return false;
    }
    return true;
  }

  @override
  Future<void> exec(ExecContext context) async {
    final app = context.yaml.getAsMap("app");
    if (app.isEmpty) {
      error("The item [app] is missing. Please add an item.");
      return;
    }
    final att = app.getAsMap("app_tracking_transparency");
    if (att.isEmpty) {
      error(
          "The item [app]->[app_tracking_transparency] is missing. Please add an item.");
      return;
    }
    final permission = att.getAsMap("permission");
    await addFlutterImport(
      [
        "permission_handler",
      ],
    );
    label("Addition of permission messages.");
    await XCodePermissionType.userTrackingUsage.setMessageToXCode(
      permission
          .map((key, value) => MapEntry(key, value.toString()))
          .where((key, value) => value.isNotEmpty),
    );
    await PodfilePermissionType.userTrackingUsage.enablePermissionToPodfile();
  }
}
