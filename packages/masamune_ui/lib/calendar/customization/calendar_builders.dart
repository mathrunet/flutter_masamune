part of masamune_calendar;

/// Class for calendar builders.
@immutable
class CalendarBuilders {
  /// Class for calendar builders.
  const CalendarBuilders({
    this.dayBuilder,
    this.selectedDayBuilder,
    this.todayDayBuilder,
    this.holidayDayBuilder,
    this.weekendDayBuilder,
    this.outsideDayBuilder,
    this.outsideWeekendDayBuilder,
    this.outsideHolidayDayBuilder,
    this.unavailableDayBuilder,
    this.markersBuilder,
    this.singleMarkerBuilder,
    this.dowWeekdayBuilder,
    this.dowWeekendBuilder,
  }) : assert(!(singleMarkerBuilder != null && markersBuilder != null));

  /// Builder to make a normal day.
  final Widget Function(BuildContext context, DateTime date, List events)?
      dayBuilder;

  /// Builder to create the selected date.
  final Widget Function(BuildContext context, DateTime date, List events)?
      selectedDayBuilder;

  /// A builder to make today.
  final Widget Function(BuildContext context, DateTime date, List events)?
      todayDayBuilder;

  /// A builder of holidays.
  final Widget Function(BuildContext context, DateTime date, List events)?
      holidayDayBuilder;

  /// A builder to make your weekend.
  final Widget Function(BuildContext context, DateTime date, List events)?
      weekendDayBuilder;

  /// Builder to create a day that is not that month.
  final Widget Function(BuildContext context, DateTime date, List events)?
      outsideDayBuilder;

  /// Builder to create a weekend day that is not that month.
  final Widget Function(BuildContext context, DateTime date, List events)?
      outsideWeekendDayBuilder;

  /// Builder to create a holiday that is not in that month.
  final Widget Function(BuildContext context, DateTime date, List events)?
      outsideHolidayDayBuilder;

  /// Builders to create days of unavailability.
  final Widget Function(BuildContext context, DateTime date, List events)?
      unavailableDayBuilder;

  /// Builder for markers.
  final List<Widget> Function(
    BuildContext context,
    DateTime date,
    List events,
    List holidays,
  )? markersBuilder;

  /// Builder for creating a single marker.
  final Widget Function(BuildContext context, DateTime? date, dynamic event)?
      singleMarkerBuilder;

  /// A builder for making days of the week.
  final Widget Function(BuildContext context, String weekday)?
      dowWeekdayBuilder;

  /// Builder for making days of the week (weekends).
  final Widget Function(BuildContext context, String weekday)?
      dowWeekendBuilder;
}
