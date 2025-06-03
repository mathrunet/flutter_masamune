part of "/masamune_calendar.dart";

/// Item classes representing calendar events and holidays.
///
/// カレンダーのイベントと休日を表すアイテムクラス。
@immutable
abstract class CalendarItem<T> {
  /// Item classes representing calendar events and holidays.
  ///
  /// カレンダーのイベントと休日を表すアイテムクラス。
  const CalendarItem({
    required this.startTime,
    required this.data,
    this.endTime,
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

  /// Event data.
  ///
  /// イベントのデータ。
  final T data;

  /// Whether the event is all day or not.
  ///
  /// イベントが終日かどうか。
  final bool allDay;
}

/// Item class representing calendar events.
///
/// カレンダーのイベントを表すアイテムクラス。
@immutable
class CalendarEventItem<T> extends CalendarItem<T> {
  /// Item class representing calendar events.
  ///
  /// カレンダーのイベントを表すアイテムクラス。
  const CalendarEventItem({
    required super.startTime,
    required super.data,
    super.endTime,
    super.allDay = false,
  });
}

/// Item class for calendar holidays.
///
/// カレンダーの休日を表すアイテムクラス。
@immutable
class CalendarHolidayItem<T> extends CalendarItem<T> {
  /// Item class for calendar holidays.
  ///
  /// カレンダーの休日を表すアイテムクラス。
  const CalendarHolidayItem({
    required DateTime date,
    required super.data,
  }) : super(startTime: date, allDay: true);
}
