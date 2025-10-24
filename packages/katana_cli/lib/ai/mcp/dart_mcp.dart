// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Contents of dart_mcp.md.
///
/// dart_mcp.mdの中身。
class DartMcpCliMcpCode extends CliMcpCode {
  /// Contents of dart_mcp.md.
  ///
  /// dart_mcp.mdの中身。
  const DartMcpCliMcpCode();

  @override
  String get name => "Dart MCP";

  @override
  String get description => "Dart MCPの設定です。";

  @override
  bool apply(ExecContext context) {
    final claudeCode =
        context.yaml.getAsMap("generative_ai").getAsMap("claude_code");
    final mcp = claudeCode.getAsMap("mcp");
    final dart = mcp.getAsMap("dart");
    return dart.get("enable", false);
  }

  @override
  DynamicMap body(ExecContext context) {
    return {
      "dart": {
        "command": "dart",
        "args": ["mcp-server", "--force-roots-fallback"]
      },
    };
  }
}
