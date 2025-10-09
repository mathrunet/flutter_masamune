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
    final claudeCode =
        context.yaml.getAsMap("generative_ai").getAsMap("claude_code");
    final enableClaudeCode = claudeCode.get("enable", false);
    final enableClaudeCodeBackground = claudeCode.get("background", false);
    await const DesignsAiCode().exec(context);
    await const ImplsAiCode().exec(context);
    await const DocsAiCode().exec(context);
    await const TestsAiCode().exec(context);
    if (enableClaudeCode) {
      label("Generate file for Claude");
      await GitClaudeMarkdownCliCode(
        availabeBackground: enableClaudeCodeBackground,
      ).generateFile("CLAUDE.md");
      await const AgentsAiCode().exec(context);
    }
  }
}
