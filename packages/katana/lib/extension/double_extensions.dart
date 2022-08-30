part of katana;

/// Provides general extensions to [double].
extension DoubleExtensions on double {
  /// Whether this int is zero.
  bool get isEmpty => this == 0.0;

  /// Whether this int is not zero.
  bool get isNotEmpty => this != 0.0;

  /// Replace Nan and Infinite values with [replace].
  double replaceNanOrInfinite([double replace = 0.0]) {
    if (isNaN || isInfinite) {
      return replace;
    }
    return this;
  }

  /// Restrict value from [min] to [max].
  double limit(double min, double max) {
    if (isNaN || this < min) {
      return min;
    }
    if (this > max) {
      return max;
    }
    return this;
  }

  /// Restrict value from [min].
  double limitLow(double min) {
    if (isNaN || this < min) {
      return min;
    }
    return this;
  }

  /// Restrict value from [max].
  double limitHigh(double max) {
    if (isNaN || this > max) {
      return max;
    }
    return this;
  }

  /// Represents a number in [format].
  ///
  /// The [format] depends on NumberFormat.
  String format(String format) {
    assert(format.isNotEmpty, "The format is empty.");
    return NumberFormat(format).format(this);
  }
}
