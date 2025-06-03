part of "/katana_router_annotation.dart";

/// Annotation to define the `RouteQuery` of the page.
///
/// Be sure to define it in the `static const` field.
///
/// By doing so, pages with annotations are defined in the routing object for all pages defined in [AppRoute].
///
/// ページの`RouteQuery`を定義するためのアノテーション。
///
/// 必ず`static const`のフィールドに定義してください。
///
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
///
/// Be sure to define it in the `static const` field.
///
/// By doing so, pages with annotations are defined in the routing object for all pages defined in [AppRoute].
///
/// ページの`RouteQuery`を定義するためのアノテーション。
///
/// 必ず`static const`のフィールドに定義してください。
///
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
  ///
  /// Be sure to define it in the `static const` field.
  ///
  /// By doing so, pages with annotations are defined in the routing object for all pages defined in [AppRoute].
  ///
  /// ページの`RouteQuery`を定義するためのアノテーション。
  ///
  /// 必ず`static const`のフィールドに定義してください。
  ///
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
