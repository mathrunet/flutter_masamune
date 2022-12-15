part of katana_cli.code;

/// Create a base class for the controller.
///
/// コントローラーのベースクラスを作成します。
class CodeControllerCliCommand extends CliCommand {
  /// Create a base class for the controller.
  ///
  /// コントローラーのベースクラスを作成します。
  const CodeControllerCliCommand();

  /// Code data.
  ///
  /// コードデータ。
  static const code = ControllerCliCode();

  @override
  String get description =>
      "Create a base class for the controller in `${code.directory}/(filepath).dart`. コントローラーのベースクラスを`${code.directory}/(filepath).dart`に作成します。";

  @override
  Future<void> exec(ExecContext context) async {
    final path = context.args.get(2, "");
    if (path.isEmpty) {
      print(
        "[path] is not specified. Please enter [path] according to the following command.\r\nkatana code controller [path]\r\n",
      );
      return;
    }
    label("Create a controller class in `${code.directory}/$path.dart`.");
    await code.generateDartCode("${code.directory}/$path");
  }
}
