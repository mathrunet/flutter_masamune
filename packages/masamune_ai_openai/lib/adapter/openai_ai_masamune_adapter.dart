part of "/masamune_ai_openai.dart";

/// [AIMasamuneAdapter] for configuring OpenAI features.
///
/// Set the API key issued by your OpenAI account in [apiKey].
///
/// OpenAIの機能を設定するための[AIMasamuneAdapter]。
///
/// [apiKey]にOpenAIのアカウントで発行したAPIキーを設定してください。
class OpenaiAIMasamuneAdapter extends AIMasamuneAdapter {
  /// [AIMasamuneAdapter] for configuring OpenAI features.
  ///
  /// Set the API key issued by your OpenAI account in [apiKey].
  ///
  /// OpenAIの機能を設定するための[AIMasamuneAdapter]。
  ///
  /// [apiKey]にOpenAIのアカウントで発行したAPIキーを設定してください。
  const OpenaiAIMasamuneAdapter({
    required this.apiKey,
    this.model = OpenaiAIModel.defaultModel,
  });

  /// API key for OpenAI.
  ///
  /// OpenAIのAPIキー。
  final String apiKey;

  /// The model name of the AI.
  ///
  /// AIのモデル名。
  final OpenaiAIModel model;

  static bool _isInitialized = false;

  @override
  bool isInitializedConfig({
    AIConfig? config,
    Set<AITool> tools = const {},
  }) {
    return _isInitialized;
  }

  @override
  Future<void> initialize({
    AIConfig? config,
    Set<AITool> tools = const {},
  }) async {
    if (_isInitialized) {
      return;
    }
    OpenAI.apiKey = apiKey;
    _isInitialized = true;
  }

  @override
  Future<AIContent?> generateContent(
    List<AIContent> contents, {
    required Future<List<AIContentFunctionResponsePart>> Function(
            List<AIContentFunctionCallPart> functionCalls)
        onFunctionCall,
    AIConfig? config,
    Set<AITool> tools = const {},
    bool includeSystemInitialContent = false,
    AIFunctionCallingConfig? Function(
            AIContent response, Set<AITool> tools, int trialCount)?
        onGenerateFunctionCallingConfig,
  }) async {
    config ??= defaultConfig;
    final systemInitialContent = includeSystemInitialContent
        ? config.systemPromptContent
            ?._toSystemInitialContent()
            ._toContents()
            .firstOrNull
        : null;
    final res = AIContent.model();
    unawaited(
      _generateContent(
        model: config.model ?? model.model,
        config: config,
        contents: [
          if (systemInitialContent != null) systemInitialContent,
          ...contents.sortTo((a, b) => a.time.compareTo(b.time)).expand((e) {
            return e._toContents();
          }),
        ],
        response: res,
        tools: tools,
        onFunctionCall: onFunctionCall,
        onGenerateFunctionCallingConfig: onGenerateFunctionCallingConfig,
        trialCount: 1,
      ),
    );
    return res;
  }

  Future<AIContent?> _generateContent({
    required String model,
    required List<OpenAIChatCompletionChoiceMessageModel> contents,
    required AIContent response,
    required AIConfig config,
    required Future<List<AIContentFunctionResponsePart>> Function(
            List<AIContentFunctionCallPart> functionCalls)
        onFunctionCall,
    required int trialCount,
    Set<AITool> tools = const {},
    AIFunctionCallingConfig? Function(
            AIContent response, Set<AITool> tools, int trialCount)?
        onGenerateFunctionCallingConfig,
  }) async {
    StreamSubscription<OpenAIStreamChatCompletionModel>? subscription;
    final stream = OpenAI.instance.chat.createStream(
      model: model,
      messages: [
        ...contents,
        ...response._toContents(),
      ],
    );
    subscription = stream.listen(
      (line) async {
        final choices = line.choices;
        for (final choice in choices) {
          final parts = choice.delta._toAIContentParts();
          response.add(
            parts,
            time: Clock.now(),
          );
          if (choice.finishReason != null) {
            try {
              response.complete(time: Clock.now());
            } finally {
              unawaited(subscription?.cancel());
              subscription = null;
            }
            return;
          }
        }
      },
      onDone: () async {
        if (subscription != null) {
          try {
            response.complete(time: Clock.now());
          } finally {
            unawaited(subscription?.cancel());
            subscription = null;
          }
        }
      },
      onError: (error, stackTrace) {
        response.error(error, stackTrace);
        subscription?.cancel();
        subscription = null;
        throw error;
      },
    );
    return response;
  }
}
