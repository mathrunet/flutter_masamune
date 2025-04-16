part of '/masamune_ai.dart';

/// Only one interaction with the AI is performed.
///
/// The result of the exchange can be obtained at [value].
///
/// Use [generateContent] method to send a message to the AI.
///
/// Use [clear] method to clear the thread.
///
/// AIとのやり取りを１回のみ行います。
///
/// やり取りの結果は[value]で取得できます。
///
/// [generateContent]メソッドでメッセージを送信します。
///
/// [clear]メソッドでスレッドをクリアします。
class AISingle extends MasamuneControllerBase<AIContent?, AIMasamuneAdapter> {
  /// Only one interaction with the AI is performed.
  ///
  /// The result of the exchange can be obtained at [value].
  ///
  /// Use [generateContent] method to send a message to the AI.
  ///
  /// Use [clear] method to clear the thread.
  ///
  /// AIとのやり取りを１回のみ行います。
  ///
  /// やり取りの結果は[value]で取得できます。
  ///
  /// [generateContent]メソッドでメッセージを送信します。
  ///
  /// [clear]メソッドでスレッドをクリアします。
  AISingle({
    super.adapter,
    String? id,
    this.config,
  }) : id = id ?? uuid();

  @override
  AIMasamuneAdapter get primaryAdapter => AIMasamuneAdapter.primary;

  /// Query for AI.
  ///
  /// ```dart
  /// appRef.controller(AIThread.query(parameters));     // Get from application scope.
  /// ref.app.controller(AIThread.query(parameters));    // Watch at application scope.
  /// ref.page.controller(AIThread.query(parameters));   // Watch at page scope.
  /// ```
  static const query = _$AISingleQuery();

  /// The ID of the single.
  ///
  /// シングルのID。
  final String id;

  /// The configuration of the model.
  ///
  /// モデルの設定。
  final AIConfig? config;

  static McpClient? _mcpClient;
  Completer<void>? _initializeCompleter;

  /// Result of interaction with AI.
  ///
  /// AIとのやりとりの結果。
  @override
  AIContent? get value => _value;
  AIContent? _value;

  /// Initialize the model.
  ///
  /// You can also pass settings to [config].
  ///
  /// [tools] can specify the tools used by AI. If [McpClient] is available, the tool is loaded.
  ///
  /// モデルを初期化します。
  ///
  /// [config]に設定を渡すことも可能です。
  ///
  /// [tools]にAIが使うツールを指定可能です。[McpClient]が利用可能の場合ツールを読み込みます。
  Future<void> initialize({
    AIConfig? config,
    Set<AITool> tools = const {},
  }) async {
    if (adapter.mcpClientConfig != null) {
      _mcpClient ??= McpClient();
      await _mcpClient?.load();
      tools = {...tools, ..._mcpClient?.value ?? const {}};
    }
    if (adapter.isInitializedConfig(
      config: config,
      tools: tools,
    )) {
      return;
    }
    if (_initializeCompleter != null) {
      return;
    }
    _initializeCompleter = Completer<void>();
    try {
      await adapter.initialize(
        config: config,
        tools: tools,
      );
      _initializeCompleter?.complete();
      _initializeCompleter = null;
    } catch (e, stackTrace) {
      _initializeCompleter?.completeError(e, stackTrace);
      _initializeCompleter = null;
    } finally {
      _initializeCompleter?.complete();
      _initializeCompleter = null;
    }
  }

  /// Generate a content from AI.
  ///
  /// Pass a content from the user to [contents].
  /// If [AIRole] is not [AIRole.user], an exception is thrown.
  ///
  /// You can also pass settings to [config].
  ///
  /// [tools] can specify the tools used by AI. If [McpClient] is available, the tool is loaded.
  ///
  /// [onGenerateFunctionCallingConfig] can pass the function calling config.
  ///
  /// AIにコンテンツを生成してもらいます。
  ///
  /// [contents]にユーザーからのコンテンツを渡してください。
  /// [AIRole]が[AIRole.user]でない場合は例外が投げられます。
  ///
  /// [config]に設定を渡すことも可能です。
  ///
  /// [tools]にAIが使うツールを指定可能です。[McpClient]が利用可能の場合ツールを読み込みます。
  ///
  /// [onGenerateFunctionCallingConfig]に関数呼び出しの設定を渡すことも可能です。
  Future<AIContent?> generateContent(
    List<AIContent> contents, {
    AIConfig? config,
    Set<AITool> tools = const {},
    bool includeSystemInitialContent = false,
    AIFunctionCallingConfig? Function(
            AIContent response, Set<AITool> tools, int trialCount)?
        onGenerateFunctionCallingConfig,
  }) async {
    try {
      await initialize(
        config: config ?? this.config,
        tools: tools,
      );
      if (_mcpClient != null) {
        tools = {...tools, ..._mcpClient?.value ?? const {}};
      }
      final res = await adapter.generateContent(
        contents,
        config: config ?? this.config,
        tools: tools,
        includeSystemInitialContent: includeSystemInitialContent,
        onGenerateFunctionCallingConfig: onGenerateFunctionCallingConfig,
        onFunctionCall: (functionCalls) async {
          if (_mcpClient != null) {
            return (await Future.wait<List<AIContentFunctionResponsePart>>(
              functionCalls.map((call) async {
                final func = adapter.mcpFunctions
                    .firstWhereOrNull((f) => f.name == call.name);
                if (func == null) {
                  throw Exception(
                    "Function ${call.name} not found",
                  );
                }
                if (func.clientProcess != null) {
                  final res = await func.clientProcess!(call);
                  return await func.generateResponse(res ?? AIContent(), call);
                }
                final res = await _mcpClient?.call(call.name, call.args);
                return await func.generateResponse(res ?? AIContent(), call);
              }),
            ))
                .expand((e) => e)
                .toList();
          }
          return [];
        },
      );
      if (res == null) {
        return null;
      }
      _value = res;
      notifyListeners();
      await res.loading;
      adapter.onGeneratedContentUsage?.call(
        res.promptTokenCount ?? 0,
        res.candidateTokenCount ?? 0,
      );
      notifyListeners();
      return res;
    } catch (e, stackTrace) {
      for (final content in contents) {
        content.error(e, stackTrace);
      }
      notifyListeners();
      return null;
    }
  }

  /// Clear the result.
  ///
  /// 結果をクリアします。
  void clear() {
    _value = null;
    notifyListeners();
  }
}

@immutable
class _$AISingleQuery {
  const _$AISingleQuery();

  @useResult
  _$_AISingleQuery call({
    String? id,
    AIMasamuneAdapter? adapter,
    AIConfig? config,
  }) =>
      _$_AISingleQuery(
        id ?? uuid(),
        config: config,
        adapter: adapter,
      );
}

@immutable
class _$_AISingleQuery extends ControllerQueryBase<AISingle> {
  const _$_AISingleQuery(
    this._name, {
    this.config,
    this.adapter,
  });

  final String _name;
  final AIConfig? config;
  final AIMasamuneAdapter? adapter;

  @override
  AISingle Function() call(Ref ref) {
    return () => AISingle(
          adapter: adapter,
          id: _name,
          config: config,
        );
  }

  @override
  String get queryName => _name;
  @override
  bool get autoDisposeWhenUnreferenced => true;
}
