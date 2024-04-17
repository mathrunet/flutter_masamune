part of 'value.dart';

/// Provides an extension method for [PageOrWidgetScopedValueRef] to update the widget.
///
/// ウィジェットの更新を行うための[PageOrWidgetScopedValueRef]用の拡張メソッドを提供します。
extension RefRefreshExtensions on PageOrWidgetScopedValueRef {
  @Deprecated(
    "You will no longer be able to use [refresh] in widget scope. Please use [ref.refresh] instead and limit its use to page scope only. Widgetスコープでの[refresh]の利用はできなくなります。代わりに[ref.refresh]を利用し、ページスコープのみでの利用に限定してください。Widgetスコープでの利用はできません。",
  )
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
  /// When executed, it redraws the associated widget.
  ///
  /// 実行すると関連するウィジェットの再描画を行ないます。
  void refresh() {
    // ignore: invalid_use_of_protected_member
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
