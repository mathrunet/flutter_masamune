part of katana_scoped;

/// ScopedWidget related extensions for [BuildContext].
///
/// [BuildContext]用のScopedWidget関連のエクステンション。
extension ScopedWidgetBuildContextExtensions on BuildContext {
  /// O(1) out [TWidget] in ancestor by passing [BuildContext].
  ///
  /// If [TWidget] does not exist in the ancestor, an error is output.
  ///
  /// [BuildContext]を渡して祖先にある[TWidget]をO(1)で取り出します。
  ///
  /// 祖先に[TWidget]が存在しない場合はエラーが出力されます。
  TWidget ancestor<TWidget extends ScopedWidgetBase>() {
    return ScopedWidgetScope.of(this);
  }
}
