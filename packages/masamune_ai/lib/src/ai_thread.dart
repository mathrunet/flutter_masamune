part of '/masamune_ai.dart';

/// Manage threads of interaction with the AI.
///
/// The result of the exchange can be obtained at [value].
///
/// Use [send] method to send a message to the AI.
///
/// Use [clear] method to clear the thread.
///
/// AIとのやりとりのスレッドを管理します。
///
/// やり取りの結果は[value]で取得できます。
///
/// [send]メソッドでメッセージを送信します。
///
/// [clear]メソッドでスレッドをクリアします。
class AIThread
    extends MasamuneControllerBase<List<AIContent>, AIMasamuneAdapter> {
  /// Manage threads of interaction with the AI.
  ///
  /// The result of the exchange can be obtained at [value].
  ///
  /// Use [send] method to send a message to the AI.
  ///
  /// Use [clear] method to clear the thread.
  ///
  /// AIとのやりとりのスレッドを管理します。
  ///
  /// やり取りの結果は[value]で取得できます。
  ///
  /// [send]メソッドでメッセージを送信します。
  ///
  /// [clear]メソッドでスレッドをクリアします。
  AIThread({
    super.adapter,
    required this.threadId,
    required List<AIContent> initialContents,
    this.config,
  }) {
    _value.addAll(initialContents);
  }

  @override
  AIMasamuneAdapter get primaryAdapter => AIMasamuneAdapter.primary;

  /// Query for AI.
  ///
  /// ```dart
  /// appRef.controller(AI.query(parameters));     // Get from application scope.
  /// ref.app.controller(AI.query(parameters));    // Watch at application scope.
  /// ref.page.controller(AI.query(parameters));   // Watch at page scope.
  /// ```
  static const query = _$AIQuery();

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
  List<AIContent> get value => _value;
  final List<AIContent> _value = [];

  /// Initialize the thread.
  ///
  /// スレッドを初期化します。
  Future<void> initialize({AIConfig? config}) async {
    if (adapter.isInitializedConfig(config: config)) {
      return;
    }
    if (_initializeCompleter != null) {
      return;
    }
    _initializeCompleter = Completer<void>();
    try {
      await adapter.initialize(config: config);
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
  /// Pass a content from the user to [content].
  /// If [AIRole] is not [AIRole.user], an exception is thrown.
  ///
  /// You can also pass settings to [config].
  ///
  /// AIにコンテンツを生成してもらいます。
  ///
  /// [content]にユーザーからのコンテンツを渡してください。
  /// [AIRole]が[AIRole.user]でない場合は例外が投げられます。
  ///
  /// [config]に設定を渡すことも可能です。
  Future<void> generateContent(AIContent content, {AIConfig? config}) async {
    if (content.role != AIRole.user) {
      throw const InvalidAIRoleException();
    }
    try {
      _value.removeWhere((e) {
        if (e.value.isEmpty) {
          return true;
        }
        return false;
      });
      await initialize(config: config ?? this.config);
      _value.add(content);
      _value.sort((a, b) => b.time.compareTo(a.time));
      notifyListeners();
      final res =
          await adapter.generateContent(_value, config: config ?? this.config);
      if (res == null) {
        return;
      }
      _value.add(res);
      _value.sort((a, b) => b.time.compareTo(a.time));
      notifyListeners();
      await res.loading;
      adapter.onGeneratedContentUsage?.call(
        res.promptTokenCount ?? 0,
        res.candidateTokenCount ?? 0,
      );
      notifyListeners();
    } catch (e, stackTrace) {
      content.error(e, stackTrace);
      notifyListeners();
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
class _$AIQuery {
  const _$AIQuery();

  @useResult
  _$_AIQuery call(
    String threadId, {
    AIConfig? config,
    List<AIContent> initialContents = const [],
  }) =>
      _$_AIQuery(
        threadId,
        config: config,
        initialContents: initialContents,
      );
}

@immutable
class _$_AIQuery extends ControllerQueryBase<AIThread> {
  const _$_AIQuery(
    this._name, {
    this.config,
    required this.initialContents,
  });

  final String _name;
  final AIConfig? config;
  final List<AIContent> initialContents;

  @override
  AIThread Function() call(Ref ref) {
    return () => AIThread(
          threadId: _name,
          config: config,
          initialContents: initialContents,
        );
  }

  @override
  String get queryName => _name;
  @override
  bool get autoDisposeWhenUnreferenced => false;
}
