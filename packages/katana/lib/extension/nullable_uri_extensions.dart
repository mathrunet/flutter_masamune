part of katana;

/// Provides an extension method for [Uri] that is nullable.
///
/// Nullableな[Uri]用の拡張メソッドを提供します。
extension NullableUriExtensions on Uri? {
  /// Whether this string is empty.
  ///
  /// Returns `true` if itself is [Null].
  ///
  /// この文字列が空かどうかを調べます。
  ///
  /// 自身が[Null]の場合`true`を返します。
  bool get isEmpty {
    if (this == null) {
      return true;
    }
    return this!.toString().isEmpty;
  }

  /// Whether this string is not empty.
  ///
  /// Returns `false` if itself is [Null].
  ///
  /// この文字列が空でないかどうかを調べます。
  ///
  /// 自身が[Null]の場合`false`を返します。
  bool get isNotEmpty {
    if (this == null) {
      return false;
    }
    return this!.toString().isNotEmpty;
  }
}
