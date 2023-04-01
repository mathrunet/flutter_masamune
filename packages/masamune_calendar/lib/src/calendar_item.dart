part of masamune_calendar;

/// Item classes representing calendar events and holidays.
///
/// カレンダーのイベントと休日を表すアイテムクラス。
@immutable
abstract class CalendarItem {
  /// Item classes representing calendar events and holidays.
  ///
  /// カレンダーのイベントと休日を表すアイテムクラス。
  const CalendarItem({
    required this.startTime,
    required this.title,
    this.endTime,
    this.text,
    this.allDay = false,
  });

  /// Event start time.
  ///
  /// イベントの開始時間。
  final DateTime startTime;

  /// End time of the event.
  ///
  /// イベントの終了時間。
  final DateTime? endTime;

  /// Event Title.
  ///
  /// イベントのタイトル。
  final String title;

  /// Event text.
  ///
  /// イベントのテキスト。
  final String? text;

  /// Whether the event is all day or not.
  ///
  /// イベントが終日かどうか。
  final bool allDay;
}

/// Item class representing calendar events.
///
/// カレンダーのイベントを表すアイテムクラス。
@immutable
class CalendarEventItem extends CalendarItem {
  /// Item class representing calendar events.
  ///
  /// カレンダーのイベントを表すアイテムクラス。
  const CalendarEventItem({
    required super.startTime,
    required super.title,
    super.endTime,
    super.text,
    super.allDay = false,
  });
}

/// Item class for calendar holidays.
///
/// カレンダーの休日を表すアイテムクラス。
@immutable
class CalendarHolidayItem extends CalendarItem {
  /// Item class for calendar holidays.
  ///
  /// カレンダーの休日を表すアイテムクラス。
  const CalendarHolidayItem({
    required DateTime date,
    required super.title,
    super.text,
  }) : super(startTime: date, allDay: true);
}
