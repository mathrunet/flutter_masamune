part of masamune;

extension WidgetRefWakelockExtensions on WidgetRef {
  void useWakelock() {
    valueBuilder<void, _WakelockValue>(
      key: "wakelock",
      builder: () {
        return const _WakelockValue();
      },
    );
  }
}

class _WakelockValue extends ScopedValue<void> {
  const _WakelockValue();
  @override
  ScopedValueState<void, ScopedValue<void>> createState() =>
      _WakelockValueState();
}

class _WakelockValueState extends ScopedValueState<void, _WakelockValue> {
  @override
  void initValue() {
    super.initValue();
    Wakelock.enable();
  }

  @override
  void build() {}

  @override
  void dispose() {
    Wakelock.disable();
    super.dispose();
  }
}
