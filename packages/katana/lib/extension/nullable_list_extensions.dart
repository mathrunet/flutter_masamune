part of katana;

/// Provides an extension method for [List] that is nullable.
/// Nullableな[List]用の拡張メソッドを提供します。
extension NullableListExtensions<T> on List<T>? {
  /// Returns `true` if [index] is within the range of elements in [List].
  /// [index]が[List]の要素の範囲内にある場合`true`を返します。
  ///
  /// Returns `false` if itself is [Null].
  /// 自身が[Null]な場合は`false`を返します。
  bool containsIndex(int index) {
    if (this == null) {
      return false;
    }
    return index >= 0 && index < length;
  }
}
