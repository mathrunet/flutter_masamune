part of katana_router;

/// Routing events for logging.
///
/// ロギング用のルーティングイベント。
enum RouteLoggerEvent {
  /// When a route is pushed.
  ///
  /// ルートがpushされたとき。
  push,

  /// When a route is poped.
  ///
  /// ルートがpopされたとき。
  pop,

  /// When a route is replaceed.
  ///
  /// ルートがreplaceされたとき。
  replace;

  /// Key for the new routing name.
  ///
  /// 新しいルーティング名のキー。
  static const newRouteKey = "newRoute";

  /// Key of the previous routing name.
  ///
  /// 前のルーティング名のキー。
  static const prevRouteKey = "prevRoute";
}
