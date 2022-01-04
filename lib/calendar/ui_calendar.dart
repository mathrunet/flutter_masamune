library masamune_calendar;

import 'package:intl/intl.dart';
import 'package:masamune/masamune.dart';
import 'package:simple_gesture_detector/simple_gesture_detector.dart';

part 'table_calendar.dart';
part 'calendar_controller.dart';
part 'customization/calendar_builders.dart';
part 'customization/calendar_style.dart';
part 'customization/days_of_week_style.dart';
part 'customization/header_style.dart';
part 'widgets/cell_widget.dart';
part 'widgets/custom_icon_button.dart';
part 'ui_day_calendar.dart';
part 'ui_schedule_calendar.dart';

/// Widget that provides a calendar function.
///
/// Tap the date on the monthly calendar to display the event details.
///
/// You can also tap the event to take action.
///
/// You can define various events by passing a list of [DynamicMap] to [events] and [holidays].
///
/// It doesn't work when keys such as [startTimeKey] and [endTimeKey] are not included in the given [DynamicMap].
///
/// If the value of [allDayKey] is `True`, it is specified as an all-day event.
///
/// By specifying [markerType], you can change the type of marker display.
/// If you want to specify in detail, please create a marker with [markerItemBuilder].
class UICalendar extends StatefulWidget {
  /// Widget that provides a calendar function.
  ///
  /// Tap the date on the monthly calendar to display the event details.
  ///
  /// You can also tap the event to take action.
  ///
  /// You can define various events by passing a list of [DynamicMap] to [events] and [holidays].
  ///
  /// It doesn't work when keys such as [startTimeKey] and [endTimeKey] are not included in the given [DynamicMap].
  ///
  /// If the value of [allDayKey] is `True`, it is specified as an all-day event.
  ///
  /// By specifying [markerType], you can change the type of marker display.
  /// If you want to specify in detail, please create a marker with [markerItemBuilder].
  const UICalendar({
    Key? key,
    this.events = const [],
    this.holidays = const [],
    this.initialDay,
    this.markerIcon,
    this.markerIconSize,
    this.markerType = UICalendarMarkerType.count,
    this.markerItemBuilder,
    this.onTap,
    this.startTimeKey = "startTime",
    this.endTimeKey = "endTime",
    this.titleKey = "name",
    this.textKey = "text",
    this.titleBuilder,
    this.textBuilder,
    this.allDayKey = "allDay",
    this.expand = false,
    this.heightOfDayOfWeekLabel = 20,
    this.calendarContentBorder,
    this.dayBuilder,
    this.selectedDayBuilder,
    this.highlightTodayColor,
    this.highlightTodayTextColor,
    this.highlightSelectedDayColor,
    this.highlightSelectedDayTextColor,
    this.highlightSelectedDay = true,
    this.highlightToday = true,
    this.counterColor,
    this.counterTextColor,
    this.regularHolidays,
    this.saturdayColor,
    this.sundayColor,
    this.holidayColor,
    this.todayDayBuilder,
    this.markersBuilder,
    this.onDaySelect,
    this.onDayLongPressed,
    this.animationTime = const Duration(milliseconds: 300),
  }) : super(key: key);

  /// Regular holiday list.
  final Map<DateTime, String>? regularHolidays;

  /// Saturday Color.
  final Color? saturdayColor;

  /// Holiday Colors.
  final Color? holidayColor;

  /// Sunday Colors.
  final Color? sundayColor;

  /// MarkerIconSize.
  final double? markerIconSize;

  /// Display the calendar in the full width of the parent widget.
  final bool expand;

  /// DayOfWeek label height.
  final double heightOfDayOfWeekLabel;

  /// Specify all borders of the calendar.
  final TableBorder? calendarContentBorder;

  /// Event list.
  final List<DynamicMap> events;

  /// Processing when an event is tapped.
  final void Function(EventData eventData)? onTap;

  /// Holiday list.
  final List<DynamicMap> holidays;

  /// First date to choose.
  final DateTime? initialDay;

  /// Key for event start time.
  final String startTimeKey;

  /// Key for event end time.
  final String endTimeKey;

  /// True to highlight today.
  final bool highlightToday;

  /// Color for highlighting today.
  final Color? highlightTodayColor;

  /// Text color for highlighting today.
  final Color? highlightTodayTextColor;

  /// True to highlight the selected days.
  final bool highlightSelectedDay;

