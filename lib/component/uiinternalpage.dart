part of flutter_runtime_database;

/// Used to display a page within a page.
///
/// Please inherit and use it.
abstract class UIInternalPage extends UIPage {
  /// Route monitoring observer.
  final InternalNavigatorObserver routeObserver = InternalNavigatorObserver();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  /// Keys for the navigator.
  NavigatorState get navigator => this._navigatorKey?.currentState;

  /// Used to display a page within a page.
  ///
  /// [key]: Widget key.
  UIInternalPage({Key key}) : super(key: key);

  /// Executed when the widget is initialized.
  ///
  /// Override and use.
  ///
  /// [context]: Build context.
  @override
  void onInit(BuildContext context) {
    super.onInit(context);
    RouteConfig._initialize(this.routes);
  }

  /// The name of the first route on the page.
  String get initialRoute;

  /// Setting up a route.
  Map<String, RouteConfig> get routes;

  /// Page when a route name is specified that is not defined in the route.
  RouteConfig get onUnknownRoute => null;

  /// Create a state.
  ///
  /// Do not use from outside.
  @override
  @protected
  State createState() => _UIInternalPageState();

  /// Callback for building.
  ///
  /// Override and use.
  ///
  /// [context]: Build context.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => context.unfocus(),
        child: this.applySafeArea
            ? SafeArea(child: this.body(context))
            : this.body(context));
  }

  /// Creating a body.
  ///
  /// [context]: Build context.
  @override
  Widget body(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        this.navigator.maybePop();
        return false;
      },
      child: Navigator(
        key: this._navigatorKey,
        initialRoute: initialRoute,
        onGenerateRoute: (settings) => RouteConfig._onGenerateRoute(settings),
        onGenerateInitialRoutes: (state, initialRouteName) {
          return [
            UIPageRoute(
                builder: routes.containsKey(initialRouteName)
                    ? routes[initialRouteName]?.builder
                    : onUnknownRoute?.builder,
                settings: RouteSettings(
                    name: initialRouteName,
                    arguments: ModalRoute.of(context).settings.arguments))
          ];
        },
        observers: [this.routeObserver, UIRouteObserver()],
        onUnknownRoute: this.onUnknownRoute != null
            ? (settings) => RouteConfig._onSingleRoute(settings, onUnknownRoute)
            : null,
      ),
    );
  }
}

