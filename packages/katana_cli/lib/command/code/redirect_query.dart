part of katana_cli.code;

/// Create a base class for RedirectQuery.
///
/// RedirectQueryのベースクラスを作成します。
class CodeRedirectQueryCliCommand extends CliCommand {
  /// Create a base class for RedirectQuery.
  ///
  /// RedirectQueryのベースクラスを作成します。
  const CodeRedirectQueryCliCommand();

  /// Code data.
  ///
  /// コードデータ。
  static const code = RedirectQueryCliCode();

  @override
  String get description =>
      "Create a base class for the RedirectQuery in `${code.directory}/(filepath).dart`. RedirectQueryのベースクラスを`${code.directory}/(filepath).dart`に作成します。";

  @override
  Future<void> exec(ExecContext context) async {
    final path = context.args.get(2, "");
    if (path.isEmpty) {
      print(
        "[path] is not specified. Please enter [path] according to the following command.\r\nkatana code page [path]\r\n",
      );
      return;
    }
    label("Create a RedirectQuery class in `${code.directory}/$path.dart`.");
    await code.generateDartCode("${code.directory}/$path");
  }
}
