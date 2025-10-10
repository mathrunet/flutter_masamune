// Project imports:
import "package:katana_cli/ai/mcp/dart_mcp.dart";
import "package:katana_cli/ai/mcp/figma_mcp.dart";
import "package:katana_cli/ai/mcp/firebase_mcp.dart";
import "package:katana_cli/ai/mcp/github_mcp.dart";
import "package:katana_cli/ai/mcp/notion_mcp.dart";
import "package:katana_cli/katana_cli.dart";

/// McpMcpCode is a command that generates MCP code.
///
/// McpMcpCodeはMCPコードを生成するコマンドです。
class McpMcpCode extends CliMcpCodeCommand {
  /// McpMcpCode is a command that generates MCP code.
  ///
  /// McpMcpCodeはMCPコードを生成するコマンドです。
  const McpMcpCode();

  @override
  final String description =
      "Generate MCP code to do the agents. エージェントを生成するためのMCPコードを生成します。";

  @override
  Map<String, CliMcpCode> get mcps => {
        "dart": const DartMcpCliMcpCode(),
        "notion": const NotionMcpCliMcpCode(),
        "figma": const FigmaMcpCliMcpCode(),
        "github": const GithubMcpCliMcpCode(),
        "firebase": const FirebaseMcpCliMcpCode(),
      };
}
