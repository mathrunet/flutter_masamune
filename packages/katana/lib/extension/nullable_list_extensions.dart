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

  /// Get the [index]th element.
  /// [index]番目の要素を取得します。
  ///
  /// If [index] is out of range, or is itself [Null], or the value is not [E], [defaultValue] is returned.
  /// [index]が範囲外、もしくは自身が[Null]、値が[E]でない場合、[defaultValue]が返されます。
  E get<E>(int index, E defaultValue) {
    if (this == null || !containsIndex(index) || this![index] is! E) {
      return defaultValue;
    }
    return this![index] as E;
  }
}
