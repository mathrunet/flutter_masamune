part of "/katana_router.dart";

@immutable
class _AppRouteInformationParser extends RouteInformationParser<RouteQuery> {
  const _AppRouteInformationParser(
    this.router,
  );

  final AppRouter router;

  @override
  Future<RouteQuery> parseRouteInformationWithDependencies(
    RouteInformation routeInformation,
    BuildContext context,
  ) async {
    if (routeInformation is InitialRouteInformation &&
        routeInformation.query != null) {
      final query =
          router._config.onDeepLink?.call(routeInformation.uri.path, true) ??
              routeInformation.query!;
      // 初回時にbootが存在するとリダイレクトをスキップ
      final boot = router._config.boot;
      if (boot != null) {
        return query;
      }
      final redirect = await router._redirect(context, query);
      if (redirect != query) {
        return redirect;
      }
      return query;
    }
    final path = routeInformation.uri.path;
    final query = router._config.onDeepLink?.call(path, false) ??
        router.pages
            .map((e) => e.resolve(path))
            .firstWhereOrNull((e) => e != null) ??
        router._config.unknown?.resolve(path) ??
        _EmptyRouteQuery(sourcePath: path);
    return await router._redirect(context, query);
  }

  @override
  RouteInformation? restoreRouteInformation(RouteQuery configuration) {
    var path = configuration.path;
    if (!path.startsWith("/")) {
      path = "/$path";
    }
    return RouteInformation(uri: Uri.tryParse(path), state: configuration);
  }
}
