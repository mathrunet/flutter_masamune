part of katana;

/// Provides extended methods for [Iterable] arrays.
///
/// [Iterable]の配列用の拡張メソッドを提供します。
extension InterableOfIterableExtensions<T> on Iterable<Iterable<T>> {
  /// Merges an array of arrays into a single array and returns it.
  ///
  /// When [separator] is passed, the elements of [separator] are inserted between the arrays to be merged.
  ///
  /// 配列の配列をマージして１つの配列にして返します。
  ///
  /// [separator]を渡すと、マージする配列と配列の間に[separator]の要素が挿入されます。
  ///
  /// ```dart
  /// final arrayOfArray = [[1, 2, 3], [5, 6], [8, 9]];
  /// final joined = arrayOfArray.joinToList(4); // [1, 2, 3, 4, 5, 6, 4, 8, 9]
  /// ```
  Iterable<T> joinToList([T? separator]) {
    final res = <T>[];
    for (final list in this) {
      res.addAll(list);
      if (separator != null) {
        res.add(separator);
      }
    }
    if (separator != null && res.isNotEmpty) {
      res.removeLast();
    }
    return res;
  }
}
