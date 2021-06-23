part of masamune_calendar;

typedef FullBuilder = Widget Function(
    BuildContext context, DateTime date, List events);

typedef FullListBuilder = List<Widget> Function(
    BuildContext context, DateTime date, List events, List holidays);

typedef DowBuilder = Widget Function(BuildContext context, String weekday);

typedef SingleMarkerBuilder = Widget Function(
    BuildContext context, DateTime? date, dynamic event);

class CalendarBuilders {
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

  final FullBuilder? dayBuilder;

  final FullBuilder? selectedDayBuilder;

  final FullBuilder? todayDayBuilder;

  final FullBuilder? holidayDayBuilder;

  final FullBuilder? weekendDayBuilder;

  final FullBuilder? outsideDayBuilder;

  final FullBuilder? outsideWeekendDayBuilder;

  final FullBuilder? outsideHolidayDayBuilder;

  final FullBuilder? unavailableDayBuilder;

  ///

  final FullListBuilder? markersBuilder;

  ///

  final SingleMarkerBuilder? singleMarkerBuilder;

  final DowBuilder? dowWeekdayBuilder;

  final DowBuilder? dowWeekendBuilder;
}
