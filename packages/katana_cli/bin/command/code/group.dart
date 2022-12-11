part of katana_cli;

/// Create a base class for the controller group.
///
/// コントローラーグループのベースクラスを作成します。
class CodeGroupCliCommand extends CliCommand {
  /// Create a base class for the controller group.
  ///
  /// コントローラーグループのベースクラスを作成します。
  const CodeGroupCliCommand();

  /// Code data.
  ///
  /// コードデータ。
  static const code = ControllerGroupCliCode();

  @override
  String get description =>
      "Create a base class for the controller group in `${code.directory}/(filepath).dart`. Create a base class for the controller group in `${code.directory}/(filepath).dart`.";

  @override
  Future<void> exec(Map yaml, List<String> args) async {
    final path = args.get(2, "");
    if (path.isEmpty) {
      print(
        "[path] is not specified. Please enter [path] according to the following command.\r\nkatana code group [path]\r\n",
      );
      return;
    }
    label("Create a controller group class in `${code.directory}/$path.dart`.");
    await code.generateDartCode("${code.directory}/$path");
  }
}
