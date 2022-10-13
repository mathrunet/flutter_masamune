part of katana_router;

@immutable
class _AppRouteInformationParser extends RouteInformationParser<PageQuery> {
  const _AppRouteInformationParser(
    this.router,
  );

  final AppRouter router;

  @override
  Future<PageQuery> parseRouteInformationWithDependencies(
    RouteInformation routeInformation,
    BuildContext context,
  ) async {
    final path = routeInformation.location;
    final query = router._config.pages
            .map((e) => e.resolve(path))
            .firstWhereOrNull((e) => e != null) ??
        router._config.unknown?.resolve(path ?? "") ??
        const _EmptyPageQuery();
    return await router._redirect(context, query);
  }

  @override
  RouteInformation? restoreRouteInformation(PageQuery configuration) {
    return RouteInformation(location: configuration.path, state: configuration);
  }
}