class _UIInternalPageState extends State<UIInternalPage>
    with WidgetsBindingObserver, RouteAware {
  /// True if the widget is valid.
  bool get enabled => this._enabled && (this._parent?.enabled ?? true);
  bool _enabled = true;
  bool _markRebuild = false;
  _UIInternalPageState _parent;
  List<void Function()> _didPushListener = [];
  List<void Function()> _didPopNextListener = [];
  List<void Function()> _didPushNextListener = [];
  @override
  void initState() {
    super.initState();
    this.widget._init?.call(this.context);
    this.widget.onInit(this.context);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this._parent = _UIInternalPageScope.of(context);
    ModalRoute route = ModalRoute.of(this.context);
    if (route != null) UIPage.routeObserver.subscribe(this, route);
    this._parent?._addDidPushListener(this.didPush);
    this._parent?._addDidPopNextListener(this._didPopNextInternal);
    this._parent?._addDidPushNextListener(this.didPushNext);
  }

  @override
  void dispose() {
    super.dispose();
    this.widget._dispose?.call(context);
    this.widget.onDispose(context);
    WidgetsBinding.instance.removeObserver(this);
    UIPage.routeObserver.unsubscribe(this);
    this._parent?._removeDidPushListener(this.didPush);
    this._parent?._removeDidPopNextListener(this._didPopNextInternal);
    this._parent?._removeDidPushNextListener(this.didPushNext);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
        this.widget._quit?.call(this.context);
        this.widget.onQuit(this.context);
        break;
      case AppLifecycleState.paused:
        this.widget._pause?.call(this.context);
        this.widget.onPause(this.context);
        break;
      case AppLifecycleState.resumed:
        this.widget._unpause?.call(this.context);
        this.widget.onUnpause(this.context);
        break;
      default:
        break;
    }
  }

  @override
  void didPop() {
    this.widget._didPop?.call(this.context);
    this.widget.didPop(this.context);
  }

  @override
  void didPopNext() {
    this._enabled = true;
    if (this._markRebuild) {
      this.setState(() {});
      this._markRebuild = false;
    }
    this._didPopNextListener.forEach((element) => element?.call());
    this.widget._didPopNext?.call(this.context);
    this.widget.didPopNext(this.context);
  }

  void _didPopNextInternal() {
    this.didPopNext();
    ModalRoute route = ModalRoute.of(this.context);
    final data = route?.settings?.arguments;
    if (data is IDataDocument) {
      final document = DataDocument(DefaultPath.pageData);
      document.clear();
      for (MapEntry<String, IDataField> tmp in data.entries) {
        if (isEmpty(tmp.key) || tmp.value == null || tmp.value.data == null)
          continue;
        document[tmp.key] = tmp.value.data;
        PathTag.set(tmp.key, tmp.value.data.toString());
      }
    }
  }

  @override
  void didPushNext() {
    this._enabled = false;
    this._didPushNextListener.forEach((element) => element?.call());
    this.widget._didPushNext?.call(this.context);
    this.widget.didPushNext(this.context);
  }

  @override
  void didPush() {
    this._enabled = true;
    this._didPushListener.forEach((element) => element?.call());
    this.widget._didPush?.call(this.context);
    this.widget.didPush(this.context);
  }

  @override
  Widget build(BuildContext context) {
    if (!this.enabled) this._markRebuild = true;
    if (this.widget._child != null) {
      return _UIInternalPageScope(
        state: this,
        child: this.widget._child(context),
      );
    }
    return _UIInternalPageScope(
      state: this,
      child: this.widget.build(context),
    );
  }

  void _addDidPopNextListener(void Function() callback) {
    if (this._didPopNextListener.contains(callback)) return;
    this._didPopNextListener.add(callback);
  }

  void _removeDidPopNextListener(void Function() callback) {
    if (!this._didPopNextListener.contains(callback)) return;
    this._didPopNextListener.remove(callback);
  }

  void _addDidPushListener(void Function() callback) {
    if (this._didPushListener.contains(callback)) return;
    this._didPushListener.add(callback);
  }

  void _removeDidPushListener(void Function() callback) {
    if (!this._didPushListener.contains(callback)) return;
    this._didPushListener.remove(callback);
  }

  void _addDidPushNextListener(void Function() callback) {
    if (this._didPushNextListener.contains(callback)) return;
    this._didPushNextListener.add(callback);
  }

  void _removeDidPushNextListener(void Function() callback) {
    if (!this._didPushNextListener.contains(callback)) return;
    this._didPushNextListener.remove(callback);
  }
}

class _UIInternalPageScope extends InheritedWidget {
  final _UIInternalPageState state;
  _UIInternalPageScope({this.state, Key key, Widget child})
      : super(key: key, child: child);
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
  static _UIInternalPageState of(BuildContext context) {
    return (context
            .getElementForInheritedWidgetOfExactType<_UIInternalPageScope>()
            ?.widget as _UIInternalPageScope)
        ?.state;
  }
}

/// Observer to be able to catch the navigation movement inside.
///
/// You can describe what to do
/// when the internal page changes by [subscribe] and listen for changes.
class InternalNavigatorObserver extends NavigatorObserver {
  Route _currentRoute;
  final List<void Function(Route route)> _listener = [];

  /// Listen for new route changes.
  ///
  /// [callback]: Callbacks to subscribe.
  void subscribe(void Function(Route route) callback) {
    if (callback == null || this._listener.contains(callback)) return;
    this._listener.add(callback);
  }

  /// Unlisten for new route changes.
  ///
  /// [callback]: Callbacks to unsubscribe.
  void unsubscribe(void Function(Route route) callback) {
    if (callback == null || !this._listener.contains(callback)) return;
    this._listener.remove(callback);
  }

  /// The [Navigator] replaced oldRoute with newRoute.
  void didReplace({Route newRoute, Route oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    this._currentRoute = newRoute;
    this._listener?.forEach((element) => element?.call(newRoute));
  }

  /// The [Navigator] pushed route.
  ///
  /// The route immediately below that one, and thus the previously active route, is previousRoute.
  @override
  void didPush(Route route, Route previousRoute) {
    super.didPush(route, previousRoute);
    this._currentRoute = route;
    this._listener?.forEach((element) => element?.call(route));
  }

  /// The [Navigator] popped route.
  ///
  /// The route immediately below that one, and thus the newly active route, is previousRoute.
  @override
  void didPop(Route route, Route previousRoute) {
    super.didPop(route, previousRoute);
    this._currentRoute = previousRoute;
    this._listener?.forEach((element) => element?.call(previousRoute));
  }
}
