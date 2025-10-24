// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Contents of figma_mcp.md.
///
/// figma_mcp.mdの中身。
class FigmaMcpCliMcpCode extends CliMcpCode {
  /// Contents of figma_mcp.md.
  ///
  /// figma_mcp.mdの中身。
  const FigmaMcpCliMcpCode();

  @override
  String get name => "Figma MCP";

  @override
  String get description => "Figma MCPの設定です。";

  @override
  bool apply(ExecContext context) {
    final claudeCode =
        context.yaml.getAsMap("generative_ai").getAsMap("claude_code");
    final mcp = claudeCode.getAsMap("mcp");
    final figma = mcp.getAsMap("figma");
    return figma.get("enable", false);
  }

  @override
  DynamicMap body(ExecContext context) {
    return {
      "figma-remote-mcp": {
        "type": "http",
        "url": "https://mcp.figma.com/mcp",
      },
    };
  }
}
