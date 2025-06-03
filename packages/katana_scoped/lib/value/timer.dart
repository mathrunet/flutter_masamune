part of "value.dart";

/// Provides an extension method for [PageOrWidgetScopedValueRef] to process [Timer].
///
/// [Timer]の処理を行うための[PageOrWidgetScopedValueRef]用の拡張メソッドを提供します。
extension PageOrWidgetScopedValueRefTimerExtensions
    on PageOrWidgetScopedValueRef {
  /// [callback] to be executed again after [duration].
  ///
  /// The start time and the current time [DateTime] are passed so that processing can be performed based on them.
  ///
  /// If [name] is specified, it can be registered as a separate task.
  ///
  /// [duration]後に再度実行される[callback]を実行します。
  ///
  /// 開始時刻と現在時刻の[DateTime]が渡されるのでそれを元に処理を行うことができます。
  ///
  /// [name]を指定すると別のタスクとして登録することができます。
  Timer? timer(
    FutureOr<void> Function(DateTime currentTime, DateTime startTime)
        callback, {
    required Duration duration,
    Object? name,
  }) {
    return getScopedValue<Timer?, _TimerValue>(
      (ref) => _TimerValue(
        callback: callback,
        duration: duration,
      ),
      listen: true,
      name: name,
    );
  }
}

/// Provides extended methods for [RefHasPage] to process [Timer].
///
/// [Timer]の処理を行うための[RefHasPage]用の拡張メソッドを提供します。
extension RefHasPageTimerExtensions on RefHasPage {
  @Deprecated(
    "It is no longer possible to use [timer] by directly specifying [PageRef] or [WidgetRef]. Instead, use [ref.page.timer] or [ref.widget.timer] to specify the scope. [PageRef]や[WidgetRef]を直接指定しての[timer]の利用はできなくなります。代わりに[ref.page.timer]や[ref.widget.timer]でスコープを指定しての利用を行ってください。",
  )
  Timer? timer(
    FutureOr<void> Function(DateTime currentTime, DateTime startTime)
        callback, {
    required Duration duration,
    Object? name,
  }) {
    return page.getScopedValue<Timer?, _TimerValue>(
      (ref) => _TimerValue(
        callback: callback,
        duration: duration,
      ),
      listen: true,
      name: name,
    );
  }
}

@immutable
class _TimerValue extends ScopedValue<Timer?> {
  const _TimerValue({
    required this.callback,
    required this.duration,
  });

  final Duration duration;
  final FutureOr<void> Function(DateTime currentTime, DateTime startTime)
      callback;

  @override
  ScopedValueState<Timer?, _TimerValue> createState() => _TimerValueState();
}

class _TimerValueState extends ScopedValueState<Timer?, _TimerValue> {
  _TimerValueState();
  Timer? _timer;
  DateTime? _startTime;

  @override
  bool get autoDisposeWhenUnreferenced => true;

  @override
  void initValue() {
    super.initValue();
    _update();
  }

  @override
  void didUpdateValue(_TimerValue oldValue) {
    super.didUpdateValue(oldValue);
    final now = DateTime.now();
    if (oldValue.duration != value.duration ||
        (_startTime != null && now.difference(_startTime!) >= value.duration)) {
      _update();
    }
  }

  void _update() {
    _timer?.cancel();
    _startTime = DateTime.now();
    _timer = Timer(value.duration, () {
      value.callback(DateTime.now(), _startTime ?? DateTime.now());
      _timer = null;
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Timer build() => _timer!;
}
