part of masamune;

// ignore: subtype_of_sealed_class
/// Provider to provide [NavigatorController].
/// [NavigatorController]を提供するためのプロバイダーです。
///
/// Returns the same [NavigatorController] if it is within the scope of that page.
/// そのページの範囲内であれば同じ[NavigatorController]を返します。
///
/// You can change the initial route of [NavigatorController] by giving the provider an `initialRoute` at watch time. In this case, [NavigatorController] will return a different object.
/// プロバイダーをwatch時に`initialRoute`を与えることで[NavigatorController]の初期ルートを変更できます。その場合[NavigatorController]は別オブジェクトが返されます。
///
///
/// ```dart
/// fianl navigationControllerProvider = NavigatorControllerProvider();
///
/// class TestPage extends PageScopedWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref){
///     final navigatorController = ref.watch(navigationControllerProvider("/home"));
///   }
/// }
/// ```
class NavigatorControllerProvider
    extends AutoDisposeChangeNotifierProviderFamily<NavigatorController,
        String?> {
  NavigatorControllerProvider()
      : super((ref, initialRoute) => NavigatorController(initialRoute));

  /// Obtains a unique [NavigatorController] within the page.
  /// ページ内で一意な[NavigatorController]を取得します。
  ///
  /// You can change the initial route of [NavigatorController] by giving the provider an [initialRoute]. In this case, [NavigatorController] will return a different object.
  /// [initialRoute]を与えることで[NavigatorController]の初期ルートを変更できます。その場合[NavigatorController]は別オブジェクトが返されます。
  @override
  AutoDisposeChangeNotifierProvider<NavigatorController> call([
    // ignore: avoid_renaming_method_parameters
    String? initialRoute,
  ]) {
    return super.call(initialRoute);
  }
}
