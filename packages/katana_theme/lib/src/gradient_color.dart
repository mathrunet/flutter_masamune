part of "/katana_theme.dart";

/// You can add gradient elements to the theme's color settings.
///
/// Two color gradients can be set by passing [mainColor] and [subColor].
///
/// To use it as a gradient, it must be converted to a gradient object using [Color.toLinearGradient].
///
/// When used as a normal [Color], the color of [mainColor] is used.
///
/// テーマの色設定にグラデーションの要素を加えることができます。
///
/// [mainColor]と[subColor]を渡すことで２色のグラデーションを設定可能です。
///
/// グラデーションとして用いるためには[Color.toLinearGradient]を利用してグラデーションオブジェクトに変換する必要があります。
///
/// 通常の[Color]として利用される場合、[mainColor]の色が使用されます。
@immutable
class GradientColor implements Color {
  /// You can add gradient elements to the theme's color settings.
  ///
  /// Two color gradients can be set by passing [mainColor] and [subColor].
  ///
  /// To use it as a gradient, it must be converted to a gradient object using [Color.toLinearGradient].
  ///
  /// When used as a normal [Color], the color of [mainColor] is used.
  ///
  /// テーマの色設定にグラデーションの要素を加えることができます。
  ///
  /// [mainColor]と[subColor]を渡すことで２色のグラデーションを設定可能です。
  ///
  /// グラデーションとして用いるためには[Color.toLinearGradient]を利用してグラデーションオブジェクトに変換する必要があります。
  ///
  /// 通常の[Color]として利用される場合、[mainColor]の色が使用されます。
  const GradientColor(
    this.mainColor,
    this.subColor,
  );

  /// The color of the starting point of the gradient color.
  ///
  /// This color is used when used as [Color].
  ///
  /// グラデーション色の開始地点の色。
  ///
  /// [Color]として利用される場合はこの色が利用されます。
  final Color mainColor;

  /// The color at the end of the gradient color.
  ///
  /// グラデーション色の終了地点の色。
  final Color subColor;

  List<Color> _toGradient() {
    return [mainColor, subColor];
  }

  @override
  double computeLuminance() {
    return mainColor.computeLuminance();
  }

  @override
  ColorSpace get colorSpace => mainColor.colorSpace;

  @override
  double get a => mainColor.a;

  @override
  double get b => mainColor.b;

  @override
  double get g => mainColor.g;

  @override
  double get r => mainColor.r;

  @override
  Color withValues({
    double? alpha,
    double? red,
    double? green,
    double? blue,
    ColorSpace? colorSpace,
  }) =>
      mainColor.withValues(
        alpha: alpha,
        red: red,
        green: green,
        blue: blue,
        colorSpace: colorSpace,
      );

  @override
  Color withAlpha(int a) {
    return mainColor.withAlpha(a);
  }

  @override
  Color withBlue(int b) {
    return mainColor.withBlue(b);
  }

  @override
  Color withGreen(int g) {
    return mainColor.withGreen(g);
  }

  @override
  Color withRed(int r) {
    return mainColor.withRed(r);
  }

  @override
  int get hashCode => mainColor.hashCode ^ subColor.hashCode;

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  String toString() {
    final mainColorValue = _floatToInt8(a) << 24 |
        _floatToInt8(r) << 16 |
        _floatToInt8(g) << 8 |
        _floatToInt8(b) << 0;
    final subColorValue = _floatToInt8(a) << 24 |
        _floatToInt8(r) << 16 |
        _floatToInt8(g) << 8 |
        _floatToInt8(b) << 0;
    return "GradientColor(0x${mainColorValue.toRadixString(16).padLeft(8, '0')}, 0x${subColorValue.toRadixString(16).padLeft(8, '0')})";
  }

  @override
  @Deprecated('Use .a.')
  int get alpha => mainColor.alpha;

  @override
  @Deprecated('Use .b.')
  int get blue => mainColor.blue;

  @override
  @Deprecated('Use .g.')
  int get green => mainColor.green;

  @override
  @Deprecated('Use .a.')
  double get opacity => mainColor.opacity;

  @override
  @Deprecated('Use .r.')
  int get red => mainColor.red;

  @override
  @Deprecated('Use component accessors like .r or .g.')
  int get value => mainColor.value;

  @override
  @Deprecated('Use .withValues() to avoid precision loss.')
  Color withOpacity(double opacity) {
    return mainColor.withOpacity(opacity);
  }

  static int _floatToInt8(double x) {
    return (x * 255.0).round() & 0xff;
  }

  @override
  int toARGB32() {
    return _floatToInt8(a) << 24 |
        _floatToInt8(r) << 16 |
        _floatToInt8(g) << 8 |
        _floatToInt8(b) << 0;
  }
}
