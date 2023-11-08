part of '/katana_theme.dart';

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
  int get alpha => mainColor.alpha;

  @override
  int get blue => mainColor.blue;

  @override
  double computeLuminance() {
    return mainColor.computeLuminance();
  }

  @override
  int get green => mainColor.green;

  @override
  double get opacity => mainColor.opacity;

  @override
  int get red => mainColor.red;

  @override
  int get value => mainColor.value;

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
  Color withOpacity(double opacity) {
    return mainColor.withOpacity(opacity);
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
  String toString() =>
      'GradientColor(0x${mainColor.value.toRadixString(16).padLeft(8, '0')}, 0x${subColor.value.toRadixString(16).padLeft(8, '0')})';
}
