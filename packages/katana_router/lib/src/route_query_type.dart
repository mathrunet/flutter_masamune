part of katana_router;

/// Defines how the page transitions.
/// ページのトランジション方法を定義します。
enum RouteQueryType {
  /// Default transitions.
  /// デフォルトのトランジション。
  initial,

  /// No transitions.
  /// トランジションしない。
  none,

  /// Full screen transition.
  /// フルスクリーントランジション。
  fullscreen,

  /// Fade transitions.
  /// フェードトランジション。
  fade,

  /// Modal Transitions.
  /// モーダルトランジション。
  ///
  /// The back page will be visible.
  /// 裏のページが見えるようになります。
  modal,
}
