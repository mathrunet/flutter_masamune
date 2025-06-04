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

/// Controller for MCP server.
///
/// Start the server with [listen].
///
/// If [config] or [AIMasamuneAdapter.mcpServerConfig] is not set, an error will result.
///
/// [unlisten] to terminate the server.
///
/// The actual list of tools is configured in [AIMasamuneAdapter.mcpFunctions].
///
/// MCPサーバーのコントローラー。
///
/// [listen]でサーバーを起動します。
///
/// [config]、もしくは[AIMasamuneAdapter.mcpServerConfig]が設定されていない場合はエラーになります。
///
/// [unlisten]でサーバーを終了します。
///
/// 実際のツール一覧は[AIMasamuneAdapter.mcpFunctions]で設定します。
class McpServer
    extends MasamuneControllerBase<McpServerStatus, AIMasamuneAdapter> {
  /// Controller for MCP server.
  ///
  /// Start the server with [listen].
  ///
  /// If [config] or [AIMasamuneAdapter.mcpServerConfig] is not set, an error will result.
  ///
  /// [unlisten] to terminate the server.
  ///
  /// The actual list of tools is configured in [AIMasamuneAdapter.mcpFunctions].
  ///
  /// MCPサーバーのコントローラー。
  ///
  /// [listen]でサーバーを起動します。
  ///
  /// [config]、もしくは[AIMasamuneAdapter.mcpServerConfig]が設定されていない場合はエラーになります。
  ///
  /// [unlisten]でサーバーを終了します。
  ///
  /// 実際のツール一覧は[AIMasamuneAdapter.mcpFunctions]で設定します。
  McpServer({super.adapter, this.config});

  /// Query for McpServer.
  ///
  /// ```dart
  /// appRef.controller(McpServer.query(parameters));     // Get from application scope.
  /// ref.app.controller(McpServer.query(parameters));    // Watch at application scope.
  /// ref.page.controller(McpServer.query(parameters));   // Watch at page scope.
  /// ```
  static const query = _$McpServerQuery();

  @override
  AIMasamuneAdapter get primaryAdapter => AIMasamuneAdapter.primary;

  /// Server configuration for MCP.
  ///
  /// MCPのサーバーコンフィグ。
  final McpServerConfig? config;

  /// Result of interaction with AI.
  ///
  /// AIとのやりとりの結果。
  @override
  McpServerStatus get value => _value;
  McpServerStatus _value = McpServerStatus.unlistened;

  /// Whether the MCP server is initialized.
  ///
  /// MCPサーバーが初期化されているかどうか。
  bool get initialized => _initialized;
  bool _initialized = false;

  Completer<void>? _initializeCompleter;
  Completer<void>? _connectCompleter;

  late final mcp.McpServer _server;

  /// Initialize the MCP server.
  ///
  /// MCPサーバーを初期化します。
  Future<void> initialize() async {
    if (_initializeCompleter != null) {
      return _initializeCompleter?.future;
    }
    if (_initialized) {
      return;
    }
    _initializeCompleter = Completer<void>();
    try {
      final config = this.config ?? adapter.mcpServerConfig;
      if (config == null) {
        throw ArgumentError("AIMasamuneAdapter.mcpServerConfig is required.");
      }
      _server = mcp.McpServer(
        mcp.Implementation(name: config.name, version: config.version),
      );
      for (final func in adapter.mcpFunctions) {
        _server.tool(
          func.name,
          description: func.description,
          inputSchemaProperties: func.parameters
              .map((key, value) => MapEntry(key, value.toJson())),
          callback: ({args, extra}) async {
            final result = await func.serverProcess(args ?? {});
            if (result == null) {
              return const mcp.CallToolResult(
                content: [],
                isError: true,
              );
            }
            return mcp.CallToolResult(
              content: [
                ...result.value.mapAndRemoveEmpty((e) {
                  return e._toMcpContent();
                })
              ],
            );
          },
        );
      }
      _initialized = true;
      notifyListeners();
      _initializeCompleter?.complete();
      _initializeCompleter = null;
    } catch (e) {
      _initializeCompleter?.completeError(e);
      _initializeCompleter = null;
      rethrow;
    } finally {
      _initializeCompleter?.complete();
      _initializeCompleter = null;
    }
  }

  @override
  void dispose() {
    unlisten();
    super.dispose();
  }

  /// Enables MCP servers to connect.
  ///
  /// MCPサーバーを接続可能にします。
  Future<void> listen() async {
    if (_connectCompleter != null) {
      return _connectCompleter?.future;
    }
    if (_value == McpServerStatus.listened) {
      return;
    }
    _connectCompleter = Completer<void>();
    try {
      await initialize();
      final config = this.config ?? adapter.mcpServerConfig;
      final transport = config?.transport;
      if (transport == null) {
        throw ArgumentError("AIMasamuneAdapter.mcpServerConfig is required.");
      }
      await _server.connect(transport);
      _value = McpServerStatus.listened;
      notifyListeners();
      _connectCompleter?.complete();
      _connectCompleter = null;
    } catch (e) {
      _connectCompleter?.completeError(e);
      _connectCompleter = null;
      rethrow;
    } finally {
      _connectCompleter?.complete();
      _connectCompleter = null;
    }
  }

  /// Disconnects the MCP server.
  ///
  /// MCPサーバーを切断します。
  Future<void> unlisten() async {
    if (_connectCompleter != null) {
      return _connectCompleter?.future;
    }
    if (_value == McpServerStatus.unlistened) {
      return;
    }
    _connectCompleter = Completer<void>();
    try {
      await initialize();
      await _server.close();
      _value = McpServerStatus.unlistened;
      notifyListeners();
      _connectCompleter?.complete();
      _connectCompleter = null;
    } catch (e) {
      _connectCompleter?.completeError(e);
      _connectCompleter = null;
      rethrow;
    } finally {
      _connectCompleter?.complete();
      _connectCompleter = null;
    }
  }
}

@immutable
class _$McpServerQuery {
  const _$McpServerQuery();

  @useResult
  _$_McpServerQuery call({
    AIMasamuneAdapter? adapter,
    McpServerConfig? config,
  }) =>
      _$_McpServerQuery(
        hashCode.toString(),
        config: config,
        adapter: adapter,
      );
}

@immutable
class _$_McpServerQuery extends ControllerQueryBase<McpServer> {
  const _$_McpServerQuery(
    this._name, {
    this.config,
    this.adapter,
  });

  final String _name;
  final McpServerConfig? config;
  final AIMasamuneAdapter? adapter;

  @override
  McpServer Function() call(Ref ref) {
    return () => McpServer(
          config: config,
          adapter: adapter,
        );
  }

  @override
  String get queryName => _name;
  @override
  bool get autoDisposeWhenUnreferenced => false;
}
