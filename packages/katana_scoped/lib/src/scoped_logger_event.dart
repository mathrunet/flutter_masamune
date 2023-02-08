part of katana_scoped;

/// Status management events for logging.
///
/// ロギング用の状態管理イベント。
enum ScopedLoggerEvent {
  /// When the state is set.
  ///
  /// 状態がセットされたとき。
  init,

  /// When the state is destroyed.
  ///
  /// 状態が破棄されたとき。
  dispose,

  /// When the condition is monitored.
  ///
  /// 状態が監視されたとき。
  listen,

  /// When the condition is no longer monitored.
  ///
  /// 状態の監視が外れたとき。
  unlisten;

  /// Scope Key.
  ///
  /// スコープのキー。
  static const scopeKey = "scope";

  /// Type key.
  ///
  /// タイプのキー。
  static const typeKey = "type";

  /// Name Key.
  ///
  /// 名前のキー。
  static const nameKey = "name";

  /// The key of the target for which the state is being managed.
  ///
  /// 状態を管理している対象のキー。
  static const managedKey = "managed";

  /// Key of the target whose status is being monitored.
  ///
  /// 状態を監視している対象のキー。
  static const listenedKey = "listened";
}

/// State management scope for logging.
///
/// ロギング用の状態管理スコープ。
enum ScopedLoggerScope {
  /// Entire application.
  ///
  /// アプリケーション全体。
  app,

  /// Page.
  ///
  /// ページ。
  page,

  /// Widgets.
  ///
  /// ウィジェット。
  widget,
}
