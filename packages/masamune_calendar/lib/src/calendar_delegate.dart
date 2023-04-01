part of masamune_calendar;

/// A delegate that represents the display portion of the calendar.
///
/// カレンダーの表示部分を表すデリゲート。
@immutable
abstract class CalendarDelegate {
  /// A delegate that represents the display portion of the calendar.
  ///
  /// カレンダーの表示部分を表すデリゲート。
  const CalendarDelegate();

  /// Generates the date display portion.
  ///
  /// 日付の表示部分を生成します。
  Widget buildDay(
    BuildContext context,
    CalendarStyle style,
    DateTime date,
  ) {
    return AnimatedContainer(
      duration: style.content.animationTime,
      decoration: BoxDecoration(
        borderRadius: style.content.borderRadius,
      ),
      padding: style.content.cellPadding,
      alignment: Alignment.topLeft,
      child: Text(
        date.day.toString(),
        style: style.content.weekdayStyle,
      ),
    );
  }

  /// Generates the display portion of the selected date.
  ///
  /// 選択された日付の表示部分を生成します。
  Widget buildSelectedDay(
    BuildContext context,
    CalendarStyle style,
    DateTime date,
  ) {
    return AnimatedContainer(
      duration: style.content.animationTime,
      decoration: BoxDecoration(
        color: style.content.highlightSelected
            ? (style.content.selectedColor ??
                Theme.of(context).colorScheme.primary)
            : null,
        borderRadius: style.content.borderRadius,
      ),
      padding: style.content.cellPadding,
      alignment: Alignment.topLeft,
      child: Text(
        date.day.toString(),
        style: style.content.highlightSelected
            ? (style.content.selectedStyle ??
                TextStyle(color: Theme.of(context).colorScheme.onPrimary))
            : style.content.weekdayStyle,
      ),
    );
  }

  /// Generates the display portion of today's date.
  ///
  /// 本日の日付の表示部分を生成します。
  Widget buildTodayDay(
    BuildContext context,
    CalendarStyle style,
    DateTime date,
  ) {
    return AnimatedContainer(
      duration: style.content.animationTime,
      decoration: BoxDecoration(
        color: style.content.highlightToday
            ? (style.content.todayColor ??
                Theme.of(context).colorScheme.secondary)
            : null,
        borderRadius: style.content.borderRadius,
      ),
      padding: style.content.cellPadding,
      alignment: Alignment.topLeft,
      child: Text(
        date.day.toString(),
        style: style.content.highlightToday
            ? (style.content.todayStyle ??
                TextStyle(color: Theme.of(context).colorScheme.onSecondary))
            : style.content.weekdayStyle,
      ),
    );
  }

  /// Generates the display portion of the holiday date.
  ///
  /// 休日の日付の表示部分を生成します。
  Widget buildHolidayDay(
    BuildContext context,
    CalendarStyle style,
    DateTime date,
  ) {
    return AnimatedContainer(
      duration: style.content.animationTime,
      decoration: BoxDecoration(
        borderRadius: style.content.borderRadius,
      ),
      padding: style.content.cellPadding,
      alignment: Alignment.topLeft,
      child: Text(
        date.day.toString(),
        style: style.content.holidayStyle ??
            TextStyle(color: Theme.of(context).colorScheme.error),
      ),
    );
  }

  /// Generate the display portion of the weekend date.
  ///
  /// 週末の日付の表示部分を生成します。
  Widget buildWeekendDay(
    BuildContext context,
    CalendarStyle style,
    DateTime date,
  ) {
    return AnimatedContainer(
      duration: style.content.animationTime,
      decoration: BoxDecoration(
        borderRadius: style.content.borderRadius,
      ),
      padding: style.content.cellPadding,
      alignment: Alignment.topLeft,
      child: Text(
        date.day.toString(),
        style: style.content.holidayStyle ??
            TextStyle(color: Theme.of(context).colorScheme.error),
      ),
    );
  }

  /// Generates the display portion of dates outside the month range.
  ///
  /// 月の範囲外の日付の表示部分を生成します。
  Widget buildOutsideDay(
    BuildContext context,
    CalendarStyle style,
    DateTime date,
  ) {
    return AnimatedContainer(
      duration: style.content.animationTime,
      decoration: BoxDecoration(
        borderRadius: style.content.borderRadius,
      ),
      padding: style.content.cellPadding,
      alignment: Alignment.topLeft,
      child: Text(
        date.day.toString(),
        style: style.content.outsideStyle ??
            TextStyle(color: Theme.of(context).disabledColor),
      ),
    );
  }

