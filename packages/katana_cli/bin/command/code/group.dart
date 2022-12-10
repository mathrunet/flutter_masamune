part of katana_cli;

/// Create a base class for the controller group in `lib/controller/(filepath).dart`.
///
/// コントローラーグループのベースクラスを`lib/controller/(filepath).dart`に作成します。
class CodeGroupCliCommand extends CliCommand {
/// Create a base class for the controller group in `lib/controller/(filepath).dart`.
///
/// コントローラーグループのベースクラスを`lib/controller/(filepath).dart`に作成します。
  const CodeGroupCliCommand();

  @override
  String get description =>
      "Create a base class for the controller group in `lib/controller/(filepath).dart`. Create a base class for the controller group in `lib/controller/(filepath).dart`.";

  @override
  Future<void> exec(Map yaml, List<String> args) async {
    final path = args.get(2, "");
    if (path.isEmpty) {
      print(
        "[path] is not specified. Please enter [path] according to the following command.\r\nkatana code group [path]\r\n",
      );
      return;
    }
    label("Create a controller group class in `lib/controller/$path.dart`.");
    await const ControllerGroupCliCode().generateDartCode("lib/controller/$path");
  }
}
