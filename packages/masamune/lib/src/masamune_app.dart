part of masamune;

@immutable
class MasamuneApp extends StatelessWidget {
  const MasamuneApp({
    super.key,
    this.appRef,
    this.localize,
    this.routerConfig,
    this.modelAdapter = const RuntimeModelAdapter(),
    this.debugShowCheckedModeBanner = true,
    this.showPerformanceOverlay = false,
    this.title = "",
    this.themeMode = ThemeMode.system,
    this.routes = const <String, WidgetBuilder>{},
    this.navigatorObservers = const <NavigatorObserver>[],
    this.theme,
    this.scaffoldMessengerKey,
    this.onGenerateTitle,
    this.color,
    this.home,
    this.initialRoute,
    this.onGenerateRoute,
    this.onGenerateInitialRoutes,
    this.onUnknownRoute,
    this.builder,
  });

  final AppRef? appRef;
  final AppThemeData? theme;
  final ModelAdapter? modelAdapter;
  final AppLocalizeBase? localize;
  final RouterConfig<Object>? routerConfig;

  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;
  final bool debugShowCheckedModeBanner;
  final bool showPerformanceOverlay;
  final String title;
  final String Function(BuildContext)? onGenerateTitle;
  final Color? color;
  final ThemeMode? themeMode;
  final Widget? home;
  final Map<String, Widget Function(BuildContext)> routes;
  final String? initialRoute;
  final Route<dynamic>? Function(RouteSettings)? onGenerateRoute;
  final List<Route<dynamic>> Function(String)? onGenerateInitialRoutes;
  final Route<dynamic>? Function(RouteSettings)? onUnknownRoute;
  final List<NavigatorObserver> navigatorObservers;
  final Widget Function(BuildContext, Widget?)? builder;

  @override
  Widget build(BuildContext context) {
    return buildModelAdapter(
      context,
      buildAppScoped(
        context,
        buildAppTheme(
          context,
          buildAppLocalize(
            context,
            buildAppRouter(context),
          ),
        ),
      ),
    );
  }

  Widget buildModelAdapter(BuildContext context, Widget child) {
    if (modelAdapter != null) {
      return ModelAdapterScope(
        adapter: modelAdapter!,
        child: child,
      );
    }
    return child;
  }

  Widget buildAppScoped(BuildContext context, Widget child) {
    if (appRef != null) {
      return AppScoped(
        appRef: appRef!,
        child: child,
      );
    }
    return child;
  }

  Widget buildAppTheme(BuildContext context, Widget child) {
    if (theme != null) {
      return AppThemeScope(
        theme: theme!,
        child: child,
      );
    }
    return child;
  }

  Widget buildAppLocalize(BuildContext context, Widget child) {
    if (localize != null) {
      return LocalizeScope(
        localize: localize!,
        builder: (context, localize) => child,
      );
    }
    return child;
  }

  Widget buildAppRouter(BuildContext context) {
    if (routerConfig != null) {
      return MaterialApp.router(
        routerConfig: routerConfig,
        locale: localize?.locale,
        supportedLocales:
            localize?.supportedLocales() ?? const [Locale('en', 'US')],
        localizationsDelegates: localize?.delegates(),
        localeResolutionCallback: localize?.localeResolutionCallback(),
        theme: theme?.toThemeData(),
        debugShowCheckedModeBanner: debugShowCheckedModeBanner,
        showPerformanceOverlay: showPerformanceOverlay,
        scaffoldMessengerKey: scaffoldMessengerKey,
        title: title,
        onGenerateTitle: onGenerateTitle,
        color: color,
        themeMode: themeMode,
        builder: builder,
      );
    } else {
      return MaterialApp(
        locale: localize?.locale,
        supportedLocales:
            localize?.supportedLocales() ?? const [Locale('en', 'US')],
        localizationsDelegates: localize?.delegates(),
        localeResolutionCallback: localize?.localeResolutionCallback(),
        theme: theme?.toThemeData(),
        scaffoldMessengerKey: scaffoldMessengerKey,
        title: title,
        onGenerateTitle: onGenerateTitle,
        color: color,
        themeMode: themeMode,
        home: home,
        routes: routes,
        initialRoute: initialRoute,
        onGenerateRoute: onGenerateRoute,
        onGenerateInitialRoutes: onGenerateInitialRoutes,
        onUnknownRoute: onUnknownRoute,
        navigatorObservers: navigatorObservers,
        builder: builder,
      );
    }
  }
}
