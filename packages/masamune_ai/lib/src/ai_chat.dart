part of "/masamune_ai.dart";

/// Manage chats with AI.
///
/// The result of the exchange can be obtained at [value].
///
/// Use [generateContent] method to send a message to the AI.
///
/// Use [clear] method to clear the thread.
///
/// AIとのチャットを管理します。
///
/// やり取りの結果は[value]で取得できます。
///
/// [generateContent]メソッドでメッセージを送信します。
///
/// [clear]メソッドでチャットをクリアします。
@Deprecated("Use AIChat instead of AIThread")
typedef AIThread = AIChat;

/// Manage chats with AI.
///
/// The result of the exchange can be obtained at [value].
///
/// Use [generateContent] method to send a message to the AI.
///
/// Use [clear] method to clear the thread.
///
/// AIとのチャットを管理します。
///
/// やり取りの結果は[value]で取得できます。
///
/// [generateContent]メソッドでメッセージを送信します。
///
/// [clear]メソッドでチャットをクリアします。
class AIChat
    extends MasamuneControllerBase<List<AIContent>, AIMasamuneAdapter> {
  /// Manage chats with AI.
  ///
  /// The result of the exchange can be obtained at [value].
  ///
  /// Use [generateContent] method to send a message to the AI.
  ///
  /// Use [clear] method to clear the thread.
  ///
  /// AIとのチャットを管理します。
  ///
  /// やり取りの結果は[value]で取得できます。
  ///
  /// [generateContent]メソッドでメッセージを送信します。
  ///
  /// [clear]メソッドでチャットをクリアします。
  AIChat({
    required this.threadId,
    required List<AIContent> initialContents,
    super.adapter,
    this.config,
  }) {
    _value.addAll(initialContents);
  }

  @override
  AIMasamuneAdapter get primaryAdapter => AIMasamuneAdapter.primary;

  /// Query for AI.
  ///
  /// ```dart
  /// appRef.controller(AIChat.query(parameters));     // Get from application scope.
  /// ref.app.controller(AIChat.query(parameters));    // Watch at application scope.
  /// ref.page.controller(AIChat.query(parameters));   // Watch at page scope.
  /// ```
  static const query = _$AIChatQuery();

  /// The ID of the thread.
  ///
  /// スレッドのID。
  final String threadId;

  /// The configuration of the thread.
  ///
  /// スレッドの設定。
  final AIConfig? config;

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
  }) async {
    if (adapter.isInitializedConfig(
      config: config,
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
  /// AIにコンテンツを生成してもらいます。
  ///
  /// [contents]にユーザーからのコンテンツを渡してください。
  /// [AIRole]が[AIRole.user]でない場合は例外が投げられます。
  ///
  /// [config]に設定を渡すことも可能です。
  Future<List<AIContent>> generateContent(
    List<AIContent> contents, {
    AIConfig? config,
    bool includeSystemInitialContent = false,
    List<AIContent> Function(List<AIContent> contents)? contentFilter,
  }) async {
    if (!contents.every((e) => e.role == AIRole.user)) {
      throw const InvalidAIRoleException();
    }
    try {
      _value.removeWhere((e) {
        if (e.value.isEmpty) {
          return true;
        }
        return false;
      });
      await initialize(
        config: config ?? this.config,
      );
      _value.addAll(contents);
      _value.sort(adapter.threadContentSortCallback);
      notifyListeners();
      final res = await adapter.generateContent(
        contentFilter?.call(_value) ??
            adapter.contentFilter?.call(_value) ??
            _value,
        config: config ?? this.config,
        includeSystemInitialContent: includeSystemInitialContent,
      );
      if (res == null) {
        return [];
      }
      _value.add(res);
      _value.sort(adapter.threadContentSortCallback);
      notifyListeners();
      await res.loading;
      adapter.onGeneratedContentUsage?.call(
        res.promptTokenCount ?? 0,
        res.candidateTokenCount ?? 0,
      );
      notifyListeners();
      return value;
    } catch (e, stackTrace) {
      for (final content in contents) {
        content.error(e, stackTrace);
      }
      notifyListeners();
      return value;
    }
  }

  /// Clear the thread.
  ///
  /// スレッドをクリアします。
  void clear() {
    _value.clear();
    notifyListeners();
  }
}

@immutable
class _$AIChatQuery {
  const _$AIChatQuery();

  @useResult
  _$_AIChatQuery call({
    required String threadId,
    AIMasamuneAdapter? adapter,
    AIConfig? config,
    List<AIContent> initialContents = const [],
  }) =>
      _$_AIChatQuery(
        threadId,
        config: config,
        adapter: adapter,
        initialContents: initialContents,
      );
}

@immutable
class _$_AIChatQuery extends ControllerQueryBase<AIChat> {
  const _$_AIChatQuery(
    this._name, {
    required this.initialContents,
    this.config,
    this.adapter,
  });

  final String _name;
  final AIConfig? config;
  final List<AIContent> initialContents;
  final AIMasamuneAdapter? adapter;

  @override
  AIChat Function() call(Ref ref) {
    return () => AIChat(
          threadId: _name,
          adapter: adapter,
          config: config,
          initialContents: initialContents,
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
