part of '/masamune_calendar.dart';

/// A calendar delegate that specifies a builder to generate widgets according to the event data.
///
/// Specify a builder in [builder] that generates widgets according to the event data.
///
/// Builders can be specified according to conditions using [selectedBuilder], [todayBuilder], [outsideBuilder], etc.
///
/// イベントのデータに応じたウィジェットを生成するビルダーを指定するカレンダーデリゲートです。
///
/// [builder]にイベントのデータに応じたウィジェットを生成するビルダーを指定します。
///
/// [selectedBuilder]や[todayBuilder]、[outsideBuilder]などで条件に応じてビルダーを指定することができます。
class BuilderCalendarDelegate<T> extends CalendarDelegate<T> {
  /// A calendar delegate that specifies a builder to generate widgets according to the event data.
  ///
  /// Specify a builder in [builder] that generates widgets according to the event data.
  ///
  /// Builders can be specified according to conditions using [selectedBuilder], [todayBuilder], [outsideBuilder], etc.
  ///
  /// イベントのデータに応じたウィジェットを生成するビルダーを指定するカレンダーデリゲートです。
  ///
  /// [builder]にイベントのデータに応じたウィジェットを生成するビルダーを指定します。
  ///
  /// [selectedBuilder]や[todayBuilder]、[outsideBuilder]などで条件に応じてビルダーを指定することができます。
  const BuilderCalendarDelegate({
    required this.builder,
    this.outsideBuilder,
    this.selectedBuilder,
    this.todayBuilder,
  });

  /// Builder for displaying events.
  ///
  /// イベントを表示するためのビルダー。
  final Widget? Function(
    BuildContext context,
    CalendarStyle style,
    DateTime date,
    List<CalendarEventItem<T>> events,
  ) builder;

  /// Builder to display events for selected dates.
  ///
  /// If this is [Null], [builder] is used.
  ///
  /// 選択された日付のイベントを表示するためのビルダー。
  ///
  /// これが[Null]の場合は[builder]が利用されます。
  final Widget? Function(
    BuildContext context,
    CalendarStyle style,
    DateTime date,
    List<CalendarEventItem<T>> events,
  )? selectedBuilder;

  /// Builder to display today's events.
  ///
  /// If this is [Null], [builder] is used.
  ///
  /// 本日のイベントを表示するためのビルダー。
  ///
  /// これが[Null]の場合は[builder]が利用されます。
  final Widget? Function(
    BuildContext context,
    CalendarStyle style,
    DateTime date,
    List<CalendarEventItem<T>> events,
  )? todayBuilder;

  /// Builder to show events outside the range for that month.
  ///
  /// If this is [Null], [builder] is used.
  ///
  /// その月の範囲外のイベントを表示するためのビルダー。
  ///
  /// これが[Null]の場合は[builder]が利用されます。
  final Widget? Function(
    BuildContext context,
    CalendarStyle style,
    DateTime date,
    List<CalendarEventItem<T>> events,
  )? outsideBuilder;

  @override
  Widget? buildEvents(
    BuildContext context,
    CalendarStyle style,
    DateTime date,
    List<CalendarEventItem<T>> events,
  ) {
    return builder.call(
      context,
      style,
      date,
      events,
    );
  }

  @override
  Widget? buildSelectedEvents(
    BuildContext context,
    CalendarStyle style,
    DateTime date,
    List<CalendarEventItem<T>> events,
  ) {
    return selectedBuilder?.call(
          context,
          style,
          date,
          events,
        ) ??
        builder.call(
          context,
          style,
          date,
          events,
        );
  }

  @override
  Widget? buildTodayEvents(
    BuildContext context,
    CalendarStyle style,
    DateTime date,
    List<CalendarEventItem<T>> events,
  ) {
    return todayBuilder?.call(
          context,
          style,
          date,
          events,
        ) ??
        builder.call(
          context,
          style,
          date,
          events,
        );
  }

  @override
  Widget? buildOutsideEvents(
    BuildContext context,
    CalendarStyle style,
    DateTime date,
    List<CalendarEventItem<T>> events,
  ) {
    return outsideBuilder?.call(
          context,
          style,
          date,
          events,
        ) ??
        builder.call(
          context,
          style,
          date,
          events,
        );
  }
}
