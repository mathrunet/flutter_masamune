part of masamune_calendar;

/// Callback for when a date is selected.
typedef OnDaySelected = void Function(DateTime day, List events, List holidays);

/// Callback for when the displayed date has changed.
typedef OnVisibleDaysChanged = void Function(
  DateTime first,
  DateTime last,
  CalendarFormat format,
);

/// Callback for when the calendar is created.
typedef OnCalendarCreated = void Function(
  DateTime first,
  DateTime last,
  CalendarFormat format,
);

/// Callback for when a header gesture is made.
typedef HeaderGestureCallback = void Function(DateTime focusedDay);

/// A builder for text.
typedef TextBuilder = String Function(DateTime date, dynamic locale);

/// Callback for determining a valid date.
typedef EnabledDayPredicate = bool Function(DateTime day);

/// Calendar Format.
enum CalendarFormat {
  /// Monthly Calendar.
  month,

  /// Two-weekly calendar.
  twoWeeks,

  /// Weekly calendar.
  week,
}

/// Format switching animation.
enum FormatAnimation {
  /// Slide animation.
  slide,

  /// Scale animation.
  scale,
}

/// Start day.
enum StartingDayOfWeek {
  /// Monday.
  monday,

  /// Tuesday
  tuesday,

  /// Wednesday
  wednesday,

  /// Thursday.
  thursday,

  /// Friday.
  friday,

  /// Saturday.
  saturday,

  /// Sunday.
  sunday
}

int _getWeekdayNumber(StartingDayOfWeek weekday) {
  return StartingDayOfWeek.values.indexOf(weekday) + 1;
}

/// Valid gestures.
enum AvailableGestures {
  /// No gestures.
  none,

  /// Up and down swipe.
  verticalSwipe,

  /// Horizontal swipe.
  horizontalSwipe,

  /// Swipe in all directions.
  all,
}

class _TableCalendar extends StatefulWidget {
  _TableCalendar({
    Key? key,
    required this.calendarController,
    this.locale,
    this.events = const {},
    this.holidays = const {},
    this.onDaySelected,
    this.onDayLongPressed,
    // ignore: unused_element
    this.onUnavailableDaySelected,
    // ignore: unused_element
    this.onUnavailableDayLongPressed,
    // ignore: unused_element
    this.onHeaderTapped,
    // ignore: unused_element
    this.onHeaderLongPressed,
    this.calendarContentBorder,
    this.onVisibleDaysChanged,
    this.onCalendarCreated,
    this.initialSelectedDay,
    // ignore: unused_element
    this.startDay,
    // ignore: unused_element
    this.endDay,
    this.expand = false,
    this.heightOfDayOfWeekLabel = 20,
    this.weekendDays = const [DateTime.saturday, DateTime.sunday],
    this.initialCalendarFormat = CalendarFormat.month,
    this.availableCalendarFormats = const {
      CalendarFormat.month: 'Month',
      CalendarFormat.twoWeeks: '2 weeks',
      CalendarFormat.week: 'Week',
    },
    // ignore: unused_element
    this.headerVisible = true,
    // ignore: unused_element
    this.enabledDayPredicate,
    // ignore: unused_element
    this.rowHeight,
    this.formatAnimation = FormatAnimation.slide,
    this.startingDayOfWeek = StartingDayOfWeek.sunday,
    // ignore: unused_element
    this.dayHitTestBehavior = HitTestBehavior.deferToChild,
    this.availableGestures = AvailableGestures.all,
    // ignore: unused_element
    this.simpleSwipeConfig = const SimpleSwipeConfig(
      verticalThreshold: 25.0,
      swipeDetectionBehavior: SwipeDetectionBehavior.continuousDistinct,
    ),
    this.calendarStyle = const CalendarStyle(),
    this.daysOfWeekStyle = const DaysOfWeekStyle(),
    this.headerStyle = const HeaderStyle(),
    this.builders = const CalendarBuilders(),
  })  : assert(availableCalendarFormats.keys.contains(initialCalendarFormat)),
        assert(availableCalendarFormats.length <= CalendarFormat.values.length),
        assert(
          weekendDays.isEmpty ||
              weekendDays.every(
                (day) => day >= DateTime.monday && day <= DateTime.sunday,
              ),
        ),
        super(key: key);

