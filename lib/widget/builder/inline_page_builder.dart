part of masamune;

class InlinePageBuilder extends StatefulWidget {
  InlinePageBuilder({this.initialRoute, this.controller})
      : assert(initialRoute != null || controller?._route != null,
            "Either [initialRoute] or [initialRoute] of [controller] must be specified.");
  final String? initialRoute;
  final NavigatorController? controller;

  @override
  State<StatefulWidget> createState() => _InlinePageBuilderState();
}

class _InlinePageBuilderState extends State<InlinePageBuilder> {
  NavigatorController? _controller;
  Widget? _cache;

  NavigatorController? get _effectiveController =>
      widget.controller ?? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _controller = NavigatorController(widget.initialRoute);
    }
  }

  /// Keys for the navigator.
  NavigatorState get navigator => _effectiveController!._state;

  /// Creating a body.
  ///
  /// [context]: Build context.
  @override
  Widget build(BuildContext context) {
    if (_cache != null) {
      return _cache!;
    }
    return _cache = WillPopScope(
      onWillPop: () async {
        return !await navigator.maybePop();
      },
      child: Navigator(
        observers: [_effectiveController!.observer],
        key: _effectiveController!._navigatorKey,
        initialRoute: _effectiveController?._route,
        onGenerateRoute: (settings) => RouteConfig.onGenerateRoute(settings),
        onGenerateInitialRoutes: (state, initialRouteName) {
          return [
            RouteConfig.onGenerateRoute(
                  RouteSettings(
                    name: initialRouteName,
                    arguments: ModalRoute.of(context)?.settings.arguments,
                  ),
                ) ??
                UIPageRoute(
                  builder: (_) => const Empty(),
                  settings: RouteSettings(
                    name: initialRouteName,
                    arguments: ModalRoute.of(context)?.settings.arguments,
                  ),
                ),
          ];
        },
      ),
    );
  }
}

class NavigatorController extends Listenable {
  NavigatorController([String? initialRoute]) : _route = initialRoute;
  final String? _route;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  final InternalNavigatorObserver observer = InternalNavigatorObserver._();
  NavigatorState get _state => _navigatorKey.currentState!;

  RouteSettings? get route =>
      observer._current?.settings ??
      RouteSettings(
        name: _route,
      );

  @override
  void addListener(VoidCallback listener) {
    observer._addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    observer._removeListener(listener);
  }

  bool canPop() => _state.canPop();

  Future<bool> maybePop<T extends Object?>([T? result]) =>
      _state.maybePop<T>(result);

  void pop<T extends Object?>([T? result]) => _state.pop<T>(result);

  Future<T?> popAndPushNamed<T extends Object?, TO extends Object?>(
          String routeName,
          {TO? result,
          Object? arguments}) =>
      _state.popAndPushNamed<T, TO>(
        routeName,
        result: result,
        arguments: arguments,
      );

  void popUntil(RoutePredicate predicate) => _state.popUntil(predicate);

  Future<T?> push<T extends Object?>(Route<T> route) => _state.push<T>(route);

  Future<T?> pushAndRemoveUntil<T extends Object?>(
          Route<T> newRoute, RoutePredicate predicate) =>
      _state.pushAndRemoveUntil<T>(
        newRoute,
        predicate,
      );

