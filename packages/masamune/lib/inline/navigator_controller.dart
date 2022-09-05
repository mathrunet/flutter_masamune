part of masamune;

class NavigatorController extends Listenable {
  NavigatorController([
    String? initialRoute,
    bool Function(String routeName)? showEmptyPage,
  ])  : _route = initialRoute,
        _showEmptyPage = showEmptyPage;
  final String? _route;
  // ignore: unused_field
  final bool Function(String routeName)? _showEmptyPage;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  final InternalNavigatorObserver observer = InternalNavigatorObserver._();
  NavigatorState get navigator => _navigatorKey.currentState!;

  RouteSettings? get route =>
      observer._current?.settings ?? RouteSettings(name: _route);

  @override
  void addListener(VoidCallback listener) {
    observer._addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    observer._removeListener(listener);
  }

  /// Destroy this object.
  void dispose() {
    observer.dispose();
  }
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

  /// Destroy this object.
  void dispose() {
    _current = null;
    _listener.clear();
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
      WidgetsBinding.instance.scheduleFrameCallback((_) {
        _listener.forEach((element) => element.call());
      });
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
      WidgetsBinding.instance.scheduleFrameCallback((_) {
        _listener.forEach((element) => element.call());
      });
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
      WidgetsBinding.instance.scheduleFrameCallback((_) {
        _listener.forEach((element) => element.call());
      });
    }
  }
}
