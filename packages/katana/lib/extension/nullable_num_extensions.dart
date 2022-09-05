part of katana;

/// Provides general extensions to [num?].
extension NullableNumExtensions on num? {
  /// Whether this num is null or zero.
  bool get isEmpty {
    if (this == null) {
      return true;
    }
    return this == 0.0;
  }

  /// Whether this num is not null or zero.
  bool get isNotEmpty {
    if (this == null) {
      return false;
    }
    return this != 0.0;
  }

  /// Calculation assuming Null.
  ///
  /// If both are null, null is returned.
  /// If either is not null, a non-null value is returned.
  num? operator +(num? other) {
    if (this == null) {
      return other;
    }
    if (other == null) {
      return this;
    }
    return this! + other;
  }

  /// Calculation assuming Null.
  ///
  /// If both are null, null is returned.
  /// If either is not null, a non-null value is returned.
  num? operator -(num? other) {
    if (this == null) {
      return other;
    }
    if (other == null) {
      return this;
    }
    return this! - other;
  }

  /// Calculation assuming Null.
  ///
  /// If both are null, null is returned.
  /// If either is not null, a non-null value is returned.
  num? operator *(num? other) {
    if (this == null) {
      return other;
    }
    if (other == null) {
      return this;
    }
    return this! * other;
  }

  /// Calculation assuming Null.
  ///
  /// If both are null, null is returned.
  /// If either is not null, a non-null value is returned.
  double? operator /(num? other) {
    if (this == null) {
      return other?.toDouble();
    }
    if (other == null) {
      return this?.toDouble();
    }
    return this! / other;
  }

  /// Calculation assuming Null.
  ///
  /// If both are null, null is returned.
  /// If either is not null, a non-null value is returned.
  num? operator %(num? other) {
    if (this == null) {
      return other;
    }
    if (other == null) {
      return this;
    }
    return this! % other;
  }

  /// Calculation assuming Null.
  ///
  /// If both are null, null is returned.
  /// If either is not null, a non-null value is returned.
  int? operator ~/(num? other) {
    if (this == null) {
      return other?.toInt();
    }
    if (other == null) {
      return this?.toInt();
    }
    return this! ~/ other;
  }
}
