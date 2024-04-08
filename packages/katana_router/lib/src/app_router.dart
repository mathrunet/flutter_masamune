part of '/katana_router.dart';

/// {@template katana_router.app_router}
/// Controller to define routing for the entire app.
///
/// You can define the routing for the entire app by passing it to `routerConfig` in [MaterialApp.router].
///
/// The controller itself can also be manipulated, and page transitions can be performed directly by executing [push], [replace], and [pop].
///
/// It is also possible to get the [AppRouter] object itself with [AppRouter.of].
///
/// By executing [setPathUrlStrategy], it is possible to use URLs with the web hash (#) removed.
///
/// Adapters for loggers can be applied to routing in [loggerAdapters].
///
/// アプリ全体のルーティングを定義するためのコントローラー。
///
/// [MaterialApp.router]の`routerConfig`に渡すことでアプリ全体のルーティングを定義することができます。
///
/// また、このコントローラー自体を操作することが可能で[push]や[replace]、[pop]を実行することでページ遷移を直接行うことが可能です。
///
/// また、[AppRouter.of]で[AppRouter]のオブジェクト自体を取得することも可能です。
///
/// [setPathUrlStrategy]を実行することでWebのハッシュ（#）を消したURLを利用することが可能になります。
///
/// [loggerAdapters]でロガー用のアダプターをルーティングに適用することができます。
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
/// {@endtemplate}
class AppRouter extends ChangeNotifier
    with _NavigatorObserverMixin
    implements RouterConfig<RouteQuery> {
  /// {@template katana_router.app_router}
  /// Controller to define routing for the entire app.
  ///
  /// You can define the routing for the entire app by passing it to `routerConfig` in [MaterialApp.router].
  ///
  /// The controller itself can also be manipulated, and page transitions can be performed directly by executing [push], [replace], and [pop].
  ///
  /// It is also possible to get the [AppRouter] object itself with [AppRouter.of].
  ///
  /// By executing [setPathUrlStrategy], it is possible to use URLs with the web hash (#) removed.
  ///
  /// Adapters for loggers can be applied to routing in [loggerAdapters].
  ///
  /// アプリ全体のルーティングを定義するためのコントローラー。
  ///
  /// [MaterialApp.router]の`routerConfig`に渡すことでアプリ全体のルーティングを定義することができます。
  ///
  /// また、このコントローラー自体を操作することが可能で[push]や[replace]、[pop]を実行することでページ遷移を直接行うことが可能です。
  ///
  /// また、[AppRouter.of]で[AppRouter]のオブジェクト自体を取得することも可能です。
  ///
  /// [setPathUrlStrategy]を実行することでWebのハッシュ（#）を消したURLを利用することが可能になります。
  ///
  /// [loggerAdapters]でロガー用のアダプターをルーティングに適用することができます。
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
  /// {@endtemplate}
  AppRouter({
    UnknownRouteQueryBuilder? unknown,
    BootRouteQueryBuilder? boot,
    String? initialPath,
    RouteQuery? initialQuery,
    required List<RouteQueryBuilder> pages,
    List<RedirectQuery> redirect = const [],
    List<NavigatorObserver> observers = const [],
    int redirectLimit = 5,
    GlobalKey<NavigatorState>? navigatorKey,
    String? restorationScopeId,
    TransitionQuery? defaultTransitionQuery,
    bool reportsRouteUpdateToEngine = true,
    Widget backgroundWidget = const Scaffold(),
    List<LoggerAdapter> loggerAdapters = const [],
    bool nested = false,
  }) : _loggerAdapters = loggerAdapters {
    navigatorKey ??= GlobalKey<NavigatorState>();

    _config = _AppRouterConfig(
      pages: pages,
      redirect: redirect,
      boot: boot,
      unknown: unknown,
      navigatorKey: navigatorKey,
      redirectLimite: redirectLimit,
      defaultTransitionQuery: defaultTransitionQuery,
      reportsRouteUpdateToEngine: reportsRouteUpdateToEngine,
      backgroundWidget: backgroundWidget,
      nested: nested,
    );

    _routerDelegate = _AppRouterDelegate(
      router: this,
      observers: [this, ...observers],
      restorationScopeId: restorationScopeId,
    );

    _routeInformationParser = _AppRouteInformationParser(this);

    _nested = nested || initialQuery?.nested == true;
    _initialPath = initialPath;
    _initialQuery = initialQuery;
  }

  late final _AppRouterConfig _config;
  final List<_PageStackContainer> _pageStack = [];

  /// Adapter to define loggers.
  ///
  /// ロガーを定義するアダプター。
  List<LoggerAdapter> get loggerAdapters {
    return [...LoggerAdapter.primary, ..._loggerAdapters];
  }

  final List<LoggerAdapter> _loggerAdapters;

  BuildContext? get _context => _config.navigatorKey.currentContext;

  /// List of [NavigatorObserver] currently owned by [AppRouter].
  ///
  /// [AppRouter]が現在持っている[NavigatorObserver]の一覧。
  List<NavigatorObserver> get navigatorObservers => _routerDelegate.observers;

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

  late final bool _nested;
  late final String? _initialPath;
  late final RouteQuery? _initialQuery;

  _AppRouteInformationProvider get _routeInformationProvider {
    return __routeInformationProvider ??= () {
      final effectiveInitialLocation = _nested
          ? null
          : _effectiveInitialLocation(
              _initialPath,
            );

      return _AppRouteInformationProvider(
        router: this,
        initialRouteInformation: InitialRouteInformation(
          query: _nested
              ? _initialQuery
              : _effectiveInitialQuery(
                  effectiveInitialLocation,
                  _initialQuery,
                ),
          uri: Uri.tryParse(effectiveInitialLocation ?? ""),
        ),
      );
    }();
  }

  _AppRouteInformationProvider? __routeInformationProvider;

  /// List of pages currently passed to [AppRouter].
  ///
  /// 現在[AppRouter]に渡されているページのリスト。
  List<RouteQueryBuilder> get pages => [..._config.pages, ..._pages];
  final Set<RouteQueryBuilder> _pages = {};

  /// Register a new [RouteQueryBuilder].
  ///
  /// 新しい[RouteQueryBuilder]を登録します。
  void registerPage(RouteQueryBuilder pageBuilder) {
    _pages.add(pageBuilder);
  }

  /// Unregister the [RouteQueryBuilder].
  ///
  /// [RouteQueryBuilder]を登録解除します。
  void unregisterPage(RouteQueryBuilder pageBuilder) {
    _pages.remove(pageBuilder);
  }

  /// You can check the current [RouteQuery].
  ///
  /// 現在の[RouteQuery]を確認することができます。
  RouteQuery? get currentQuery => _routerDelegate.currentConfiguration;

  /// Passing [routeQuery] will take you to a new page.
  ///
  /// The method of page transition can be specified with [transitionQuery].
  ///
  /// You can wait until the page is destroyed by the [pop] method with the return value [Future].
  ///
  /// In doing so, it can also receive the object passed by [pop].
  ///
  /// [routeQuery]を渡すことにより新しいページに遷移します。
  ///
  /// ページ遷移の方法を[transitionQuery]で指定可能です。
  ///
  /// 戻り値の[Future]で[pop]メソッドでページが破棄されるまで待つことができます。
  ///
  /// また、その際[pop]で渡されたオブジェクトを受け取ることができます。
  Future<E?> push<E>(
    RouteQuery routeQuery, [
    TransitionQuery? transitionQuery,
  ]) async {
    final completer = Completer<E?>();
    final resolveQuery = _InnerRouteQueryImpl(
      routeQuery: _context != null
          ? await _redirect(_context!, routeQuery)
          : routeQuery,
      transitionQuery: transitionQuery ?? _config.defaultTransitionQuery,
    );
    _pageStack.add(
      _PageStackContainer<E>(
        query: resolveQuery,
        route: resolveQuery.route<E>(),
        completer: completer,
      ),
    );
    _routerDelegate.notifyListeners();
    return completer.future;
  }

  /// Finds a [RouteQuery] that matches the [path] in the list of pages passed to [AppRouter.pages] and transitions to that page.
  ///
  /// The method of page transition can be specified with [transitionQuery].
  ///
  /// You can wait until the page is destroyed by the [pop] method with the return value [Future].
  ///
  /// In doing so, it can also receive the object passed by [pop].
  ///
  /// [AppRouter.pages]に渡したページリストから[path]に当てはまる[RouteQuery]を探し出しそちらのページに遷移します。
  ///
  /// ページ遷移の方法を[transitionQuery]で指定可能です。
  ///
  /// 戻り値の[Future]で[pop]メソッドでページが破棄されるまで待つことができます。
  ///
  /// また、その際[pop]で渡されたオブジェクトを受け取ることができます。
  Future<E?> pushNamed<E>(
    String path, [
    TransitionQuery? transitionQuery,
  ]) async {
    for (final page in pages) {
      final resolved = page.resolve(path);
      if (resolved != null) {
        return push<E>(
          resolved,
          transitionQuery,
        );
      }
    }
    throw Exception("No $path found.");
  }

  /// Passing [routeQuery] replaces the currently displayed page with a new page.
  ///
  /// The method of page transition can be specified with [transitionQuery].
  ///
  /// You can wait until the page is destroyed by the [pop] method with the return value [Future].
  ///
  /// In doing so, it can also receive the object passed by [pop].
  ///
  /// [routeQuery]を渡すことにより現在表示されているページを新しいページに置き換えます。
  ///
  /// ページ遷移の方法を[transitionQuery]で指定可能です。
  ///
  /// 戻り値の[Future]で[pop]メソッドでページが破棄されるまで待つことができます。
  ///
  /// また、その際[pop]で渡されたオブジェクトを受け取ることができます。
  Future<E?> replace<E>(
    RouteQuery routeQuery, [
    TransitionQuery? transitionQuery,
  ]) {
    if (_pageStack.isNotEmpty) {
      _pageStack.removeLast();
    }
    return push<E>(routeQuery, transitionQuery);
  }

  /// Finds a [RouteQuery] that matches the [path] in the list of pages passed to [AppRouter.pages] and replaces the currently displayed page with that page.
  ///
  /// The method of page transition can be specified with [transitionQuery].
  ///
  /// You can wait until the page is destroyed by the [pop] method with the return value [Future].
  ///
  /// In doing so, it can also receive the object passed by [pop].
  ///
  /// [AppRouter.pages]に渡したページリストから[path]に当てはまる[RouteQuery]を探し出しそちらのページに現在表示されているページを置き換えます。
  ///
  /// ページ遷移の方法を[transitionQuery]で指定可能です。
  ///
  /// 戻り値の[Future]で[pop]メソッドでページが破棄されるまで待つことができます。
  ///
  /// また、その際[pop]で渡されたオブジェクトを受け取ることができます。
  Future<E?> replaceNamed<E>(
    String path, [
    TransitionQuery? transitionQuery,
  ]) async {
    for (final page in pages) {
      final resolved = page.resolve(path);
      if (resolved != null) {
        return replace<E>(
          resolved,
          transitionQuery,
        );
      }
    }
    throw Exception("No $path found.");
  }

  /// Checks if the page is [pop]-able. If `true` is returned, the page is [pop]able.
  ///
  /// ページが[pop]可能かどうかをチェックします。`true`が返された場合[pop]可能です。
  bool canPop() => _pageStack.length > 1;

  /// Discards the current page and returns to the previous page.
  ///
  /// If [canPop] is `false`, the application is terminated.
  ///
  /// By passing a value to [result], an object can be passed to the return value of [push] or [replace].
  ///
  /// 現在のページを破棄し、前のページに戻ります。
  ///
  /// [canPop]が`false`の場合、アプリを終了します。
  ///
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

  void _forcePop<E>([E? result]) {
    if (_pageStack.isEmpty) {
      return;
    }
    final container = _pageStack.removeLast();
    container.completer.complete(result);
    _routerDelegate.notifyListeners();
  }

  /// Keep [pop] until the [predicate] condition is `true`.
  ///
  /// The result of [pop] is returned by [result].
  ///
  /// [predicate]の条件が`true`になるまで[pop]し続けます。
  ///
  /// [pop]した結果を[result]で返します。
  void popUntil<E>(bool Function(RouteQuery query) predicate, [E? result]) {
    var index = _pageStack.length - 1;
    while (index >= 0 && !predicate(_pageStack[index].query)) {
      final container = _pageStack.removeAt(index);
      container.completer.complete(result);
      index -= 1;
    }
    _routerDelegate.notifyListeners();
  }

  /// Continue to [pop] until the history stack runs out.
  ///
  /// The result of [pop] is returned by [result].
  ///
  /// ヒストリーのスタックがなくなるまで[pop]し続けます。
  ///
  /// [pop]した結果を[result]で返します。
  void reset<E>([E? result]) {
    var index = _pageStack.length - 1;
    while (index >= 0) {
      final container = _pageStack.removeAt(index);
      container.completer.complete(result);
      index -= 1;
    }
    _routerDelegate.notifyListeners();
  }

  /// Keep [pop] until the history stack runs out, then [push] [routeQuery].
  ///
  /// The method of page transition can be specified with [transitionQuery].
  ///
  /// ヒストリーのスタックがなくなるまで[pop]し続けた後[routeQuery]を[push]します。
  ///
  /// ページ遷移の方法を[transitionQuery]で指定可能です。
  Future<E?> resetAndPush<E>(
    RouteQuery routeQuery, [
    TransitionQuery? transitionQuery,
  ]) {
    var index = _pageStack.length - 1;
    while (index >= 0) {
      final container = _pageStack.removeAt(index);
      container.completer.complete(null);
      index -= 1;
    }
    return push<E>(routeQuery, transitionQuery);
  }

  /// Continue [pop] until the history stack runs out, then [push] to the [RouteQuery] that applies to [path].
  ///
  /// The method of page transition can be specified with [transitionQuery].
  ///
  /// ヒストリーのスタックがなくなるまで[pop]し続けた後[path]に当てはまる[RouteQuery]に[push]します。
  ///
  /// ページ遷移の方法を[transitionQuery]で指定可能です。
  Future<E?> resetAndPushNamed<E>(
    String path, [
    TransitionQuery? transitionQuery,
  ]) {
    var index = _pageStack.length - 1;
    while (index >= 0) {
      final container = _pageStack.removeAt(index);
      container.completer.complete(null);
      index -= 1;
    }
    return pushNamed<E>(path, transitionQuery);
  }

  /// Refresh the current page.
  ///
  /// 現在のページを再更新します。
  void refresh() {
    _routeInformationProvider.notifyListeners();
  }

  /// Clears all router pages and returns to the startup state.
  ///
  /// すべてのルーターのページをクリアし起動時の状態に戻します。
  void clear() {
    _pageStack.clear();
    _pages.clear();
    __routeInformationProvider = null;
  }

  /// Sets the URL strategy of your web app to using paths instead of a leading hash (#).
  ///
  /// You can safely call this on all platforms, i.e. also when running on mobile or desktop. In that case, it will simply be a noop.
  ///
  /// Web アプリの URL 戦略を、先頭のハッシュ (#) の代わりにパスを使用するように設定します。
  ///
  /// これは、すべてのプラットフォームで安全に呼び出すことができます。つまり、モバイルまたはデスクトップで実行している場合でも同様です。その場合、それは単にヌープになります。
  // TODO: 非アクティブにするが、一応残しておく
  // static void setPathUrlStrategy() => url_strategy.setPathUrlStrategy();

  /// Get [AppRouter] placed on the widget tree.
  ///
  /// Setting [root] to `true` will get [AppRouter] at the top level.
  ///
  /// ウィジェットツリー上に配置されている[AppRouter]を取得します。
  ///
  /// [root]を`true`にすると最上位にある[AppRouter]を取得します。
  static AppRouter of(BuildContext context, {bool root = false}) {
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
      query = await r.redirect(context, query);
    }
    return query;
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sendLog(RouteLoggerEvent.push, parameters: {
        RouteLoggerEvent.newRouteKey: route.settings.name,
        RouteLoggerEvent.prevRouteKey: previousRoute?.settings.name,
      });
      notifyListeners();
    });
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sendLog(RouteLoggerEvent.pop, parameters: {
        RouteLoggerEvent.newRouteKey: previousRoute?.settings.name,
        RouteLoggerEvent.prevRouteKey: route.settings.name,
      });
      notifyListeners();
    });
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sendLog(RouteLoggerEvent.pop, parameters: {
        RouteLoggerEvent.newRouteKey: newRoute?.settings.name,
        RouteLoggerEvent.prevRouteKey: oldRoute?.settings.name,
      });
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _routeInformationProvider.dispose();
    _routerDelegate.dispose();
    super.dispose();
  }

  void _sendLog(RouteLoggerEvent event, {DynamicMap? parameters}) {
    for (final loggerAdapter in loggerAdapters) {
      loggerAdapter.send(event.toString(), parameters: parameters);
    }
  }

  String? _effectiveInitialLocation(String? initialLocation) {
    final String platformDefault =
        WidgetsBinding.instance.platformDispatcher.defaultRouteName;
    if (platformDefault == "/") {
      return initialLocation;
    } else {
      return platformDefault;
    }
  }

  RouteQuery? _effectiveInitialQuery(
    String? initialLocation,
    RouteQuery? initialQuery,
  ) {
    if (initialLocation.isEmpty) {
      return initialQuery;
    }
    for (final page in pages) {
      final query = page.resolve(initialLocation);
      if (query != null) {
        return query;
      }
    }
    return initialQuery;
  }
}

