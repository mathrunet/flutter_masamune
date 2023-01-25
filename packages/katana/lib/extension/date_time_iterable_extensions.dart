part of katana;

/// Provides extended methods for [DateTime] arrays.
///
/// [DateTime]の配列用の拡張メソッドを提供します。
extension DateTimeIterableExtensions on Iterable<DateTime> {
  /// Get the closest [DateTime] to [point] in the [DateTime] array.
  ///
  /// If the array is empty, [Null] is returned.
  ///
  /// [DateTime]の配列の中で[point]に一番近い[DateTime]を取得します。
  ///
  /// 配列が空の場合は[Null]が返されます。
  ///
  /// ```dart
  /// final dateTimeArray = [
  ///   DateTime(2022, 12, 20),
  ///   DateTime(2022, 12, 28),
  ///   DateTime(2023, 1, 12),
  /// ];
  /// final nearest = dateTimeArray.nearestOrNull(DateTime(2022, 12, 22)); // DateTime(2022, 12, 20)
  /// ```
  DateTime? nearestOrNull(DateTime point) {
    if (isEmpty) {
      return null;
    }
    DateTime? res;
    int? tmpPoint;
    final pointMilliseconds = point.millisecondsSinceEpoch;
    for (final tmp in this) {
      final tmpMilliseconds = tmp.millisecondsSinceEpoch;
      if (tmpMilliseconds == pointMilliseconds) {
        return tmp;
      }
      final p = (pointMilliseconds - tmpMilliseconds).abs();
      if (tmpPoint == null || p < tmpPoint) {
        res = tmp;
        tmpPoint = p;
      }
    }
    return res;
  }
}
