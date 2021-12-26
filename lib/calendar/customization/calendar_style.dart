part of masamune_calendar;

class CalendarStyle {
  const CalendarStyle({
    this.contentDecoration = const BoxDecoration(),
    this.weekdayStyle = const TextStyle(),
    this.weekendStyle =
        const TextStyle(color: Color(0xFFF44336)), // Material red[500]
    this.holidayStyle =
        const TextStyle(color: Color(0xFFF44336)), // Material red[500]
    this.selectedStyle = const TextStyle(
        color: Color(0xFFFAFAFA), fontSize: 16.0), // Material grey[50]
    this.todayStyle = const TextStyle(
        color: Color(0xFFFAFAFA), fontSize: 16.0), // Material grey[50]
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

  final BoxDecoration contentDecoration;

  final TextStyle weekdayStyle;

  final TextStyle weekendStyle;

  final TextStyle holidayStyle;

  final TextStyle selectedStyle;

  final TextStyle todayStyle;

  final TextStyle outsideStyle;

  final TextStyle outsideWeekendStyle;

  final TextStyle outsideHolidayStyle;

  final TextStyle unavailableStyle;

  final TextStyle eventDayStyle;

  final Color selectedColor;

  final Color todayColor;

  final Color markersColor;

  final Alignment markersAlignment;

  final double? markersPositionTop;

  final double markersPositionBottom;

  final double? markersPositionLeft;

  final double? markersPositionRight;

  final int markersMaxAmount;

  final bool outsideDaysVisible;

  final bool renderSelectedFirst;

  final bool renderDaysOfWeek;

  final EdgeInsetsGeometry contentPadding;

  final EdgeInsetsGeometry cellMargin;

  final bool canEventMarkersOverflow;

  final bool highlightSelected;

  final bool highlightToday;
}
