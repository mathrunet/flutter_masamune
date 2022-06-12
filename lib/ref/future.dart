part of masamune;

extension WidgetRefFutureExtensions on WidgetRef {
  FutureValue<T> useFuture<T>(
    String key,
    Future<T> Function() callback,
  ) {
    return valueBuilder<FutureValue<T>, _FutureValue<T>>(
      key: "future:$key",
      builder: () {
        return _FutureValue<T>(callback);
      },
    );
  }
}

@immutable
class _FutureValue<T> extends ScopedValue<FutureValue<T>> {
  const _FutureValue(this.callback);

  final Future<T> Function() callback;
  @override
  ScopedValueState<FutureValue<T>, ScopedValue<FutureValue<T>>> createState() =>
      _FutureValueState<T>();
}

class _FutureValueState<T>
    extends ScopedValueState<FutureValue<T>, _FutureValue<T>> {
  FutureValue<T> _value = FutureValue<T>();
  @override
  Future<void> initValue() async {
    super.initValue();
    _value = FutureValue<T>(state: ConnectionState.active);
    final future = value.callback.call();
    _value = FutureValue<T>(state: ConnectionState.waiting);
    final val = await future;
    _value = FutureValue<T>(value: val, state: ConnectionState.done);
  }

  @override
  FutureValue<T> build() => _value;
}

class FutureValue<T> {
  FutureValue({
    this.value,
    this.state = ConnectionState.none,
  });
  final T? value;
  final ConnectionState state;
}
