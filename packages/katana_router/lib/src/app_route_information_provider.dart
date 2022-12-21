part of katana_router;

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
        location: val.location,
        state: val.state,
      );
    } else {
      return RouteInformation(
        location: val.location,
        state: val.state,
      );
    }
  }

  RouteInformation _value;

  set value(RouteInformation other) {
    final bool shouldNotify =
        _value.location != other.location || _value.state != other.state;
    _value = other;
    if (shouldNotify) {
      notifyListeners();
    }
  }

  RouteInformation _valueInEngine =
      RouteInformation(location: _binding.platformDispatcher.defaultRouteName);

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
    if (routeQuery?._transition != null &&
        routeQuery!._transition!.transition.isModal) {
      return;
    }
    final bool replace = type == RouteInformationReportingType.neglect ||
        (type == RouteInformationReportingType.none &&
            _valueInEngine.location == routeInformation.location);
    SystemNavigator.selectMultiEntryHistory();
    SystemNavigator.routeInformationUpdated(
      location: routeInformation.location!,
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
    assert(hasListeners);
    _platformReportsNewRouteInformation(routeInformation);
    return SynchronousFuture<bool>(true);
  }

  @override
  Future<bool> didPushRoute(String route) {
    assert(hasListeners);
    _platformReportsNewRouteInformation(RouteInformation(location: route));
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

class InitialRouteInformation extends RouteInformation {
  const InitialRouteInformation({this.query, super.location, super.state});

  final RouteQuery? query;
}
