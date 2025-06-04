part of "value.dart";

/// Provides an extended method for [PageOrWidgetScopedValueRef] to monitor [Future].
///
/// [Future]の監視を行うための[PageOrWidgetScopedValueRef]用の拡張メソッドを提供します。
extension PageOrWidgetScopedValueRefFutureExtensions
    on PageOrWidgetScopedValueRef {
  /// You can pass a [callback] that returns [Future] and wait for it.
  ///
  /// When [FutureContext] is returned and [Future] finishes, the screen is redrawn.
  ///
  /// If [keys] is different from the previous value, [callback] is executed again and the new [FutureContext] is saved.
  ///
  /// If [name] is specified, it is saved as a separate type. If [keys] is changed, the previous state is discarded, but if [name] is changed, it is kept as a separate state.
  ///
  /// [Future]を返す[callback]を渡すとそれを待つことができます。
  ///
  /// [FutureContext]が返され[Future]が終了すると画面を再描画します。
  ///
  /// [keys]が前の値と違う場合再度[callback]が実行され、新しい[FutureContext]が保存されます。
  ///
  /// [name]を指定すると別のタイプとして保存されます。[keys]を変えた場合は以前の状態は破棄されますが、[name]を変えた場合は別々の状態として保持されます。
  FutureContext<T> future<T>(
    FutureOr<T> Function() callback, {
    List<Object> keys = const [],
    Object? name,
  }) {
    return getScopedValue<FutureContext<T>, _FutureValue<T>>(
      (ref) => _FutureValue<T>(
        callback: callback,
        keys: keys,
      ),
      listen: true,
      name: name,
    );
  }
}

@immutable
class _FutureValue<T> extends ScopedValue<FutureContext<T>> {
  const _FutureValue({
    required this.callback,
    required this.keys,
  }) : super();

  final FutureOr<T> Function() callback;
  final List<Object> keys;

  @override
  ScopedValueState<FutureContext<T>, _FutureValue<T>> createState() =>
      _FutureValueState<T>();
}

class _FutureValueState<T>
    extends ScopedValueState<FutureContext<T>, _FutureValue<T>> {
  _FutureValueState();
  final FutureContext<T> _context = FutureContext._();

  @override
  bool get autoDisposeWhenUnreferenced => true;

  @override
  void initValue() {
    super.initValue();
    _initOrUpdate(false);
  }

  Future<void> _initOrUpdate(bool updated) async {
    _context._completer = Completer();
    final futureOr = value.callback();
    if (futureOr is Future) {
      _context._value = await futureOr;
      _context._completer?.complete();
      _context._completer = null;
      setState(() {});
    } else {
      _context._value = futureOr;
      _context._completer?.complete();
      _context._completer = null;
      if (updated) {
        setState(() {});
      }
    }
  }

  @override
  void didUpdateValue(covariant _FutureValue<T> oldValue) {
    super.didUpdateValue(oldValue);
    if (!equalsKeys(value.keys, oldValue.keys)) {
      _context._value = null;
      _initOrUpdate(true);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _context._completer?.complete();
    _context._completer = null;
  }

  @override
  FutureContext<T> build() => _context;
}

/// Object returned when [future] is executed.
///
/// The end of [Future] can be monitored by [waiting].
///
/// You can also check if it is finished by pressing [done].
///
/// The value retrieved from [Future] can be obtained at [value].
///
/// [future]を実行する際に返されるオブジェクト。
///
/// [Future]の終了を[waiting]で監視することができます。
///
/// また、終了したかどうかを[done]で確認することができます。
///
/// [Future]から取得された値は[value]で取得できます。
class FutureContext<T> {
  FutureContext._();
  Completer<void>? _completer;

  /// The value retrieved from [Future].
  ///
  /// [Future]から取得された値。
  T? get value => _value;
  T? _value;

  /// [Future] to monitor the end of the `future` when it is executed.
  ///
  /// `future`を実行したときにその終了を監視するための[Future]。
  Future<void>? get waiting => _completer?.future;

  /// Return `true` if `future` is executed and terminated.
  ///
  /// `future`を実行したときに終了した場合`true`を返す。
  bool get done => _completer == null;
}
