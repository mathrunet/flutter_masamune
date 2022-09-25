part of masamune;

@deprecated
extension WidgetRefMemoizedExtensions on WidgetRef {
  @Deprecated(
    "It will not be available from the next version. Instead, please write a process to save the value to [ValueNotifierProvider] or the like in the [ref.on] method.",
  )
  T cache<T>(
    T Function() callback, {
    String hookId = "",
    List<Object?>? keys,
  }) {
    return valueBuilder<T, _MemoizedValue<T>>(
      key: "cache:$hookId",
      builder: () {
        return _MemoizedValue<T>(
          callback: callback,
          keys: keys,
        );
      },
    );
  }
}

@deprecated
@immutable
class _MemoizedValue<T> extends ScopedValue<T> {
  const _MemoizedValue({
    required this.callback,
    required this.keys,
  });
  final T Function() callback;
  final List<Object?>? keys;
  @override
  ScopedValueState<T, ScopedValue<T>> createState() => _MemoizedValueState<T>();
}

@deprecated
class _MemoizedValueState<T> extends ScopedValueState<T, _MemoizedValue<T>> {
  late T _value;

  @override
  void initValue() {
    super.initValue();
    _value = value.callback.call();
  }

  @override
  void didUpdateValue(_MemoizedValue<T> oldValue) {
    super.didUpdateValue(oldValue);
    if (!equalsKeys(value.keys, oldValue.keys)) {
      _value = value.callback.call();
    }
  }

  @override
  T build() => _value;
}
