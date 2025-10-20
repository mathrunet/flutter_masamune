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
  const AgentStep({
    required this.id,
    required this.kind,
    required this.message,
    required this.time,
    this.metadata = const {},
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
  final String message;

  /// Timestamp of the step.
  ///
  /// ステップのタイムスタンプ。
  final DateTime time;

  /// Additional metadata.
  ///
  /// 追加メタデータ。
  final DynamicMap metadata;
}

/// Memory container for [AIAgent].
///
/// [AIAgent]のためのメモリコンテナ。
@immutable
class AgentMemory {
  /// Creates an instance of [AgentMemory].
  ///
  /// [AgentMemory]のインスタンスを生成します。
  const AgentMemory({
    this.entries = const [],
    this.maxEntries = 50,
  });

  /// Stored memory entries.
  ///
  /// 保存されたメモリ。
  final List<String> entries;

  /// Maximum number of entries retained.
  ///
  /// 保持する最大件数。
  final int maxEntries;

  /// Records a new [entry] into memory.
  ///
  /// 新しい[entry]をメモリに記録します。
  AgentMemory record(String entry) {
    if (entry.isEmpty) {
      return this;
    }
    final updated = [...entries, entry];
    if (updated.length <= maxEntries) {
      return AgentMemory(
          entries: List.unmodifiable(updated), maxEntries: maxEntries);
    }
    final trimmed = updated.sublist(updated.length - maxEntries);
    return AgentMemory(
        entries: List.unmodifiable(trimmed), maxEntries: maxEntries);
  }

  /// Merges [other] memory into this instance.
  ///
  /// [other]のメモリを現在のメモリに統合します。
  AgentMemory merge(AgentMemory other) {
    final merged = [...entries, ...other.entries];
    if (merged.length <= maxEntries) {
      return AgentMemory(
          entries: List.unmodifiable(merged), maxEntries: maxEntries);
    }
    final trimmed = merged.sublist(merged.length - maxEntries);
    return AgentMemory(
        entries: List.unmodifiable(trimmed), maxEntries: maxEntries);
  }
}

/// Final result returned by [AIAgent.run].
///
/// [AIAgent.run] が返却する最終結果。
@immutable
class AgentRunResult {
  /// Creates an instance of [AgentRunResult].
  ///
  /// [AgentRunResult]のインスタンスを生成します。
  const AgentRunResult({
    required this.status,
    required this.responses,
    required this.steps,
    required this.usedTools,
    required this.memory,
  });

  /// Final status of the run.
  ///
  /// 実行結果のステータス。
  final AgentStatus status;

  /// Agent responses returned to the caller.
  ///
  /// 返却されたエージェントの応答。
  final List<AIContent> responses;

  /// Recorded steps during the run.
  ///
  /// 実行中に記録されたステップ。
  final List<AgentStep> steps;

  /// Tool names used in the run.
  ///
  /// 実行時に利用したツール一覧。
  final Set<String> usedTools;

  /// Memory state after the run.
  ///
  /// 実行完了時のメモリ状態。
  final AgentMemory memory;
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
    this.enableSearch = false,
    AgentMemory? memory,
  }) : _memory = memory ?? const AgentMemory() {
    if (promptTemplate != null &&
        !initialContents.any((e) => e.role == AIRole.system)) {
      final systemPrompt = promptTemplate!.generate();
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
      _recordMemory(systemPrompt);
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

  static const int _maxRecordedSteps = 100;

  Completer<void>? _initializeCompleter;

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
        message: "Initializing agent",
        time: Clock.now(),
        metadata: {
          "tools": tools.map((e) => e.name).toList(),
        },
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
          metadata: {
            "stackTrace": stackTrace.toString(),
          },
        ),
      );
      _initializeCompleter?.completeError(e, stackTrace);
      _notify();
      rethrow;
    } finally {
      _initializeCompleter = null;
      _notify();
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
    if (_steps.length > _maxRecordedSteps) {
      _steps.removeRange(0, _steps.length - _maxRecordedSteps);
    }
  }

  void _recordMemory(String entry) {
    final updated = _memory.record(entry);
    if (!identical(_memory, updated)) {
      _memory = updated;
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
          metadata: {
            "count": contents.length,
          },
        ),
      );
      _recordMemory(message);
      _notify();
    }
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
                metadata: {
                  "calls": functionCalls
                      .map(
                        (e) => {
                          "name": e.name,
                          "arguments": e.args,
                        },
                      )
                      .toList(),
                },
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
                    metadata: {
                      "tool": call.name,
                    },
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
          metadata: {
            "stackTrace": stackTrace.toString(),
          },
        ),
      );
      _recordMemory(e.toString());
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
  }) =>
      _$_AIAgentQuery(
        threadId,
        config: config,
        adapter: adapter,
        initialContents: initialContents,
        promptTemplate: promptTemplate,
        memory: memory,
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
  });

  final String _name;
  final AIConfig? config;
  final List<AIContent> initialContents;
  final AIMasamuneAdapter? adapter;
  final AgentPromptTemplate? promptTemplate;
  final AgentMemory? memory;

  @override
  AIAgent Function() call(Ref ref) {
    return () => AIAgent(
          threadId: _name,
          adapter: adapter,
          config: config,
          initialContents: initialContents,
          promptTemplate: promptTemplate,
          memory: memory,
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
