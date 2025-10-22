part of "/masamune_ai.dart";

/// The execution status of [AIAgent].
///
/// エージェントの実行状況。
enum AgentStatus {
  /// The agent is idle.
  ///
  /// エージェントが待機中。
  idle,

  /// The agent is initializing.
  ///
  /// エージェントが初期化中。
  initializing,

  /// The agent is processing a request.
  ///
  /// エージェントが処理中。
  running,

  /// The agent is waiting for tool execution.
  ///
  /// エージェントがツールの実行待ち。
  waitingForTool,

  /// The agent finished successfully.
  ///
  /// エージェントが正常終了。
  completed,

  /// The agent terminated with an error.
  ///
  /// エージェントがエラーで終了。
  error,
}

/// The kind of [AgentStep].
///
/// ステップの種別。
enum AgentStepKind {
  /// System level message.
  ///
  /// システムメッセージ。
  system,

  /// User input message.
  ///
  /// ユーザーメッセージ。
  user,

  /// Model response message.
  ///
  /// モデル応答。
  model,

  /// Tool call request.
  ///
  /// ツール呼び出し。
  toolCall,

  /// Tool execution result.
  ///
  /// ツール実行結果。
  toolResult,

  /// Error information.
  ///
  /// エラー情報。
  error,
}

/// Execution step recorded by [AIAgent].
///
/// [AIAgent]が記録する実行ステップ。
@immutable
class AgentStep {
  /// Creates an instance of [AgentStep].
  ///
  /// [AgentStep]のインスタンスを生成します。
  const AgentStep(
      {required this.id,
      required this.kind,
      required this.time,
      this.message,
      this.tools,
      this.stackTrace,
      this.memories,
      this.contentLength,
      this.functionCalls
      // this.metadata = const {},
      });

  /// Unique identifier of the step.
  ///
  /// ステップの一意なID。
  final String id;

  /// Step kind.
  ///
  /// ステップ種別。
  final AgentStepKind kind;

  /// Human readable message.
  ///
  /// 表示用メッセージ。
  final String? message;

  /// Timestamp of the step.
  ///
  /// ステップのタイムスタンプ。
  final DateTime time;

  /// Tool names used in the step.
  ///
  /// ステップで使用されたツール名。
  final List<String>? tools;

  /// Stack trace in case of error.
  ///
  /// エラー時のスタックトレース。
  final String? stackTrace;

  /// Additional memories associated with the step.
  ///
  /// ステップに関連する追加のメモリ。
  final List<String>? memories;

  /// Length of the content in the step.
  ///
  /// ステップ内のコンテンツの長さ。
  final int? contentLength;

  /// Function calls made during the step.
  ///
  /// ステップ中に行われた関数呼び出し。
  final List<AIContentFunctionCallPart>? functionCalls;
}

