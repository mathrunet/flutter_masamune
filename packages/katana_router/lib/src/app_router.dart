part of katana_router;

/// Controller to define routing for the entire app.
/// アプリ全体のルーティングを定義するためのコントローラー。
///
/// It is an abstract class and should be used by inheriting it from a class such as `AppRouter`.
/// 抽象クラスなので`AppRouter`などのクラスに継承して利用してください。
///
/// You can define the routing for the entire app by passing it to `routerConfig` in [MaterialApp.router].
/// [MaterialApp.router]の`routerConfig`に渡すことでアプリ全体のルーティングを定義することができます。
///
/// The controller itself can also be manipulated, and page transitions can be performed directly by executing [push], [replace], and [pop].
/// また、このコントローラー自体を操作することが可能で[push]や[replace]、[pop]を実行することでページ遷移を直接行うことが可能です。
///
/// By executing [setPathUrlStrategy], it is possible to use URLs with the web hash (#) removed.
/// [setPathUrlStrategy]を実行することでWebのハッシュ（#）を消したURLを利用することが可能になります。
///
/// ```dart
/// final appRouter = AppRouter(
///   pages: [
///     ListPage.query,
///     DetailPage.query,
///   ]
/// );
///
/// void main(){
///   runApp(
///     const MainPage(),
///   );
/// }
///
/// class MainPage extends StatelessWidget {
///   const MainPage();
///
///   @override
///   Widget build(BuilcContext context){
///     return MaterialApp.router(
///       routerConfig: appRouter,
///       title: "Title",
///     );
///   }
/// }
///
/// ```
abstract class AppRouterBase extends ChangeNotifier
    with NavigatorObserver
    implements RouterConfig<RouteQuery> {
  /// Controller to define routing for the entire app.
  /// アプリ全体のルーティングを定義するためのコントローラー。
  ///
  /// You can define the routing for the entire app by passing it to `routerConfig` in [MaterialApp.router].
  /// [MaterialApp.router]の`routerConfig`に渡すことでアプリ全体のルーティングを定義することができます。
  ///
  /// The controller itself can also be manipulated, and page transitions can be performed directly by executing [push], [replace], and [pop].
  /// また、このコントローラー自体を操作することが可能で[push]や[replace]、[pop]を実行することでページ遷移を直接行うことが可能です。
  ///
  /// It is also possible to get the [AppRouterBase] object itself with [AppRouterBase.of].
  /// また、[AppRouterBase.of]で[AppRouterBase]のオブジェクト自体を取得することも可能です。
  ///
  /// By executing [setPathUrlStrategy], it is possible to use URLs with the web hash (#) removed.
  /// [setPathUrlStrategy]を実行することでWebのハッシュ（#）を消したURLを利用することが可能になります。
  ///
  /// ```dart
  /// final appRouter = AppRouter(
  ///   pages: [
  ///     ListPage.query,
  ///     DetailPage.query,
  ///   ]
  /// );
  ///
  /// void main(){
  ///   runApp(
  ///     const MainPage(),
  ///   );
  /// }
  ///
  /// class MainPage extends StatelessWidget {
  ///   const MainPage();
  ///
  ///   @override
  ///   Widget build(BuilcContext context){
  ///     return MaterialApp.router(
  ///       routerConfig: appRouter,
  ///       title: "Title",
  ///     );
  ///   }
  /// }
  ///
  /// ```
  AppRouterBase({
    UnknownRouteQueryBuilder? unknown,
    BootRouteQueryBuilder? boot,
    String? initialPath = "/",
    required List<RouteQueryBuilder> pages,
    List<RedirectQuery> redirect = const [],
    List<NavigatorObserver> observers = const [],
    int redirectLimit = 5,
    GlobalKey<NavigatorState>? navigatorKey,
    String? restorationScopeId,
    TransitionQuery? defaultRouteQuery,
  }) {
    navigatorKey ??= GlobalKey<NavigatorState>();

    _config = _AppRouterConfig(
      pages: pages,
      redirect: redirect,
      boot: boot,
      unknown: unknown,
      navigatorKey: navigatorKey,
      redirectLimite: redirectLimit,
      defaultRouteQuery: defaultRouteQuery,
    );

    _routerDelegate = _AppRouterDelegate(
      router: this,
      observers: [this, ...observers],
      restorationScopeId: restorationScopeId,
    );

    _routeInformationParser = _AppRouteInformationParser(this);

    _routeInformationProvider = _AppRouteInformationProvider(
      initialRouteInformation: RouteInformation(
        location: _effectiveInitialLocation(initialPath),
      ),
    );
  }

  late final _AppRouterConfig _config;
  final List<_PageStackContainer> _pageStack = [];

  @override
  RouterDelegate<RouteQuery> get routerDelegate => _routerDelegate;
  late final _AppRouterDelegate _routerDelegate;

  @override
  RouteInformationParser<RouteQuery> get routeInformationParser =>
      _routeInformationParser;
  late final _AppRouteInformationParser _routeInformationParser;

  @override
  final BackButtonDispatcher backButtonDispatcher = RootBackButtonDispatcher();

  @override
  RouteInformationProvider? get routeInformationProvider =>
      _routeInformationProvider;
  late final _AppRouteInformationProvider _routeInformationProvider;

  /// You can check the current path (URL).
  /// 現在のパス（URL）を確認することができます。
  String get path =>
      _routerDelegate.currentConfiguration?.path.toString() ?? "";

  /// Passing [pageQuery] will take you to a new page.
  /// [pageQuery]を渡すことにより新しいページに遷移します。
  ///
  /// The method of page transition can be specified with [routeQuery].
  /// ページ遷移の方法を[routeQuery]で指定可能です。
  ///
  /// You can wait until the page is destroyed by the [pop] method with the return value [Future].
  /// 戻り値の[Future]で[pop]メソッドでページが破棄されるまで待つことができます。
  ///
  /// In doing so, it can also receive the object passed by [pop].
  /// また、その際[pop]で渡されたオブジェクトを受け取ることができます。
  Future<E?> push<E>(RouteQuery pageQuery, [TransitionQuery? routeQuery]) {
    final completer = Completer<E?>();
    _pageStack.add(
      _PageStackContainer<E>(
        query: pageQuery,
        route: pageQuery.route<E>(routeQuery ?? _config.defaultRouteQuery),
        completer: completer,
      ),
    );
    _routerDelegate.notifyListeners();
    return completer.future;
  }

  /// Passing [pageQuery] replaces the currently displayed page with a new page.
  /// [pageQuery]を渡すことにより現在表示されているページを新しいページに置き換えます。
  ///
  /// The method of page transition can be specified with [routeQuery].
  /// ページ遷移の方法を[routeQuery]で指定可能です。
  ///
  /// You can wait until the page is destroyed by the [pop] method with the return value [Future].
  /// 戻り値の[Future]で[pop]メソッドでページが破棄されるまで待つことができます。
  ///
  /// In doing so, it can also receive the object passed by [pop].
  /// また、その際[pop]で渡されたオブジェクトを受け取ることができます。
  Future<E?> replace<E>(RouteQuery pageQuery, [TransitionQuery? routeQuery]) {
    pop();
    return push<E>(pageQuery, routeQuery);
  }

  /// Checks if the page is [pop]-able. If `true` is returned, the page is [pop]able.
  /// ページが[pop]可能かどうかをチェックします。`true`が返された場合[pop]可能です。
  bool canPop() => _pageStack.isNotEmpty;

  /// Discards the current page and returns to the previous page.
  /// 現在のページを破棄し、前のページに戻ります。
  ///
  /// If [canPop] is `false`, the application is terminated.
  /// [canPop]が`false`の場合、アプリを終了します。
  ///
  /// By passing a value to [result], an object can be passed to the return value of [push] or [replace].
  /// [result]に値を渡すことにより[push]や[replace]の戻り値にオブジェクトを渡すことができます。
  void pop<E>([E? result]) {
    if (!canPop()) {
      SystemNavigator.pop();
      return;
    }
    final container = _pageStack.removeLast();
    container.completer.complete(result);
    _routerDelegate.notifyListeners();
  }

  void popUntil<E>(bool Function(RouteQuery query) predicate, [E? result]) {
    var index = _pageStack.length - 1;
    while (index >= 0 && !predicate(_pageStack[index].query)) {
      final container = _pageStack.removeAt(index);
      container.completer.complete(result);
      index -= 1;
    }
    _routerDelegate.notifyListeners();
  }

  void reset<E>([E? result]) {
    var index = _pageStack.length - 1;
    while (index >= 0) {
      final container = _pageStack.removeAt(index);
      container.completer.complete(result);
      index -= 1;
    }
    _routerDelegate.notifyListeners();
  }

  Future<E?> resetAndPush<E>(RouteQuery pageQuery,
      [TransitionQuery? routeQuery]) {
    var index = _pageStack.length - 1;
    while (index >= 0) {
      final container = _pageStack.removeAt(index);
      container.completer.complete(null);
      index -= 1;
    }
    return push<E>(pageQuery, routeQuery);
  }

  /// Refresh the current page.
  /// 現在のページを再更新します。
  void refresh() {
    _routeInformationProvider.notifyListeners();
  }

  /// Sets the URL strategy of your web app to using paths instead of a leading hash (#).
  /// Web アプリの URL 戦略を、先頭のハッシュ (#) の代わりにパスを使用するように設定します。
  ///
  /// You can safely call this on all platforms, i.e. also when running on mobile or desktop. In that case, it will simply be a noop.
  /// これは、すべてのプラットフォームで安全に呼び出すことができます。つまり、モバイルまたはデスクトップで実行している場合でも同様です。その場合、それは単にヌープになります。
  static void setPathUrlStrategy() => url_strategy.setPathUrlStrategy();

  /// Get [AppRouterBase] placed on the widget tree.
  /// ウィジェットツリー上に配置されている[AppRouterBase]を取得します。
  ///
  /// Setting [root] to `true` will get [AppRouterBase] at the top level.
  /// [root]を`true`にすると最上位にある[AppRouterBase]を取得します。
  static AppRouterBase of(BuildContext context, {bool root = false}) {
    final navigator = Navigator.of(context, rootNavigator: root).context;
    final scope = navigator
        .getElementForInheritedWidgetOfExactType<AppRouteScope>()
        ?.widget as AppRouteScope?;
    assert(scope != null, "AppRouter is not found.");
    return scope!.router;
  }

  FutureOr<RouteQuery> _redirect(
    BuildContext context,
    RouteQuery query,
  ) async {
    final redirectList = [
      ...query.redirect(),
      ..._config.redirect,
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
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      notifyListeners();

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      notifyListeners();

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      notifyListeners();

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) =>
      notifyListeners();

  @override
  void dispose() {
    _routeInformationProvider.dispose();
    _routerDelegate.dispose();
    super.dispose();
  }

  String _effectiveInitialLocation(String? initialLocation) {
    final String platformDefault =
        WidgetsBinding.instance.platformDispatcher.defaultRouteName;
    if (initialLocation == null) {
      return platformDefault;
    } else if (platformDefault == "/") {
      return initialLocation;
    } else {
      return platformDefault;
    }
  }
}

/// [InheritedWidget] for placing [AppRouterBase] on the widget tree.
/// [AppRouterBase]をウィジェットツリー上に配置するための[InheritedWidget]。
///
/// You can take the value of [AppRouterBase] passed here in [AppRouterBase.of].
/// [AppRouterBase.of]でここで渡した[AppRouterBase]の値を取ることができます。
class AppRouteScope extends InheritedWidget {
  const AppRouteScope({
    super.key,
    required this.router,
    required super.child,
  });

  /// Value of [AppRouterBase].
  /// [AppRouterBase]の値。
  final AppRouterBase router;

  @override
  bool updateShouldNotify(covariant AppRouteScope oldWidget) {
    return false;
  }
}

@immutable
class _PageStackContainer<T> {
  const _PageStackContainer({
    required this.query,
    required this.route,
    required this.completer,
  });

  final AppPageRoute<T> route;
  final RouteQuery query;

  final Completer<T?> completer;
}

@immutable
class _AppRouterConfig {
  const _AppRouterConfig({
    this.boot,
    this.unknown,
    this.pages = const [],
    this.redirect = const [],
    this.redirectLimite = 5,
    required this.navigatorKey,
    this.defaultRouteQuery,
  });
  final BootRouteQueryBuilder? boot;
  final UnknownRouteQueryBuilder? unknown;
  final List<RouteQueryBuilder> pages;
  final List<RedirectQuery> redirect;
  final int redirectLimite;
  final GlobalKey<NavigatorState> navigatorKey;
  final TransitionQuery? defaultRouteQuery;
}
