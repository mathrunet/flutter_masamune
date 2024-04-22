// Project imports:
import 'package:katana_cli/katana_cli.dart';

/// Add a module to pick up images.
///
/// 画像のピックアップを行うためのモジュールを追加します。
class AppPickerCliAction extends CliCommand with CliActionMixin {
  /// Add a module to pick up images.
  ///
  /// 画像のピックアップを行うためのモジュールを追加します。
  const AppPickerCliAction();

  @override
  String get description =>
      "Add a module to pick up images. 画像のピックアップを行うためのモジュールを追加します。";

  @override
  bool checkEnabled(ExecContext context) {
    final value = context.yaml.getAsMap("app").getAsMap("picker");
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
    final picker = app.getAsMap("picker");
    if (picker.isEmpty) {
      error("The item [app]->[picker] is missing. Please add an item.");
      return;
    }
    final permission = picker.getAsMap("permission");
    if (permission.isEmpty) {
      error(
        "The item [app]->[picker]->[permission] is missing. Please include the language code and the message when authorization is granted here.",
      );
      return;
    }
    label("Addition of permission messages.");
    await XCodePermissionType.photoLibraryUsage.setMessageToXCode(
      permission
          .map((key, value) => MapEntry(key, value.toString()))
          .where((key, value) => value.isNotEmpty),
    );
    await PodfilePermissionType.photoLibraryUsage.enablePermissionToPodfile();
    await addFlutterImport(
      [
        "masamune_picker",
      ],
    );
    label("Edit PrivacyInfo.xcprivacy.");
    await XCodePrivacyManifests.fileTimestamp.setPrivacyManifestToXCode(
      XCodePrivacyManifests.fileTimestamp.reasons.first,
    );
  }
}
