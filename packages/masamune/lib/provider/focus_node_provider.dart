part of masamune;

// ignore: subtype_of_sealed_class
/// Provider to provide [FocusNode].
/// [FocusNode]を提供するためのプロバイダーです。
///
/// Returns the same [FocusNode] if it is within the range of that page.
/// そのページの範囲内であれば同じ[FocusNode]を返します。
///
/// It is possible to focus the provider automatically by setting `autoFocus` to `true` at the time of watch.
/// プロバイダーをwatch時に`autoFocus`を`true`にすることで自動的にフォーカスすることが可能です。
///
/// ```dart
/// fianl focusNodeProvider = FocusNodeProvider();
///
/// class TestPage extends PageScopedWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref){
///     final focusNode = ref.watch(focusNodeProvider(true)); // Auto focus
///   }
/// }
/// ```
class FocusNodeProvider
    extends AutoDisposeChangeNotifierProviderFamily<FocusNode, bool> {
  FocusNodeProvider()
      : super((ref, autoFocus) {
          final focusNode = FocusNode();
          if (autoFocus) {
            focusNode.requestFocus();
          }
          return focusNode;
        });

  /// Get a unique [FocusNode] within the page.
  /// ページ内で一意な[FocusNode]を取得します。
  ///
  /// You can set [autoFocus] to `true` to automatically focus.
  /// [autoFocus]を`true`にすることで自動的にフォーカスすることが可能です。
  @override
  AutoDisposeChangeNotifierProvider<FocusNode> call([
    // ignore: avoid_renaming_method_parameters
    bool? autoFocus,
  ]) {
    return super.call(autoFocus ?? false);
  }
}
