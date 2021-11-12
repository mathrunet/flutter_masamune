part of masamune;

extension WidgetRefValueNotifierExtensions on WidgetRef {
  ValueNotifier<T> useValueNotifier<T>(String key, T defaultValue) {
    return valueBuilder<ValueNotifier<T>, _ValueNotifierValue<T>>(
      key: "valueNotifier:$key",
      builder: () {
        return _ValueNotifierValue<T>(defaultValue);
      },
    );
  }
}

class _ValueNotifierValue<T> extends ScopedValue<ValueNotifier<T>> {
  const _ValueNotifierValue(this.initialValue);
  final T initialValue;
  @override
  ScopedValueState<ValueNotifier<T>, ScopedValue<ValueNotifier<T>>>
      createState() => _ValueNotifierValueState<T>();
}

class _ValueNotifierValueState<T>
    extends ScopedValueState<ValueNotifier<T>, _ValueNotifierValue<T>> {
  late ValueNotifier<T> _valueNotifier;

  @override
  void initValue() {
    super.initValue();
    _valueNotifier = ValueNotifier<T>(value.initialValue);
    _valueNotifier.addListener(_handledOnUpdate);
  }

  @override
  void didUpdateValue(_ValueNotifierValue<T> oldValue) {
    super.didUpdateValue(oldValue);
    if (value.initialValue != oldValue.initialValue) {
      _valueNotifier.value = value.initialValue;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _valueNotifier.removeListener(_handledOnUpdate);
    _valueNotifier.dispose();
  }

  @override
  ValueNotifier<T> build() => _valueNotifier;

  void _handledOnUpdate() {
    setState(() {});
  }
}
