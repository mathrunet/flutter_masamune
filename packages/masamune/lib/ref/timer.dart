part of masamune;

extension WidgetRefTimerExtensions on WidgetRef {
  Timer useTimer(
    void Function(DateTime dateTime) callback, {
    Duration duration = const Duration(seconds: 1),
  }) {
    return valueBuilder<Timer, _TimerValue>(
      key: "timer:${duration.inMicroseconds}",
      builder: () {
        return _TimerValue(
          duration: duration,
          callback: callback,
        );
      },
    );
  }

  Timer schedule(
    Map<DateTime, VoidCallback> schedule, {
    Duration duration = const Duration(seconds: 1),
  }) {
    return valueBuilder<Timer, _ScheduleValue>(
      key: "schedule:${duration.inMicroseconds}",
      builder: () {
        return _ScheduleValue(
          duration: duration,
          schedule: schedule,
        );
      },
    );
  }
}

@immutable
class _TimerValue extends ScopedValue<Timer> {
  const _TimerValue({
    required this.duration,
    required this.callback,
  });
  final Duration duration;
  final void Function(DateTime dateTime) callback;
  @override
  ScopedValueState<Timer, ScopedValue<Timer>> createState() =>
      _TimerValueState();
}

class _TimerValueState extends ScopedValueState<Timer, _TimerValue> {
  late final Timer _timer;
  @override
  void initValue() {
    super.initValue();
    _timer = Timer.periodic(value.duration, (timer) {
      value.callback.call(DateTime.now());
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Timer build() => _timer;
}

@immutable
class _ScheduleValue extends ScopedValue<Timer> {
  const _ScheduleValue({
    required this.duration,
    required this.schedule,
  });
  final Duration duration;
  final Map<DateTime, VoidCallback> schedule;
  @override
  ScopedValueState<Timer, ScopedValue<Timer>> createState() =>
      _ScheduleValueState();
}

class _ScheduleValueState extends ScopedValueState<Timer, _ScheduleValue> {
  late final Timer _timer;
  late final List<DateTime> _keys;

  @override
  void initValue() {
    super.initValue();
    _keys = List<DateTime>.from(value.schedule.keys).sortTo(
      (a, b) => a.millisecondsSinceEpoch - b.millisecondsSinceEpoch,
    );
    _timer = Timer.periodic(value.duration, (timer) {
      final dateTimeMilliSeconds = DateTime.now().millisecondsSinceEpoch;
      _keys.removeWhere((key) {
        if (key.millisecondsSinceEpoch < dateTimeMilliSeconds ||
            key.millisecondsSinceEpoch >=
                dateTimeMilliSeconds + value.duration.inMilliseconds) {
          return false;
        }
        value.schedule[key]?.call();
        return true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Timer build() => _timer;
}
