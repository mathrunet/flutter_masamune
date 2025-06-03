part of "/masamune_universal_ui.dart";

/// Extension methods for [Widget].
///
/// [Widget]の拡張メソッドです。
extension UniversalUIClipExtensions on Widget {
  /// Set the size of the [Widget] to [width] and [height].
  ///
  /// [Widget]のサイズを[width]と[height]に設定します。
  @Deprecated(
    "This Extension is no longer available; please use a Widget to describe it. このExtensionは使えなくなります。Widgetで記述してください。",
  )
  SizedBox sizeTo({
    double? width,
    double? height,
  }) {
    return SizedBox(
      width: width,
      height: height,
      child: this,
    );
  }

  /// Clip [Widget] with a rounded rectangle.
  ///
  /// [Widget]を丸みを帯びた四角形でクリップします。
  @Deprecated(
    "This Extension is no longer available; please use a Widget to describe it. このExtensionは使えなくなります。Widgetで記述してください。",
  )
  ClipRRect clipRect({
    required BorderRadiusGeometry borderRadius,
    CustomClipper<RRect>? clipper,
    Clip clipBehavior = Clip.antiAlias,
  }) {
    return ClipRRect(
      borderRadius: borderRadius,
      clipper: clipper,
      clipBehavior: clipBehavior,
      child: this,
    );
  }

  /// Clip [Widget] in a circle.
  ///
  /// [Widget]を円形でクリップします。
  @Deprecated(
    "This Extension is no longer available; please use a Widget to describe it. このExtensionは使えなくなります。Widgetで記述してください。",
  )
  ClipOval clipOval({
    CustomClipper<Rect>? clipper,
    Clip clipBehavior = Clip.antiAlias,
  }) {
    return ClipOval(
      clipper: clipper,
      clipBehavior: clipBehavior,
      child: this,
    );
  }
}
