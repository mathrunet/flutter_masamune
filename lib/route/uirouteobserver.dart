part of masamune;

/// Set RouteObserver.
///
/// Use it by passing it to the MaterialPage class.
class UIRouteObserver extends NavigatorObserver {
  /// The [Navigator] replaced `oldRoute` with `newRoute`.
  void didReplace({Route newRoute, Route oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    this._initData(newRoute);
  }

  /// The [Navigator] pushed route.
  ///
  /// The route immediately below that one, and thus the previously active route,
  /// is previousRoute.
  @override
  void didPush(Route route, Route previousRoute) {
    super.didPush(route, previousRoute);
    _initData(route);
  }

  /// The [Navigator] popped route.
  ///
  /// The route immediately below that one, and thus the newly active route,
  /// is previousRoute.
  @override
  void didPop(Route route, Route previousRoute) {
    super.didPop(route, previousRoute);
    _initData(previousRoute);
  }

  void _initData(Route route) {
    final data = route?.settings?.arguments;
    if (data is IDataDocument) {
      final document = DataDocument(UIPage.dataPath);
      document.clear();
      for (MapEntry<String, IDataField> tmp in data.entries) {
        if (isEmpty(tmp.key) || tmp.value == null || tmp.value.data == null)
          continue;
        document[tmp.key] = tmp.value.data;
        PathTag.set(tmp.key, tmp.value.data.toString());
      }
    }
  }
}
