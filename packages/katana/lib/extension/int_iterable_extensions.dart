part of katana;

/// Provides extended methods for [int] arrays.
/// [int]の配列用の拡張メソッドを提供します。
extension IntIterableExtensions on Iterable<int> {
  /// Get the closest [int] to [point] in the [int] array.
  /// [int]の配列の中で[point]に一番近い[int]を取得します。
  ///
  /// [Null] is returned if the array is empty or if [point] is [double.nan].
  /// 配列が空の場合や[point]が[double.nan]の場合は[Null]が返されます。
  ///
  /// ```dart
  /// final intArray = [
  ///   1, 2, 5, 100
  /// ];
  /// final nearest = intArray.nearestOrNull(8); // 5
  /// ```
  int? nearestOrNull(num point) {
    if (isEmpty || point.isNaN) {
      return null;
    }
    int? _res;
    int? _point;
    for (final tmp in this) {
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
