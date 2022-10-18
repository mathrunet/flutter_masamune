part of katana_router;

@immutable
class _AppRouteInformationParser extends RouteInformationParser<RouteQuery> {
  const _AppRouteInformationParser(
    this.router,
  );

  final AppRouterBase router;

  @override
  Future<RouteQuery> parseRouteInformationWithDependencies(
    RouteInformation routeInformation,
    BuildContext context,
  ) async {
    if (routeInformation is InitialRouteInformation &&
        routeInformation.query != null) {
      return routeInformation.query!;
    }
    final path = routeInformation.location;
    final query = router._config.pages
            .map((e) => e.resolve(path))
            .firstWhereOrNull((e) => e != null) ??
        router._config.unknown?.resolve(path ?? "") ??
        _EmptyRouteQuery(sourcePath: path ?? "");
    return await router._redirect(context, query);
  }

  @override
  RouteInformation? restoreRouteInformation(RouteQuery configuration) {
    return RouteInformation(location: configuration.path, state: configuration);
  }
}
