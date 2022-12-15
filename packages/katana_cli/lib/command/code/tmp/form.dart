part of katana_cli.code.tmp;

/// Create a template for the form page.
///
/// フォームページのテンプレートを作成します。
class CodeTmpFormCliCommand extends CliCommand {
  /// Create a template for the form page.
  ///
  /// フォームページのテンプレートを作成します。
  const CodeTmpFormCliCommand();

  /// Code data.
  ///
  /// コードデータ。
  static const code = FormPageCliCode();

  @override
  String get description =>
      "Create a template for the form page in `${code.directory}/(filepath).dart`. フォームページのテンプレートを`${code.directory}/(filepath).dart`に作成します。";

  @override
  Future<void> exec(ExecContext context) async {
    final path = context.args.get(3, "");
    if (path.isEmpty) {
      print(
        "[path] is not specified. Please enter [path] according to the following command.\r\nkatana code tmp form [path]\r\n",
      );
      return;
    }
    label("Create a form template in `${code.directory}/$path.dart`.");
    await code.generateDartCode("${code.directory}/$path");
  }
}
