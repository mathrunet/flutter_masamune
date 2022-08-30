part of katana;

/// Provides general extensions to [Object?].
extension NullableObjectExtensions on Object? {
  /// Specifies the initial value when the value is [Null].
  ///
  /// If the value is [Null],
  /// the value specified by [defaultValue] will be returned.
  ///
  /// All returned values will be of type non-null.
  T def<T>(T defaultValue) {
    if (this == null) {
      return defaultValue;
    }
    return this as T;
  }
}
