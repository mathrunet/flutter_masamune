part of katana_cli;

/// Create a base class for the page.
///
/// ページのベースクラスを作成します。
class CodePageCliCommand extends CliCommand {
  /// Create a base class for the page.
  ///
  /// ページのベースクラスを作成します。
  const CodePageCliCommand();

  /// Code data.
  ///
  /// コードデータ。
  static const code = PageCliCode();

  @override
  String get description =>
      "Create a base class for the page in `${code.directory}/(filepath).dart`. ページのベースクラスを`${code.directory}/(filepath).dart`に作成します。";

  @override
  Future<void> exec(Map yaml, List<String> args) async {
    final path = args.get(2, "");
    if (path.isEmpty) {
      print(
        "[path] is not specified. Please enter [path] according to the following command.\r\nkatana code page [path]\r\n",
      );
      return;
    }
    label("Create a page class in `${code.directory}/$path.dart`.");
    await code.generateDartCode("${code.directory}/$path");
  }
}
