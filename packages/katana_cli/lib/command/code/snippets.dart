part of "code.dart";

/// Snippets for VSCode.
///
/// VSCode用のコードスニペットを作成します。
class CodeSnippetsCliCommand extends CliCommand {
  /// Snippets for VSCode.
  ///
  /// VSCode用のコードスニペットを作成します。
  const CodeSnippetsCliCommand();

  @override
  String get description => "Snippets for VSCode. VSCode用のコードスニペットを作成します。";

  @override
  String? get example => "katana code snippets";

  @override
  Future<void> exec(ExecContext context) async {
    label("Generate file for VSCode Snippets");
    await CodeSnippetsCliGroup().generateFiles();
  }
}
