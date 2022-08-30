part of katana;


/// Provides general extensions to [int].
extension IntExtensions on int {
  /// Whether this int is zero.
  bool get isEmpty => this == 0;

  /// Whether this int is not zero.
  bool get isNotEmpty => this != 0;

  /// Replace Nan and Infinite values with [replace].
  int replaceNanOrInfinite([int replace = 0]) {
    if (isNaN || isInfinite) {
      return replace;
    }
    return this;
  }

  /// Restrict value from [min] to [max].
  int limit(int min, int max) {
    if (this < min) {
      return min;
    }
    if (this > max) {
      return max;
    }
    return this;
  }

  /// Restrict value from [min].
  int limitLow(int min) {
    if (this < min) {
      return min;
    }
    return this;
  }

  /// Restrict value from [max].
  int limitHigh(int max) {
    if (this > max) {
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
