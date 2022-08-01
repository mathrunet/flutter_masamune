part of katana_routing;

/// A color class for gradations that allows only two colors to be specified.
///
/// You can get the color as an array with the `toGradient()` extension method of Color.
@immutable
class GradientColor implements Color {
  const GradientColor(
    this.mainColor,
    this.subColor,
  );

  /// Main color.
  final Color mainColor;

  /// Sub color.
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
