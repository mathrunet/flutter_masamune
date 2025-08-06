part of "/masamune_ai.dart";

/// Status of the MCP server.
///
/// MCPサーバーの状態。
enum McpServerStatus {
  /// The server is listening.
  ///
  /// サーバーがリッスンしています。
  listened,

  /// The server is not listening.
  ///
  /// サーバーがリッスンしていません。
  unlistened;
}

/// Server configuration for MCP.
///
/// MCPのサーバーコンフィグ。
@immutable
class McpServerConfig {
  /// Server configuration for MCP.
  ///
  /// MCPのサーバーコンフィグ。
  const McpServerConfig({
    required this.name,
    required this.transport,
    this.version = "1.0.0",
  });

  /// Server name.
  ///
  /// サーバー名。
  final String name;

  /// Server version.
  ///
  /// サーバーバージョン。
  final String version;

  /// Transport settings.
  ///
  /// トランスポート設定。
  final Transport transport;
}
