// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Contents of firebase_mcp.md.
///
/// firebase_mcp.mdの中身。
class FirebaseMcpCliMcpCode extends CliMcpCode {
  /// Contents of firebase_mcp.md.
  ///
  /// firebase_mcp.mdの中身。
  const FirebaseMcpCliMcpCode();

  @override
  String get name => "Firebase MCP";

  @override
  String get description => "Firebase MCPの設定です。";

  @override
  bool apply(ExecContext context) {
    final claudeCode =
        context.yaml.getAsMap("generative_ai").getAsMap("claude_code");
    final mcp = claudeCode.getAsMap("mcp");
    final firebase = mcp.getAsMap("firebase");
    return firebase.get("enable", false);
  }

  @override
  DynamicMap body(ExecContext context) {
    return {
      "firebase": {
        "type": "stdio",
        "command": "npx",
        "args": ["-y", "firebase-tools@latest", "experimental:mcp"],
        "env": {}
      }
    };
  }
}
