part of masamune_calendar;

/// Style class for calendar.
@immutable
class CalendarStyle {
  /// Style class for calendar.
  const CalendarStyle({
    this.contentDecoration = const BoxDecoration(),
    this.weekdayStyle = const TextStyle(),
    this.weekendStyle =
        const TextStyle(color: Color(0xFFF44336)), // Material red[500]
    this.holidayStyle =
        const TextStyle(color: Color(0xFFF44336)), // Material red[500]
    this.selectedStyle = const TextStyle(
      color: Color(0xFFFAFAFA),
      fontSize: 16.0,
    ), // Material grey[50]
    this.todayStyle = const TextStyle(
      color: Color(0xFFFAFAFA),
      fontSize: 16.0,
    ), // Material grey[50]
    this.outsideStyle =
        const TextStyle(color: Color(0xFF9E9E9E)), // Material grey[500]
    this.outsideWeekendStyle =
        const TextStyle(color: Color(0xFFEF9A9A)), // Material red[200]
    this.outsideHolidayStyle =
        const TextStyle(color: Color(0xFFEF9A9A)), // Material red[200]
    this.unavailableStyle = const TextStyle(color: Color(0xFFBFBFBF)),
    this.eventDayStyle = const TextStyle(),
    this.selectedColor = const Color(0xFF5C6BC0), // Material indigo[400]
    this.todayColor = const Color(0xFF9FA8DA), // Material indigo[200]
    this.markersColor = const Color(0xFF263238), // Material blueGrey[900]
    this.markersAlignment = Alignment.bottomCenter,
    this.markersPositionTop,
    this.markersPositionBottom = 5.0,
    this.markersPositionLeft,
    this.markersPositionRight,
    this.markersMaxAmount = 4,
    this.outsideDaysVisible = true,
    this.renderSelectedFirst = true,
    this.renderDaysOfWeek = true,
    this.contentPadding =
        const EdgeInsets.only(bottom: 4.0, left: 8.0, right: 8.0),
    this.cellMargin = const EdgeInsets.all(6.0),
    this.canEventMarkersOverflow = false,
    this.highlightSelected = true,
    this.highlightToday = true,
  });

  /// Content Decoration.
  final BoxDecoration contentDecoration;

  /// Text style for days of the week.
  final TextStyle weekdayStyle;

  /// Text style for days of the week (weekends)
  final TextStyle weekendStyle;

  /// Text style for holidays.
  final TextStyle holidayStyle;

  /// Text style for the selected day.
  final TextStyle selectedStyle;

  /// Text style of the day.
  final TextStyle todayStyle;

  /// Text style for days not in that month.
  final TextStyle outsideStyle;

  /// Weekend texting style for days not in that month.
  final TextStyle outsideWeekendStyle;

  /// Text style for holidays on days not in that month.
  final TextStyle outsideHolidayStyle;

  /// Text style for unavailable days.
  final TextStyle unavailableStyle;

  /// Event day text style.
  final TextStyle eventDayStyle;

  /// The color, if selected.
  final Color selectedColor;

  /// Color of the today.
  final Color todayColor;

  /// Marker color.
  final Color markersColor;

  /// Marker placement.
  final Alignment markersAlignment;

  /// Marker position (from top)
  final double? markersPositionTop;

  /// Marker position (from bottom)
  final double markersPositionBottom;

  /// Marker positions (from left)
  final double? markersPositionLeft;

  /// Marker position (from right)
  final double? markersPositionRight;

  /// Maximum number of markers to display.
  final int markersMaxAmount;

  /// `True` if you want to show days that are not in the month.
  final bool outsideDaysVisible;

  /// `True` if you want to show the first selected day.
  final bool renderSelectedFirst;

  /// If you want to display the day of the week, use `True`.
  final bool renderDaysOfWeek;

  /// Content padding.
  final EdgeInsetsGeometry contentPadding;

  /// The margin of each cell.
  final EdgeInsetsGeometry cellMargin;

  /// `True` if you want to show the event marker out of the way.
  final bool canEventMarkersOverflow;

  /// If you want to highlight the selected day `True`.
  final bool highlightSelected;

  /// If you want to highlight today, use `True`.
  final bool highlightToday;
}
