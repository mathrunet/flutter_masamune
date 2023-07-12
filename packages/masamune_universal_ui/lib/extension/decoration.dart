part of masamune_universal_ui;

/// Extension methods for [Widget].
///
/// [Widget]の拡張メソッドです。
extension UniversalUIDecorationExtensions on Widget {
  /// Change the transparency of [Widget] to [opacity].
  ///
  /// [Widget]の透明度を[opacity]に変更します。
  Opacity opacity({required double opacity}) => Opacity(
        opacity: opacity,
        child: this,
      );

  /// Add a [backgroundColor] background or [border] to the [Widget].
  ///
  /// [Widget]に[backgroundColor]の背景もしくは[border]を付与します。
  DecoratedBox decoration({
    Color? backgroundColor,
    BoxBorder? border,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: border,
      ),
      child: this,
    );
  }

  /// Change the [backgroundColor] of the [Widget].
  ///
  /// [Widget]の[backgroundColor]を変更します。
  DecoratedBox background(
    Color backgroundColor,
  ) =>
      decoration(backgroundColor: backgroundColor);

  /// Add [border] to [Widget].
  ///
  /// [Widget]に[border]を付与します。
  DecoratedBox border(
    BoxBorder border,
  ) =>
      decoration(border: border);

  /// Add shadow to [Widget].
  ///
  /// [Widget]に影を付与します。
  DecoratedBox shadow({
    Color shadowColor = const Color(_kColorDefault),
    double blurRadius = 0.0,
    double spreadRadius = 0.0,
    Offset offset = Offset.zero,
    BlurStyle blurStyle = BlurStyle.normal,
  }) =>
      DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: blurRadius,
              spreadRadius: spreadRadius,
              offset: offset,
              blurStyle: blurStyle,
            ),
          ],
        ),
        child: this,
      );
}