  final CalendarController calendarController;

  final dynamic locale;

  final Map<DateTime, List> events;

  final Map<DateTime, List> holidays;

  final OnDaySelected? onDaySelected;

  final OnDaySelected? onDayLongPressed;

  final VoidCallback? onUnavailableDaySelected;

  final VoidCallback? onUnavailableDayLongPressed;

  final HeaderGestureCallback? onHeaderTapped;

  final HeaderGestureCallback? onHeaderLongPressed;

  final OnVisibleDaysChanged? onVisibleDaysChanged;

  final OnCalendarCreated? onCalendarCreated;

  final DateTime? initialSelectedDay;

  final DateTime? startDay;

  final DateTime? endDay;

  final List<int> weekendDays;

  final CalendarFormat initialCalendarFormat;

  final Map<CalendarFormat, String> availableCalendarFormats;

  final bool headerVisible;

  final EnabledDayPredicate? enabledDayPredicate;

  final double? rowHeight;

  final FormatAnimation formatAnimation;

  final StartingDayOfWeek startingDayOfWeek;

  final HitTestBehavior dayHitTestBehavior;

  final AvailableGestures availableGestures;

  final SimpleSwipeConfig simpleSwipeConfig;

  final CalendarStyle calendarStyle;

  final DaysOfWeekStyle daysOfWeekStyle;

  final HeaderStyle headerStyle;

  final CalendarBuilders builders;

  final bool expand;

  final double heightOfDayOfWeekLabel;

  final TableBorder? calendarContentBorder;

  @override
  _TableCalendarState createState() => _TableCalendarState();
}

