part of masamune_calendar;

/// Calendar on an event basis.
///
/// This is used to display a list of the most recent events.
@immutable
class UIScheduleCalendar extends StatefulWidget {
  /// Calendar on an event basis.
  ///
  /// This is used to display a list of the most recent events.
  const UIScheduleCalendar({
    required this.source,
    required this.builder,
    this.startTimeKey = "startTime",
    this.endTimeKey = "endTime",
    this.titleKey = "name",
    this.textKey = "text",
    this.allDayKey = "allDay",
    this.labelWidth = 56,
    this.padding,
    this.dayTextStyle,
    this.physics,
    this.shrinkWrap = false,
  });

  /// [ScrollPhysics] for lists.
  final ScrollPhysics? physics;

  /// [shrinkWrap] for lists.
  final bool shrinkWrap;

  /// Padding.
  final EdgeInsetsGeometry? padding;

  /// Key for event start time.
  final String startTimeKey;

  /// Key for event end time.
  final String endTimeKey;

  /// The name key.
  final String titleKey;

  /// The text key.
  final String textKey;

  /// True if the event is all day.
  final String allDayKey;

  /// Date text style.
  final TextStyle? dayTextStyle;

  /// Calendar event data source.
  final List<DynamicMap> source;

  /// Label width.
  final double labelWidth;

  /// Builder for events.
  final Widget? Function(BuildContext context, DynamicMap item) builder;

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
  State<StatefulWidget> createState() => _UIScheduleCalendarState();
}

class _UIScheduleCalendarState extends State<UIScheduleCalendar> {
  final List<Listenable> _listenableList = [];
  Listenable? _sourceListenable;

  @override
  void initState() {
    super.initState();
    if (widget.source is Listenable) {
      _sourceListenable = (widget.source as Listenable)
        ..addListener(_handledOnListUpdate);
    }
    _listenableList.addAll(widget.source.whereType<Listenable>());
    _listenableList.forEach((element) => element.addListener(_handledOnUpdate));
  }

  void _handledOnListUpdate() {
    _listenableList
        .forEach((element) => element.removeListener(_handledOnUpdate));
    _listenableList.clear();
    _listenableList.addAll(widget.source.whereType<Listenable>());
    _listenableList.forEach((element) => element.addListener(_handledOnUpdate));
    setState(() {});
  }

  void _handledOnUpdate() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _listenableList
        .forEach((element) => element.removeListener(_handledOnUpdate));
    _sourceListenable?.removeListener(_handledOnListUpdate);
  }

  @override
  void didUpdateWidget(UIScheduleCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.source != oldWidget.source) {
      _sourceListenable?.removeListener(_handledOnListUpdate);
      _listenableList
          .forEach((element) => element.removeListener(_handledOnUpdate));
      _listenableList.clear();
      if (widget.source is Listenable) {
        _sourceListenable = (widget.source as Listenable)
          ..addListener(_handledOnListUpdate);
      }
      _listenableList.addAll(widget.source.whereType<Listenable>());
      _listenableList
          .forEach((element) => element.addListener(_handledOnUpdate));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = <DateTime, List<DynamicMap>>{};
    for (final tmp in widget.source) {
      final start = tmp.getAsDateTime(widget.startTimeKey);
      final day = start.toDate();
      if (data.containsKey(day)) {
        data[day]!.add(tmp);
      } else {
        data[day] = [tmp];
      }
    }
    for (final val in data.values) {
      val.sort((a, b) =>
          a.get(widget.startTimeKey, 0) - b.get(widget.startTimeKey, 0));
    }
    final keys = List<DateTime>.from(data.keys);
    keys.sort((a, b) => a.compareTo(b));

    return ListBuilder<DateTime>(
      shrinkWrap: widget.shrinkWrap,
      physics: widget.physics,
      padding: widget.padding,
      source: keys,
      builder: (context, day, index) {
        final event = data[day];
        if (event == null) {
          return [];
        }

        return [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: widget.labelWidth + 8,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                  child: DefaultTextStyle(
                    style: widget.dayTextStyle ??
                        TextStyle(
                          color: context.theme.dividerColor,
                        ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          day.shortLocalizedWeekDay,
                          style: const TextStyle(fontSize: 12),
                        ),
                        Text(
                          day.day.toString(),
                          style: const TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: event.mapAndRemoveEmpty((item) {
                    return widget.builder.call(context, item);
                  }),
                ),
              ),
            ],
          )
        ];
      },
    );
  }
}
