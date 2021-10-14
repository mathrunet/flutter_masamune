part of masamune_calendar;

class UIScheduleCalendar extends StatefulWidget {
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
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;
  final String startTimeKey;
  final String endTimeKey;
  final String titleKey;
  final String textKey;
  final TextStyle? dayTextStyle;
  final List<DynamicMap> source;
  final String allDayKey;
  final double labelWidth;
  final Widget? Function(BuildContext context, DynamicMap item) builder;

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
