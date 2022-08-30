part of katana;


/// Provides general extensions to [Iterable<double>?].
extension NullableDoubleIterableExtensions on Iterable<double>? {
  /// Get the number closest to [point] from the array.
  ///
  /// If the array has no elements, [Null] is passed.
  double? nearestOrNull(num point) {
    if (isEmpty) {
      return null;
    }
    double? _res;
    double? _point;
    for (final tmp in this!) {
      if (tmp == point) {
        return tmp;
      }
      final p = (point - tmp).abs();
      if (_point == null || p < _point) {
        _res = tmp;
        _point = p;
      }
    }
    return _res;
  }
}
