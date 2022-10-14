part of katana_router_annotation;

/// Automatically generates routing for the entire application.
/// アプリケーション全体のルーティングを自動生成します。
///
/// By adding this annotation to the global field as shown in the example below, all pages defined with @PagePath will be automatically defined and routable in the application.
/// 下記の例のようにグローバルのフィールドにこのアノテーションを付与することでアプリケーション内で@PagePathを付与して定義されたすべてのページが自動的に定義されルーティングが可能になります。
///
/// ```dart
/// @appRoute
/// final appRouter = _$AppRouter();
///
/// void main(){
///   runApp(
///     MaterialApp.router(
///       routerConfig: appRouter,
///       title: "Application",
///     );
///   );
/// }
/// ```
const appRoute = AppRoute();

/// Automatically generates routing for the entire application.
/// アプリケーション全体のルーティングを自動生成します。
///
/// By adding this annotation to the global field as shown in the example below, all pages defined with @PagePath will be automatically defined and routable in the application.
/// 下記の例のようにグローバルのフィールドにこのアノテーションを付与することでアプリケーション内で@PagePathを付与して定義されたすべてのページが自動的に定義されルーティングが可能になります。
///
/// ```dart
/// @appRoute
/// final appRouter = _$AppRouter();
///
/// void main(){
///   runApp(
///     MaterialApp.router(
///       routerConfig: appRouter,
///       title: "Application",
///     );
///   );
/// }
/// ```
class AppRoute {
  /// Automatically generates routing for the entire application.
  /// アプリケーション全体のルーティングを自動生成します。
  ///
  /// By adding this annotation to the global field as shown in the example below, all pages defined with @PagePath will be automatically defined and routable in the application.
  /// 下記の例のようにグローバルのフィールドにこのアノテーションを付与することでアプリケーション内で@PagePathを付与して定義されたすべてのページが自動的に定義されルーティングが可能になります。
  ///
  /// ```dart
  /// @appRoute
  /// final appRouter = _$AppRouter();
  ///
  /// void main(){
  ///   runApp(
  ///     MaterialApp.router(
  ///       routerConfig: appRouter,
  ///       title: "Application",
  ///     );
  ///   );
  /// }
  /// ```
  const AppRoute();
}
