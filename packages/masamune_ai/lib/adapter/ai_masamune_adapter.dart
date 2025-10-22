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
    this.defaultTools = const {},
    this.onGenerateFunctionCallingConfig,
    this.contentFilter,
    this.threadContentSortCallback = defaultThreadContentSortCallback,
    ModelAdapter? vectorModelAdapter,
    this.defaultAgentPromptTemplate,
    this.defaultAgentVectorMemoryConfig,
    this.maxAgentRecordStep = 100,
    AppRef? appRef,
  })  : _appRef = appRef,
        _vectorModelAdapter = vectorModelAdapter;

  /// The default configuration of the AI.
  ///
  /// AIのデフォルト設定。
  final AIConfig defaultConfig;

  /// The adapter for the vector model.
  ///
  /// ベクトルモデルのアダプター。
  ModelAdapter? get vectorModelAdapter {
    if (_vectorModelAdapter != null) {
      return _vectorModelAdapter;
    }
    return _sharedRuntimeModelAdapter;
  }

  static const ModelAdapter _sharedRuntimeModelAdapter = RuntimeModelAdapter();

  final ModelAdapter? _vectorModelAdapter;

  /// Called when the content is generated.
  ///
  /// 内容が生成されたときに呼び出されます。
  final void Function(int promptTokenCount, int candidateTokenCount)?
      onGeneratedContentUsage;

  /// Default AI tools.
  ///
  /// デフォルトのAIツール一覧。
  final Set<AITool> defaultTools;

  /// Called before content is generated.
  ///
  /// 内容が生成される前に呼び出されます。
  final List<AIContent> Function(List<AIContent> contents)? contentFilter;

  /// Called before content is generated.
  ///
  /// 内容が生成される前に呼び出されます。
  final int Function(AIContent a, AIContent b)? threadContentSortCallback;

  /// The prompt template for the agent.
  ///
  /// エージェントのプロンプトテンプレート。
  final AgentPromptTemplate? defaultAgentPromptTemplate;

  /// Configuration for vector-based memory.
  ///
  /// ベクトルメモリの設定。
  final AIAgentVectorMemoryConfig? defaultAgentVectorMemoryConfig;

  /// Maximum number of steps to record for the agent.
  ///
  /// エージェントが記録する最大ステップ数。
  final int maxAgentRecordStep;

  /// Called when the function calling config is generated.
  ///
  /// 関数呼び出しの設定が生成されたときに呼び出されます。
  final AIFunctionCallingConfig? Function(
          AIContent response, Set<AITool> tools, int trialCount)?
      onGenerateFunctionCallingConfig;

  final AppRef? _appRef;

  /// The [AppRef] provided when creating [AIMasamuneAdapter].
  ///
  /// [AIMasamuneAdapter]作成時に提供された[AppRef]。
  static AppRef get appRef {
    if (primary._appRef != null) {
      return primary._appRef!;
    }
    return __appRef ??= AppRef();
  }

  static AppRef? __appRef;

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

  /// Check if the AI is initialized with the given config.
  ///
  /// 与えられた設定でAIが初期化されているかどうかを確認します。
  bool isInitializedConfig({
    AIConfig? config,
    Set<AITool> tools = const {},
    bool enableSearch = false,
  });

  /// Initialize the AI.
  ///
  /// AIを初期化します。
  Future<void> initialize({
    AIConfig? config,
    Set<AITool> tools = const {},
    bool enableSearch = false,
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
    bool enableSearch = false,
    AIFunctionCallingConfig? Function(
            AIContent response, Set<AITool> tools, int trialCount)?
        onGenerateFunctionCallingConfig,
  });

  /// Create a vector embedding from [text] for memory retrieval.
  ///
  /// Subclasses can override this to integrate with embedding providers.
  ///
  /// メモリ検索のために[text]からベクトル埋め込みを生成します。
  ///
  /// サブクラスでオーバーライドして埋め込みプロバイダと連携してください。
  @protected
  Future<List<double>?> createEmbedding(String text) async {
    return null;
  }
}
