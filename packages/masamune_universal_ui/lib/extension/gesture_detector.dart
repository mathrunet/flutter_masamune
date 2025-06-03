part of "/masamune_universal_ui.dart";

/// Extension methods for [Widget].
///
/// [Widget]の拡張メソッドです。
extension UniversalUIGestureDetectorExtensions on Widget {
  /// [callback] when a double-tap is performed.
  ///
  /// ダブルタップを行った際に[callback]を実行します。
  @Deprecated(
    "This Extension is no longer available; please use a Widget to describe it. このExtensionは使えなくなります。Widgetで記述してください。",
  )
  GestureDetector onDoubleTap(VoidCallback callback) => GestureDetector(
        onDoubleTap: callback,
        child: this,
      );

  /// [callback] when a tap is performed.
  ///
  /// タップを行った際に[callback]を実行します。
  @Deprecated(
    "This Extension is no longer available; please use a Widget to describe it. このExtensionは使えなくなります。Widgetで記述してください。",
  )
  GestureDetector onTap(VoidCallback callback) => GestureDetector(
        onTap: callback,
        child: this,
      );

  /// Execute [callback] when a long press is performed.
  ///
  /// ロングプレスを行った際に[callback]を実行します。
  @Deprecated(
    "This Extension is no longer available; please use a Widget to describe it. このExtensionは使えなくなります。Widgetで記述してください。",
  )
  GestureDetector onLongPress(VoidCallback callback) => GestureDetector(
        onLongPress: callback,
        child: this,
      );

  /// [callback] when a double-tap is performed.
  ///
  /// ダブルタップを行った際に[callback]を実行します。
  @Deprecated(
    "This Extension is no longer available; please use a Widget to describe it. このExtensionは使えなくなります。Widgetで記述してください。",
  )
  InkWell onDoubleTapWithInk(VoidCallback callback) => InkWell(
        onDoubleTap: callback,
        child: this,
      );

  /// [callback] when a tap is performed.
  ///
  /// タップを行った際に[callback]を実行します。
  @Deprecated(
    "This Extension is no longer available; please use a Widget to describe it. このExtensionは使えなくなります。Widgetで記述してください。",
  )
  InkWell onTapWithInk(VoidCallback callback) => InkWell(
        onTap: callback,
        child: this,
      );

  /// Execute [callback] when a long press is performed.
  ///
  /// ロングプレスを行った際に[callback]を実行します。
  @Deprecated(
    "This Extension is no longer available; please use a Widget to describe it. このExtensionは使えなくなります。Widgetで記述してください。",
  )
  InkWell onLongPressWithInk(VoidCallback callback) => InkWell(
        onLongPress: callback,
        child: this,
      );
}
