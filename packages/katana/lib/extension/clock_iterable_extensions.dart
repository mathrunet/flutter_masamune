part of "/katana.dart";

/// Provides extended methods for [Clock] arrays.
///
/// [Clock]の配列用の拡張メソッドを提供します。
extension ClockIterableExtensions on Iterable<Clock> {
  /// Get the closest [Clock] to [point] in the [Clock] array.
  ///
  /// If the array is empty, [Null] is returned.
  ///
  /// [Clock]の配列の中で[point]に一番近い[Clock]を取得します。
  ///
  /// 配列が空の場合は[Null]が返されます。
  ///
  /// ```dart
  /// final clockArray = [
  ///   Clock(2022, 12, 20),
  ///   Clock(2022, 12, 28),
  ///   Clock(2023, 1, 12),
  /// ];
  /// final nearest = clockArray.nearestOrNull(Clock(2022, 12, 22)); // Clock(2022, 12, 20)
  /// ```
  Clock? nearestOrNull(DateTime point) {
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
    if (res == null) {
      return null;
    }
    return Clock.fromDateTime(res);
  }

  /// Calculates the most recent date in the [DateTime] list.
  ///
  /// [DateTime]のリストの中で一番新しい日付を算出します。
  Clock max() {
    return Clock.fromMicrosecondsSinceEpoch(
      map((e) => e.microsecondsSinceEpoch).reduce((a, b) => a > b ? a : b),
    );
  }

  /// Calculates the oldest date in the [DateTime] list.
  ///
  /// [DateTime]のリストの中で一番古い日付を算出します。
  Clock min() {
    return Clock.fromMicrosecondsSinceEpoch(
      map((e) => e.microsecondsSinceEpoch).reduce((a, b) => a < b ? a : b),
    );
  }
}
