part of masamune;

/// Provides extended methods for [WidgetRef].
/// [WidgetRef]用の拡張メソッドを提供します。
extension WidgetRefFutureExtensions on WidgetRef {
  /// You can write a process to wait for Future to take the value of [T].
  /// Futureを待って[T]の値を取るための処理を書くことができます。
  ///
  /// Please describe the process in [callback].
  /// [callback]にその処理を記載してください。
  ///
  /// The widget is rebuilt again when the [callback] process is complete.
  /// [callback]の処理が完了したときに再度ウィジェットがリビルドされます。
  ///
  /// If you change the contents of [keys], the process will be executed again.
  /// [keys]の中身を変更すると再度処理が実行されます。
  FutureValue<T> future<T>(
    Future<T> Function() callback, {
    List<Object> keys = const [],
  }) {
    return valueBuilder<FutureValue<T>, _FutureValue<T>>(
      key: "future:${keys.join()}",
      builder: () {
        return _FutureValue<T>(callback);
      },
    );
  }

  @Deprecated(
    "It will not be available from the next version. Use [future] instead.",
  )
  FutureValue<T> useFuture<T>(
    Future<T> Function() callback, {
    String hookId = "",
  }) {
    return valueBuilder<FutureValue<T>, _FutureValue<T>>(
      key: "future:$hookId",
      builder: () {
        return _FutureValue<T>(callback);
      },
    );
  }
}

@deprecated
@immutable
class _FutureValue<T> extends ScopedValue<FutureValue<T>> {
  const _FutureValue(this.callback);

  final Future<T> Function() callback;
  @override
  ScopedValueState<FutureValue<T>, ScopedValue<FutureValue<T>>> createState() =>
      _FutureValueState<T>();
}

@deprecated
class _FutureValueState<T>
    extends ScopedValueState<FutureValue<T>, _FutureValue<T>> {
  FutureValue<T> _value = FutureValue<T>();
  @override
  Future<void> initValue() async {
    super.initValue();
    _value = FutureValue<T>(state: ConnectionState.active);
    final future = value.callback.call();
    _value = FutureValue<T>(state: ConnectionState.waiting, future: future);
    final val = await future;
    _value =
        FutureValue<T>(value: val, state: ConnectionState.done, future: future);
  }

  @override
  FutureValue<T> build() => _value;
}

class FutureValue<T> {
  FutureValue({
    this.value,
    this.future,
    this.state = ConnectionState.none,
  });
  final T? value;
  final Future<T>? future;
  final ConnectionState state;
}