  /// The color when the selected date is highlighted.
  final Color? highlightSelectedDayColor;

  /// The text color when the selected date is highlighted.
  final Color? highlightSelectedDayTextColor;

  /// Color of the counter.
  final Color? counterColor;

  /// Text color of the counter.
  final Color? counterTextColor;

  /// Builder for getting the title.
  final String Function(DynamicMap data)? titleBuilder;

  /// Builder for getting text.
  final String Function(DynamicMap data)? textBuilder;

  /// The name key.
  final String titleKey;

  /// The text key.
  final String textKey;

  /// True if the event is all day.
  final String allDayKey;

  /// Animation time.
  final Duration animationTime;

  /// Day builder.
  final Widget Function(
    BuildContext context,
    DateTime date,
    List<EventData> events,
  )? dayBuilder;

  /// Selected day builder.
  final Widget Function(
    BuildContext context,
    DateTime date,
    List<EventData> events,
  )? selectedDayBuilder;

  /// Today day builder.
  final Widget Function(
    BuildContext context,
    DateTime date,
    List<EventData> events,
  )? todayDayBuilder;

  /// Markers builder.
  final List<Widget> Function(
    BuildContext context,
    DateTime date,
    List<EventData> events,
    List<EventData> holidays,
  )? markersBuilder;

  /// What happens when a date is selected.
  final void Function(
    DateTime day,
    List<EventData> events,
    List<EventData> holidays,
  )? onDaySelect;

  /// What happens when a date is long pressed.
  final void Function(
    DateTime day,
    List<EventData> events,
    List<EventData> holidays,
  )? onDayLongPressed;

  /// Marker type of calendar.
  final UICalendarMarkerType markerType;

  /// Builder for each item in the marker.
  final Widget Function(EventData event)? markerItemBuilder;

  /// Icons for markers.
  final Widget? markerIcon;

  /// Creates the mutable state for this widget at a given location in the tree.
  ///
  /// Subclasses should override this method to return a newly created
  /// instance of their associated [State] subclass:
  ///
  /// ```dart
  /// @override
  /// State<MyWidget> createState() => _MyWidgetState();
  /// ```
  ///
  /// The framework can call this method multiple times over the lifetime of
  /// a [StatefulWidget]. For example, if the widget is inserted into the tree
  /// in multiple locations, the framework will create a separate [State] object
  /// for each location. Similarly, if the widget is removed from the tree and
  /// later inserted into the tree again, the framework will call [createState]
  /// again to create a fresh [State] object, simplifying the lifecycle of
  /// [State] objects.
  @protected
  @override
  _UICalendarState createState() => _UICalendarState();

  /// Holidays in Japan.
  static final Map<DateTime, String> japaneseHolidays = {
    DateTime(2021, 1, 1): "元日",
    DateTime(2021, 1, 11): "成人の日",
    DateTime(2021, 2, 11): "建国記念の日",
    DateTime(2021, 2, 23): "天皇誕生日",
    DateTime(2021, 3, 20): "春分の日",
    DateTime(2021, 4, 29): "昭和の日",
    DateTime(2021, 5, 3): "憲法記念日",
    DateTime(2021, 5, 4): "みどりの日",
    DateTime(2021, 5, 5): "こどもの日",
    DateTime(2021, 7, 22): "海の日",
    DateTime(2021, 7, 23): "スポーツの日",
    DateTime(2021, 8, 8): "山の日",
    DateTime(2021, 8, 9): "休日",
    DateTime(2021, 9, 20): "敬老の日",
    DateTime(2021, 9, 23): "秋分の日",
    DateTime(2021, 11, 3): "文化の日",
    DateTime(2021, 11, 23): "勤労感謝の日",
  };
}

