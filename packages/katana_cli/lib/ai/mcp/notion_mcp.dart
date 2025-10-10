// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Contents of notion_mcp.md.
///
/// notion_mcp.mdの中身。
class NotionMcpCliMcpCode extends CliMcpCode {
  /// Contents of notion_mcp.md.
  ///
  /// notion_mcp.mdの中身。
  const NotionMcpCliMcpCode();

  @override
  String get name => "Notion MCP";

  @override
  String get description => "Notion MCPの設定です。";

  @override
  bool apply(ExecContext context) {
    final claudeCode =
        context.yaml.getAsMap("generative_ai").getAsMap("claude_code");
    final mcp = claudeCode.getAsMap("mcp");
    final notion = mcp.getAsMap("notion");
    return notion.get("enable", false);
  }

  @override
  DynamicMap body(ExecContext context) {
    return {
      "notion": {
        "type": "http",
        "url": "https://mcp.notion.com/mcp",
      },
    };
  }
}
