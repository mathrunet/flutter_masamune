part of katana_routing;

/// Class for displaying the internal page.
///
/// As with [UIMaterialApp], you can specify [initialRoute] and[routes] and
/// use [navigator.pushName()] to transition pages.
///
/// It inherits from [ConsumerStatefulWidget], so you can use the flutter_hooks function.
///
/// ```
/// class Main extends PageScopedWidget {
///   @override
///   final get initialRoute = "/home";
///   @override
///   final Map<String, RouteConfig> routes = {
///     "/home": RouteConfig((_) => Home()),
///     "/notfound": RouteConfig((_) => NotFound()),
///   };
///   @override
///   final RouteConfig onUnknownRoute = RouteConfig((_) => Unknown());
/// }
/// ```
abstract class InternalPageScopedWidget extends PageScopedWidget {
  /// Used to display a page within a page.
  ///
  /// [key]: Widget key.
  InternalPageScopedWidget({Key? key}) : super(key: key);

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  /// Keys for the navigator.
  NavigatorState get navigator => _navigatorKey.currentState!;

  /// The name of the first route on the page.
  String get initialRoute;

  /// Setting up a route.
  Map<String, RouteConfig> get routes;

  /// Page when a route name is specified that is not defined in the route.
  RouteConfig get onUnknownRoute;

  /// Creating a body.
  ///
  /// [context]: Build context.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WillPopScope(
      onWillPop: () async {
        navigator.maybePop();
        return false;
      },
      child: Navigator(
        key: _navigatorKey,
        initialRoute: initialRoute,
        onGenerateRoute: (settings) =>
            RouteConfig.onGenerateRoute(context, settings),
        onGenerateInitialRoutes: (state, initialRouteName) {
          return [
            UIPageRoute(
              builder: routes.containsKey(initialRouteName)
                  ? routes[initialRouteName]!.builder
                  : onUnknownRoute.builder,
              settings: RouteSettings(
                name: initialRouteName,
                arguments: ModalRoute.of(context)?.settings.arguments,
              ),
            ),
          ];
        },
        onUnknownRoute: (settings) =>
            RouteConfig.onSingleRoute(context, settings, onUnknownRoute),
      ),
    );
  }
}
