part of masamune;

/// Provides extended methods for [WidgetRef].
/// [WidgetRef]用の拡張メソッドを提供します。
extension WidgetRefTimerExtensions on WidgetRef {
  /// Create a timer to execute [callback] for each [duration].
  /// [duration]ごとに[callback]を実行するタイマーを作成します。
  ///
  /// The created timer will be canceled if the page is destroyed.
  /// 作成されたタイマーはページが破棄された場合キャンセルされます。
  Timer periodic(
    void Function(DateTime dateTime) callback, {
    Duration duration = const Duration(seconds: 1),
  }) {
    return valueBuilder<Timer, _TimerValue>(
      key: "_\$\$periodic:${duration.inMicroseconds}",
      builder: () {
        return _TimerValue(
          duration: duration,
          callback: callback,
        );
      },
    );
  }

  /// Create a timer that executes a process for each [duration] and executes the value [VoidCallback] each time a key ([DateTime]) in [schedule] elapses.
  /// [duration]ごとに処理を実行し、[schedule]内のキー（[DateTime]）を経過するごとに値[VoidCallback]が実行されるタイマーを作成します。
  ///
  /// Once [VoidCallback] is executed after [DateTime] has elapsed, it will not be executed again.
  /// 一度[DateTime]を経過して実行された[VoidCallback]は再度実行されません。
  Timer schedule(
    Map<DateTime, VoidCallback> schedule, {
    Duration duration = const Duration(seconds: 1),
  }) {
    return valueBuilder<Timer, _ScheduleValue>(
      key: "_\$\$schedule:${duration.inMicroseconds}",
      builder: () {
        return _ScheduleValue(
          duration: duration,
          schedule: schedule,
        );
      },
    );
  }

  @Deprecated(
    "It will not be available from the next version. Use [WidgetRef.periodic] instead.",
  )
  Timer useTimer(
    void Function(DateTime dateTime) callback, {
    Duration duration = const Duration(seconds: 1),
  }) {
    return valueBuilder<Timer, _TimerValue>(
      key: "_\$\$periodic:${duration.inMicroseconds}",
      builder: () {
        return _TimerValue(
          duration: duration,
          callback: callback,
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
