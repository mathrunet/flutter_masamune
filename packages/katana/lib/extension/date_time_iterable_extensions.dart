part of katana;

/// Provides general extensions to [Iterable<DateTime>].
extension DateTimeIterableExtensions on Iterable<DateTime> {
  /// Get the datetime closest to [point] from the array.
  ///
  /// If the array has no elements, [Null] is passed.
  DateTime? nearestOrNull(DateTime point) {
    if (isEmpty) {
      return null;
    }
    DateTime? _res;
    int? _point;
    final pointMilliseconds = point.millisecondsSinceEpoch;
    for (final tmp in this) {
      final tmpMilliseconds = tmp.millisecondsSinceEpoch;
      if (tmpMilliseconds == pointMilliseconds) {
        return tmp;
      }
      final p = (pointMilliseconds - tmpMilliseconds).abs();
      if (_point == null || p < _point) {
        _res = tmp;
        _point = p;
      }
    }
    return _res;
  }
}
