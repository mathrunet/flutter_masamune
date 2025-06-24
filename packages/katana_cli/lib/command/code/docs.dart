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
    final enableClaudeCode = context.yaml
        .getAsMap("github")
        .getAsMap("claude_code")
        .get("enable", false);
    final enableCursor =
        context.yaml.getAsMap("github").getAsMap("cursor").get("enable", false);
    label("Generate file for AI");
    await const DesignsAiCode().exec(context);
    await const ImplsAiCode().exec(context);
    await const DocsAiCode().exec(context);
    await const TestsAiCode().exec(context);
    if (enableCursor) {
      label("Generate file for Cursor");
      final flutterVersion = await getFlutterVersion();
      label("Create global.mdc");
      await const GitCursorGlobalMdcCliCode().generateFile("global.mdc");
      label("Create Dockerfile");
      await GitCursorDockerfileCliCode(flutterVersion: flutterVersion)
          .generateFile("Dockerfile");
      label("Create environment.json");
      await const GitCursorEnvironmentCliCode()
          .generateFile("environment.json");
    }
    if (enableClaudeCode) {
      label("Generate file for Claude");
      await const GitClaudeMarkdownCliCode().generateFile("CLAUDE.md");
    }
  }
}
