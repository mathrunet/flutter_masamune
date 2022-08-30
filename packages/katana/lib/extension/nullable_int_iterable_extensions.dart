part of katana;

/// Provides general extensions to [Iterable<int>?].
extension NullableIntIterableExtensions on Iterable<int>? {
  /// Get the number closest to [point] from the array.
  ///
  /// If the array has no elements, [Null] is passed.
  int? nearestOrNull(num point) {
    if (isEmpty) {
      return null;
    }
    int? _res;
    int? _point;
    for (final tmp in this!) {
      if (tmp == point) {
        return tmp;
      }
      final p = (point - tmp).abs().toInt();
      if (_point == null || p < _point) {
        _res = tmp;
        _point = p;
      }
    }
    return _res;
  }
}