  Future<T?> pushNamed<T extends Object?>(String routeName,
          {Object? arguments}) =>
      _state.pushNamed<T>(
        routeName,
        arguments: arguments,
      );

  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
          String newRouteName, RoutePredicate predicate,
          {Object? arguments}) =>
      _state.pushNamedAndRemoveUntil<T>(
        newRouteName,
        predicate,
        arguments: arguments,
      );

  Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
          Route<T> newRoute,
          {TO? result}) =>
      _state.pushReplacement<T, TO>(
        newRoute,
        result: result,
      );

  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
          String routeName,
          {TO? result,
          Object? arguments}) =>
      _state.pushReplacementNamed<T, TO>(
        routeName,
        result: result,
        arguments: arguments,
      );

  void removeRoute(Route route) => _state.removeRoute(route);

  void removeRouteBelow(Route anchorRoute) =>
      _state.removeRouteBelow(anchorRoute);

  void replace<T extends Object?>(
          {required Route oldRoute, required Route<T> newRoute}) =>
      _state.replace<T>(
        oldRoute: oldRoute,
        newRoute: newRoute,
      );

  void replaceRouteBelow<T extends Object?>(
          {required Route anchorRoute, required Route<T> newRoute}) =>
      _state.replaceRouteBelow<T>(
        anchorRoute: anchorRoute,
        newRoute: newRoute,
      );

  String restorablePopAndPushNamed<T extends Object?, TO extends Object?>(
          String routeName,
          {TO? result,
          Object? arguments}) =>
      _state.restorablePopAndPushNamed<T, TO>(
        routeName,
        result: result,
        arguments: arguments,
      );

  String restorablePush<T extends Object?>(
          RestorableRouteBuilder<T> routeBuilder,
          {Object? arguments}) =>
      _state.restorablePush<T>(
        routeBuilder,
        arguments: arguments,
      );

  String restorablePushAndRemoveUntil<T extends Object?>(
          RestorableRouteBuilder<T> newRouteBuilder, RoutePredicate predicate,
          {Object? arguments}) =>
      _state.restorablePushAndRemoveUntil<T>(
        newRouteBuilder,
        predicate,
        arguments: arguments,
      );

  String restorablePushNamed<T extends Object?>(String routeName,
          {Object? arguments}) =>
      _state.restorablePushNamed(
        routeName,
        arguments: arguments,
      );

  String restorablePushNamedAndRemoveUntil<T extends Object?>(
          String newRouteName, RoutePredicate predicate,
          {Object? arguments}) =>
      _state.restorablePushNamedAndRemoveUntil<T>(
        newRouteName,
        predicate,
        arguments: arguments,
      );

  String restorablePushReplacement<T extends Object?, TO extends Object?>(
          RestorableRouteBuilder<T> routeBuilder,
          {TO? result,
          Object? arguments}) =>
      _state.restorablePushReplacement<T, TO>(
        routeBuilder,
        result: result,
        arguments: arguments,
      );

  String restorablePushReplacementNamed<T extends Object?, TO extends Object?>(
          String routeName,
          {TO? result,
          Object? arguments}) =>
      _state.restorablePushReplacementNamed<T, TO>(
        routeName,
        result: result,
        arguments: arguments,
      );

  String restorableReplace<T extends Object?>(
          {required Route oldRoute,
          required RestorableRouteBuilder<T> newRouteBuilder,
          Object? arguments}) =>
      _state.restorableReplace<T>(
        oldRoute: oldRoute,
        newRouteBuilder: newRouteBuilder,
        arguments: arguments,
      );

  String restorableReplaceRouteBelow<T extends Object?>(
          {required Route anchorRoute,
          required RestorableRouteBuilder<T> newRouteBuilder,
          Object? arguments}) =>
      _state.restorableReplaceRouteBelow(
        anchorRoute: anchorRoute,
        newRouteBuilder: newRouteBuilder,
        arguments: arguments,
      );

  String? get restorationId => _state.restorationId;

  bool get restorePending => _state.restorePending;

  void restoreState(RestorationBucket? oldBucket, bool initialRestore) =>
      _state.restoreState(oldBucket, initialRestore);
}

/// Observer to be able to catch the navigation movement inside.
///
/// You can describe what to do
/// when the internal page changes by [subscribe] and listen for changes.
class InternalNavigatorObserver extends NavigatorObserver {
  InternalNavigatorObserver._();
  final List<VoidCallback> _listener = [];
  Route? _current;

  void _addListener(VoidCallback listener) {
    if (_listener.contains(listener)) {
      return;
    }
    _listener.add(listener);
  }

  void _removeListener(VoidCallback listener) {
    _listener.remove(listener);
  }

  /// The [Navigator] replaced oldRoute with newRoute.
  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (_current == newRoute) {
      return;
    }
    if (_current == null) {
      _current = newRoute;
    } else {
      _current = newRoute;
      _listener.forEach((element) => element.call());
    }
  }

  /// The [Navigator] pushed route.
  ///
  /// The route immediately below that one, and thus the previously active route, is previousRoute.
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (_current == route) {
      return;
    }
    if (_current == null) {
      _current = route;
    } else {
      _current = route;
      _listener.forEach((element) => element.call());
    }
  }

  /// The [Navigator] popped route.
  ///
  /// The route immediately below that one, and thus the newly active route, is previousRoute.
  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    if (_current == previousRoute) {
      return;
    }
    if (_current == null) {
      _current = previousRoute;
    } else {
      _current = previousRoute;
      _listener.forEach((element) => element.call());
    }
  }
}
