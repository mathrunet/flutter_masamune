part of katana;

/// Provides extended methods for [double] arrays.
///
/// [double]の配列用の拡張メソッドを提供します。
extension DoubleIterableExtensions on Iterable<double> {
  /// Get the closest [double] to [point] in the [double] array.
  ///
  /// [Null] is returned if the array is empty or if [point] is [double.nan].
  ///
  /// [double]の配列の中で[point]に一番近い[double]を取得します。
  ///
  /// 配列が空の場合や[point]が[double.nan]の場合は[Null]が返されます。
  ///
  /// ```dart
  /// final doubleArray = [
  ///   1.0, 2.0, 5.0, 100.0
  /// ];
  /// final nearest = doubleArray.nearestOrNull(8.0); // 5.0
  /// ```
  double? nearestOrNull(num point) {
    if (isEmpty || point.isNaN) {
      return null;
    }
    double? _res;
    double? _point;
    for (final tmp in this) {
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
