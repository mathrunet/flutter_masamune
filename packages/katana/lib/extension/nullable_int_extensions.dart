part of katana;

/// Provides general extensions to [int?].
extension NullableIntExtensions on int? {
  /// Whether this int is null or zero.
  bool get isEmpty {
    if (this == null) {
      return true;
    }
    return this == 0;
  }

  /// Whether this int is not null or zero.
  bool get isNotEmpty {
    if (this == null) {
      return false;
    }
    return this != 0;
  }
}
