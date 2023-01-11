part of katana_cli.code;

/// Create a base class for the Boot page.
///
/// Bootページのベースクラスを作成します。
class CodeBootCliCommand extends CliCommand {
  /// Create a base class for the Boot page.
  ///
  /// Bootページのベースクラスを作成します。
  const CodeBootCliCommand();

  /// Code data.
  ///
  /// コードデータ。
  static const code = BootCliCode();

  @override
  String get description =>
      "Create a base class for the boot page in `${code.directory}/boot.dart`. ブートページのベースクラスを`${code.directory}/boot.dart`に作成します。";

  @override
  Future<void> exec(ExecContext context) async {
    label("Create a Boot class in `${code.directory}/boot.dart`.");
    await code.generateDartCode("${code.directory}/boot.dart");
  }
}