/// Manage interaction with the AI agent.
///
/// The result of the exchange can be obtained at [value].
///
/// Use [generateContent] method to send a message to the AI.
///
/// Use [clear] method to clear the thread.
///
/// AIエージェントとのやりとりを管理します。
///
/// やり取りの結果は[value]で取得できます。
///
/// [generateContent]メソッドでメッセージを送信します。
///
/// [clear]メソッドでスレッドをクリアします。
class AIAgent
    extends MasamuneControllerBase<List<AIContent>, AIMasamuneAdapter> {
  /// Manage interaction with the AI agent.
  ///
  /// The result of the exchange can be obtained at [value].
  ///
  /// Use [generateContent] method to send a message to the AI.
  ///
  /// Use [clear] method to clear the thread.
  ///
  /// AIエージェントとのやりとりを管理します。
  ///
  /// やり取りの結果は[value]で取得できます。
  ///
  /// [generateContent]メソッドでメッセージを送信します。
  ///
  /// [clear]メソッドでスレッドをクリアします。
  AIAgent({
    required this.threadId,
    required List<AIContent> initialContents,
    super.adapter,
    this.config,
    this.promptTemplate,
    this.vectorMemoryConfig,
    this.enableSearch = false,
    AgentMemory? memory,
  }) : _memory = memory ?? const AgentMemory() {
    final promptTemplate =
        this.promptTemplate ?? adapter.defaultAgentPromptTemplate;
    if (promptTemplate != null &&
        !initialContents.any((e) => e.role == AIRole.system)) {
      final systemPrompt = promptTemplate.generate();
      _value.add(
        AIContent.system(
          [AIContent.text(systemPrompt)],
        ),
      );
      _registerStep(
        AgentStep(
          id: uuid(),
          kind: AgentStepKind.system,
          message: systemPrompt,
          time: Clock.now(),
        ),
      );
      _recordMemory(systemPrompt, scheduleVector: false);
    }
    _value.addAll(initialContents);
  }

  @override
  AIMasamuneAdapter get primaryAdapter => AIMasamuneAdapter.primary;

  /// Query for AI.
  ///
  /// ```dart
  /// appRef.controller(AIThread.query(parameters));     // Get from application scope.
  /// ref.app.controller(AIThread.query(parameters));    // Watch at application scope.
  /// ref.page.controller(AIThread.query(parameters));   // Watch at page scope.
  /// ```
  static const query = _$AIAgentQuery();

  /// The ID of the thread.
  ///
  /// スレッドのID。
  final String threadId;

  /// The configuration of the agent.
  ///
  /// エージェントの設定。
  final AIConfig? config;

  /// The prompt template for the agent.
  ///
  /// エージェントのプロンプトテンプレート。
  final AgentPromptTemplate? promptTemplate;

  /// Configuration for vector-based memory.
  ///
  /// ベクトルメモリの設定。
  final AIAgentVectorMemoryConfig? vectorMemoryConfig;

  /// If `true`, the search is enabled.
  ///
  /// If this is `true`, other tools cannot be used.
  ///
  /// 検索が有効な場合は`true`に設定してください。
  ///
  /// これが`true`の場合、他のツールは使用できません。
  final bool enableSearch;

  /// Current status of the agent.
  ///
  /// 現在のエージェントステータス。
  AgentStatus get status => _status;
  AgentStatus _status = AgentStatus.idle;

  /// Recorded execution steps.
  ///
  /// 記録された実行ステップ。
  List<AgentStep> get steps => List.unmodifiable(_steps);
  final List<AgentStep> _steps = [];

  /// Agent memory snapshot.
  ///
  /// エージェントのメモリ。
  AgentMemory get memory => _memory;
  AgentMemory _memory;

  /// Result of the latest run.
  ///
  /// 直近の実行結果。
  AgentRunResult? get lastRun => _lastRun;
  AgentRunResult? _lastRun;

  Completer<void>? _initializeCompleter;
  Future<void>? _vectorMemoryQueue;
  List<String> _lastInjectedMemories = const [];
  String? _memoryContextContentId;

  /// Result of interaction with AI.
  ///
  /// AIとのやりとりの結果。
  @override
  List<AIContent> get value =>
      _value.where((e) => e.role != AIRole.function).toList();
  final List<AIContent> _value = [];

  /// Initialize the thread.
  ///
  /// You can also pass settings to [config].
  ///
  /// [tools] can specify the tools used by AI. If [McpClient] is available, the tool is loaded.
  ///
  /// スレッドを初期化します。
  ///
  /// [config]に設定を渡すことも可能です。
  ///
  /// [tools]にAIが使うツールを指定可能です。[McpClient]が利用可能の場合ツールを読み込みます。
  Future<void> initialize({
    AIConfig? config,
    Set<AITool> tools = const {},
  }) async {
    tools = {...adapter.defaultTools, ...tools};
    if (adapter.isInitializedConfig(
      config: config,
      tools: tools,
      enableSearch: enableSearch,
    )) {
      _setStatus(AgentStatus.idle);
      return;
    }
    if (_initializeCompleter != null) {
      await _initializeCompleter?.future;
      return;
    }
    _setStatus(AgentStatus.initializing);
    _registerStep(
      AgentStep(
        id: uuid(),
        kind: AgentStepKind.system,
        time: Clock.now(),
        tools: tools.map((e) => e.name).toList(),
      ),
    );
    _notify();
    _initializeCompleter = Completer<void>();
    try {
      await adapter.initialize(
        config: config,
        tools: tools,
        enableSearch: enableSearch,
      );
      _setStatus(AgentStatus.idle);
      _initializeCompleter?.complete();
    } catch (e, stackTrace) {
      _setStatus(AgentStatus.error);
      _registerStep(
        AgentStep(
          id: uuid(),
          kind: AgentStepKind.error,
          message: e.toString(),
          time: Clock.now(),
          stackTrace: stackTrace.toString(),
        ),
      );
      _initializeCompleter?.completeError(e, stackTrace);
      _notify();
      rethrow;
    } finally {
      _initializeCompleter = null;
      _notify();
    }
    final vectorMemoryConfig =
        this.vectorMemoryConfig ?? adapter.defaultAgentVectorMemoryConfig;
    if (vectorMemoryConfig != null) {
      unawaited(_recallVectorMemory(contents: const []));
    }
  }

  /// Run the agent with the given [contents].
  ///
  /// 指定した[contents]でエージェントを実行します。
  Future<AgentRunResult> run(
    List<AIContent> contents, {
    AIConfig? config,
    Set<AITool> tools = const {},
    bool includeSystemInitialContent = false,
    List<AIContent> Function(List<AIContent> contents)? contentFilter,
    AIFunctionCallingConfig? Function(
            AIContent response, Set<AITool> tools, int trialCount)?
        onGenerateFunctionCallingConfig,
  }) async {
    await generateContent(
      contents,
      config: config,
      tools: tools,
      includeSystemInitialContent: includeSystemInitialContent,
      contentFilter: contentFilter,
      onGenerateFunctionCallingConfig: onGenerateFunctionCallingConfig,
    );
    return _lastRun ??
        AgentRunResult(
          status: _status,
          responses: List.unmodifiable(value),
          steps: steps,
          usedTools: const {},
          memory: _memory,
        );
  }

  void _setStatus(AgentStatus status) {
    if (_status == status) {
      return;
    }
    _status = status;
  }

  void _registerStep(AgentStep step) {
    _steps.add(step);
    if (_steps.length > adapter.maxAgentRecordStep) {
      _steps.removeRange(0, _steps.length - adapter.maxAgentRecordStep);
    }
  }

  void _recordMemory(String entry, {bool scheduleVector = true}) {
    final trimmed = entry.trim();
    if (trimmed.isEmpty) {
      return;
    }
    final updated = _memory.record(trimmed);
    if (!identical(_memory, updated)) {
      _memory = updated;
    }
    if (scheduleVector) {
      _scheduleVectorMemoryProcessing(trimmed);
    }
  }

  void _scheduleVectorMemoryProcessing(String entry) {
    final config = vectorMemoryConfig ?? adapter.defaultAgentVectorMemoryConfig;
    if (config == null) {
      return;
    }
    _vectorMemoryQueue = (_vectorMemoryQueue ?? Future.value())
        .then(
      (_) => _storeVectorMemory(entry),
      onError: (_) {},
    )
        .catchError((error, stackTrace) {
      debugPrint(
        "AIAgent: Failed to store vector memory. $error\n$stackTrace",
      );
    });
  }

  Future<void> _storeVectorMemory(String entry) async {
    final config = vectorMemoryConfig ?? adapter.defaultAgentVectorMemoryConfig;
    if (config == null) {
      return;
    }
    final normalized = entry.trim();
    if (normalized.length < config.minChunkLength) {
      return;
    }
    final chunks = _chunkText(normalized, config);
    if (chunks.isEmpty) {
      return;
    }
    final collection = AIMasamuneAdapter.appRef.model(
      VectorModel.collection(
        adapter: adapter.vectorModelAdapter,
        agentId: threadId,
      ),
    );
    final seen = <String>{};
    for (final chunk in chunks.take(config.maxChunksPerEntry)) {
      if (!seen.add(chunk)) {
        continue;
      }
      try {
        final embedding = await adapter.createEmbedding(chunk);
        if (embedding == null || embedding.isEmpty) {
          continue;
        }
        final document = collection.create();
        await document.save(
          VectorModel(
            agentId: threadId,
            content: chunk,
            vector: ModelVectorValue.fromList(embedding),
            createdAt: const ModelTimestamp.now(),
          ),
        );
      } catch (error, stackTrace) {
        debugPrint(
          "AIAgent: Failed to save vector memory. $error\n$stackTrace",
        );
      }
    }
  }

  List<String> _chunkText(String text, AIAgentVectorMemoryConfig config) {
    final sanitized = text.replaceAll(RegExp(r"\s+"), " ").trim();
    if (sanitized.isEmpty) {
      return const [];
    }
    if (sanitized.length <= config.chunkSize) {
      return [sanitized];
    }
    final chunkSize = config.chunkSize;
    final overlap = config.safeChunkOverlap;
    final chunks = <String>[];
    var start = 0;
    var safety = 0;
    while (start < sanitized.length &&
        chunks.length < config.maxChunksPerEntry &&
        safety < 1000) {
      final end = math.min(start + chunkSize, sanitized.length);
      final chunk = sanitized.substring(start, end).trim();
      if (chunk.length >= config.minChunkLength) {
        chunks.add(chunk);
      }
      if (end >= sanitized.length) {
        break;
      }
      final nextStart = end - overlap;
      if (nextStart <= start) {
        start = end;
      } else {
        start = nextStart;
      }
      safety++;
    }
    if (chunks.isEmpty && sanitized.isNotEmpty) {
      return [sanitized];
    }
    return chunks;
  }

  Future<void> _recallVectorMemory({
    required List<AIContent> contents,
  }) async {
    final config = vectorMemoryConfig ?? adapter.defaultAgentVectorMemoryConfig;
    if (config == null) {
      return;
    }
    final queryText = _composeQueryText(contents, config);
    if (queryText.isEmpty) {
      _injectMemoryPrompt(const []);
      return;
    }
    List<double>? embedding;
    try {
      embedding = await adapter.createEmbedding(queryText);
    } catch (error, stackTrace) {
      debugPrint(
        "AIAgent: Failed to create query embedding. $error\n$stackTrace",
      );
      embedding = null;
    }
    if (embedding == null || embedding.isEmpty) {
      return;
    }
    final collection = AIMasamuneAdapter.appRef.model(
      VectorModel.collection(agentId: threadId)
          .vector
          .nearest(
            embedding,
            measure: config.measure,
          )
          .limitTo(config.recallLimit),
    );
    try {
      await collection.load();
    } catch (error, stackTrace) {
      debugPrint(
        "AIAgent: Failed to load vector memories. $error\n$stackTrace",
      );
      return;
    }
    if (collection.isEmpty) {
      _injectMemoryPrompt(const []);
      return;
    }
    final memories = <String>[];
    for (final doc in collection) {
      if (doc.value == null) {
        continue;
      }
      try {
        final targetThreadId = doc.value?.agentId;
        if (targetThreadId != null && targetThreadId != threadId) {
          continue;
        }
        final content = doc.value?.content.trim();
        if (content != null && content.isNotEmpty) {
          memories.add(content);
        }
      } catch (error, stackTrace) {
        debugPrint(
          "AIAgent: Failed to parse vector memory. $error\n$stackTrace",
        );
      }
    }
    _injectMemoryPrompt(memories);
    if (memories.isNotEmpty && !listEquals(_lastInjectedMemories, memories)) {
      _registerStep(
        AgentStep(
          id: uuid(),
          kind: AgentStepKind.system,
          message: "Recalled ${memories.length} memory entries.",
          time: Clock.now(),
          memories: memories.take(config.recallLimit).toList(),
        ),
      );
    }
  }

  String _composeQueryText(
    List<AIContent> contents,
    AIAgentVectorMemoryConfig config,
  ) {
    final collected = <String>[];
    for (final content in contents) {
      final text = _contentToPlainText(content);
      if (text != null) {
        collected.add(text);
      }
    }
    if (collected.isEmpty) {
      final previousUserMessages = _value.reversed
          .where((element) => element.role == AIRole.user)
          .map(_contentToPlainText)
          .whereType<String>()
          .take(3)
          .toList()
          .reversed;
      collected.addAll(previousUserMessages);
    }
    return collected.join("\n\n").trim();
  }

  String? _contentToPlainText(AIContent content) {
    final buffer = <String>[];
    for (final part in content.value) {
      if (part is AIContentTextPart) {
        buffer.add(part.text);
      } else if (part is AIContentJsonPart) {
        buffer.add(jsonEncode(part.json));
      }
    }
    if (buffer.isEmpty) {
      return null;
    }
    final text = buffer.join("\n").trim();
    return text.isEmpty ? null : text;
  }

  void _injectMemoryPrompt(List<String> memories) {
    final config = vectorMemoryConfig ?? adapter.defaultAgentVectorMemoryConfig;
    if (config == null) {
      return;
    }
    final normalized = memories
        .map((e) => e.trim())
        .where((element) => element.isNotEmpty)
        .toList();
    if (listEquals(_lastInjectedMemories, normalized)) {
      return;
    }
    var changed = false;
    if (_memoryContextContentId != null) {
      final before = _value.length;
      _value.removeWhere((element) => element.id == _memoryContextContentId);
      if (_value.length != before) {
        changed = true;
      }
      _memoryContextContentId = null;
    }
    if (normalized.isEmpty) {
      _lastInjectedMemories = const [];
      if (changed) {
        _notify();
      }
      return;
    }
    final prompt = config.buildMemoryPrompt(normalized);
    if (prompt.isEmpty) {
      _lastInjectedMemories = const [];
      if (changed) {
        _notify();
      }
      return;
    }
    final content = AIContent(
      role: AIRole.system,
      time: Clock.now().subtract(const Duration(milliseconds: 1)),
      values: [
        AIContentTextPart(prompt),
      ],
      completed: true,
    );
    _memoryContextContentId = content.id;
    _value.add(content);
    _value.sort(adapter.threadContentSortCallback);
    _lastInjectedMemories = List.unmodifiable(normalized);
    changed = true;
    if (changed) {
      _notify();
    }
  }

  void _notify() {
    notifyListeners();
  }

  /// Add a content to the thread.
  ///
  /// Pass a content from the user to [contents].
  /// If [AIRole] is not [AIRole.user], an exception is thrown.
  ///
  /// スレッドにコンテンツを追加します。
  ///
  /// [contents]にユーザーからのコンテンツを渡してください。
  /// [AIRole]が[AIRole.user]でない場合は例外が投げられます。
  Future<List<AIContent>> addContent(
    List<AIContent> contents,
  ) async {
    if (!contents.every((e) => e.role == AIRole.user)) {
      throw const InvalidAIRoleException();
    }
    _value.removeWhere((e) {
      if (e.value.isEmpty) {
        return true;
      }
      return false;
    });
    _value.addAll(contents);
    _value.sort((a, b) => b.time.compareTo(a.time));
    notifyListeners();
    return value;
  }

  /// Generate a content from AI.
  ///
  /// Pass a content from the user to [contents].
  /// If [AIRole] is not [AIRole.user], an exception is thrown.
  ///
  /// You can also pass settings to [config].
  ///
  /// [tools] can specify the tools used by AI.
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
  /// [tools]にAIが使うツールを指定可能です。
  ///
  /// [onGenerateFunctionCallingConfig]に関数呼び出しの設定を渡すことも可能です。
  Future<List<AIContent>> generateContent(
    List<AIContent> contents, {
    AIConfig? config,
    Set<AITool> tools = const {},
    bool includeSystemInitialContent = false,
    List<AIContent> Function(List<AIContent> contents)? contentFilter,
    AIFunctionCallingConfig? Function(
            AIContent response, Set<AITool> tools, int trialCount)?
        onGenerateFunctionCallingConfig,
  }) async {
    if (!contents.every((e) => e.role == AIRole.user)) {
      throw const InvalidAIRoleException();
    }
    final usedToolNames = <String>{};
    if (contents.isNotEmpty) {
      final message = contents.map((e) => e.toString()).join("\n\n");
      _registerStep(
        AgentStep(
          id: uuid(),
          kind: AgentStepKind.user,
          message: message,
          time: Clock.now(),
          contentLength: message.length,
        ),
      );
      _recordMemory(message);
      _notify();
    }
    await _recallVectorMemory(contents: contents);
    try {
      _value.removeWhere((e) {
        if (e.value.isEmpty) {
          return true;
        }
        return false;
      });
      _setStatus(AgentStatus.running);
      _notify();
      await initialize(
        config: config ?? this.config,
        tools: tools,
      );
      tools = {...adapter.defaultTools, ...tools};
      _value.addAll(contents);
      _value.sort(adapter.threadContentSortCallback);
      _notify();
      final res = await adapter.generateContent(
        contentFilter?.call(_value) ??
            adapter.contentFilter?.call(_value) ??
            _value,
        config: config ?? this.config,
        tools: tools,
        enableSearch: enableSearch,
        includeSystemInitialContent: includeSystemInitialContent,
        onGenerateFunctionCallingConfig: onGenerateFunctionCallingConfig,
        onFunctionCall: (functionCalls) async {
          final activeToolNames = functionCalls.map((e) => e.name).toSet();
          usedToolNames.addAll(activeToolNames);
          if (activeToolNames.isNotEmpty) {
            _setStatus(AgentStatus.waitingForTool);
            _registerStep(
              AgentStep(
                id: uuid(),
                kind: AgentStepKind.toolCall,
                message: activeToolNames.join(", "),
                time: Clock.now(),
                functionCalls: functionCalls.clone(),
              ),
            );
            _notify();
          }
          if (tools.isNotEmpty) {
            final responses =
                (await Future.wait<List<AIContentFunctionResponsePart>>(
              functionCalls.map((call) async {
                final func = tools
                    .whereType<AIFunctionTool>()
                    .firstWhereOrNull((f) => f.name == call.name);
                if (func == null) {
                  throw Exception(
                    "Function ${call.name} not found",
                  );
                }
                final ref =
                    AIToolRef._(tools: tools, call: call, adapter: adapter);
                final res = await func.process(ref);
                usedToolNames.add(call.name);
                if (res == null) {
                  return [];
                }
                final response = await func.generateResponse(res, ref);
                _registerStep(
                  AgentStep(
                    id: uuid(),
                    kind: AgentStepKind.toolResult,
                    message: res.toString(),
                    time: Clock.now(),
                    tools: [call.name],
                  ),
                );
                _recordMemory(res.toString());
                return response;
              }),
            ))
                    .expand((e) => e)
                    .toList();
            if (_status == AgentStatus.waitingForTool) {
              _setStatus(AgentStatus.running);
              _notify();
            }
            return responses;
          }
          if (_status == AgentStatus.waitingForTool) {
            _setStatus(AgentStatus.running);
            _notify();
          }
          return [];
        },
      );
      if (res == null) {
        _setStatus(AgentStatus.completed);
        _lastRun = AgentRunResult(
          status: _status,
          responses: List.unmodifiable(value),
          steps: steps,
          usedTools: usedToolNames,
          memory: _memory,
        );
        _notify();
        return [];
      }
      _value.add(res);
      _value.sort(adapter.threadContentSortCallback);
      _registerStep(
        AgentStep(
          id: res.id,
          kind: AgentStepKind.model,
          message: res.toString(),
          time: Clock.now(),
        ),
      );
      _recordMemory(res.toString());
      _notify();
      await res.loading;
      adapter.onGeneratedContentUsage?.call(
        res.promptTokenCount ?? 0,
        res.candidateTokenCount ?? 0,
      );
      _setStatus(AgentStatus.completed);
      _lastRun = AgentRunResult(
        status: _status,
        responses: List.unmodifiable(value),
        steps: steps,
        usedTools: usedToolNames,
        memory: _memory,
      );
      _notify();
      return value;
    } catch (e, stackTrace) {
      for (final content in contents) {
        content.error(e, stackTrace);
      }
      _setStatus(AgentStatus.error);
      _registerStep(
        AgentStep(
          id: uuid(),
          kind: AgentStepKind.error,
          message: e.toString(),
          time: Clock.now(),
          stackTrace: stackTrace.toString(),
        ),
      );
      _recordMemory(e.toString(), scheduleVector: false);
      _lastRun = AgentRunResult(
        status: _status,
        responses: List.unmodifiable(value),
        steps: steps,
        usedTools: usedToolNames,
        memory: _memory,
      );
      _notify();
      return value;
    }
  }

  /// Clear the thread.
  ///
  /// スレッドをクリアします。
  void clear({bool resetMemory = false}) {
    _value.clear();
    _steps.clear();
    if (resetMemory) {
      _memory = const AgentMemory();
    }
    _memoryContextContentId = null;
    _lastInjectedMemories = const [];
    _vectorMemoryQueue = null;
    _lastRun = null;
    _setStatus(AgentStatus.idle);
    _notify();
  }
}

