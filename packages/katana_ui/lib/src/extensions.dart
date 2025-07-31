part of "/katana_ui.dart";

/// Extensions for [ImageProvider].
///
/// [ImageProvider]の拡張メソッド。
extension ImageProviderExtensions on ImageProvider {
  /// Converts the [ImageProvider] to an [Image] widget.
  ///
  /// [ImageProvider]を[Image]ウィジェットに変換します。
  Image toImage({
    Widget Function(BuildContext, Widget, int?, bool)? frameBuilder,
    Widget Function(BuildContext, Widget, ImageChunkEvent?)? loadingBuilder,
    Widget Function(BuildContext, Object, StackTrace?)? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    FilterQuality filterQuality = FilterQuality.medium,
  }) {
    return Image(
      image: this,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      filterQuality: filterQuality,
    );
  }
}

/// Extensions for [String].
///
/// [String]の拡張メソッド。
extension StringToColorExtensions on String {
  /// Converts the [String] to a [Color].
  ///
  /// [String]を[Color]に変換します。
  Color toColor({int alpha = 255}) {
    return Color.fromARGB(
      alpha,
      int.parse(substring(0, 2), radix: 16),
      int.parse(substring(2, 4), radix: 16),
      int.parse(substring(4, 6), radix: 16),
    );
  }
}
