part of masamune;

extension WidgetRefMemoizedExtensions on WidgetRef {
  T useMemoized<T>(
    String key,
    T Function() callback, {
    List<Object?>? keys,
  }) {
    return valueBuilder<T, _MemoizedValue<T>>(
      key: "memoized:$key",
      builder: () {
        return _MemoizedValue<T>(
          callback: callback,
          keys: keys,
        );
      },
    );
  }
}

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
