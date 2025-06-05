part of "value.dart";

/// Provides an extension method for [PageOrWidgetScopedValueRef] to perform scheduling.
///
/// スケジュール処理を行うための[PageOrWidgetScopedValueRef]用の拡張メソッドを提供します。
extension PageOrWidgetScopedValueRefScheduleExtensions
    on PageOrWidgetScopedValueRef {
  /// [callback] executed on [dateTime].
  ///
  /// The start time and the current time [DateTime] are passed to [callback], which can then be used for processing.
  ///
  /// If [name] is specified, it can be registered as a separate task.
  ///
  /// [dateTime]に実行される[callback]を実行します。
  ///
  /// [callback]に開始時刻と現在時刻の[DateTime]が渡されるのでそれを元に処理を行うことができます。
  ///
  /// [name]を指定すると別のタスクとして登録することができます。
  ScheduleContext schedule(
    FutureOr<void> Function(DateTime currentTime, DateTime startTime)
        callback, {
    required DateTime dateTime,
    Object? name,
  }) {
    return getScopedValue<ScheduleContext, _ScheduleValue>(
      (ref) => _ScheduleValue(
        callback: callback,
        dateTime: dateTime,
      ),
      listen: true,
      name: "$name#${dateTime.toIso8601String()}",
    );
  }
}

@immutable
class _ScheduleValue extends ScopedValue<ScheduleContext> {
  const _ScheduleValue({
    required this.callback,
    required this.dateTime,
  });

  final DateTime dateTime;
  final FutureOr<void> Function(DateTime currentTime, DateTime startTime)
      callback;

  @override
  ScopedValueState<ScheduleContext, _ScheduleValue> createState() =>
      _ScheduleValueState();
}

class _ScheduleValueState
    extends ScopedValueState<ScheduleContext, _ScheduleValue> {
  _ScheduleValueState();
  final ScheduleContext _context = ScheduleContext._();
  late DateTime _startTime;
  Timer? _timer;

  @override
  bool get autoDisposeWhenUnreferenced => true;

  @override
  void initValue() {
    super.initValue();
    _init();
  }

  Future<void> _init() async {
    _context._completer = Completer();
    _startTime = Clock.now();
    if (value.dateTime.isAfter(_startTime)) {
      _timer = Timer(
        value.dateTime.difference(_startTime),
        () {
          _timer = null;
          _context._completer?.complete();
          _context._completer = null;
          value.callback(Clock.now(), _startTime);
          setState(() {});
        },
      );
    } else {
      await Future.delayed(Duration.zero);
      _context._completer?.complete();
      _context._completer = null;
      value.callback(_startTime, _startTime);
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    _context._completer?.complete();
    _context._completer = null;
    _timer?.cancel();
    _timer = null;
  }

  @override
  ScheduleContext build() => _context;
}

/// Object returned when [schedule] is executed.
///
/// The end of the schedule can be monitored by [waiting].
///
/// You can also check if it is finished by pressing [done].
///
/// [schedule]を実行する際に返されるオブジェクト。
///
/// スケジュールの終了を[waiting]で監視することができます。
///
/// また、終了したかどうかを[done]で確認することができます。
class ScheduleContext {
  ScheduleContext._();
  Completer<void>? _completer;

  /// [Future] to monitor the end of the `schedule` when it is executed.
  ///
  /// `schedule`を実行したときにその終了を監視するための[Future]。
  Future<void>? get waiting => _completer?.future;

  /// Return `true` if `schedule` is executed and terminated.
  ///
  /// `schedule`を実行したときに終了した場合`true`を返す。
  bool get done => _completer == null;
}
