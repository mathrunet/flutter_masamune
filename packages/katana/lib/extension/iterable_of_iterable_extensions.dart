part of katana;


/// Provides general extensions to [Iterable<Iterable<T>>].
extension InterableOfIterableExtensions<T> on Iterable<Iterable<T>> {
  /// The list inside are grouped together into a single list.
  ///
  /// You can define a [separator] to put an element in between.
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
