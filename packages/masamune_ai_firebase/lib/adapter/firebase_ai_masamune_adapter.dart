part of "/masamune_ai_firebase.dart";

/// [MasamuneAdapter] for configuring FirebaseVertexAI features.
///
/// Set Firebase options in [options].
///
/// FirebaseVertexAIの機能を設定するための[MasamuneAdapter]。
///
/// [options]にFirebaseのオプションを設定してください。
class FirebaseAIMasamuneAdapter extends AIMasamuneAdapter {
  /// [MasamuneAdapter] for configuring FirebaseVertexAI features.
  ///
  /// Set Firebase options in [options].
  ///
  /// FirebaseVertexAIの機能を設定するための[MasamuneAdapter]。
  ///
  /// [options]にFirebaseのオプションを設定してください。
  const FirebaseAIMasamuneAdapter({
    FirebaseVertexAI? vertexAI,
    FirebaseOptions? options,
    this.model = FirebaseAIModel.defaultModel,
    this.enableAppCheck = true,
    super.defaultConfig = const AIConfig(),
    this.iosOptions,
    this.androidOptions,
    this.webOptions,
    this.linuxOptions,
    this.windowsOptions,
    this.macosOptions,
    super.onGeneratedContentUsage,
    super.mcpClientConfig,
    super.mcpServerConfig,
    super.mcpFunctions = const [],
    super.onGenerateFunctionCallingConfig,
    super.listenMcpServerOnRunApp = false,
  })  : _options = options,
        _vertexAI = vertexAI;

  /// The model name of the AI.
  ///
  /// AIのモデル名。
  final FirebaseAIModel model;

  /// Whether to enable AppCheck.
  ///
  /// AppCheckを有効にするかどうか。
  final bool enableAppCheck;

  /// FirebaseVertexAI instance.
  ///
  /// FirebaseVertexAIのインスタンス。
  FirebaseVertexAI get vertexAI =>
      _vertexAI ??
      FirebaseVertexAI.instanceFor(
        appCheck: enableAppCheck ? FirebaseAppCheck.instance : null,
      );
  final FirebaseVertexAI? _vertexAI;

  static final Map<AIConfigKey, GenerativeModel> _generativeModel = {};

  /// Options for initializing Firebase.
  ///
  /// If platform-specific options are specified, they take precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// プラットフォーム固有のオプションが指定されている場合はそちらが優先されます。
  FirebaseOptions? get options {
    if (UniversalPlatform.isIOS) {
      return iosOptions ?? _options;
    } else if (UniversalPlatform.isAndroid) {
      return androidOptions ?? _options;
    } else if (UniversalPlatform.isWeb) {
      return webOptions ?? _options;
    } else if (UniversalPlatform.isLinux) {
      return linuxOptions ?? _options;
    } else if (UniversalPlatform.isWindows) {
      return windowsOptions ?? _options;
    } else if (UniversalPlatform.isMacOS) {
      return macosOptions ?? _options;
    } else {
      return _options;
    }
  }

  /// Options for initializing Firebase.
  ///
  /// If options for other platforms are specified, these are ignored.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// 他のプラットフォーム用のオプションが指定されている場合はこちらは無視されます。
  final FirebaseOptions? _options;

  /// Options for initializing Firebase.
  ///
  /// Applies to IOS only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// IOSのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? iosOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to Android only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// Androidのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? androidOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to Web only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// Webのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? webOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to Web only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// Webのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? windowsOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to MacOS only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// MacOSのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? macosOptions;

  /// Options for initializing Firebase.
  ///
  /// Applies to Linux only.
  ///
  /// If [options] is specified, this takes precedence.
  ///
  /// Firebaseを初期化する際のオプション。
  ///
  /// Linuxのみに適用されます。
  ///
  /// [options]が指定されている場合はこちらが優先されます。
  final FirebaseOptions? linuxOptions;

  @override
  bool isInitializedConfig({
    AIConfig? config,
    Set<AITool> tools = const {},
  }) {
    config ??= defaultConfig;
    final key = AIConfigKey(config: config, tools: tools);
    if (_generativeModel.containsKey(key)) {
      return true;
    }
    return false;
  }

