part of "/katana_router.dart";

class _AppRouteInformationProvider extends RouteInformationProvider
    with WidgetsBindingObserver, ChangeNotifier {
  _AppRouteInformationProvider({
    required this.router,
    required RouteInformation initialRouteInformation,
  }) : _value = initialRouteInformation;

  // ignore: unnecessary_non_null_assertion
  static WidgetsBinding get _binding => WidgetsBinding.instance;

  final AppRouter router;

  @override
  RouteInformation get value {
    final val = _value;
    if (val is InitialRouteInformation) {
      return InitialRouteInformation(
        query: val.query,
        uri: val.uri,
        state: val.state,
      );
    } else {
      return RouteInformation(
        uri: val.uri,
        state: val.state,
      );
    }
  }

  RouteInformation _value;

  set value(RouteInformation other) {
    final bool shouldNotify =
        _value.uri != other.uri || _value.state != other.state;
    _value = other;
    if (shouldNotify) {
      notifyListeners();
    }
  }

  RouteInformation _valueInEngine = RouteInformation(
    uri: Uri.tryParse(_binding.platformDispatcher.defaultRouteName),
  );

  @override
  void routerReportsNewRouteInformation(
    RouteInformation routeInformation, {
    RouteInformationReportingType type = RouteInformationReportingType.none,
  }) {
    if (!router._config.reportsRouteUpdateToEngine) {
      return;
    }
    assert(
      routeInformation.state is RouteQuery?,
      "RouteInformation does not contain a Query.",
    );
    final routeQuery = routeInformation.state as RouteQuery?;
    if (routeQuery?.hidden ?? false) {
      return;
    }
    if (routeQuery?._transition != null &&
        routeQuery!._transition!.transition.isModal) {
      return;
    }
    final bool replace = type == RouteInformationReportingType.neglect ||
        (type == RouteInformationReportingType.none &&
            _valueInEngine.uri.path.trimString("/") ==
                routeInformation.uri.path.trimString("/"));
    SystemNavigator.selectMultiEntryHistory();
    SystemNavigator.routeInformationUpdated(
      uri: routeInformation.uri,
      replace: replace,
    );
    _value = routeInformation;
    _valueInEngine = routeInformation;
  }

  @override
  void addListener(VoidCallback listener) {
    if (!hasListeners) {
      _binding.addObserver(this);
    }
    super.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    super.removeListener(listener);
    if (!hasListeners) {
      _binding.removeObserver(this);
    }
  }

  @override
  void dispose() {
    if (hasListeners) {
      _binding.removeObserver(this);
    }
    super.dispose();
  }

  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) {
    assert(hasListeners, "hasListeners is false");
    _platformReportsNewRouteInformation(routeInformation);
    return SynchronousFuture<bool>(true);
  }

  @override
  Future<bool> didPushRoute(String route) {
    assert(hasListeners, "hasListeners is false");
    if (!route.startsWith("/")) {
      route = "/$route";
    }
    _platformReportsNewRouteInformation(
        RouteInformation(uri: Uri.tryParse(route)));
    return SynchronousFuture<bool>(true);
  }

  void _platformReportsNewRouteInformation(RouteInformation routeInformation) {
    if (_value == routeInformation) {
      return;
    }
    _value = routeInformation;
    _valueInEngine = routeInformation;
    notifyListeners();
  }
}

/// InitialRouteInformation is a class that contains the initial route information.
///
/// [InitialRouteInformation]は初期ルート情報を含むクラスです。
class InitialRouteInformation extends RouteInformation {
  /// InitialRouteInformation is a class that contains the initial route information.
  ///
  /// [InitialRouteInformation]は初期ルート情報を含むクラスです。
  const InitialRouteInformation({
    this.query,
    super.uri,
    super.state,
  });

  /// Query is the query of the route.
  ///
  /// [query]はルートのクエリです。
  final RouteQuery? query;
}
