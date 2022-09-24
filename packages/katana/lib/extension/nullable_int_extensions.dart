part of katana;

/// Provides an extension method for [int] that is nullable.
/// Nullableな[int]用の拡張メソッドを提供します。
extension NullableIntExtensions on int? {
  /// Returns `true` if [int] is [null] or `0`.
  /// [int]が[Null]、もしくは`0`の場合`true`を返します。
  bool get isEmpty {
    if (this == null) {
      return true;
    }
    return this == 0;
  }

  /// Returns `true` if [int] is not [Null] or `0`.
  /// [int]が[Null]、もしくは`0`でない場合`true`を返します。
  bool get isNotEmpty {
    if (this == null) {
      return false;
    }
    return this != 0;
  }
}
