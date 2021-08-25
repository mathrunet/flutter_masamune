part of masamune_calendar;

class UIDayCalendar extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final day = DateTime(this.day?.year ?? now.year,
        this.day?.month ?? now.month, this.day?.day ?? now.day);
    final eventMap = <DateTime, List<DynamicMap>>{};
    source.forEach((item) {
      if (item.get(allDayKey, false) || !item.containsKey(endTimeKey)) {
        return;
      }
      final startTime = item.getAsDateTime(startTimeKey);
      if (eventMap.containsKey(startTime)) {
        eventMap[startTime]?.add(item);
      } else {
        eventMap[startTime] = [item];
      }
    });
    final events = eventMap.toList((key, value) {
      if (value.length > 1) {
        final startTime = value.first.getAsDateTime(startTimeKey);
        final start = startTime.difference(day);
        return Positioned(
          left: labelWidth + 8,
          right: 8,
          top: start.inMinutes * height / 60,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: value.mapAndRemoveEmpty((item) {
              final endTime = item.getAsDateTime(endTimeKey);
              final duration = endTime.difference(startTime);
              final widget = builder.call(context, item);
              if (widget == null) {
                return const Empty();
              }
              return Expanded(
                flex: 1,
                child: SizedBox(
                  height: (height * duration.inMinutes / 60) + 1,
                  child: widget,
                ),
              );
            }),
          ),
        );
      } else {
        final item = value.first;
        final startTime = item.getAsDateTime(startTimeKey);
        final endTime = item.getAsDateTime(endTimeKey);
        final duration = endTime.difference(startTime);
        final start = startTime.difference(day);
        final widget = builder.call(context, item);
        if (widget == null) {
          return const Empty();
        }
        return Positioned(
          left: labelWidth + 8,
          right: 8,
          top: start.inMinutes * height / 60,
          child: SizedBox(
            height: (height * duration.inMinutes / 60) + 1,
            child: widget,
          ),
        );
      }
    });

    final allDay = source.mapAndRemoveEmpty((item) {
      if (item.get(allDayKey, false) || !item.containsKey(endTimeKey)) {
        final widget = builder.call(context, item);
        if (widget == null) {
          return null;
        }
        return widget;
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
                      width: labelWidth + 8,
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
                            children: allDay)),
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
                          height: (height - 8).limitLow(0),
                        ),
                        for (var i = 1; i <= 11; i++)
                          SizedBox(
                            height: height,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                SizedBox(
                                  width: labelWidth,
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
                            height: height,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                SizedBox(
                                  width: labelWidth,
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
              left: labelWidth + 8,
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
