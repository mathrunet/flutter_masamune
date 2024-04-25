part of '/masamune_universal_ui.dart';

/// Extension methods for [Text].
///
/// [Text]の拡張メソッドです。
extension UniversalUIIconExtensions on Icon {
  /// Create a new [Icon] by copying the contents of [Icon].
  ///
  /// [Icon]の内容をコピーして新しい[Icon]を作成します。
  @Deprecated(
    "This Extension is no longer available; please use a Widget to describe it. このExtensionは使えなくなります。Widgetで記述してください。",
  )
  Icon copyWith({
    IconData? icon,
    double? size,
    double? fill,
    double? weight,
    double? grade,
    double? opticalSize,
    Color? color,
    List<Shadow>? shadows,
    String? semanticLabel,
    TextDirection? textDirection,
  }) {
    return Icon(
      icon ?? this.icon,
      size: size ?? this.size,
      color: color ?? this.color,
      semanticLabel: semanticLabel ?? this.semanticLabel,
      textDirection: textDirection ?? this.textDirection,
      fill: fill ?? this.fill,
      grade: grade ?? this.grade,
      opticalSize: opticalSize ?? this.opticalSize,
      shadows: shadows ?? this.shadows,
      weight: weight ?? this.weight,
    );
  }

  /// Change [Icon.size] to [size].
  ///
  /// [Icon.size]を[size]に変更します。
  @Deprecated(
    "This Extension is no longer available; please use a Widget to describe it. このExtensionは使えなくなります。Widgetで記述してください。",
  )
  Icon iconSize(double size) => copyWith(size: size);

  /// Change [Icon.weight] to [weight].
  ///
  /// [Icon.weight]を[weight]に変更します。
  @Deprecated(
    "This Extension is no longer available; please use a Widget to describe it. このExtensionは使えなくなります。Widgetで記述してください。",
  )
  Icon iconWeight(double weight) => copyWith(weight: weight);

  /// Change [Icon.color] to [color].
  ///
  /// [Icon.color]を[color]に変更します。
  @Deprecated(
    "This Extension is no longer available; please use a Widget to describe it. このExtensionは使えなくなります。Widgetで記述してください。",
  )
  Icon color(Color color) => copyWith(color: color);
}
