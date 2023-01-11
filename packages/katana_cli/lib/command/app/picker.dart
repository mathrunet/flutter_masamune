part of katana_cli.app;

/// Add a module to pick up images.
///
/// 画像のピックアップを行うためのモジュールを追加します。
class AppPickerCliCommand extends CliCommand {
  /// Add a module to pick up images.
  ///
  /// 画像のピックアップを行うためのモジュールを追加します。
  const AppPickerCliCommand();

  @override
  String get description =>
      "Add a module to pick up images. 画像のピックアップを行うためのモジュールを追加します。";

  @override
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final flutter = bin.get("flutter", "flutter");
    final app = context.yaml.getAsMap("app");
    if (app.isEmpty) {
      print("The item [app] is missing. Please add an item.");
      return;
    }
    final picker = app.getAsMap("picker");
    if (picker.isEmpty) {
      print("The item [app]->[picker] is missing. Please add an item.");
      return;
    }
    final permission = picker.getAsMap("permission");
    if (permission.isEmpty) {
      print(
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
    final platform = picker.get("platform", "any");
    switch (platform) {
      case "mobile":
        await command(
          "Import packages.",
          [
            flutter,
            "pub",
            "add",
            "masamune_picker_mobile",
          ],
        );
        break;
      case "any":
        await command(
          "Import packages.",
          [
            flutter,
            "pub",
            "add",
            "masamune_picker_file",
          ],
        );
        break;
      default:
        print(
          "The item [app]->[picker]->[platform] is missing. Write `any` or `mobile`.",
        );
        return;
    }
  }
}
