part of katana_cli;

/// Create a base class for the controller in `lib/controller/(filepath).dart`.
///
/// コントローラーのベースクラスを`lib/controller/(filepath).dart`に作成します。
class CodeControllerCliCommand extends CliCommand {
  /// Create a base class for the controller in `lib/controller/(filepath).dart`.
  ///
  /// コントローラーのベースクラスを`lib/controller/(filepath).dart`に作成します。
  const CodeControllerCliCommand();

  @override
  String get description =>
      "Create a base class for the controller in `lib/controller/(filepath).dart`. コントローラーのベースクラスを`lib/controller/(filepath).dart`に作成します。";

  @override
  Future<void> exec(Map yaml, List<String> args) async {
    final path = args.get(2, "");
    if (path.isEmpty) {
      print(
        "[path] is not specified. Please enter [path] according to the following command.\r\nkatana code controller [path]\r\n",
      );
      return;
    }
    label("Create a controller class in `lib/controller/$path.dart`.");
    await const ControllerCliCode().generateDartCode("lib/controller/$path");
  }
}
