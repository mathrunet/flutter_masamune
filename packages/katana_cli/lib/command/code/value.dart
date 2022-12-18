part of katana_cli.code;

/// Create a base class for Immutable values.
///
/// Immutableな値のベースクラスを作成します。
class CodeValueCliCommand extends CliCommand {
  /// Create a base class for Immutable values.
  ///
  /// Immutableな値のベースクラスを作成します。
  const CodeValueCliCommand();

  /// Code data.
  ///
  /// コードデータ。
  static const code = ValueCliCode();

  @override
  String get description =>
      "Create a base class for Immutable value in `${code.directory}/(filepath).dart`. Immutableな値のベースクラスを`${code.directory}/(filepath).dart`に作成します。";

  @override
  Future<void> exec(ExecContext context) async {
    final path = context.args.get(2, "");
    if (path.isEmpty) {
      print(
        "[path] is not specified. Please enter [path] according to the following command.\r\nkatana code page [path]\r\n",
      );
      return;
    }
    label("Create a Immutable value class in `${code.directory}/$path.dart`.");
    await code.generateDartCode("${code.directory}/$path");
  }
}
