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

  Completer<void>? _sendCompleter;
  Completer<void>? _initializeCompleter;

  /// Whether the thread is initialized.
  ///
  /// スレッドが初期化されているかどうか。
  bool get initialized => _initialized;
  bool _initialized = false;

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
    if (initialized) {
      return;
    }
    if (_initializeCompleter != null) {
      return;
    }
    _initializeCompleter = Completer<void>();
    try {
      await adapter.initialize();
      _initialized = true;
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
  /// AIにコンテンツを生成してもらいます。
  ///
  /// [content]にユーザーからのコンテンツを渡してください。
  /// [AIRole]が[AIRole.user]でない場合は例外が投げられます。
  Future<void> generateContent(AIContent content) async {
    if (_sendCompleter != null) {
      return;
    }
    if (content.role != AIRole.user) {
      throw const InvalidAIRoleException();
    }
    _sendCompleter = Completer<void>();
    try {
      await initialize(config: config);
      _value.add(content);
      _value.sort((a, b) => a.time.compareTo(b.time));
      notifyListeners();
      final res = await adapter.generateContent(_value, config: config);
      if (res == null) {
        return;
      }
      _value.add(res);
      _value.sort((a, b) => a.time.compareTo(b.time));
      await res.loading;
      _sendCompleter?.complete();
      _sendCompleter = null;
      notifyListeners();
    } catch (e, stackTrace) {
      content.error(e, stackTrace);
      _sendCompleter?.completeError(e, stackTrace);
      _sendCompleter = null;
      notifyListeners();
    } finally {
      _sendCompleter?.complete();
      _sendCompleter = null;
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
  bool get autoDisposeWhenUnreferenced => true;
}
