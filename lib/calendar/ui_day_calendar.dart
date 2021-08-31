part of masamune_calendar;

class UIDayCalendar extends StatefulWidget {
  const UIDayCalendar({
    required this.source,
    required this.builder,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.day,
    this.height = 36,
    this.labelWidth = 56,
    this.startTimeKey = "startTime",
    this.endTimeKey = "endTime",
    this.titleKey = "name",
    this.textKey = "text",
    this.titleBuilder,
    this.textBuilder,
    this.allDayKey = "allDay",
  });

  final DateTime? day;
  final EdgeInsetsGeometry padding;
  final String startTimeKey;
  final String endTimeKey;
  final String titleKey;
  final String textKey;
  final double height;
  final double labelWidth;
  final List<DynamicMap> source;
  final String allDayKey;
  final String Function(DynamicMap data)? titleBuilder;
  final String Function(DynamicMap data)? textBuilder;
  final Widget? Function(BuildContext context, DynamicMap item) builder;

  @override
  State<StatefulWidget> createState() => _UIDayCalendarState();
}

class _UIDayCalendarState extends State<UIDayCalendar> {
  final List<Listenable> _listenableList = [];
  Listenable? _sourceListenable;
  final now = DateTime.now();

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
  void didUpdateWidget(UIDayCalendar oldWidget) {
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
    final day = DateTime(widget.day?.year ?? now.year,
        widget.day?.month ?? now.month, widget.day?.day ?? now.day);
    final eventMap = <DateTime, List<DynamicMap>>{};
    widget.source.forEach((item) {
      if (item.get(widget.allDayKey, false) ||
          !item.containsKey(widget.endTimeKey)) {
        return;
      }
      final startTime = item.getAsDateTime(widget.startTimeKey);
      if (eventMap.containsKey(startTime)) {
        eventMap[startTime]?.add(item);
      } else {
        eventMap[startTime] = [item];
      }
    });
    final events = eventMap.toList((key, value) {
      if (value.length > 1) {
        final startTime = value.first.getAsDateTime(widget.startTimeKey);
        final start = startTime.difference(day);
        return Positioned(
          left: widget.labelWidth + 8,
          right: 8,
          top: start.inMinutes * widget.height / 60,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: value.mapAndRemoveEmpty((item) {
              final endTime = item.getAsDateTime(widget.endTimeKey);
              final duration = endTime.difference(startTime);
              final child = widget.builder.call(context, item);
              if (child == null) {
                return const Empty();
              }
              return Expanded(
                flex: 1,
                child: SizedBox(
                  height: (widget.height * duration.inMinutes / 60) + 1,
                  child: child,
                ),
              );
            }),
          ),
        );
      } else {
        final item = value.first;
        final startTime = item.getAsDateTime(widget.startTimeKey);
        final endTime = item.getAsDateTime(widget.endTimeKey);
        final duration = endTime.difference(startTime);
        final start = startTime.difference(day);
        final child = widget.builder.call(context, item);
        if (child == null) {
          return const Empty();
        }
        return Positioned(
          left: widget.labelWidth + 8,
          right: 8,
          top: start.inMinutes * widget.height / 60,
          child: SizedBox(
            height: (widget.height * duration.inMinutes / 60) + 1,
            child: child,
          ),
        );
      }
    });

    final allDay = widget.source.mapAndRemoveEmpty((item) {
      if (!item.containsKey(widget.endTimeKey)) {
        final startDate = item.getAsDateTime(widget.startTimeKey);
        if (startDate.day != day.day ||
            startDate.month != day.month ||
            startDate.year != day.year) {
          return null;
        }
        final child = widget.builder.call(context, item);
        if (child == null) {
          return null;
        }
        return child;
      } else if (item.get(widget.allDayKey, false)) {
        final startDate = item.getAsDateTime(widget.startTimeKey);
        final endDate = item.getAsDateTime(widget.endTimeKey);
        final start = DateTime(startDate.year, startDate.month, startDate.day);
        final end = DateTime(endDate.year, endDate.month, endDate.day)
            .add(const Duration(days: 1));
        if (start.millisecondsSinceEpoch > day.millisecondsSinceEpoch ||
            end.millisecondsSinceEpoch <= day.millisecondsSinceEpoch) {
          return null;
        }
        final child = widget.builder.call(context, item);
        if (child == null) {
          return null;
        }
        return child;
      }
      return null;
    });

    return UIScrollbar(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      width: widget.labelWidth + 8,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              day.shortLocalizedWeekDay,
                              style: TextStyle(
                                  color: context.theme.dividerColor,
                                  fontSize: 12),
                            ),
                            Text(
                              day.day.toString(),
                              style: TextStyle(
                                  color: context.theme.dividerColor,
                                  fontSize: 24),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: allDay,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints.expand(height: 1),
                  child: ColoredBox(
                    color: context.theme.dividerColor,
                  ),
                ),
                Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: (widget.height - 8).limitLow(0),
                        ),
                        for (var i = 1; i <= 11; i++)
                          SizedBox(
                            height: widget.height,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                SizedBox(
                                  width: widget.labelWidth,
                                  child: Text(
                                    "%s AM".localize().format([i]),
                                    style: TextStyle(
                                        color: context.theme.dividerColor),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints.expand(
                                          height: 1),
                                      child: ColoredBox(
                                        color: context.theme.dividerColor,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        for (var i = 0; i <= 11; i++)
                          SizedBox(
                            height: widget.height,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                SizedBox(
                                  width: widget.labelWidth,
                                  child: Text(
                                    "%s AM".localize().format([i]),
                                    style: TextStyle(
                                        color: context.theme.dividerColor),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints.expand(
                                          height: 1),
                                      child: ColoredBox(
                                        color: context.theme.dividerColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                    ...events,
                  ],
                ),
              ],
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: widget.labelWidth + 8,
              child: SizedBox(
                width: 1,
                child: ColoredBox(
                  color: context.theme.dividerColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
