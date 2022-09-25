part of masamune;

/// Provides extended methods for [WidgetRef].
/// [WidgetRef]用の拡張メソッドを提供します。
extension WidgetRefOnExtensions on WidgetRef {
  /// You can describe a process that will be executed only once when the widget is first displayed ([initOrUpdate]), just before it is destroyed ([deactivate]), or after it is disposed ([disposed]).
  /// Widgetの初回表示時([initOrUpdate])、破棄直前（[deactivate]）、破棄後（[disposed]）のタイミングで1度のみ実行される処理を記述することができます。
  ///
  /// If [keys] is specified and the content of the specified [keys] is changed after the first time, [initOrUpdate] will be executed again.
  /// また[keys]を指定し、初回以降指定した[keys]の内容を変更した場合、[initOrUpdate]が再度実行されます。
  void on({
    VoidCallback? initOrUpdate,
    VoidCallback? disposed,
    VoidCallback? deactivate,
    List<Object?>? keys,
  }) {
    return valueBuilder<void, _EffectValue>(
      key: r"_$$effect",
      builder: () {
        return _EffectValue(
          onInitOrUpdate: initOrUpdate,
          onDeactivate: disposed,
          onDispose: deactivate,
          keys: keys,
        );
      },
    );
  }

  @Deprecated(
    "It will not be available from the next version. Use [WidgetRef.on] instead.",
  )
  void effect({
    VoidCallback? onInitOrUpdate,
    VoidCallback? onDispose,
    VoidCallback? onDeactivate,
    List<Object?>? keys,
  }) {
    return valueBuilder<void, _EffectValue>(
      key: r"_$$effect",
      builder: () {
        return _EffectValue(
          onInitOrUpdate: onInitOrUpdate,
          onDeactivate: onDeactivate,
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
    required this.onDeactivate,
    required this.keys,
  });
  final VoidCallback? onInitOrUpdate;
  final VoidCallback? onDispose;
  final VoidCallback? onDeactivate;
  final List<Object?>? keys;
  @override
  ScopedValueState<void, ScopedValue<void>> createState() =>
      _EffectValueState();
}

class _EffectValueState extends ScopedValueState<void, _EffectValue> {
  @override
  void initValue() {
    super.initValue();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      value.onInitOrUpdate?.call();
    });
  }

  @override
  void didUpdateValue(_EffectValue oldValue) {
    super.didUpdateValue(oldValue);
    if (!equalsKeys(value.keys, oldValue.keys)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        value.onInitOrUpdate?.call();
      });
    }
  }

  @override
  void deactivate() {
    value.onDeactivate?.call();
    super.deactivate();
  }

  @override
  void dispose() {
    value.onDispose?.call();
    super.dispose();
  }

  @override
  void build() {}
}
