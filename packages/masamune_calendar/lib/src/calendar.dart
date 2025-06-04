part of "/masamune_calendar.dart";

const double _dxMax = 1.2;
const double _dxMin = -1.2;

/// Specify the calendar gesture.
///
/// カレンダーのジェスチャーを指定します。
enum AvailableGestures {
  /// Disables gestures.
  ///
  /// ジェスチャーを無効にします。
  none,

  /// Enable horizontal swipes only.
  ///
  /// 水平方向のスワイプのみを有効にします。
  horizontalSwipe,
}

/// Specify the calendar widget.
///
/// Specify a list of events in [events].
///
/// Specify holidays in [holidays].
///
/// If you specify [delegate], you can customize the calendar design.
///
/// Specify the calendar controller in [controller].
///
/// Passing [onTap] allows you to specify what happens when the date is tapped.
///
/// Specify the calendar style in [style].
///
/// If [expand] is set to true, the calendar height is automatically adjusted.
///
/// カレンダーのウィジェットを指定します。
///
/// [events]にイベントのリストを指定します。
///
/// [holidays]に休日を指定します。
///
/// [delegate]を指定すると、カレンダーのデザインをカスタマイズできます。
///
/// [controller]にカレンダーのコントローラーを指定します。
///
/// [onTap]を渡すと日付をタップした際の処理を指定できます。
///
/// [style]にカレンダーのスタイルを指定します。
///
/// [expand]にtrueを指定すると、カレンダーの高さを自動的に調整します。
@immutable
class Calendar<T> extends StatefulWidget {
  /// Specify the calendar widget.
  ///
  /// Specify a list of events in [events].
  ///
  /// Specify holidays in [holidays].
  ///
  /// If you specify [delegate], you can customize the calendar design.
  ///
  /// Specify the calendar controller in [controller].
  ///
  /// Passing [onTap] allows you to specify what happens when the date is tapped.
  ///
  /// Specify the calendar style in [style].
  ///
  /// If [expand] is set to true, the calendar height is automatically adjusted.
  ///
  /// カレンダーのウィジェットを指定します。
  ///
  /// [events]にイベントのリストを指定します。
  ///
  /// [holidays]に休日を指定します。
  ///
  /// [delegate]を指定すると、カレンダーのデザインをカスタマイズできます。
  ///
  /// [controller]にカレンダーのコントローラーを指定します。
  ///
  /// [onTap]を渡すと日付をタップした際の処理を指定できます。
  ///
  /// [style]にカレンダーのスタイルを指定します。
  ///
  /// [expand]にtrueを指定すると、カレンダーの高さを自動的に調整します。
  const Calendar({
    required this.events,
    super.key,
    this.holidays = const [],
    this.controller,
    this.onTap,
    this.style = const CalendarStyle(),
    this.expand = false,
    this.calendarFormat = CalendarFormat.month,
    this.startingDayOfWeek,
    this.startDay,
    this.endDay,
    this.enabledDayChecker,
    this.onTapUnavailableDay,
    this.availableGestures = AvailableGestures.horizontalSwipe,
    this.weekendDays,
    this.delegate = const MarkerCalendarDelegate(),
  });

  /// Customize your calendar design.
  ///
  /// カレンダーのデザインをカスタマイズできます。
  final CalendarDelegate<T> delegate;

  /// Specifies calendar events.
  ///
  /// カレンダーのイベントを指定します。
  final List<CalendarEventItem<T>> events;

  /// Specify calendar holidays.
  ///
  /// カレンダーの休日を指定します。
  final List<CalendarHolidayItem<T>> holidays;

  /// Specifies the calendar controller.
  ///
  /// カレンダーのコントローラーを指定します。
  final CalendarController? controller;

  /// Calendar Style.
  ///
  /// カレンダーのスタイル。
  final CalendarStyle style;

  /// Formatting of the calendar display range.
  ///
  /// カレンダーの表示範囲のフォーマット。
  final CalendarFormat calendarFormat;

  /// Specify the first day of the week.
  ///
  /// １週間の最初の曜日を指定します。
  final DayOfWeek? startingDayOfWeek;