/// Class for creating nested [AppRouter].
///
/// ネストされた[AppRouter]を作成するためのクラスです。
///
/// {@macro katana_router.app_router}
class NestedAppRouter extends AppRouter {
  /// Class for creating nested [AppRouter].
  ///
  /// ネストされた[AppRouter]を作成するためのクラスです。
  ///
  /// {@macro katana_router.app_router}
  NestedAppRouter({
    super.unknown,
    super.boot,
    super.initialPath,
    super.initialQuery,
    required super.pages,
    super.redirect = const [],
    super.observers = const [],
    super.redirectLimit = 5,
    super.navigatorKey,
    super.restorationScopeId,
    super.defaultTransitionQuery,
    super.reportsRouteUpdateToEngine = true,
    super.backgroundWidget = const Scaffold(),
    super.loggerAdapters = const [],
  }) : super(nested: true);
}

/// [InheritedWidget] for placing [AppRouter] on the widget tree.
///
/// You can take the value of [AppRouter] passed here in [AppRouter.of].
///
/// [AppRouter]をウィジェットツリー上に配置するための[InheritedWidget]。
///
/// [AppRouter.of]でここで渡した[AppRouter]の値を取ることができます。
@immutable
class AppRouteScope extends InheritedWidget {
  const AppRouteScope({
    super.key,
    required this.router,
    required super.child,
  });

  /// Value of [AppRouter].
  ///
  /// [AppRouter]の値。
  final AppRouter router;

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
    this.defaultTransitionQuery,
    this.backgroundWidget = const Scaffold(),
    this.reportsRouteUpdateToEngine = true,
    this.nested = false,
  });
  final bool nested;
  final BootRouteQueryBuilder? boot;
  final UnknownRouteQueryBuilder? unknown;
  final List<RouteQueryBuilder> pages;
  final List<RedirectQuery> redirect;
  final int redirectLimite;
  final GlobalKey<NavigatorState> navigatorKey;
  final TransitionQuery? defaultTransitionQuery;
  final bool reportsRouteUpdateToEngine;
  final Widget backgroundWidget;
}

mixin _NavigatorObserverMixin implements NavigatorObserver {
  @override
  NavigatorState? get navigator => _navigators[this];

  static final Expando<NavigatorState> _navigators = Expando<NavigatorState>();

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {}

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {}

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {}

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {}
  @override
  void didStartUserGesture(
      Route<dynamic> route, Route<dynamic>? previousRoute) {}

  @override
  void didStopUserGesture() {}
}
