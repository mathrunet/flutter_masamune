part of katana_router;

/// Defines how the page transitions.
/// ページのトランジション方法を定義します。
enum TransitionQueryType {
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
  ///
  /// The back page will be visible.
  ///
  /// モーダルトランジション。
  ///
  /// 裏のページが見えるようになります。
  modal,
}
