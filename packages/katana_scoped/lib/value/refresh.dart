part of katana_scoped.value;

/// Provides an extension method for [PageOrWidgetScopedValueRef] to update the widget.
///
/// ウィジェットの更新を行うための[PageOrWidgetScopedValueRef]用の拡張メソッドを提供します。
extension RefRefreshExtensions on PageOrWidgetScopedValueRef {
  /// When executed, it redraws the associated widget.
  ///
  /// 実行すると関連するウィジェットの再描画を行ないます。
  void refresh() {
    return getScopedValue<void, _RefreshValue>(
      (ref) => const _RefreshValue(),
      listen: true,
    );
  }
}

@immutable
class _RefreshValue extends ScopedValue<void> {
  const _RefreshValue();

  @override
  ScopedValueState<void, ScopedValue<void>> createState() =>
      _RefreshValueState();
}

class _RefreshValueState extends ScopedValueState<void, _RefreshValue> {
  _RefreshValueState();

  @override
  void initValue() {
    super.initValue();
    setState(() {});
  }

  @override
  void didUpdateValue(_RefreshValue oldValue) {
    super.didUpdateValue(oldValue);
    setState(() {});
  }

  @override
  void build() {}
}
