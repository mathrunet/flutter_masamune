part of masamune_universal_ui;

/// Extension methods for [Widget].
///
/// [Widget]の拡張メソッドです。
extension UniversalUIGestureDetectorExtensions on Widget {
  /// [callback] when a double-tap is performed.
  ///
  /// ダブルタップを行った際に[callback]を実行します。
  GestureDetector onDoubleTap(VoidCallback callback) => GestureDetector(
        onDoubleTap: callback,
        child: this,
      );

  /// [callback] when a tap is performed.
  ///
  /// タップを行った際に[callback]を実行します。
  GestureDetector onTap(VoidCallback callback) => GestureDetector(
        onTap: callback,
        child: this,
      );

  /// Execute [callback] when a long press is performed.
  ///
  /// ロングプレスを行った際に[callback]を実行します。
  GestureDetector onLongPress(VoidCallback callback) => GestureDetector(
        onLongPress: callback,
        child: this,
      );

  /// [callback] when a double-tap is performed.
  ///
  /// ダブルタップを行った際に[callback]を実行します。
  InkWell onDoubleTapWithInk(VoidCallback callback) => InkWell(
        onDoubleTap: callback,
        child: this,
      );

  /// [callback] when a tap is performed.
  ///
  /// タップを行った際に[callback]を実行します。
  InkWell onTapWithInk(VoidCallback callback) => InkWell(
        onTap: callback,
        child: this,
      );

  /// Execute [callback] when a long press is performed.
  ///
  /// ロングプレスを行った際に[callback]を実行します。
  InkWell onLongPressWithInk(VoidCallback callback) => InkWell(
        onLongPress: callback,
        child: this,
      );
}
