part of masamune;

/// Widget which extended [MaterialApp] for Path.
class UIMaterialApp extends StatefulHookWidget {
  final BuildEvent init;
  final BuildEvent didInit;
  final BuildEvent dispose;
  final BuildEvent pause;
  final BuildEvent unpause;
  final BuildEvent quit;
  final String flavor;
  final WidgetBuilder home;
  final GlobalKey<NavigatorState> navigatorKey;
  final Map<String, RouteConfig> routes;
  final String initialRoute;
  final List<NavigatorObserver> navigatorObservers;
  final String title;
  final RouteFactory onGenerateTitle;
  final RouteConfig onUnknownRoute;
  final RouteConfig onBootRoute;
  final Color color;
  final ThemeColor theme;
  final ThemeColor darkTheme;
  final ThemeMode themeMode;
  final Locale locale;
  final Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates;
  final Locale Function(List<Locale>, Iterable<Locale>)
      localeListResolutionCallback;
  final Locale Function(Locale, Iterable<Locale>) localeResolutionCallback;
  final Iterable<Locale> supportedLocales;
  final bool debugShowMaterialGrid;
  final bool showPerformanceOverlay;
  final bool checkerboardRasterCacheImages;
  final bool checkerboardOffscreenLayers;
  final bool showSemanticsDebugger;
  final bool debugShowCheckedModeBanner;

  /// Widget which extended [MaterialApp] for Path.
  UIMaterialApp(
      {this.init,
      this.didInit,
      this.dispose,
      this.pause,
      this.unpause,
      this.quit,
      Key key,
      this.flavor,
      this.home,
      this.navigatorKey,
      this.routes = const <String, RouteConfig>{},
      this.initialRoute,
      this.navigatorObservers = const <NavigatorObserver>[],
      this.title = '',
      this.onGenerateTitle,
      this.onUnknownRoute,
      this.onBootRoute,
      this.color,
      this.theme,
      this.darkTheme,
      this.themeMode = ThemeMode.system,
      this.locale,
      this.localizationsDelegates,
      this.localeListResolutionCallback,
      this.localeResolutionCallback,
      this.supportedLocales = const <Locale>[Locale('en', 'US')],
      this.debugShowMaterialGrid = false,
      this.showPerformanceOverlay = false,
      this.checkerboardRasterCacheImages = false,
      this.checkerboardOffscreenLayers = false,
      this.showSemanticsDebugger = false,
      this.debugShowCheckedModeBanner = true})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _UIMaterialAppState();
}

class _UIMaterialAppState extends State<UIMaterialApp>
    with WidgetsBindingObserver {
  /// Initializes the widget.
  @override
  @protected
  void initState() {
    super.initState();
    this.widget.init?.call(this.context);
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      this.widget.didInit?.call(this.context);
    });
  }

  /// Called when the widget is disposed.
  @override
  @protected
  void dispose() {
    super.dispose();
    this.widget.dispose?.call(this.context);
    WidgetsBinding.instance.removeObserver(this);
  }

  /// Called when the state of the app is changed.
  ///
  /// [state]: AppLifecycleState.
  @override
  @protected
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.detached:
        this.widget.quit?.call(this.context);
        PathMap.onApplicationQuit();
        break;
      case AppLifecycleState.paused:
        this.widget.pause?.call(this.context);
        PathMap.onApplicationPause(true);
        break;
      case AppLifecycleState.resumed:
        this.widget.unpause?.call(this.context);
        PathMap.onApplicationPause(false);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    RouteConfig._initialize(this.widget.routes);
    return ProviderScope(
      child: FlavorScope(
        flavor: this.widget.flavor,
        child: MaterialApp(
          key: this.widget.key,
          navigatorKey: this.widget.navigatorKey,
          initialRoute: this.widget.initialRoute,
          home: this.widget.home != null ? this.widget.home(context) : null,
          onGenerateRoute: this.widget.home != null
              ? null
              : (settings) => RouteConfig._onGenerateRoute(settings),
          onGenerateInitialRoutes: this.widget.home != null
              ? null
              : (initialRouteName) => RouteConfig._onGenerateInitialRoute(
                  initialRouteName,
                  boot: this.widget.onBootRoute),
          navigatorObservers: [
            if (this.widget.navigatorObservers != null)
              ...this.widget.navigatorObservers,
            UIRouteObserver(),
            UIPage.routeObserver
          ],
          builder: null,
          title: this.widget.title,
          onUnknownRoute: this.widget.onUnknownRoute == null
              ? null
              : (settings) => RouteConfig._onSingleRoute(
                  settings, this.widget.onUnknownRoute),
          color: this.widget.color,
          theme: this.widget.theme?.toThemeData(),
          darkTheme: this.widget.darkTheme?.toThemeData(),
          themeMode: this.widget.themeMode,
          localizationsDelegates: this.widget.localizationsDelegates,
          localeListResolutionCallback:
              this.widget.localeListResolutionCallback,
          localeResolutionCallback: this.widget.localeResolutionCallback,
          supportedLocales: this.widget.supportedLocales,
          debugShowMaterialGrid: this.widget.debugShowMaterialGrid,
          showPerformanceOverlay: this.widget.showPerformanceOverlay,
          checkerboardRasterCacheImages:
              this.widget.checkerboardRasterCacheImages,
          checkerboardOffscreenLayers: this.widget.checkerboardOffscreenLayers,
          showSemanticsDebugger: this.widget.showSemanticsDebugger,
          debugShowCheckedModeBanner: this.widget.debugShowCheckedModeBanner,
        ),
      ),
    );
  }
}

/// Widget to get the flavor.
///
/// You can get the widget with [FlavorScope.of(context)].
class FlavorScope extends InheritedWidget {
  /// Widget to get the flavor.
  ///
  /// You can get the widget with [FlavorScope.of(context)].
  ///
  /// [key]: Key.
  /// [flavor]: Flavor.
  /// [child]: Child widget.
  const FlavorScope({
    Key key,
    this.flavor,
    Widget child,
  }) : super(key: key, child: child);

  /// Get FlavorScope.
  ///
  /// You can check the current Flavor setting.
  static FlavorScope of(BuildContext context) {
    return context.getElementForInheritedWidgetOfExactType()?.widget;
  }

  /// Flavor.
  final String flavor;

  /// True to build on update.
  ///
  /// [oldWidget]: Previous widget.
  @override
  bool updateShouldNotify(FlavorScope oldWidget) {
    return true;
  }
}
