part of '/masamune_calendar.dart';

/// Day of the week.
///
/// 曜日。
enum DayOfWeek {
  /// Monday.
  ///
  /// 月曜日。
  monday,

  /// Tuesday.
  ///
  /// 火曜日。
  tuesday,

  /// Wednesday.
  ///
  /// 水曜日。
  wednesday,

  /// Thursday.
  ///
  /// 木曜日。
  thursday,

  /// Friday.
  ///
  /// 金曜日。
  friday,

  /// Saturday.
  ///
  /// 土曜日。
  saturday,

  /// Sunday.
  ///
  /// 日曜日。
  sunday;

  /// Get the day of the week as a number.
  ///
  /// Returns the same value as [DateTime.weekday].
  ///
  /// 曜日を数値で取得します。
  ///
  /// [DateTime.weekday]と同じ値を返します。
  int get weekNumber {
    switch (this) {
      case DayOfWeek.monday:
        return 1;
      case DayOfWeek.tuesday:
        return 2;
      case DayOfWeek.wednesday:
        return 3;
      case DayOfWeek.thursday:
        return 4;
      case DayOfWeek.friday:
        return 5;
      case DayOfWeek.saturday:
        return 6;
      case DayOfWeek.sunday:
        return 7;
    }
  }
}
