part of masamune_universal_ui;

/// Extension methods for [Widget].
///
/// [Widget]の拡張メソッドです。
extension UniversalUIDecorationExtensions on Widget {
  /// Set the size of the [Widget] to [width] and [height].
  ///
  /// [Widget]のサイズを[width]と[height]に設定します。
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

  ClipRRect clipRect({
    BorderRadiusGeometry? borderRadius,
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
