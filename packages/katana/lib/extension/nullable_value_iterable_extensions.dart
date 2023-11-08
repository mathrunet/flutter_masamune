part of '/katana.dart';

/// Provides an extension method for [Iterable] whose value is nullable.
///
/// 値がNullableな[Iterable]用の拡張メソッドを提供します。
extension NullableValueIterableExtensions<T> on Iterable<T?> {
  /// If the value of the content of [Iterable] is [Null], it is deleted.
  ///
  /// Returns [Iterable] as [List<T>] after being deleted.
  ///
  /// [Iterable]の中身の値が[Null]な場合それを削除します。
  ///
  /// 削除されたあと[List<T>]として[Iterable]を返します。
  ///
  /// ```dart
  /// final array = [1, null, 2, null, 3];
  /// final removed = array.removeEmpty(); // [1, 2, 3]
  /// ```
  List<T> removeEmpty() {
    final list = <T>[];
    for (final tmp in this) {
      if (tmp == null) {
        continue;
      }
      list.add(tmp);
    }
    return list;
  }
}
