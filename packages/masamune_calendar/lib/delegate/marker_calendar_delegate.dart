part of "/masamune_calendar.dart";

/// The design of the calendar is simply to display a marker in the center of the calendar on days that have events.
///
/// Specify the widget for the marker in [marker].
///
/// You can change the color and size of the marker by specifying [color], [size], [selectedColor], [todayColor], and [outsideColor].
///
/// イベントがある日に中央にマーカーを表示するだけのカレンダーのデザインです。
///
/// [marker]にマーカーのウィジェットを指定します。
///
/// [color]や[size]、[selectedColor]、[todayColor]、[outsideColor]を指定することで、マーカーの色やサイズを変更できます。
class MarkerCalendarDelegate<T> extends CalendarDelegate<T> {
  /// The design of the calendar is simply to display a marker in the center of the calendar on days that have events.
  ///
  /// Specify the widget for the marker in [marker].
  ///
  /// You can change the color and size of the marker by specifying [color], [size], [selectedColor], [todayColor], and [outsideColor].
  ///
  /// イベントがある日に中央にマーカーを表示するだけのカレンダーのデザインです。
  ///
  /// [marker]にマーカーのウィジェットを指定します。
  ///
  /// [color]や[size]、[selectedColor]、[todayColor]、[outsideColor]を指定することで、マーカーの色やサイズを変更できます。
  const MarkerCalendarDelegate({
    this.marker,
    this.color,
    this.size,
    this.selectedColor,
    this.todayColor,
    this.outsideColor,
  });

  /// Marker widget to be displayed in the center.
  ///
  /// 中央に表示するマーカーのウィジェット。
  final Widget? marker;

  /// Marker color.
  ///
  /// マーカーの色。
  final Color? color;

  /// Selected color of the marker.
  ///
  /// マーカーの選択された色。
  final Color? selectedColor;

  /// Today's color of the marker.
  ///
  /// マーカーの本日の色。
  final Color? todayColor;

  /// Marker icon size.
  ///
  /// マーカーアイコンのサイズ。
  final double? size;

  /// The color of markers outside the display range of the month.
  ///
  /// 月の表示範囲外のマーカーの色。
  final Color? outsideColor;

  @override
  Widget? buildEvents(
    BuildContext context,
    CalendarStyle style,
    DateTime date,
    List<CalendarEventItem<T>> events,
  ) {
    if (events.isEmpty) {
      return null;
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: IconTheme(
            data: IconThemeData(
              size: size ??
                  (min(constraints.maxHeight, constraints.maxWidth) / 2),
              color: color ??
                  style.content.eventColor ??
                  Theme.of(context).colorScheme.primary,
            ),
            child: marker ?? const Icon(Icons.check_circle),
          ),
        );
      },
    );
  }

  @override
  Widget? buildSelectedEvents(
    BuildContext context,
    CalendarStyle style,
    DateTime date,
    List<CalendarEventItem<T>> events,
  ) {
    if (events.isEmpty) {
      return null;
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: IconTheme(
            data: IconThemeData(
              size: size ??
                  (min(constraints.maxHeight, constraints.maxWidth) / 2),
              color: selectedColor ??
                  style.content.selectedEventColor ??
                  Theme.of(context).colorScheme.onPrimary,
            ),
            child: marker ?? const Icon(Icons.check_circle),
          ),
        );
      },
    );
  }

  @override
  Widget? buildTodayEvents(
    BuildContext context,
    CalendarStyle style,
    DateTime date,
    List<CalendarEventItem<T>> events,
  ) {
    if (events.isEmpty) {
      return null;
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: IconTheme(
            data: IconThemeData(
              size: size ??
                  (min(constraints.maxHeight, constraints.maxWidth) / 2),
              color: todayColor ??
                  style.content.todayEventColor ??
                  Theme.of(context).colorScheme.onPrimary,
            ),
            child: marker ?? const Icon(Icons.check_circle),
          ),
        );
      },
    );
  }

  @override
  Widget? buildOutsideEvents(
    BuildContext context,
    CalendarStyle style,
    DateTime date,
    List<CalendarEventItem<T>> events,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: IconTheme(
            data: IconThemeData(
              size: size ??
                  (min(constraints.maxHeight, constraints.maxWidth) / 2),
              color: outsideColor ??
                  style.content.outsideEventColor ??
                  Theme.of(context).disabledColor,
            ),
            child: marker ?? const Icon(Icons.check_circle),
          ),
        );
      },
    );
  }
}
