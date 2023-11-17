part of '/katana.dart';

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
    double? res;
    double? tmpPoint;
    for (final tmp in this) {
      if (tmp == point) {
        return tmp;
      }
      final p = (point - tmp).abs();
      if (tmpPoint == null || p < tmpPoint) {
        res = tmp;
        tmpPoint = p;
      }
    }
    return res;
  }

  /// Calculate the sum using all values in the [double] list.
  ///
  /// [double]のリストのすべての値を用いて合計を算出します。
  double sum() {
    return reduce((a, b) => a + b);
  }

  /// Calculate the average using all values in the [double] list.
  ///
  /// [double]のリストのすべての値を用いて平均を算出します。
  double average() {
    return sum() / length;
  }

  /// Calculate the standard deviation using all values in the [double] list.
  ///
  /// [double]のリストのすべての値を用いて標準偏差を算出します。
  double standardDeviation() {
    return sqrt(variance());
  }

  /// Calculate the variance using all the values in the list of [int].
  ///
  /// [double]のリストのすべての値を用いて分散を算出します。
  double variance() {
    final mean = reduce((a, b) => a + b) / length;
    final variance =
        map((value) => pow(value - mean, 2)).reduce((a, b) => a + b) / length;
    return variance;
  }

  /// Calculate the maximum value in the [double] list.
  ///
  /// [double]のリストの中で最大値を算出します。
  double max() {
    return reduce((a, b) => a > b ? a : b);
  }

  /// Calculate the minimum value in the [double] list.
  ///
  /// [double]のリストの中で最小値を算出します。
  double min() {
    return reduce((a, b) => a < b ? a : b);
  }
}
