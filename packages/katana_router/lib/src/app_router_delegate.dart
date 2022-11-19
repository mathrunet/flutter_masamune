part of katana_router;

class _AppRouterDelegate extends RouterDelegate<RouteQuery>
    with ChangeNotifier {
  _AppRouterDelegate({
    required this.router,
    this.observers = const [],
    this.restorationScopeId,
  });

  final AppRouterBase router;
  final String? restorationScopeId;
  final List<NavigatorObserver> observers;

  @override
  RouteQuery? get currentConfiguration => router._pageStack.lastOrNull?.query;

  @override
  Widget build(BuildContext context) {
    if (router._pageStack.isEmpty) {
      return router._config.backgroundWidget;
    }
    return AppRouteScope(
      router: router,
      child: Navigator(
        key: router._config.navigatorKey,
        pages: router._pageStack.map((e) => e.route).toList(),
        observers: observers,
        restorationScopeId: restorationScopeId,
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }
          pop();
          return true;
        },
      ),
    );
  }

  Future<E?> push<E>(
    RouteQuery routeQuery, [
    TransitionQuery? transitionQuery,
  ]) =>
      router.push<E>(routeQuery, transitionQuery);

  Future<E?> replace<E>(
    RouteQuery routeQuery, [
    TransitionQuery? transitionQuery,
  ]) =>
      router.replace<E>(routeQuery, transitionQuery);

  bool canPop() => router.canPop();

  void pop<E>([E? result]) => router.pop<E>(result);

  @override
  Future<bool> popRoute() {
    if (!canPop()) {
      SystemNavigator.pop();
      return SynchronousFuture(false);
    }
    pop();
    return SynchronousFuture(true);
  }

  @override
  Future<void> setNewRoutePath(RouteQuery configuration) {
    return push<void>(configuration);
  }

  @override
  Future<void> setInitialRoutePath(RouteQuery configuration) async {
    final boot = router._config.boot;
    if (boot != null) {
      await push<void>(boot.resolve(configuration.path));
      return push<void>(configuration, boot.initialTransitionQuery);
    }
    return super.setInitialRoutePath(configuration);
  }
}