@immutable
class _$AIAgentQuery {
  const _$AIAgentQuery();

  @useResult
  _$_AIAgentQuery call({
    required String threadId,
    AIMasamuneAdapter? adapter,
    AIConfig? config,
    List<AIContent> initialContents = const [],
    AgentPromptTemplate? promptTemplate,
    AgentMemory? memory,
    AIAgentVectorMemoryConfig? vectorMemoryConfig,
  }) =>
      _$_AIAgentQuery(
        threadId,
        config: config,
        adapter: adapter,
        initialContents: initialContents,
        promptTemplate: promptTemplate,
        memory: memory,
        vectorMemoryConfig: vectorMemoryConfig,
      );
}

@immutable
class _$_AIAgentQuery extends ControllerQueryBase<AIAgent> {
  const _$_AIAgentQuery(
    this._name, {
    required this.initialContents,
    this.config,
    this.adapter,
    this.promptTemplate,
    this.memory,
    this.vectorMemoryConfig,
  });

  final String _name;
  final AIConfig? config;
  final List<AIContent> initialContents;
  final AIMasamuneAdapter? adapter;
  final AgentPromptTemplate? promptTemplate;
  final AgentMemory? memory;
  final AIAgentVectorMemoryConfig? vectorMemoryConfig;

  @override
  AIAgent Function() call(Ref ref) {
    return () => AIAgent(
          threadId: _name,
          adapter: adapter,
          config: config,
          initialContents: initialContents,
          promptTemplate: promptTemplate,
          memory: memory,
          vectorMemoryConfig: vectorMemoryConfig,
        );
  }

  @override
  String get queryName => "$_name@${_hashCode.toString()}";

  int get _hashCode {
    if (initialContents.isEmpty) {
      return 0;
    }
    final hashCode = initialContents.fold(0, (a, b) => a ^ b.hashCode);
    return hashCode;
  }

  @override
  bool get autoDisposeWhenUnreferenced => false;
}
