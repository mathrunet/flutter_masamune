// Project imports:
import "package:katana_cli/katana_cli.dart";

/// Contents of github_mcp.md.
///
/// github_mcp.mdの中身。
class GithubMcpCliMcpCode extends CliMcpCode {
  /// Contents of github_mcp.md.
  ///
  /// github_mcp.mdの中身。
  const GithubMcpCliMcpCode();

  @override
  String get name => "Github MCP";

  @override
  String get description => "Github MCPの設定です。";

  @override
  bool apply(ExecContext context) {
    final claudeCode =
        context.yaml.getAsMap("generative_ai").getAsMap("claude_code");
    final mcp = claudeCode.getAsMap("mcp");
    final github = mcp.getAsMap("github");
    final token = github.get("access_token", "");
    if (token.isEmpty) {
      return false;
    }
    return github.get("enable", false);
  }

  @override
  DynamicMap body(ExecContext context) {
    final claudeCode =
        context.yaml.getAsMap("generative_ai").getAsMap("claude_code");
    final mcp = claudeCode.getAsMap("mcp");
    final github = mcp.getAsMap("github");
    final token = github.get("access_token", "");
    return {
      "github": {
        "type": "http",
        "url": "https://api.githubcopilot.com/mcp",
        "headers": {"Authorization": "Bearer $token"}
      },
    };
  }
}
