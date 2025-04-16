part of '/masamune_ai.dart';

/// Status of the MCP client.
///
/// MCPクライアントの状態。
enum McpClientStatus {
  /// The client is connected to the server.
  ///
  /// クライアントがサーバーに接続されています。
  connected,

  /// The client is disconnected from the server.
  ///
  /// クライアントがサーバーから切断されています。
  disconnected;
}

/// Client configuration for MCP.
///
/// MCPのクライアントコンフィグ。
@immutable
class McpClientConfig {
  /// Client configuration for MCP.
  ///
  /// MCPのクライアントコンフィグ。
  const McpClientConfig({
    required this.name,
    this.version = "1.0.0",
    required this.transport,
  });

  /// Client name.
  ///
  /// クライアント名。
  final String name;

  /// Client version.
  ///
  /// クライアントバージョン。
  final String version;

  /// Transport settings.
  ///
  /// トランスポート設定。
  final Transport transport;
}

/// Controller for MCP client.
///
/// Connect to the server side with [connect].
///
/// If [config] or [AIMasamuneAdapter.mcpClientConfig] is not set, an error will result.
///
/// After connecting, use [load] to load the available tools from the MCP server.
///
/// Use [value] as a tool for AI to generate content.
///
/// If a `FunctionCall` is made from AI, call the tool with [call].
///
/// MCPクライアントのコントローラー。
///
/// [connect]でサーバー側に接続します。
///
/// [config]、もしくは[AIMasamuneAdapter.mcpClientConfig]が設定されていない場合はエラーになります。
///
/// 接続後[load]でMCPサーバーから利用可能なツールを読み込みます。
///
/// [value]をAIのツールとして使用し、コンテンツを生成します。
///
/// AIから`FunctionCall`が行われた場合、[call]でツールを呼び出します。
class McpClient
    extends MasamuneControllerBase<List<AITool>, AIMasamuneAdapter> {
  /// Controller for MCP client.
  ///
  /// Connect to the server side with [connect].
  ///
  /// If [config] or [AIMasamuneAdapter.mcpClientConfig] is not set, an error will result.
  ///
  /// After connecting, use [load] to load the available tools from the MCP server.
  ///
  /// Use [value] as a tool for AI to generate content.
  ///
  /// If a `FunctionCall` is made from AI, call the tool with [call].
  ///
  /// MCPクライアントのコントローラー。
  ///
  /// [connect]でサーバー側に接続します。
  ///
  /// [config]、もしくは[AIMasamuneAdapter.mcpClientConfig]が設定されていない場合はエラーになります。
  ///
  /// 接続後[load]でMCPサーバーから利用可能なツールを読み込みます。
  ///
  /// [value]をAIのツールとして使用し、コンテンツを生成します。
  ///
  /// AIから`FunctionCall`が行われた場合、[call]でツールを呼び出します。
  McpClient({super.adapter, this.config});

  /// Query for McpClient.
  ///
  /// ```dart
  /// appRef.controller(McpClient.query(parameters));     // Get from application scope.
  /// ref.app.controller(McpClient.query(parameters));    // Watch at application scope.
  /// ref.page.controller(McpClient.query(parameters));   // Watch at page scope.
  /// ```
  static const query = _$McpClientQuery();

  @override
  AIMasamuneAdapter get primaryAdapter => AIMasamuneAdapter.primary;

  /// Client configuration for MCP.
  ///
  /// MCPのクライアントコンフィグ。
  final McpClientConfig? config;

  /// AI's tool list.
  ///
  /// AIのツールリスト。
  @override
  List<AITool> get value => _value;
  final List<AITool> _value = [];

  /// Whether the MCP client is initialized.
  ///
  /// MCPクライアントが初期化されているかどうか。
  bool get initialized => _initialized;
  bool _initialized = false;

  Completer<void>? _initializeCompleter;
  Completer<void>? _connectCompleter;

  /// Whether the MCP client is loaded.
  ///
  /// MCPクライアントが読み込まれているかどうか。
  Future<void>? get loading => _loadingCompleter?.future;
  Completer<void>? _loadingCompleter;
  bool _loaded = false;

  /// Status of the MCP client.
  ///
  /// MCPクライアントの状態。
  McpClientStatus get status => _status;
  McpClientStatus _status = McpClientStatus.disconnected;

  late final mcp.Client _client;

  /// Initialize the MCP client.
  ///
  /// MCPクライアントを初期化します。
  Future<void> initialize() async {
    if (_initializeCompleter != null) {
      return _initializeCompleter?.future;
    }
    if (initialized) {
      return;
    }
    _initializeCompleter = Completer<void>();
    try {
      final config = this.config ?? adapter.mcpClientConfig;
      if (config == null) {
        throw ArgumentError("AIMasamuneAdapter.mcpClientConfig is required.");
      }
      _client = mcp.Client(
        mcp.Implementation(name: config.name, version: config.version),
      );
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
    disconnect();
    super.dispose();
  }

  /// Make the MCP client a connection.
  ///
  /// MCPクライアントを接続にします。
  Future<void> connect() async {
    if (_connectCompleter != null) {
      return _connectCompleter?.future;
    }
    if (_status == McpClientStatus.connected) {
      return;
    }
    _connectCompleter = Completer<void>();
    try {
      await initialize();
      final config = this.config ?? adapter.mcpClientConfig;
      final transport = config?.transport;
      if (transport == null) {
        throw ArgumentError("AIMasamuneAdapter.mcpClientConfig is required.");
      }
      await _client.connect(transport);
      _status = McpClientStatus.connected;
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

  /// Disconnects the MCP client.
  ///
  /// MCPクライアントを切断します。
  Future<void> disconnect() async {
    if (_connectCompleter != null) {
      return _connectCompleter?.future;
    }
    if (_status == McpClientStatus.disconnected) {
      return;
    }
    _connectCompleter = Completer<void>();
    try {
      await initialize();
      await _client.close();
      _status = McpClientStatus.disconnected;
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

  /// Load the tools from the MCP client.
  ///
  /// MCPクライアントからツールを読み込みます。
  Future<void> load() async {
    if (_loaded) {
      return;
    }
    if (_loadingCompleter != null) {
      return _loadingCompleter?.future;
    }
    _loadingCompleter = Completer<void>();
    try {
      await initialize();
      await connect();
      final tools = await _client.listTools();
      _value.clear();
      _value.addAll(tools.tools.mapAndRemoveEmpty((e) {
        return AITool(
          name: e.name,
          description: e.description ?? "",
          parameters: e.inputSchema.properties?.toSchema() ?? {},
        );
      }));
      notifyListeners();
      _loadingCompleter?.complete();
      _loadingCompleter = null;
    } catch (e) {
      _loadingCompleter?.completeError(e);
      _loadingCompleter = null;
      rethrow;
    } finally {
      _loadingCompleter?.complete();
      _loadingCompleter = null;
    }
  }

  /// Reload the tools from the MCP client.
  ///
  /// MCPクライアントからツールを再読み込みします。
  Future<void> reload() async {
    _loaded = false;
    await load();
  }

  /// Call the tool.
  ///
  /// ツールを呼び出します。
  Future<AIContent?> call(String name, DynamicMap args) async {
    await initialize();
    final result = await _client.callTool(
      mcp.CallToolRequestParams(name: name, arguments: args),
    );
    return AIContent(
      role: AIRole.function,
      time: DateTime.now(),
      values: result.content.mapAndRemoveEmpty(
        (e) => AIContentPart._fromContent(e),
      ),
    );
  }
}

extension on Map<String, dynamic> {
  Map<String, AISchema> toSchema() {
    return map((key, value) {
      if (value is! DynamicMap) {
        return MapEntry(key, null);
      }
      return MapEntry(key, value._toSchema());
    }).where((k, v) => v != null).cast();
  }

  AISchema _toSchema() {
    final type = get("type", "");
    switch (type) {
      case "string":
        if (containsKey("enum")) {
          return AISchema.enumString(
            enumValues: getAsList<String>("enum"),
            description: get("description", nullOfString),
            nullable: get("nullable", nullOfBool),
          );
        } else {
          return AISchema.string(
            description: get("description", nullOfString),
            nullable: get("nullable", nullOfBool),
            format: get("format", nullOfString),
          );
        }
      case "number":
        return AISchema.double(
          description: get("description", nullOfString),
          nullable: get("nullable", nullOfBool),
          format: get("format", nullOfString),
        );
      case "integer":
        return AISchema.int(
          description: get("description", nullOfString),
          nullable: get("nullable", nullOfBool),
          format: get("format", nullOfString),
        );
      case "boolean":
        return AISchema.boolean(
          description: get("description", nullOfString),
          nullable: get("nullable", nullOfBool),
        );
      case "array":
        return AISchema.list(
          items: getAsMap("items")._toSchema(),
          description: get("description", nullOfString),
          nullable: get("nullable", nullOfBool),
        );
      case "object":
        return AISchema.map(
          properties: getAsMap("properties").toSchema(),
          description: get("description", nullOfString),
          nullable: get("nullable", nullOfBool),
        );
      default:
        throw Exception("Unknown type: $type");
    }
  }
}

@immutable
class _$McpClientQuery {
  const _$McpClientQuery();

  @useResult
  _$_McpClientQuery call({
    AIMasamuneAdapter? adapter,
    McpClientConfig? config,
  }) =>
      _$_McpClientQuery(
        hashCode.toString(),
        config: config,
        adapter: adapter,
      );
}

@immutable
class _$_McpClientQuery extends ControllerQueryBase<McpClient> {
  const _$_McpClientQuery(
    this._name, {
    this.config,
    this.adapter,
  });

  final String _name;
  final McpClientConfig? config;
  final AIMasamuneAdapter? adapter;

  @override
  McpClient Function() call(Ref ref) {
    return () => McpClient(
          config: config,
          adapter: adapter,
        );
  }

  @override
  String get queryName => _name;
  @override
  bool get autoDisposeWhenUnreferenced => false;
}
