part of '/katana.dart';

/// A class that represents a date period.
///
/// Enter only [year], [month], or [day] to be the period.
///
/// 日付の期間を表すクラス。
///
/// [year]、[month]、[day]のみを入力してその期間とします。
class DateDuration {
  /// A class that represents a date period.
  ///
  /// Enter only [year], [month], or [day] to be the period.
  ///
  /// 日付の期間を表すクラス。
  ///
  /// [year]、[month]、[day]のみを入力してその期間とします。
  const DateDuration(this.year, this.month, this.day);

  /// Years.
  ///
  /// 年数。
  final int year;

  /// Months.
  ///
  /// 月数。
  final int month;

  /// Days.
  ///
  /// 日数。
  final int day;

  @override
  String toString() {
    return "$runtimeType($year, $month, $day)";
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes
  int get hashCode => year.hashCode ^ month.hashCode ^ day.hashCode;
}