class _TableCalendarState extends State<_TableCalendar>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    widget.calendarController._init(
      events: widget.events,
      holidays: widget.holidays,
      initialDay: widget.initialSelectedDay,
      initialFormat: widget.initialCalendarFormat,
      availableCalendarFormats: widget.availableCalendarFormats,
      useNextCalendarFormat: widget.headerStyle.formatButtonShowsNext,
      startingDayOfWeek: widget.startingDayOfWeek,
      selectedDayCallback: _selectedDayCallback,
      onVisibleDaysChanged: widget.onVisibleDaysChanged,
      onCalendarCreated: widget.onCalendarCreated,
      includeInvisibleDays: widget.calendarStyle.outsideDaysVisible,
    );
  }

  @override
  void didUpdateWidget(_TableCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.events != widget.events) {
      widget.calendarController._events = widget.events;
    }

    if (oldWidget.holidays != widget.holidays) {
      widget.calendarController._holidays = widget.holidays;
    }

    if (oldWidget.availableCalendarFormats != widget.availableCalendarFormats) {
      widget.calendarController._availableCalendarFormats =
          widget.availableCalendarFormats;
    }
  }

  void _selectedDayCallback(DateTime day) {
    widget.onDaySelected?.call(
      day,
      widget.calendarController.visibleEvents[_getEventKey(day)] ?? [],
      widget.calendarController.visibleHolidays[_getHolidayKey(day)] ?? [],
    );
  }

  void _selectPrevious() {
    setState(() {
      widget.calendarController._selectPrevious();
    });
  }

  void _selectNext() {
    setState(() {
      widget.calendarController._selectNext();
    });
  }

  void _selectDay(DateTime day) {
    setState(() {
      widget.calendarController.setSelectedDay(day, isProgrammatic: false);
      _selectedDayCallback(day);
    });
  }

  void _onDayLongPressed(DateTime day) {
    widget.onDayLongPressed?.call(
      day,
      widget.calendarController.visibleEvents[_getEventKey(day)] ?? [],
      widget.calendarController.visibleHolidays[_getHolidayKey(day)] ?? [],
    );
  }

  void _toggleCalendarFormat() {
    setState(() {
      widget.calendarController.toggleCalendarFormat();
    });
  }

  void _onHorizontalSwipe(DismissDirection direction) {
    if (direction == DismissDirection.startToEnd) {
      // Swipe right
      _selectPrevious();
    } else {
      // Swipe left
      _selectNext();
    }
  }

  void _onUnavailableDaySelected() {
    widget.onUnavailableDaySelected?.call();
  }

  void _onUnavailableDayLongPressed() {
    widget.onUnavailableDayLongPressed?.call();
  }

  void _onHeaderTapped() {
    widget.onHeaderTapped?.call(widget.calendarController.focusedDay);
  }

  void _onHeaderLongPressed() {
    widget.onHeaderLongPressed?.call(widget.calendarController.focusedDay);
  }

  bool _isDayUnavailable(DateTime day) {
    return (widget.startDay != null &&
            day.isBefore(
              widget.calendarController._normalizeDate(widget.startDay!),
            )) ||
        (widget.endDay != null &&
            day.isAfter(
              widget.calendarController._normalizeDate(widget.endDay!),
            )) ||
        (!_isDayEnabled(day));
  }

  bool _isDayEnabled(DateTime day) {
    return widget.enabledDayPredicate?.call(day) ?? true;
  }

  DateTime? _getEventKey(DateTime day) {
    return widget.calendarController._getEventKey(day);
  }

  DateTime? _getHolidayKey(DateTime day) {
    return widget.calendarController._getHolidayKey(day);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.expand) {
      return Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          if (widget.headerVisible) _buildHeader(),
          Expanded(
            child: Padding(
              padding: widget.calendarStyle.contentPadding,
              child: _buildCalendarContent(),
            ),
          ),
        ],
      );
    } else {
      return ClipRect(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (widget.headerVisible) _buildHeader(),
            Padding(
              padding: widget.calendarStyle.contentPadding,
              child: _buildCalendarContent(),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildHeader() {
    final children = [
      if (widget.headerStyle.showLeftChevron)
        _CustomIconButton(
          icon: widget.headerStyle.leftChevronIcon,
          onTap: _selectPrevious,
          margin: widget.headerStyle.leftChevronMargin,
          padding: widget.headerStyle.leftChevronPadding,
        )
      else
        Container(),
      Expanded(
        child: GestureDetector(
          onTap: _onHeaderTapped,
          onLongPress: _onHeaderLongPressed,
          child: Text(
            widget.headerStyle.titleTextBuilder?.call(
                  widget.calendarController.focusedDay,
                  widget.locale,
                ) ??
                DateFormat.yMMMM(widget.locale)
                    .format(widget.calendarController.focusedDay),
            style: widget.headerStyle.titleTextStyle,
            textAlign: widget.headerStyle.centerHeaderTitle
                ? TextAlign.center
                : TextAlign.start,
          ),
        ),
      ),
      if (widget.headerStyle.showRightChevron)
        _CustomIconButton(
          icon: widget.headerStyle.rightChevronIcon,
          onTap: _selectNext,
          margin: widget.headerStyle.rightChevronMargin,
          padding: widget.headerStyle.rightChevronPadding,
        )
      else
        Container()
    ];

    if (widget.headerStyle.formatButtonVisible &&
        widget.availableCalendarFormats.length > 1) {
      children.insert(2, const SizedBox(width: 8.0));
      children.insert(3, _buildFormatButton());
    }

    return Container(
      decoration: widget.headerStyle.decoration,
      margin: widget.headerStyle.headerMargin,
      padding: widget.headerStyle.headerPadding,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: children,
      ),
    );
  }

  Widget _buildFormatButton() {
    return GestureDetector(
      onTap: _toggleCalendarFormat,
      child: Container(
        decoration: widget.headerStyle.formatButtonDecoration,
        padding: widget.headerStyle.formatButtonPadding,
        child: Text(
          widget.calendarController._getFormatButtonText(),
          style: widget.headerStyle.formatButtonTextStyle,
        ),
      ),
    );
  }

  Widget _buildCalendarContent() {
    if (widget.formatAnimation == FormatAnimation.slide) {
      return AnimatedSize(
        duration: Duration(
          milliseconds:
              widget.calendarController.calendarFormat == CalendarFormat.month
                  ? 330
                  : 220,
        ),
        curve: Curves.fastOutSlowIn,
        alignment: const Alignment(0, -1),
        child: _buildWrapper(),
      );
    } else {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        transitionBuilder: (child, animation) {
          return SizeTransition(
            sizeFactor: animation,
            child: ScaleTransition(
              scale: animation,
              child: child,
            ),
          );
        },
        child: _buildWrapper(
          key: ValueKey(widget.calendarController.calendarFormat),
        ),
      );
    }
  }

  Widget _buildWrapper({Key? key}) {
    Widget wrappedChild = _buildTable();

    switch (widget.availableGestures) {
      case AvailableGestures.all:
        wrappedChild = _buildVerticalSwipeWrapper(
          child: _buildHorizontalSwipeWrapper(
            child: wrappedChild,
          ),
        );
        break;
      case AvailableGestures.verticalSwipe:
        wrappedChild = _buildVerticalSwipeWrapper(
          child: wrappedChild,
        );
        break;
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

  Widget _buildVerticalSwipeWrapper({required Widget child}) {
    return SimpleGestureDetector(
      child: child,
      onVerticalSwipe: (direction) {
        setState(() {
          widget.calendarController
              .swipeCalendarFormat(isSwipeUp: direction == SwipeDirection.up);
        });
      },
      swipeConfig: widget.simpleSwipeConfig,
    );
  }

  Widget _buildHorizontalSwipeWrapper({required Widget child}) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      switchInCurve: Curves.decelerate,
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(widget.calendarController._dx, 0),
            end: const Offset(0, 0),
          ).animate(animation),
          child: child,
        );
      },
      layoutBuilder: (currentChild, _) => currentChild ?? const Empty(),
      child: Dismissible(
        key: ValueKey(widget.calendarController._pageId),
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
          if (widget.calendarStyle.renderDaysOfWeek) _buildDaysOfWeek(),
        ];

        int x = 0;
        while (x < widget.calendarController._visibleDays.value.length) {
          children.add(
            _buildTableRow(
              widget.calendarController._visibleDays.value
                  .skip(x)
                  .take(daysInWeek)
                  .toList(),
              constraints,
            ),
          );
          x += daysInWeek;
        }

        return Table(
          defaultColumnWidth: const FractionColumnWidth(1.0 / daysInWeek),
          children: children,
          border: widget.calendarContentBorder,
        );
      },
    );
  }

  TableRow _buildDaysOfWeek() {
    return TableRow(
      decoration: widget.daysOfWeekStyle.decoration,
      children:
          widget.calendarController._visibleDays.value.take(7).map((date) {
        final weekdayString =
            widget.daysOfWeekStyle.dowTextBuilder?.call(date, widget.locale) ??
                DateFormat.E(widget.locale).format(date);
        final isWeekend =
            widget.calendarController._isWeekend(date, widget.weekendDays);

        if (isWeekend && widget.builders.dowWeekendBuilder != null) {
          return widget.builders.dowWeekendBuilder!
              .call(context, weekdayString);
        }
        if (widget.builders.dowWeekdayBuilder != null) {
          return widget.builders.dowWeekdayBuilder!
              .call(context, weekdayString);
        }
        return Container(
          height: widget.heightOfDayOfWeekLabel,
          alignment: Alignment.center,
          child: Text(
            weekdayString,
            style: isWeekend
                ? widget.daysOfWeekStyle.weekendStyle
                : widget.daysOfWeekStyle.weekdayStyle,
          ),
        );
      }).toList(),
    );
  }

  TableRow _buildTableRow(List<DateTime> days, BoxConstraints constraints) {
    return TableRow(
      decoration: widget.calendarStyle.contentDecoration,
      children: days.map((date) => _buildTableCell(date, constraints)).toList(),
    );
  }

  // TableCell will have equal width and height
  Widget _buildTableCell(DateTime date, BoxConstraints constraints) {
    if (widget.expand) {
      final double height =
          (constraints.maxHeight - widget.heightOfDayOfWeekLabel) /
              (widget.calendarController._visibleDays.value.length / 7.0)
                  .ceilToDouble();
      return LayoutBuilder(
        builder: (context, constraints) => ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: widget.rowHeight ?? height,
            minHeight: widget.rowHeight ?? height,
          ),
          child: _buildCell(date),
        ),
      );
    } else {
      return LayoutBuilder(
        builder: (context, constraints) => ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: widget.rowHeight ?? constraints.maxWidth,
            minHeight: widget.rowHeight ?? constraints.maxWidth,
          ),
          child: _buildCell(date),
        ),
      );
    }
  }

  Widget _buildCell(DateTime date) {
    if (!widget.calendarStyle.outsideDaysVisible &&
        widget.calendarController._isExtraDay(date) &&
        widget.calendarController.calendarFormat == CalendarFormat.month) {
      return Container();
    }

    Widget content = _buildCellContent(date);

    final eventKey = _getEventKey(date);
    final holidayKey = _getHolidayKey(date);
    final key = eventKey ?? holidayKey;

    if (key != null) {
      final children = <Widget>[content];
      final events = widget.calendarController.visibleEvents[eventKey] ?? [];
      final holidays =
          widget.calendarController.visibleHolidays[holidayKey] ?? [];

      if (!_isDayUnavailable(date)) {
        if (widget.builders.markersBuilder != null) {
          children.addAll(
            widget.builders.markersBuilder!.call(
              context,
              key,
              events,
              holidays,
            ),
          );
        } else {
          children.add(
            Positioned(
              top: widget.calendarStyle.markersPositionTop,
              bottom: widget.calendarStyle.markersPositionBottom,
              left: widget.calendarStyle.markersPositionLeft,
              right: widget.calendarStyle.markersPositionRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: events
                    .take(widget.calendarStyle.markersMaxAmount)
                    .map((event) => _buildMarker(eventKey, event))
                    .toList(),
              ),
            ),
          );
        }
      }

      if (children.length > 1) {
        content = Stack(
          alignment: widget.calendarStyle.markersAlignment,
          children: children,
          clipBehavior: widget.calendarStyle.canEventMarkersOverflow
              ? Clip.none
              : Clip.hardEdge,
        );
      }
    }

    return GestureDetector(
      behavior: widget.dayHitTestBehavior,
      onTap: () => _isDayUnavailable(date)
          ? _onUnavailableDaySelected()
          : _selectDay(date),
      onLongPress: () => _isDayUnavailable(date)
          ? _onUnavailableDayLongPressed()
          : _onDayLongPressed(date),
      child: content,
    );
  }

  Widget _buildCellContent(DateTime date) {
    final eventKey = _getEventKey(date);

    final tIsUnavailable = _isDayUnavailable(date);
    final tIsSelected = widget.calendarController.isSelected(date);
    final tIsToday = widget.calendarController.isToday(date);
    final tIsOutside = widget.calendarController._isExtraDay(date);
    final tIsHoliday = widget.calendarController.visibleHolidays
        .containsKey(_getHolidayKey(date));
    final tIsWeekend =
        widget.calendarController._isWeekend(date, widget.weekendDays);
    final tIsEventDay =
        widget.calendarController.visibleEvents.containsKey(eventKey);

    final isUnavailable =
        widget.builders.unavailableDayBuilder != null && tIsUnavailable;
    final isSelected =
        widget.builders.selectedDayBuilder != null && tIsSelected;
    final isToday = widget.builders.todayDayBuilder != null && tIsToday;
    final isOutsideHoliday = widget.builders.outsideHolidayDayBuilder != null &&
        tIsOutside &&
        tIsHoliday;
    final isHoliday =
        widget.builders.holidayDayBuilder != null && !tIsOutside && tIsHoliday;
    final isOutsideWeekend = widget.builders.outsideWeekendDayBuilder != null &&
        tIsOutside &&
        tIsWeekend &&
        !tIsHoliday;
    final isOutside = widget.builders.outsideDayBuilder != null &&
        tIsOutside &&
        !tIsWeekend &&
        !tIsHoliday;
    final isWeekend = widget.builders.weekendDayBuilder != null &&
        !tIsOutside &&
        tIsWeekend &&
        !tIsHoliday;

    if (isUnavailable) {
      return widget.builders.unavailableDayBuilder!.call(
        context,
        date,
        widget.calendarController.visibleEvents[eventKey] ?? [],
      );
    } else if (isSelected && widget.calendarStyle.renderSelectedFirst) {
      return widget.builders.selectedDayBuilder!.call(
        context,
        date,
        widget.calendarController.visibleEvents[eventKey] ?? [],
      );
    } else if (isToday) {
      return widget.builders.todayDayBuilder!.call(
        context,
        date,
        widget.calendarController.visibleEvents[eventKey] ?? [],
      );
    } else if (isSelected) {
      return widget.builders.selectedDayBuilder!.call(
        context,
        date,
        widget.calendarController.visibleEvents[eventKey] ?? [],
      );
    } else if (isOutsideHoliday) {
      return widget.builders.outsideHolidayDayBuilder!.call(
        context,
        date,
        widget.calendarController.visibleEvents[eventKey] ?? [],
      );
    } else if (isHoliday) {
      return widget.builders.holidayDayBuilder!.call(
        context,
        date,
        widget.calendarController.visibleEvents[eventKey] ?? [],
      );
    } else if (isOutsideWeekend) {
      return widget.builders.outsideWeekendDayBuilder!.call(
        context,
        date,
        widget.calendarController.visibleEvents[eventKey] ?? [],
      );
    } else if (isOutside) {
      return widget.builders.outsideDayBuilder!.call(
        context,
        date,
        widget.calendarController.visibleEvents[eventKey] ?? [],
      );
    } else if (isWeekend) {
      return widget.builders.weekendDayBuilder!.call(
        context,
        date,
        widget.calendarController.visibleEvents[eventKey] ?? [],
      );
    } else if (widget.builders.dayBuilder != null) {
      return widget.builders.dayBuilder!.call(
        context,
        date,
        widget.calendarController.visibleEvents[eventKey] ?? [],
      );
    } else {
      return _CellWidget(
        text: '${date.day}',
        isUnavailable: tIsUnavailable,
        isSelected: tIsSelected,
        isToday: tIsToday,
        isWeekend: tIsWeekend,
        isOutsideMonth: tIsOutside,
        isHoliday: tIsHoliday,
        isEventDay: tIsEventDay,
        calendarStyle: widget.calendarStyle,
      );
    }
  }

  Widget _buildMarker(DateTime? date, dynamic event) {
    if (widget.builders.singleMarkerBuilder != null) {
      return widget.builders.singleMarkerBuilder!.call(context, date, event);
    } else {
      return Container(
        width: 8.0,
        height: 8.0,
        margin: const EdgeInsets.symmetric(horizontal: 0.3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.calendarStyle.markersColor,
        ),
      );
    }
  }
}
