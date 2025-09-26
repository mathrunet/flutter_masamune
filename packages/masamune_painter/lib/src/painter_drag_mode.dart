part of "/masamune_painter.dart";

/// DragMode enumeration.
///
/// ドラッグモードの列挙型。
enum PainterDragMode {
  /// None.
  ///
  /// ドラッグモードがない場合。
  none,

  /// Creating.
  ///
  /// 作成中。
  creating,

  /// Moving.
  ///
  /// 移動中。
  moving,

  /// Resizing.
  ///
  /// リサイズ中。
  resizing,

  /// Selecting.
  ///
  /// 選択中。
  selecting,

  /// Panning.
  ///
  /// パン（視点移動）中。
  panning;
}