  /// Specifies the start date and time of a valid date range.
  ///
  /// To specify a specific date, use [enabledDayChecker].
  ///
  /// 有効な日付の範囲の開始日時を指定します。
  ///
  /// 特定の日付を指定する場合は、[enabledDayChecker]を使用してください。
  final DateTime? startDay;

  /// Specifies the end date and time of a valid date range.
  ///
  /// To specify a specific date, use [enabledDayChecker].
  ///
  /// 有効な日付の範囲の終了日時を指定します。
  ///
  /// 特定の日付を指定する場合は、[enabledDayChecker]を使用してください。
  final DateTime? endDay;

  /// Specify the day of the week for the weekend.
  ///
  /// 週末の曜日を指定します。
  final List<DayOfWeek>? weekendDays;

  /// Specify a valid date in the callback.
  ///
  /// 有効な日付をコールバックで指定します。
  final bool Function(DateTime day)? enabledDayChecker;

  /// Callback when a non-valid date is tapped.
  ///
  /// 有効でない日付をタップした際のコールバック。
  final VoidCallback? onTapUnavailableDay;

  /// Specifies what happens when a valid date is tapped.
  ///
  /// The date is passed to [day] and the list of events for that day is passed to [events].
  ///
  /// 有効な日付をタップした際の処理を指定します。
  ///
  /// [day]に日付が渡され、[events]にその日のイベント一覧が渡されます。
  final void Function(DateTime day, List<CalendarEventItem<T>> events)? onTap;

  /// If `true` is specified, the calendar height is automatically adjusted.
  ///
  /// `true`を指定すると、カレンダーの高さを自動的に調整します。
  final bool expand;

  /// Specify available gestures.
  ///
  /// 利用可能なジェスチャーを指定します。
  final AvailableGestures availableGestures;

  @override
  State<StatefulWidget> createState() => _CalendarState<T>();
}

