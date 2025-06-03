part of "value.dart";

/// Provides an extension method for [PageOrWidgetScopedValueRef] to update the widget.
///
/// ウィジェットの更新を行うための[PageOrWidgetScopedValueRef]用の拡張メソッドを提供します。
extension PageOrWidgetScopedValueRefRefreshExtensions
    on PageOrWidgetScopedValueRef {
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

/// Provides an extension method for [RefHasPage] to update the widget.
///
/// ウィジェットの更新を行うための[RefHasPage]用の拡張メソッドを提供します。
extension RefHasPageRefreshExtensions on RefHasPage {
  @Deprecated(
    "It is no longer possible to use [refresh] by directly specifying [PageRef] or [WidgetRef]. Instead, use [ref.page.refresh] or [ref.widget.refresh] to specify the scope. [PageRef]や[WidgetRef]を直接指定しての[refresh]の利用はできなくなります。代わりに[ref.page.refresh]や[ref.widget.refresh]でスコープを指定しての利用を行ってください。",
  )
  void refresh() {
    return page.getScopedValue<void, _RefreshValue>(
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
