part of "code.dart";

/// Documentation for AI.
///
/// AI用のドキュメントを作成します。
class CodeDocsCliCommand extends CliCommand {
  /// Documentation for AI.
  ///
  /// AI用のドキュメントを作成します。
  const CodeDocsCliCommand();

  @override
  String get description => "Documentation for AI. AI用のドキュメントを作成します。";

  @override
  String? get example => "katana code docs";

  @override
  Future<void> exec(ExecContext context) async {
    label("Generate file for Cursor AI");
    await const DesignsAiCode().exec(context);
    await const ImplsAiCode().exec(context);
    await const DocsAiCode().exec(context);
  }
}