  @override
  Future<void> initialize({
    AIConfig? config,
    Set<AITool> tools = const {},
  }) async {
    config ??= defaultConfig;
    final key = AIConfigKey(config: config, tools: tools);
    if (_generativeModel.containsKey(key)) {
      return;
    }
    assert(
      config.systemPromptContent == null ||
          config.systemPromptContent!.role == AIRole.system,
      "systemPromptContent must be a system prompt.",
    );
    await FirebaseCore.initialize(options: options);
    final systemPromptContent = config.systemPromptContent;
    final responseSchema = config.responseSchema;
    _generativeModel[key] = vertexAI.generativeModel(
      model: config.model ?? model.model,
      generationConfig: GenerationConfig(
        responseMimeType: responseSchema != null ? "application/json" : null,
        responseSchema: responseSchema?._toSchema(),
      ),
      tools: [if (tools.isNotEmpty) tools._toVertexAITools(mcpFunctions)],
      toolConfig: ToolConfig(
        functionCallingConfig:
            FunctionCallingConfig.any({...tools.map((e) => e.name)}),
      ),
      systemInstruction: systemPromptContent
          ?._toSystemPromptContent()
          ._toContents()
          .firstOrNull,
    );
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
    final key = AIConfigKey(config: config, tools: tools);
    final generativeModel = _generativeModel[key];
    if (generativeModel == null) {
      throw Exception("Please call initialize() before send().");
    }
    final systemInitialContent = includeSystemInitialContent
        ? config.systemPromptContent
            ?._toSystemInitialContent()
            ._toContents()
            .firstOrNull
        : null;
    final res = AIContent.model();
    unawaited(
      _generateContent(
        contents: [
          if (systemInitialContent != null) systemInitialContent,
          ...contents.sortTo((a, b) => a.time.compareTo(b.time)).expand((e) {
            return e._toContents();
          }),
        ],
        response: res,
        tools: tools,
        generativeModel: generativeModel,
        onFunctionCall: onFunctionCall,
        onGenerateFunctionCallingConfig: onGenerateFunctionCallingConfig,
        trialCount: 1,
      ),
    );
    return res;
  }

  Future<AIContent?> _generateContent({
    required List<Content> contents,
    required AIContent response,
    required GenerativeModel generativeModel,
    required Future<List<AIContentFunctionResponsePart>> Function(
            List<AIContentFunctionCallPart> functionCalls)
        onFunctionCall,
    required int trialCount,
    Set<AITool> tools = const {},
    AIFunctionCallingConfig? Function(
            AIContent response, Set<AITool> tools, int trialCount)?
        onGenerateFunctionCallingConfig,
  }) async {
    StreamSubscription<GenerateContentResponse>? subscription;
    final functionCallingConfig = (onGenerateFunctionCallingConfig ??
                this.onGenerateFunctionCallingConfig)
            ?.call(
          response,
          tools,
          trialCount,
        ) ??
        AIFunctionCallingConfig.auto();
    final stream = generativeModel.generateContentStream(
      [
        ...contents,
        ...response._toContents(),
      ],
      toolConfig: ToolConfig(
        functionCallingConfig: functionCallingConfig._toFunctionCallingConfig(),
      ),
    );
    Completer<void>? functionCallCompleter;
    subscription = stream.listen(
      (line) async {
        response.usage(
          promptTokenCount: line.usageMetadata?.promptTokenCount ?? 0,
          candidateTokenCount: line.usageMetadata?.candidatesTokenCount ?? 0,
        );
        final candidates = line.candidates;
        for (final candidate in candidates) {
          final parts = candidate.content._toAIContentParts();
          response.add(
            parts,
            time: DateTime.now(),
          );
          if (functionCallCompleter != null) {
            await functionCallCompleter?.future;
          }
          if (candidate.finishReason != null) {
            functionCallCompleter ??= Completer<void>();
            try {
              if (!response.isFunctionsCompleted) {
                final functionCall = response.functions
                    .where((e) => !e.completed)
                    .map((e) => e.call)
                    .toList();
                if (functionCall.isNotEmpty) {
                  final functionResponse = await onFunctionCall(functionCall);
                  response.add(
                    functionResponse,
                    time: DateTime.now(),
                  );
                  unawaited(
                    _generateContent(
                      contents: contents,
                      response: response,
                      tools: tools,
                      generativeModel: generativeModel,
                      onFunctionCall: onFunctionCall,
                      onGenerateFunctionCallingConfig:
                          onGenerateFunctionCallingConfig,
                      trialCount: trialCount + 1,
                    ),
                  );
                  return;
                }
              }
              response.complete(time: DateTime.now());
            } finally {
              unawaited(subscription?.cancel());
              subscription = null;
              functionCallCompleter?.complete();
              functionCallCompleter = null;
            }
            return;
          }
        }
      },
      onDone: () async {
        if (functionCallCompleter != null) {
          await functionCallCompleter?.future;
        }
        if (subscription != null) {
          functionCallCompleter ??= Completer<void>();
          try {
            if (!response.isFunctionsCompleted) {
              final functionCall = response.functions
                  .where((e) => !e.completed)
                  .map((e) => e.call)
                  .toList();
              if (functionCall.isNotEmpty) {
                final functionResponse = await onFunctionCall(functionCall);
                response.add(
                  functionResponse,
                  time: DateTime.now(),
                );
                unawaited(
                  _generateContent(
                    contents: contents,
                    response: response,
                    tools: tools,
                    generativeModel: generativeModel,
                    onFunctionCall: onFunctionCall,
                    onGenerateFunctionCallingConfig:
                        onGenerateFunctionCallingConfig,
                    trialCount: trialCount + 1,
                  ),
                );
                return;
              }
            }
            response.complete(time: DateTime.now());
          } finally {
            unawaited(subscription?.cancel());
            subscription = null;
            functionCallCompleter?.complete();
            functionCallCompleter = null;
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
