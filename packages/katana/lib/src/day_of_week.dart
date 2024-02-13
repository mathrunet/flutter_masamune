part of '/katana.dart';

/// Day of the week.
///
/// 曜日。
enum DayOfWeek {
  /// Monday.
  ///
  /// 月曜日。
  monday(1),

  /// Tuesday.
  ///
  /// 火曜日。
  tuesday(2),

  /// Wednesday.
  ///
  /// 水曜日。
  wednesday(3),

  /// Thursday.
  ///
  /// 木曜日。
  thursday(4),

  /// Friday.
  ///
  /// 金曜日。
  friday(5),

  /// Saturday.
  ///
  /// 土曜日。
  saturday(6),

  /// Sunday.
  ///
  /// 日曜日。
  sunday(7);

  /// Day of the week.
  ///
  /// 曜日。
  const DayOfWeek(this.value);

  /// The day of the week from the [DateTime].
  ///
  /// [DateTime]から曜日を取得します。
  static DayOfWeek fromDateTime(DateTime dateTime) {
    return DayOfWeek.values[dateTime.weekday - 1];
  }

  /// The day of the week from the [int].
  ///
  /// [int]から曜日を取得します。
  static DayOfWeek fromInt(int weekDay) {
    return DayOfWeek.values[weekDay - 1];
  }

  /// The value of the day of the week in [DateTime].
  ///
  /// [DateTime]の曜日の値。
  final int value;

  /// The name of the day of the week.
  ///
  /// 曜日の名前。
  String get shortName {
    switch (this) {
      case DayOfWeek.monday:
        return "mon";
      case DayOfWeek.tuesday:
        return "tue";
      case DayOfWeek.wednesday:
        return "wed";
      case DayOfWeek.thursday:
        return "thu";
      case DayOfWeek.friday:
        return "fri";
      case DayOfWeek.saturday:
        return "sat";
      case DayOfWeek.sunday:
        return "sun";
    }
  }
}
