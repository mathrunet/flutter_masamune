part of katana_router;

@immutable
abstract class PageQueryBuilder {
  const PageQueryBuilder();

  PageQuery get query;
  PageQuery? resolve(String? path);
}

@immutable
class AppRouter {
  const AppRouter({
    this.unknown,
    this.boot,
    required this.home,
    this.pages = const [],
    this.redirect = const [],
  });

  final PageQueryBuilder? boot;
  final PageQueryBuilder home;
  final PageQueryBuilder? unknown;
  final List<PageQueryBuilder> pages;
  final List<RedirectQuery> redirect;

  FutureOr<PageQuery> _redirect(
    BuildContext context,
    PageQuery query,
  ) async {
    final redirectList = [
      ...query.redirect(),
      ...redirect,
    ];
    for (final r in redirectList) {
      final res = await r.redirect(context, query);
      if (res != null) {
        return res;
      }
    }
    return query;
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode =>
      pages.hashCode ^ boot.hashCode ^ home.hashCode ^ unknown.hashCode;
}

@immutable
class AppRouteInformationParser extends RouteInformationParser<PageQuery> {
  const AppRouteInformationParser(
    this.appRouter,
  );

  final AppRouter appRouter;

  @override
  Future<PageQuery> parseRouteInformationWithDependencies(
    RouteInformation routeInformation,
    BuildContext context,
  ) async {
    final path = routeInformation.location;
    final query = appRouter.pages
            .map((e) => e.resolve(path))
            .firstWhereOrNull((e) => e != null) ??
        appRouter.unknown?.query ??
        appRouter.home.query;
    return await appRouter._redirect(context, query);
  }

  @override
  RouteInformation? restoreRouteInformation(PageQuery configuration) {
    return RouteInformation(location: configuration.path, state: configuration);
  }
}

class AppRouterDelegate extends RouterDelegate<PageQuery> with ChangeNotifier {
  AppRouterDelegate(
    this.appRouter,
  );

  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      pages: [],
    );
  }

  @override
  Future<bool> popRoute() {
    // TODO: implement popRoute
    throw UnimplementedError();
  }

  @override
  Future<void> setNewRoutePath(PageQuery configuration) {
    // TODO: implement setNewRoutePath
    throw UnimplementedError();
  }
}