class _CalendarState<T> extends State<Calendar<T>>
    with TickerProviderStateMixin {
  int _pageId = 0;
  double _dx = 0;

  List<DateTime> _visibleDays = [];

  CalendarController get _effectiveController {
    if (widget.controller != null) {
      return widget.controller!;
    }
    return _controller ??= CalendarController();
  }

  CalendarController? _controller;

  @override
  void initState() {
    super.initState();
    _effectiveController._addListener(
      _selectNext,
      _selectPrev,
      _selectDay,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _visibleDays = _getVisibleDays();
  }

  @override
  void didUpdateWidget(covariant Calendar<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._removeListener(
        _selectNext,
        _selectPrev,
        _selectDay,
      );
      if (widget.controller == null) {
        _controller = CalendarController();
        _controller?._addListener(
          _selectNext,
          _selectPrev,
          _selectDay,
        );
      } else {
        widget.controller?._addListener(
          _selectNext,
          _selectPrev,
          _selectDay,
        );
      }
    }
    if (oldWidget.calendarFormat != widget.calendarFormat) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller?._removeListener(
      _selectNext,
      _selectPrev,
      _selectDay,
    );
    _controller?._removeListener(
      _selectNext,
      _selectPrev,
      _selectDay,
    );
    _controller?.dispose();
  }

  List<DateTime> _getVisibleDays() {
    final focuesedDay = _effectiveController.focusedDay;
    if (widget.calendarFormat == CalendarFormat.month) {
      return _daysInMonth(focuesedDay);
    } else if (widget.calendarFormat == CalendarFormat.twoWeeks) {
      return _daysInWeek(focuesedDay)
        ..addAll(
          _daysInWeek(
            focuesedDay.add(const Duration(days: 7)),
          ),
        );
    } else {
      return _daysInWeek(focuesedDay);
    }
  }

  void _decrementPage() {
    _pageId--;
    _dx = _dxMin;
  }

  void _incrementPage() {
    _pageId++;
    _dx = _dxMax;
  }

  List<DateTime> _daysInMonth(DateTime month) {
    final first = _firstDayOfMonth(month);
    final daysBefore = _getDaysBefore(first);
    final firstToDisplay = first.subtract(Duration(days: daysBefore));

    final last = _lastDayOfMonth(month);
    final daysAfter = _getDaysAfter(last);

    final lastToDisplay = last.add(Duration(days: daysAfter));
    return _daysInRange(firstToDisplay, lastToDisplay).toList();
  }

  void _selectPrev() {
    setState(() {
      if (widget.calendarFormat == CalendarFormat.month) {
        _selectPrevMonth();
      } else if (widget.calendarFormat == CalendarFormat.twoWeeks) {
        _selectPrevTwoWeeks();
      } else {
        _selectPrevWeek();
      }

      _visibleDays = _getVisibleDays();
      _decrementPage();
    });
  }

  void _selectNext() {
    setState(() {
      if (widget.calendarFormat == CalendarFormat.month) {
        _selectNextMonth();
      } else if (widget.calendarFormat == CalendarFormat.twoWeeks) {
        _selectNextTwoWeeks();
      } else {
        _selectNextWeek();
      }

      _visibleDays = _getVisibleDays();
      _incrementPage();
    });
  }

  void _selectDay(DateTime value) {
    setState(() {
      final normalizedDate = _normalizeDate(value);

      if (normalizedDate.isBefore(_getFirstDay(includeInvisible: false))) {
        _decrementPage();
      } else if (normalizedDate.isAfter(_getLastDay(includeInvisible: false))) {
        _incrementPage();
      }

      // _effectiveController.select(normalizedDate);
      _effectiveController.focus(normalizedDate);
      _updateVisibleDays();
    });
  }

  void _onUnavailableDaySelected() {
    widget.onTapUnavailableDay?.call();
  }

  void _onHorizontalSwipe(DismissDirection direction) {
    if (direction == DismissDirection.startToEnd) {
      _effectiveController.prev();
    } else {
      _effectiveController.next();
    }
  }

  bool _isSelected(DateTime day) {
    return day.isThisDay(_effectiveController.selectedDay);
  }

  bool _isDayUnavailable(DateTime day) {
    return (widget.startDay != null &&
            day.isBefore(
              _normalizeDate(widget.startDay!),
            )) ||
        (widget.endDay != null &&
            day.isAfter(
              _normalizeDate(widget.endDay!),
            )) ||
        (!_isDayEnabled(day));
  }

  bool _isDayEnabled(DateTime day) {
    return widget.enabledDayChecker?.call(day) ?? true;
  }

  bool _isWeekend(DateTime day, List<DayOfWeek> weekendDays) {
    return weekendDays.map((e) => e.weekNumber).contains(day.weekday);
  }

  bool _isExtraDay(DateTime day) {
    return _isExtraDayBefore(day) || _isExtraDayAfter(day);
  }

  bool _isExtraDayBefore(DateTime day) {
    return day.month < _effectiveController.focusedDay.month;
  }

  bool _isExtraDayAfter(DateTime day) {
    return day.month > _effectiveController.focusedDay.month;
  }

  void _updateVisibleDays() {
    if (widget.calendarFormat != CalendarFormat.twoWeeks) {
      _visibleDays = _getVisibleDays();
    }
  }

  DateTime _getFirstDay({required bool includeInvisible}) {
    if (widget.calendarFormat == CalendarFormat.month && !includeInvisible) {
      final focuesedDay = _effectiveController.focusedDay;
      return _firstDayOfMonth(focuesedDay);
    } else {
      return _visibleDays.first;
    }
  }

  DateTime _getLastDay({required bool includeInvisible}) {
    if (widget.calendarFormat == CalendarFormat.month && !includeInvisible) {
      final focuesedDay = _effectiveController.focusedDay;
      return _lastDayOfMonth(focuesedDay);
    } else {
      return _visibleDays.last;
    }
  }

  int _getDaysBefore(DateTime firstDay) {
    final adapter = MasamuneAdapterScope.of<CalendarMasamuneAdapter>(context);
    final startingDayOfWeek = widget.startingDayOfWeek ??
        adapter?.startingDayOfWeek ??
        DayOfWeek.sunday;
    return (firstDay.weekday + 7 - _getWeekdayNumber(startingDayOfWeek)) % 7;
  }

  int _getDaysAfter(DateTime lastDay) {
    final adapter = MasamuneAdapterScope.of<CalendarMasamuneAdapter>(context);
    final startingDayOfWeek = widget.startingDayOfWeek ??
        adapter?.startingDayOfWeek ??
        DayOfWeek.sunday;
    final invertedStartingWeekday = 8 - _getWeekdayNumber(startingDayOfWeek);

    int daysAfter = 7 - ((lastDay.weekday + invertedStartingWeekday) % 7) + 1;
    if (daysAfter == 8) {
      daysAfter = 1;
    }

    return daysAfter;
  }

  int _getWeekdayNumber(DayOfWeek weekday) {
    return DayOfWeek.values.indexOf(weekday) + 1;
  }

  List<DateTime> _daysInWeek(DateTime week) {
    final first = _firstDayOfWeek(week);
    final last = _lastDayOfWeek(week);

    return _daysInRange(first, last).toList();
  }

  DateTime _firstDayOfWeek(DateTime day) {
    day = _normalizeDate(day);

    final decreaseNum = _getDaysBefore(day);
    return day.subtract(Duration(days: decreaseNum));
  }

  DateTime _lastDayOfWeek(DateTime day) {
    day = _normalizeDate(day);

    final increaseNum = _getDaysBefore(day);
    return day.add(Duration(days: 7 - increaseNum));
  }

  DateTime _firstDayOfMonth(DateTime month) {
    return DateTime.utc(month.year, month.month, 1, 12);
  }

  DateTime _lastDayOfMonth(DateTime month) {
    final date = month.month < 12
        ? DateTime.utc(month.year, month.month + 1, 1, 12)
        : DateTime.utc(month.year + 1, 1, 1, 12);
    return date.subtract(const Duration(days: 1));
  }

  void _selectPrevMonth() {
    final focuesedDay = _effectiveController.focusedDay;
    _effectiveController.focus(_prevMonth(focuesedDay));
  }

  void _selectNextMonth() {
    final focuesedDay = _effectiveController.focusedDay;
    _effectiveController.focus(_nextMonth(focuesedDay));
  }

  void _selectPrevTwoWeeks() {
    final focuesedDay = _effectiveController.focusedDay;
    if (_visibleDays.take(7).contains(focuesedDay)) {
      _effectiveController.focus(_prevWeek(focuesedDay));
    } else {
      _effectiveController
          .focus(_prevWeek(focuesedDay.subtract(const Duration(days: 7))));
    }
  }

  void _selectNextTwoWeeks() {
    final focuesedDay = _effectiveController.focusedDay;
    if (!_visibleDays.skip(7).contains(focuesedDay)) {
      _effectiveController.focus(_nextWeek(focuesedDay));
    }
  }

  void _selectPrevWeek() {
    final focuesedDay = _effectiveController.focusedDay;
    _effectiveController.focus(_prevWeek(focuesedDay));
  }

  void _selectNextWeek() {
    final focuesedDay = _effectiveController.focusedDay;
    _effectiveController.focus(_nextWeek(focuesedDay));
  }

  DateTime _prevWeek(DateTime week) {
    return week.subtract(const Duration(days: 7));
  }

  DateTime _nextWeek(DateTime week) {
    return week.add(const Duration(days: 7));
  }

  DateTime _prevMonth(DateTime month) {
    if (month.month == 1) {
      return DateTime(month.year - 1, 12);
    } else {
      return DateTime(month.year, month.month - 1);
    }
  }

  DateTime _nextMonth(DateTime month) {
    if (month.month == 12) {
      return DateTime(month.year + 1, 1);
    } else {
      return DateTime(month.year, month.month + 1);
    }
  }

  Iterable<DateTime> _daysInRange(DateTime firstDay, DateTime lastDay) sync* {
    var temp = firstDay;

    while (temp.isBefore(lastDay)) {
      yield _normalizeDate(temp);
      temp = temp.add(const Duration(days: 1));
    }
  }

  DateTime _normalizeDate(DateTime value) {
    return DateTime.utc(value.year, value.month, value.day, 12);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.expand) {
      return SizedBox(
        height: double.infinity,
        child: Padding(
          padding: widget.style.content.padding,
          child: _buildCalendarContent(),
        ),
      );
    } else {
      return ClipRect(
        child: Padding(
          padding: widget.style.content.padding,
          child: _buildCalendarContent(),
        ),
      );
    }
  }

  Widget _buildCalendarContent() {
    return AnimatedSize(
      duration: Duration(
        milliseconds: widget.calendarFormat == CalendarFormat.month ? 330 : 220,
      ),
      curve: Curves.fastOutSlowIn,
      alignment: const Alignment(0, -1),
      child: _buildWrapper(),
    );
  }

  Widget _buildWrapper({Key? key}) {
    Widget wrappedChild = _buildTable();

    switch (widget.availableGestures) {
      case AvailableGestures.horizontalSwipe:
        wrappedChild = _buildHorizontalSwipeWrapper(
          child: wrappedChild,
        );
        break;
      case AvailableGestures.none:
        break;
    }

    return Container(
      key: key,
      child: wrappedChild,
    );
  }

  Widget _buildHorizontalSwipeWrapper({required Widget child}) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      switchInCurve: Curves.decelerate,
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(_dx, 0),
            end: const Offset(0, 0),
          ).animate(animation),
          child: child,
        );
      },
      layoutBuilder: (currentChild, _) => currentChild ?? const Empty(),
      child: Dismissible(
        key: ValueKey(_pageId),
        resizeDuration: null,
        onDismissed: _onHorizontalSwipe,
        direction: DismissDirection.horizontal,
        child: child,
      ),
    );
  }

  Widget _buildTable() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const daysInWeek = 7;
        final children = <TableRow>[
          if (widget.style.daysOfWeek.visible) _buildDaysOfWeek(),
        ];

        int x = 0;
        while (x < _visibleDays.length) {
          children.add(
            _buildTableRow(
              _visibleDays.skip(x).take(daysInWeek).toList(),
              constraints,
            ),
          );
          x += daysInWeek;
        }

        return Table(
          defaultColumnWidth: const FractionColumnWidth(1.0 / daysInWeek),
          border: widget.style.border,
          children: children,
        );
      },
    );
  }

  TableRow _buildDaysOfWeek() {
    final adapter = MasamuneAdapterScope.of<CalendarMasamuneAdapter>(context);
    final weekendDays = widget.weekendDays ??
        adapter?.weekendDays ??
        [DayOfWeek.saturday, DayOfWeek.sunday];
    return TableRow(
      decoration: widget.style.daysOfWeek.decoration,
      children: _visibleDays.take(7).map((date) {
        if (_isWeekend(date, weekendDays)) {
          return widget.delegate.buildDaysOfWeekWeekend(
            context,
            widget.style,
            date,
          );
        } else {
          return widget.delegate.buildDaysOfWeekWeekday(
            context,
            widget.style,
            date,
          );
        }
      }).toList(),
    );
  }

  TableRow _buildTableRow(List<DateTime> days, BoxConstraints constraints) {
    return TableRow(
      decoration: widget.style.content.decoration,
      children: days.map((date) => _buildTableCell(date, constraints)).toList(),
    );
  }

  Widget _buildTableCell(DateTime date, BoxConstraints constraints) {
    if (widget.expand) {
      final double height =
          (constraints.maxHeight - widget.style.daysOfWeek.height) /
              (_visibleDays.length / 7.0).ceilToDouble();
      return LayoutBuilder(
        builder: (context, constraints) => ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: widget.style.content.height ?? height,
            minHeight: widget.style.content.height ?? height,
          ),
          child: _buildCell(date),
        ),
      );
    } else {
      return LayoutBuilder(
        builder: (context, constraints) => ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: widget.style.content.height ?? constraints.maxWidth,
            minHeight: widget.style.content.height ?? constraints.maxWidth,
          ),
          child: _buildCell(date),
        ),
      );
    }
  }

  Widget _buildCell(DateTime date) {
    if (!widget.style.content.visibleOutsideDays &&
        _isExtraDay(date) &&
        widget.calendarFormat == CalendarFormat.month) {
      return const Empty();
    }
    final adapter = MasamuneAdapterScope.of<CalendarMasamuneAdapter>(context);
    final weekendDays = widget.weekendDays ??
        adapter?.weekendDays ??
        [DayOfWeek.saturday, DayOfWeek.sunday];
    final isUnavailable = _isDayUnavailable(date);
    final isSelected = _isSelected(date);
    final isToday = date.isThisDay();
    final tIsOutside = _isExtraDay(date);
    final tIsHoliday = widget.holidays.any((e) => e.startTime.isThisDay(date));
    final tIsWeekend = _isWeekend(date, weekendDays);

    final isOutsideHoliday = tIsOutside && tIsHoliday;
    final isHoliday = !tIsOutside && tIsHoliday;
    final isOutsideWeekend = tIsOutside && tIsWeekend && !tIsHoliday;
    final isOutside = tIsOutside && !tIsWeekend && !tIsHoliday;
    final isWeekend = !tIsOutside && tIsWeekend && !tIsHoliday;

    var content = _buildCellContent(
      date,
      isUnavailable: isUnavailable,
      isSelected: isSelected,
      isToday: isToday,
      isOutside: isOutside,
      isOutsideHoliday: isOutsideHoliday,
      isOutsideWeekend: isOutsideWeekend,
      isHoliday: isHoliday,
      isWeekend: isWeekend,
    );

    final events =
        widget.events.where((e) => e.startTime.isThisDay(date)).toList();

    if (events.isNotEmpty) {
      final children = <Widget>[content];

      if (!isUnavailable) {
        if (isSelected && widget.style.content.highlightSelected) {
          final event = widget.delegate.buildSelectedEvents(
            context,
            widget.style,
            date,
            events,
          );
          if (event != null) {
            children.add(event);
          }
        } else if (isToday && widget.style.content.highlightToday) {
          final event = widget.delegate.buildTodayEvents(
            context,
            widget.style,
            date,
            events,
          );
          if (event != null) {
            children.add(event);
          }
        } else if (tIsOutside) {
          final event = widget.delegate.buildOutsideEvents(
            context,
            widget.style,
            date,
            events,
          );
          if (event != null) {
            children.add(event);
          }
        } else {
          final event = widget.delegate.buildEvents(
            context,
            widget.style,
            date,
            events,
          );
          if (event != null) {
            children.add(event);
          }
        }
      }

      if (children.length > 1) {
        content = Stack(
          alignment: widget.style.content.alignment,
          clipBehavior: widget.style.content.clipBehavior,
          children: children,
        );
      }
    }

    return GestureDetector(
      onTap: () {
        if (_isDayUnavailable(date)) {
          _onUnavailableDaySelected();
        } else {
          _effectiveController.select(date);
        }
        final events =
            widget.events.where((e) => e.startTime.isThisDay(date)).toList();
        widget.onTap?.call(date, events);
      },
      child: content,
    );
  }

  Widget _buildCellContent(
    DateTime date, {
    required bool isUnavailable,
    required bool isSelected,
    required bool isToday,
    required bool isOutsideHoliday,
    required bool isHoliday,
    required bool isOutsideWeekend,
    required bool isOutside,
    required bool isWeekend,
  }) {
    if (isUnavailable) {
      return widget.delegate.buildUnavailableDay(
        context,
        widget.style,
        date,
      );
    } else if (isSelected) {
      return widget.delegate.buildSelectedDay(
        context,
        widget.style,
        date,
      );
    } else if (isToday) {
      return widget.delegate.buildTodayDay(
        context,
        widget.style,
        date,
      );
    } else if (isOutsideHoliday) {
      return widget.delegate.buildOutsideHolidayDay(
        context,
        widget.style,
        date,
      );
    } else if (isHoliday) {
      return widget.delegate.buildHolidayDay(
        context,
        widget.style,
        date,
      );
    } else if (isOutsideWeekend) {
      return widget.delegate.buildOutsideWeekendDay(
        context,
        widget.style,
        date,
      );
    } else if (isOutside) {
      return widget.delegate.buildOutsideDay(
        context,
        widget.style,
        date,
      );
    } else if (isWeekend) {
      return widget.delegate.buildWeekendDay(
        context,
        widget.style,
        date,
      );
    } else {
      return widget.delegate.buildDay(
        context,
        widget.style,
        date,
      );
    }
  }
}

class _CalendarChevronIconButton extends StatelessWidget {
  const _CalendarChevronIconButton({
    required this.icon,
    required this.onTap,
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.all(0),
  });

  final Widget icon;
  final VoidCallback onTap;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100.0),
        child: Padding(
          padding: padding,
          child: icon,
        ),
      ),
    );
  }
}
