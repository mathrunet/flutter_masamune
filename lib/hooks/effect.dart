part of masamune;

extension WidgetRefEffectExtensions on WidgetRef {
  void effect({
    VoidCallback? onInitOrUpdate,
    VoidCallback? onDispose,
    List<Object?>? keys,
  }) {
    return valueBuilder<void, _EffectValue>(
      key: "effect",
      builder: () {
        return _EffectValue(
          onInitOrUpdate: onInitOrUpdate,
          onDispose: onDispose,
          keys: keys,
        );
      },
    );
  }
}

@immutable
class _EffectValue extends ScopedValue<void> {
  const _EffectValue({
    required this.onInitOrUpdate,
    required this.onDispose,
    required this.keys,
  });
  final VoidCallback? onInitOrUpdate;
  final VoidCallback? onDispose;
  final List<Object?>? keys;
  @override
  ScopedValueState<void, ScopedValue<void>> createState() =>
      _EffectValueState();
}

class _EffectValueState extends ScopedValueState<void, _EffectValue> {
  @override
  void initValue() {
    super.initValue();
    value.onInitOrUpdate?.call();
  }

  @override
  void didUpdateValue(_EffectValue oldValue) {
    super.didUpdateValue(oldValue);
    if (!equalsKeys(value.keys, oldValue.keys)) {
      value.onInitOrUpdate?.call();
    }
  }

  @override
  void dispose() {
    value.onDispose?.call();
    super.dispose();
  }

  @override
  void build() {}
}
