part of katana_router_annotation;

/// Annotation to define the `RouteQuery` of the page.
/// ページの`RouteQuery`を定義するためのアノテーション。
///
/// Be sure to define it in the `static const` field.
/// 必ず`static const`のフィールドに定義してください。
///
/// By doing so, pages with annotations are defined in the routing object for all pages defined in [AppRoute].
/// こうすることにより[AppRoute]で定義した全ページのルーティングオブジェクトにアノテーションを付与したページが定義されます。
///
/// ```dart
/// @PagePath("/test")
/// class Test extends StatelessWidget {
///   const Test();
///
///   @pageRouteQuery
///   static const query = _$Test;
///
///   @override
///   Widget build(BuildContext context){
///     //~~~~
///   }
/// }
/// ```
const pageRouteQuery = PageRouteQuery();

/// Annotation to define the `RouteQuery` of the page.
/// ページの`RouteQuery`を定義するためのアノテーション。
///
/// Be sure to define it in the `static const` field.
/// 必ず`static const`のフィールドに定義してください。
///
/// By doing so, pages with annotations are defined in the routing object for all pages defined in [AppRoute].
/// こうすることにより[AppRoute]で定義した全ページのルーティングオブジェクトにアノテーションを付与したページが定義されます。
///
/// ```dart
/// @PagePath("/test")
/// class Test extends StatelessWidget {
///   const Test();
///
///   @pageRouteQuery
///   static const query = _$Test;
///
///   @override
///   Widget build(BuildContext context){
///     //~~~~
///   }
/// }
/// ```
class PageRouteQuery {
  /// Annotation to define the `RouteQuery` of the page.
  /// ページの`RouteQuery`を定義するためのアノテーション。
  ///
  /// Be sure to define it in the `static const` field.
  /// 必ず`static const`のフィールドに定義してください。
  ///
  /// By doing so, pages with annotations are defined in the routing object for all pages defined in [AppRoute].
  /// こうすることにより[AppRoute]で定義した全ページのルーティングオブジェクトにアノテーションを付与したページが定義されます。
  ///
  /// ```dart
  /// @PagePath("/test")
  /// class Test extends StatelessWidget {
  ///   const Test();
  ///
  ///   @pageRouteQuery
  ///   static const query = _$Test;
  ///
  ///   @override
  ///   Widget build(BuildContext context){
  ///     //~~~~
  ///   }
  /// }
  /// ```
  const PageRouteQuery();
}