  /// Generates the display portion of weekend dates outside of the month range.
  ///
  /// 月の範囲外の週末の日付の表示部分を生成します。
  Widget buildOutsideWeekendDay(
    BuildContext context,
    CalendarStyle style,
    DateTime date,
  ) {
    return AnimatedContainer(
      duration: style.content.animationTime,
      decoration: BoxDecoration(
        borderRadius: style.content.borderRadius,
      ),
      padding: style.content.cellPadding,
      alignment: Alignment.topLeft,
      child: Text(
        date.day.toString(),
        style: style.content.outsideWeekendStyle ??
            TextStyle(color: Theme.of(context).disabledColor),
      ),
    );
  }

  /// Generates the display portion of holiday dates outside of the month range.
  ///
  /// 月の範囲外の休日の日付の表示部分を生成します。
  Widget buildOutsideHolidayDay(
    BuildContext context,
    CalendarStyle style,
    DateTime date,
  ) {
    return AnimatedContainer(
      duration: style.content.animationTime,
      decoration: BoxDecoration(
        borderRadius: style.content.borderRadius,
      ),
      padding: style.content.cellPadding,
      alignment: Alignment.topLeft,
      child: Text(
        date.day.toString(),
        style: style.content.outsideHolidayStyle ??
            TextStyle(color: Theme.of(context).disabledColor),
      ),
    );
  }

  /// Generates display grains for unavailable dates.
  ///
  /// 利用できない日付の表示粒分を生成します。
  Widget buildUnavailableDay(
    BuildContext context,
    CalendarStyle style,
    DateTime date,
  ) {
    return AnimatedContainer(
      duration: style.content.animationTime,
      decoration: BoxDecoration(
        borderRadius: style.content.borderRadius,
      ),
      padding: style.content.cellPadding,
      alignment: Alignment.topLeft,
      child: Text(
        date.day.toString(),
        style: style.content.unavailableStyle ??
            TextStyle(color: Theme.of(context).disabledColor),
      ),
    );
  }

  /// Generate a widget to display the event.
  ///
  /// The events of [date] are passed to [events].
  ///
  /// イベントを表示するウィジェットを生成します。
  ///
  /// [events]に[date]のイベントが渡されます。
  Widget? buildEvents(
    BuildContext context,
    CalendarStyle style,
    DateTime date,
    List<CalendarEventItem> events,
  );

  /// Generates a widget that displays today's events.
  ///
  /// The events of [date] are passed to [events].
  ///
  /// 本日のイベントを表示するウィジェットを生成します。
  ///
  /// [events]に[date]のイベントが渡されます。
  Widget? buildTodayEvents(
    BuildContext context,
    CalendarStyle style,
    DateTime date,
    List<CalendarEventItem> events,
  );

  /// Generates a widget that displays events for the selected date.
  ///
  /// The events of [date] are passed to [events].
  ///
  /// 選択された日付のイベントを表示するウィジェットを生成します。
  ///
  /// [events]に[date]のイベントが渡されます。
  Widget? buildSelectedEvents(
    BuildContext context,
    CalendarStyle style,
    DateTime date,
    List<CalendarEventItem> events,
  );

  /// Generates a widget that displays events for dates outside the month range.
  ///
  /// The events of [date] are passed to [events].
  ///
  /// 月の範囲外の日付のイベントを表示するウィジェットを生成します。
  ///
  /// [events]に[date]のイベントが渡されます。
  Widget? buildOutsideEvents(
    BuildContext context,
    CalendarStyle style,
    DateTime date,
    List<CalendarEventItem> events,
  );

  /// Generates the weekday display portion of the weekday.
  ///
  /// 平日の曜日の表示部分を生成します。
  Widget buildDaysOfWeekWeekday(
    BuildContext context,
    CalendarStyle style,
    DateTime date,
  ) {
    return Container(
      height: style.daysOfWeek.height,
      alignment: Alignment.center,
      child: Text(date.E(), style: style.daysOfWeek.weekdayTextStyle),
    );
  }

  /// Generate the display portion of the weekend days of the week.
  ///
  /// 週末の曜日の表示部分を生成します。
  Widget buildDaysOfWeekWeekend(
    BuildContext context,
    CalendarStyle style,
    DateTime date,
  ) {
    return Container(
      height: style.daysOfWeek.height,
      alignment: Alignment.center,
      child: Text(
        date.E(),
        style: style.daysOfWeek.weekendTextStyle ??
            TextStyle(
              color: Theme.of(context).colorScheme.error,
            ),
      ),
    );
  }
}
