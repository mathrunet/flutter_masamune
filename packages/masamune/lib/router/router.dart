part of "/masamune.dart";

/// Create an extension method for [PageScopedValueRef] to create nested routers.
///
/// ネストされたルーターを作成するための[PageScopedValueRef]の拡張メソッドを作成します。
extension MasamuneRouterPageScopedValueRefExtensions on PageScopedValueRef {
  /// Create nested routers by passing [pages].
  ///
  /// Pass to [Router.withConfig] to display nested pages.
  ///
  /// Multiple routers can be created by specifying [name].
  ///
  /// [pages]を渡すことによりネストされたルーターを作成します。
  ///
  /// [Router.withConfig]に渡してネストされたページを表示してください。
  ///
  /// [name]を指定することで複数のルーターを作成することが可能です。
  ///
  /// ```dart
  /// final router = ref.page.router(
  ///   initialQuery: HomePage.query(),
  ///   pages: [
  ///     HomePage.query,
  ///     ProfilePage.query,
  ///   ],
  /// );
  /// return Router.withConfig(router);
  /// ```
  NestedAppRouter router({
    required RouteQuery? initialQuery,
    required List<RouteQueryBuilder> pages,
    TransitionQuery? defaultTransitionQuery,
    Object? name,
    List<NavigatorObserver> observers = const [],
    List<LoggerAdapter> loggerAdapters = const [],
  }) {
    return watch(
      (ref) {
        return NestedAppRouter(
          initialQuery: initialQuery,
          pages: pages,
          defaultTransitionQuery: defaultTransitionQuery,
          observers: observers,
          loggerAdapters: loggerAdapters,
        );
      },
      name: name,
    );
  }

  /// Get the nested routers created in [router].
  ///
  /// It is possible to manipulate routing from inside the nested pages using the routers obtained.
  ///
  /// If the [router] was created with [name] specified, specify the [name] at the time of creation to obtain the data.
  ///
  /// Returns an error if [NestedAppRouter] does not exist.
  ///
  /// [router]で作成されたネストされたルーターを取得します。
  ///
  /// 取得したルーターを利用してネストされたページ内部からルーティングを操作することが可能です。
  ///
  /// [router]に[name]を指定して作成した場合は作成時の[name]を指定して取得してください。
  ///
  /// [NestedAppRouter]が存在しない場合はエラーを返します。
  NestedAppRouter nestedRouter({
    Object? name,
  }) {
    final router = fetch<NestedAppRouter>(name);
    return router;
  }
}
