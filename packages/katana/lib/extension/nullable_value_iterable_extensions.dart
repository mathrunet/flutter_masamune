part of katana;

/// Provides general extensions to [Iterable<T?>].
extension NullableValueIterableExtensions<T> on Iterable<T?> {
  /// If the iterator value is empty, delete the element.
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
