part of katana_theme;

extension ThemeColorExtensions on Color {
  Gradient toLinearGradient({
    AlignmentGeometry begin = Alignment.centerLeft,
    AlignmentGeometry end = Alignment.centerRight,
    TileMode tileMode = TileMode.clamp,
    List<double>? stops,
    GradientTransform? transform,
  }) {
    final color = this;
    if (color is GradientColor) {
      return LinearGradient(
        colors: color._toGradient(),
        stops: stops,
        transform: transform,
        begin: begin,
        end: end,
        tileMode: tileMode,
      );
    } else {
      return LinearGradient(
        colors: [this],
        stops: stops,
        transform: transform,
        begin: begin,
        end: end,
        tileMode: tileMode,
      );
    }
  }

  bool get isGradient {
    return this is GradientColor;
  }

  Color darken([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  Color lighten([double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }
}

extension ThemeTextStyleExtensions on TextStyle {
  TextStyle darken([double amount = 0.1]) {
    return copyWith(
      color: color?.darken(amount),
    );
  }

  TextStyle lighten([double amount = 0.1]) {
    return copyWith(
      color: color?.lighten(amount),
    );
  }

  TextStyle smallize([double amount = 1]) {
    return copyWith(fontSize: fontSize == null ? null : (fontSize! - amount));
  }

  TextStyle largize([double amount = 1]) {
    return copyWith(fontSize: fontSize == null ? null : (fontSize! + amount));
  }

  TextStyle withOpacity(double opacity) {
    return copyWith(color: color?.withOpacity(opacity));
  }

  TextStyle withColor(Color color) {
    return copyWith(color: color);
  }

  TextStyle withBold([FontWeight fontWeight = FontWeight.bold]) {
    return copyWith(fontWeight: fontWeight);
  }

  TextStyle withFont(String fontfamily) {
    return copyWith(fontFamily: fontfamily);
  }
}
