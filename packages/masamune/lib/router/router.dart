part of masamune;

/// Create an extension method for [RefHasPage] to create nested routers.
///
/// ネストされたルーターを作成するための[RefHasPage]の拡張メソッドを作成します。
extension MasamuneModelAppRefExtensions on RefHasPage {
  /// Create nested routers by passing [pages].
  ///
  /// Pass to [Router.withConfig] to display nested pages.
  ///
  /// [pages]を渡すことによりネストされたルーターを作成します。
  ///
  /// [Router.withConfig]に渡してネストされたページを表示してください。
  ///
  /// ```dart
  /// final router = ref.router(
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
  }) {
    return page.watch((ref) {
      return NestedAppRouter(
        initialQuery: initialQuery,
        pages: pages,
      );
    });
  }
}