class _UICalendarState extends State<UICalendar> with TickerProviderStateMixin {
  final Map<DateTime, List<EventData>> _events = {};
  final Map<DateTime, List<EventData>> _holidays = {};
  List<EventData> _selectedEvents = [];
  AnimationController? _animationController;
  CalendarController? _calendarController;
  final List<Listenable> _listenableList = [];
  Listenable? _eventsListenable;
  Listenable? _holidaysListenable;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController?.forward();
    if (widget.events is Listenable) {
      _eventsListenable = (widget.events as Listenable)
        ..addListener(_handledOnListUpdate);
    }
    if (widget.holidays is Listenable) {
      _holidaysListenable = (widget.holidays as Listenable)
        ..addListener(_handledOnListUpdate);
    }
    _listenableList.addAll(widget.events.whereType<Listenable>());
    _listenableList.addAll(widget.holidays.whereType<Listenable>());
    _listenableList.forEach((element) => element.addListener(_handledOnUpdate));
  }

  void _handledOnUpdate() {
    setState(() {});
  }

  void _handledOnListUpdate() {
    _listenableList
        .forEach((element) => element.removeListener(_handledOnUpdate));
    _listenableList.clear();
    _listenableList.addAll(widget.events.whereType<Listenable>());
    _listenableList.addAll(widget.holidays.whereType<Listenable>());
    _listenableList.forEach((element) => element.addListener(_handledOnUpdate));
    setState(() {});
  }

  @override
  void dispose() {
    _listenableList
        .forEach((element) => element.removeListener(_handledOnUpdate));
    _eventsListenable?.removeListener(_handledOnListUpdate);
    _holidaysListenable?.removeListener(_handledOnListUpdate);
    _animationController?.dispose();
    _calendarController?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(UICalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.events != oldWidget.events ||
        widget.holidays != oldWidget.holidays) {
      _eventsListenable?.removeListener(_handledOnListUpdate);
      _holidaysListenable?.removeListener(_handledOnListUpdate);
      _listenableList
          .forEach((element) => element.removeListener(_handledOnUpdate));
      _listenableList.clear();
      if (widget.events is Listenable) {
        _eventsListenable = (widget.events as Listenable)
          ..addListener(_handledOnListUpdate);
      }
      if (widget.holidays is Listenable) {
        _holidaysListenable = (widget.holidays as Listenable)
          ..addListener(_handledOnListUpdate);
      }
      _listenableList.addAll(widget.events.whereType<Listenable>());
      _listenableList.addAll(widget.holidays.whereType<Listenable>());
      _listenableList
          .forEach((element) => element.addListener(_handledOnUpdate));
      setState(() {});
    }
  }

  void _onDaySelected(
    DateTime day,
    List<EventData> events,
    List<EventData> holidays,
  ) {
    setState(() {});
  }

  void _onVisibleDaysChanged(
    DateTime first,
    DateTime last,
    CalendarFormat format,
  ) {}

  void _onCalendarCreated(
    DateTime first,
    DateTime last,
    CalendarFormat format,
  ) {}
  void _initEventData() {
    _events.clear();
    for (final data in widget.events) {
      final startTime = data.containsKey(widget.startTimeKey)
          ? DateTime.fromMillisecondsSinceEpoch(
              data.get(widget.startTimeKey, 0),
            )
          : null;
      final endTime = data.containsKey(widget.endTimeKey)
          ? DateTime.fromMillisecondsSinceEpoch(
              data.get(widget.endTimeKey, 0),
            )
          : null;
      if (startTime == null) {
        continue;
      }
      final startDay = DateTime(
        startTime.year,
        startTime.month,
        startTime.day,
        12,
      ).toUtc();
      _setEvent(
        _events,
        day: startDay,
        startTime: startTime,
        endTime: endTime,
        data: data,
        allDay: data.get(widget.allDayKey, false),
      );
      if (endTime != null) {
        final endDay = DateTime(
          endTime.year,
          endTime.month,
          endTime.day,
          12,
        ).toUtc();
        if (startDay.day != endDay.day) {
          for (var day = startDay.add(const Duration(days: 1));
              day.millisecondsSinceEpoch <= endDay.millisecondsSinceEpoch;
              day = day.add(const Duration(days: 1))) {
            _setEvent(
              _events,
              day: day,
              startTime: startTime,
              endTime: endTime,
              data: data,
              allDay: data.get(widget.allDayKey, false) ||
                  day.millisecondsSinceEpoch != endDay.millisecondsSinceEpoch,
            );
          }
        }
      }
    }
  }

  void _initHolidayData() {
    _holidays.clear();
    for (final data in widget.holidays) {
      final startTime = data.containsKey(widget.startTimeKey)
          ? DateTime.fromMillisecondsSinceEpoch(
              data.get(widget.startTimeKey, 0),
            )
          : null;
      if (startTime == null) {
        continue;
      }
      final startDay = DateTime(
        startTime.year,
        startTime.month,
        startTime.day,
        12,
      ).toUtc();
      _setEvent(
        _events,
        day: startDay,
        startTime: startTime,
        data: data,
        allDay: true,
      );
    }
  }

  void _initSelectedEvents() {
    if (_calendarController == null || !_calendarController!.initialized) {
      return;
    }
    if (_calendarController?.focusedDay == null) {
      return;
    }
    final date = DateTime(
            _calendarController!.focusedDay.year,
            _calendarController!.focusedDay.month,
            _calendarController!.focusedDay.day,
            12)
        .toUtc();
    _selectedEvents = _events[date] ?? [];
  }

  void _setEvent(
    Map<DateTime, List<EventData>> event, {
    DateTime? day,
    required DateTime startTime,
    required Map<String, dynamic> data,
    DateTime? endTime,
    bool allDay = false,
  }) {
    day ??= startTime;
    if (event.containsKey(day)) {
      event[day]?.add(
        EventData(
          startTime: startTime,
          endTime: endTime,
          data: data,
          title:
              widget.titleBuilder?.call(data) ?? data.get(widget.titleKey, ""),
          text: widget.textBuilder?.call(data) ?? data.get(widget.textKey, ""),
          allDay: allDay,
        ),
      );
    } else {
      event[day] = [
        EventData(
          startTime: startTime,
          endTime: endTime,
          data: data,
          title:
              widget.titleBuilder?.call(data) ?? data.get(widget.titleKey, ""),
          text: widget.textBuilder?.call(data) ?? data.get(widget.textKey, ""),
          allDay: allDay,
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    _initEventData();
    _initHolidayData();
    _initSelectedEvents();
    if (widget.expand) {
      return Container(
        constraints: const BoxConstraints.expand(),
        child: _buildTableCalendarWithBuilders(),
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildTableCalendarWithBuilders()),
          Expanded(child: _buildEventList()),
        ],
      );
    }
  }

  Widget _buildTableCalendarWithBuilders() {
    if (_calendarController == null) {
      return const Empty();
    }
    return _TableCalendar(
      initialSelectedDay: widget.initialDay ?? DateTime.now(),
      locale: Localize.locale,
      weekendDays: const [DateTime.sunday],
      calendarController: _calendarController!,
      events: _events,
      holidays: _holidays,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.horizontalSwipe,
      availableCalendarFormats: const {
        CalendarFormat.month: "",
        CalendarFormat.week: "",
      },
      expand: widget.expand,
      calendarContentBorder: widget.calendarContentBorder,
      heightOfDayOfWeekLabel: widget.heightOfDayOfWeekLabel,
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        contentDecoration: BoxDecoration(
          border: Border(
            left: BorderSide(
                color: context.theme.dividerColor.withOpacity(0.25), width: 1),
            top: BorderSide(
                color: context.theme.dividerColor.withOpacity(0.25), width: 1),
          ),
        ),
        contentPadding: const EdgeInsets.all(0),
        // contentPadding: widget.expand
        //     ? const EdgeInsets.all(0)
        //     : const EdgeInsets.only(bottom: 4.0, left: 8.0, right: 8.0),
        weekendStyle: TextStyle(color: Colors.red[800]),
        holidayStyle: TextStyle(color: Colors.red[800]),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle(color: Colors.red[600]),
      ),
      headerStyle: const HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        dayBuilder: (context, date, events) {
          if (widget.dayBuilder != null) {
            return widget.dayBuilder!.call(
              context,
              date,
              events.cast<EventData>(),
            );
          }
          return Container(
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            decoration: BoxDecoration(
              border: Border(
                left: date.day == 1
                    ? BorderSide(
                        color: context.theme.dividerColor.withOpacity(0.25),
                        width: 1)
                    : BorderSide.none,
                right: BorderSide(
                    color: context.theme.dividerColor.withOpacity(0.25),
                    width: 1),
              ),
            ),
            // color: context.theme.scaffoldBackgroundColor,
            constraints: const BoxConstraints.expand(),
            child: Text(
              "${date.day}",
              style: TextStyle(
                fontSize: 16.0,
                color: _dayTextColor(date),
              ),
            ),
          );
        },
        selectedDayBuilder: widget.selectedDayBuilder != null
            ? (context, date, events) {
                return widget.selectedDayBuilder!
                    .call(context, date, events.cast<EventData>());
              }
            : (widget.highlightSelectedDay
                ? (context, date, _) {
                    return FadeTransition(
                      opacity: Tween(begin: 0.0, end: 1.0)
                          .animate(_animationController!),
                      child: Container(
                        padding: const EdgeInsets.only(top: 5.0, left: 6.0),
                        color: widget.highlightSelectedDayColor ??
                            context.theme.primaryColor,
                        constraints: const BoxConstraints.expand(),
                        width: 100,
                        height: 100,
                        child: Text(
                          "${date.day}",
                          style: TextStyle(
                            fontSize: 16.0,
                            color: widget.highlightSelectedDayTextColor ??
                                context.theme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    );
                  }
                : null),
        todayDayBuilder: widget.todayDayBuilder != null
            ? (context, date, events) {
                return widget.todayDayBuilder!
                    .call(context, date, events.cast<EventData>());
              }
            : (widget.highlightToday
                ? (context, date, _) {
                    return Container(
                      padding: const EdgeInsets.only(top: 5.0, left: 6.0),
                      color: widget.highlightTodayColor ??
                          context.theme.primaryColor.withOpacity(0.5),
                      constraints: const BoxConstraints.expand(),
                      child: Text(
                        "${date.day}",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: widget.highlightTodayTextColor ??
                              context.theme.colorScheme.onPrimary
                                  .withOpacity(0.5),
                        ),
                      ),
                    );
                  }
                : null),
        markersBuilder: (context, date, events, holidays) {
          if (widget.markersBuilder != null) {
            return widget.markersBuilder!.call(context, date,
                events.cast<EventData>(), holidays.cast<EventData>());
          }
          return _defaultMarkers(context, date, events.cast<EventData>(),
              holidays.cast<EventData>());
        },
      ),
      onDaySelected: (date, events, holidays) {
        final firstDate = DateTime(date.year, date.month, date.day);
        _onDaySelected(
          firstDate,
          events.cast<EventData>(),
          holidays.cast<EventData>(),
        );
        widget.onDaySelect?.call(
          firstDate,
          events.cast<EventData>(),
          holidays.cast<EventData>(),
        );
        _animationController?.forward(from: 0.0);
      },
      onDayLongPressed: (date, events, holidays) {
        final firstDate = DateTime(date.year, date.month, date.day);
        widget.onDayLongPressed?.call(
          firstDate,
          events.cast<EventData>(),
          holidays.cast<EventData>(),
        );
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  Color? _dayTextColor(DateTime date) {
    if (widget.sundayColor != null && date.weekday == DateTime.sunday) {
      return widget.sundayColor;
    }
    if (widget.holidayColor != null &&
        widget.regularHolidays != null &&
        widget.regularHolidays!.keys.any((element) =>
            element.month == date.month && element.day == date.day)) {
      return widget.holidayColor;
    }
    if (widget.saturdayColor != null && date.weekday == DateTime.saturday) {
      return widget.saturdayColor;
    }
    return null;
  }

  Color? _markerColor(BuildContext context, DateTime date) {
    if (_calendarController == null) {
      return context.theme.primaryColor;
    }
    if (_calendarController!.isToday(date)) {
      return widget.highlightTodayTextColor ??
          context.theme.colorScheme.onPrimary;
    }
    if (_calendarController!.isSelected(date)) {
      return widget.highlightSelectedDayTextColor ??
          context.theme.colorScheme.onPrimary;
    }
    return context.theme.primaryColor;
  }

  Color? _countBackgroundColor(BuildContext context, DateTime date) {
    if (_calendarController == null) {
      return widget.counterColor ?? context.theme.primaryColor;
    }
    if (_calendarController!.isToday(date)) {
      return widget.highlightTodayTextColor ??
          context.theme.colorScheme.onPrimary;
    }
    if (_calendarController!.isSelected(date)) {
      return widget.highlightSelectedDayTextColor ??
          context.theme.colorScheme.onPrimary;
    }
    return widget.counterColor ?? context.theme.primaryColor;
  }

  Color? _countTextColor(BuildContext context, DateTime date) {
    if (_calendarController == null) {
      return widget.counterTextColor ?? context.theme.colorScheme.onPrimary;
    }
    if (_calendarController!.isToday(date)) {
      return widget.highlightTodayColor ?? context.theme.primaryColor;
    }
    if (_calendarController!.isSelected(date)) {
      return widget.highlightSelectedDayColor ?? context.theme.primaryColor;
    }
    return widget.counterTextColor ?? context.theme.colorScheme.onPrimary;
  }

  List<Widget> _defaultMarkers(BuildContext context, DateTime date,
      List<EventData> events, List<EventData> holidays) {
    switch (widget.markerType) {
      case UICalendarMarkerType.icon:
        return [
          IconTheme(
            data: IconThemeData(
              color: _markerColor(context, date),
              size: widget.markerIconSize ?? 36,
            ),
            child: Container(
              constraints: const BoxConstraints.expand(),
              padding: const EdgeInsets.only(
                top: 30,
                left: 4,
                right: 4,
                bottom: 4,
              ),
              child: Center(
                child: widget.markerIcon,
              ),
            ),
          )
        ];
      case UICalendarMarkerType.list:
        return [
          DefaultTextStyle(
            style: TextStyle(
              fontSize: 10,
              color: _markerColor(context, date),
            ),
            child: Container(
              constraints: const BoxConstraints.expand(),
              padding: const EdgeInsets.only(
                top: 30,
                left: 4,
                right: 0,
                bottom: 0,
              ),
              child: Wrap(
                direction: Axis.vertical,
                children: [
                  ...events.mapAndRemoveEmpty(
                    (item) => widget.markerItemBuilder?.call(item),
                  ),
                  ...holidays.mapAndRemoveEmpty(
                    (item) => widget.markerItemBuilder?.call(item),
                  )
                ],
              ),
            ),
          )
        ];
      default:
        return [
          if (events.isNotEmpty)
            Positioned(
              right: 1,
              bottom: 1,
              child: _buildEventsMarker(date, events),
            ),
          if (holidays.isNotEmpty)
            Positioned(
              right: -2,
              top: -2,
              child: _buildHolidaysMarker(),
            ),
        ];
    }
  }

  Widget _buildEventsMarker(DateTime date, List<EventData> events) {
    return AnimatedContainer(
      duration: widget.animationTime,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _countBackgroundColor(context, date),
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          "${events.length}",
          style: TextStyle(
            color: _countTextColor(context, date),
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Container(
      alignment: Alignment.center,
      color: context.theme.secondaryColor,
      child: const Icon(Icons.add, size: 20.0, color: Colors.white),
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: [
        Container(
          decoration: BoxDecoration(
            color: context.theme.primaryColor,
            borderRadius: BorderRadius.circular(10.0),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(
            DateFormat.yMMMd(Localize.locale)
                .format(_calendarController?.selectedDay ?? DateTime.now()),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ..._selectedEvents.mapAndRemoveEmpty(
          (event) => Container(
            decoration: BoxDecoration(
              border: Border.all(width: 1),
              borderRadius: BorderRadius.circular(10.0),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: event.text.isNotEmpty
                ? ListTile(
                    isThreeLine: true,
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(event.timeString),
                        ),
                        Flexible(child: Text(event.title))
                      ],
                    ),
                    subtitle: Text(event.text!),
                    onTap: () {
                      widget.onTap?.call(event);
                    },
                  )
                : ListTile(
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(event.timeString)),
                        Flexible(child: Text(event.title))
                      ],
                    ),
                    onTap: () {
                      widget.onTap?.call(event);
                    },
                  ),
          ),
        ),
      ],
    );
  }
}

/// Class for storing event data.
class EventData {
  /// Class for storing event data.
  const EventData({
    required this.startTime,
    this.data = const {},
    this.endTime,
    required this.title,
    this.text,
    this.allDay = false,
  });

  /// Start date and time.
  final DateTime startTime;

  /// End date and time.
  final DateTime? endTime;

  /// Event title.
  final String title;

  /// Event details.
  final String? text;

  /// True if the event is all day.
  final bool allDay;

  /// Raw data for the event.
  final DynamicMap data;

  /// Gets the time string.
  ///
  /// If it is all day, it will be displayed as all day.
  ///
  /// If there is no end time, only the start time is displayed.
  String get timeString {
    if (allDay) {
      return "All day".localize();
    }
    final tmp =
        "${startTime.hour.format("00")}:${startTime.minute.format("00")} -";
    if (endTime == null ||
        startTime.millisecondsSinceEpoch >= endTime!.millisecondsSinceEpoch) {
      return tmp;
    }
    return "$tmp ${endTime!.hour.format("00")}:${endTime!.minute.format("00")}";
  }
}

/// Marker type of calendar.
enum UICalendarMarkerType {
  /// Show a number of events.
  count,

  /// Show a icon.
  icon,

  /// Show a list of events.
  list
}
