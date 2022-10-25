part of katana_router;

/// Defines how the page transitions.
///
/// ページのトランジション方法を定義します。
enum _TransitionQueryType {
  /// Default transitions.
  ///
  /// デフォルトのトランジション。
  initial(modal: false),

  /// No transitions.
  ///
  /// トランジションしない。
  none(modal: false),

  /// Full screen transition.
  ///
  /// フルスクリーントランジション。
  fullscreen(modal: false),

  /// Fade transitions.
  ///
  /// フェードトランジション。
  fade(modal: false),

  /// Modal transition from the middle.
  ///
  /// The back page will be visible.
  ///
  /// 真ん中からのモーダルトランジション。
  ///
  /// 裏のページが見えるようになります。
  centerModal(modal: true),

  /// Modal transitions from below.
  ///
  /// The back page will be visible.
  ///
  /// 下からのモーダルトランジション。
  ///
  /// 裏のページが見えるようになります。
  bottomModal(modal: true);

  /// Defines how the page transitions.
  ///
  /// ページのトランジション方法を定義します。
  const _TransitionQueryType({required this.modal});

  /// True when using a modal.
  ///
  /// モーダルを利用する場合True.
  final bool modal;
}
