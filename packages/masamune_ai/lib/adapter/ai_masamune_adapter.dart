part of "/masamune_ai.dart";

/// Abstract class of [MasamuneAdapter] for configuring AI functions.
///
/// Inherit this class to set up AI functions.
///
/// AIの機能を設定するための[MasamuneAdapter]の抽象クラス。
///
/// このクラスを継承してAIの機能を設定してください。
abstract class AIMasamuneAdapter extends MasamuneAdapter {
  /// Abstract class of [MasamuneAdapter] for configuring AI functions.
  ///
  /// Inherit this class to set up AI functions.
  ///
  /// AIの機能を設定するための[MasamuneAdapter]の抽象クラス。
  ///
  /// このクラスを継承してAIの機能を設定してください。
  const AIMasamuneAdapter({
    this.defaultConfig = const AIConfig(),
    this.onGeneratedContentUsage,
    this.mcpServerConfig,
    this.mcpClientConfig,
    this.mcpFunctions = const [],
    this.onGenerateFunctionCallingConfig,
    this.listenMcpServerOnRunApp = false,
    this.contentFilter,
    this.threadContentSortCallback = defaultThreadContentSortCallback,
  });

  static McpServer? _mcpServer;

  /// The default configuration of the AI.
  ///
  /// AIのデフォルト設定。
  final AIConfig defaultConfig;

  /// Called when the content is generated.
  ///
  /// 内容が生成されたときに呼び出されます。
  final void Function(int promptTokenCount, int candidateTokenCount)?
      onGeneratedContentUsage;

  /// The configuration of the MCP server.
  ///
  /// MCPサーバーの設定。
  final McpServerConfig? mcpServerConfig;

  /// The configuration of the MCP client.
  ///
  /// MCPクライアントの設定。
  final McpClientConfig? mcpClientConfig;

  /// List of MCP server functions.
  ///
  /// MCPサーバーの関数一覧。
  final List<McpFunction> mcpFunctions;

  /// Whether to listen to the MCP server on [onPreRunApp].
  ///
  /// [onPreRunApp]でMCPサーバーを監視するかどうか。
  final bool listenMcpServerOnRunApp;

  /// Called before content is generated.
  ///
  /// 内容が生成される前に呼び出されます。
  final List<AIContent> Function(List<AIContent> contents)? contentFilter;

  /// Called before content is generated.
  ///
  /// 内容が生成される前に呼び出されます。
  final int Function(AIContent a, AIContent b)? threadContentSortCallback;

  /// Called when the function calling config is generated.
  ///
  /// 関数呼び出しの設定が生成されたときに呼び出されます。
  final AIFunctionCallingConfig? Function(
          AIContent response, Set<AITool> tools, int trialCount)?
      onGenerateFunctionCallingConfig;

  /// The default callback for sorting thread contents.
  ///
  /// スレッドコンテンツをソートするためのデフォルトコールバック。
  static int defaultThreadContentSortCallback(AIContent a, AIContent b) {
    return a.time.compareTo(b.time);
  }

  /// The default callback for sorting thread contents in reverse order.
  ///
  /// スレッドコンテンツを逆順でソートするためのデフォルトコールバック。
  static int reverseThreadContentSortCallback(AIContent a, AIContent b) {
    return b.time.compareTo(a.time);
  }

  /// The default callback for filtering thread contents.

  /// You can retrieve the [AIMasamuneAdapter] first given by [MasamuneAdapterScope].
  ///
  /// 最初に[MasamuneAdapterScope]で与えた[AIMasamuneAdapter]を取得することができます。
  static AIMasamuneAdapter get primary {
    assert(
      _primary != null,
      "AIMasamuneAdapter is not set. Place [MasamuneAdapterScope] widget closer to the root.",
    );
    return _primary!;
  }

  static AIMasamuneAdapter? _primary;

  @override
  void onInitScope(MasamuneAdapter adapter) {
    super.onInitScope(adapter);
    if (adapter is! AIMasamuneAdapter) {
      return;
    }
    _primary = adapter;
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<AIMasamuneAdapter>(
      adapter: this,
      child: app,
    );
  }

  @override
  FutureOr<void> onPreRunApp(WidgetsBinding binding) async {
    if (listenMcpServerOnRunApp && mcpServerConfig != null) {
      _mcpServer ??= McpServer(adapter: this);
      await _mcpServer?.listen();
    }
    return super.onPreRunApp(binding);
  }

  /// Check if the AI is initialized with the given config.
  ///
  /// 与えられた設定でAIが初期化されているかどうかを確認します。
  bool isInitializedConfig({
    AIConfig? config,
    Set<AITool> tools = const {},
  });

  /// Initialize the AI.
  ///
  /// AIを初期化します。
  Future<void> initialize({
    AIConfig? config,
    Set<AITool> tools = const {},
  });

  /// Generate the content of the AI.
  ///
  /// AIの内容を生成します。
  Future<AIContent?> generateContent(
    List<AIContent> contents, {
    Future<List<AIContentFunctionResponsePart>> Function(
            List<AIContentFunctionCallPart> functionCalls)?
        onFunctionCall,
    AIConfig? config,
    bool includeSystemInitialContent = false,
    Set<AITool> tools = const {},
    AIFunctionCallingConfig? Function(
            AIContent response, Set<AITool> tools, int trialCount)?
        onGenerateFunctionCallingConfig,
  });
}
