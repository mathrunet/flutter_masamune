part of katana_routing;

/// Widget which extended [MaterialApp] for Path.
class UIMaterialApp extends StatelessWidget {
  /// Widget which extended [MaterialApp] for Path.
  const UIMaterialApp({
    Key? key,
    this.flavor = "",
    this.home,
    this.navigatorKey,
    this.routes = const <String, RouteConfig>{},
    this.initialRoute = "/",
    this.homeRoute,
    this.navigatorObservers = const <NavigatorObserver>[],
    this.title = "",
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
    this.supportedLocales = const <Locale>[
      Locale("en"),
      Locale("ja"),
      Locale("zh"),
    ],
    this.debugShowMaterialGrid = false,
    this.showPerformanceOverlay = false,
    this.checkerboardRasterCacheImages = false,
    this.checkerboardOffscreenLayers = false,
    this.showSemanticsDebugger = false,
    this.builder,
    this.debugShowCheckedModeBanner = true,
    this.minTextScaleFactor = 0.8,
    this.maxTextScaleFactor = 1.2,
    this.designType = DesignType.modern,
    this.webStyle = true,
    this.providerContainer,
  }) : super(key: key);

  final ProviderContainer? providerContainer;
  final DesignType designType;
  final bool webStyle;
  final String flavor;
  final double minTextScaleFactor;
  final double maxTextScaleFactor;
  final WidgetBuilder? home;
  final Widget Function(BuildContext, Widget?)? builder;
  final GlobalKey<NavigatorState>? navigatorKey;
  final Map<String, RouteConfig> routes;
  final String initialRoute;
  final String? homeRoute;
  final List<NavigatorObserver> navigatorObservers;
  final String title;
  final RouteFactory? onGenerateTitle;
  final RouteConfig? onUnknownRoute;
  final RouteConfig? onBootRoute;
  final Color? color;
  final AppTheme? theme;
  final AppTheme? darkTheme;
  final ThemeMode themeMode;
  final Locale? locale;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final Locale? Function(List<Locale>?, Iterable<Locale>)?
      localeListResolutionCallback;
  final Locale? Function(Locale?, Iterable<Locale>)? localeResolutionCallback;
  final Iterable<Locale> supportedLocales;
  final bool debugShowMaterialGrid;
  final bool showPerformanceOverlay;
  final bool checkerboardRasterCacheImages;
  final bool checkerboardOffscreenLayers;
  final bool showSemanticsDebugger;
  final bool debugShowCheckedModeBanner;

  /// Describes the part of the user interface represented by this widget.
  ///
  /// The framework calls this method when this widget is inserted into the tree
  /// in a given [BuildContext] and when the dependencies of this widget change
  /// (e.g., an [InheritedWidget] referenced by this widget changes). This
  /// method can potentially be called in every frame and should not have any side
  /// effects beyond building a widget.
  ///
  /// The framework replaces the subtree below this widget with the widget
  /// returned by this method, either by updating the existing subtree or by
  /// removing the subtree and inflating a new subtree, depending on whether the
  /// widget returned by this method can update the root of the existing
  /// subtree, as determined by calling [Widget.canUpdate].
  ///
  /// Typically implementations return a newly created constellation of widgets
  /// that are configured with information from this widget's constructor and
  /// from the given [BuildContext].
  ///
  /// The given [BuildContext] contains information about the location in the
  /// tree at which this widget is being built. For example, the context
  /// provides the set of inherited widgets for this location in the tree. A
  /// given widget might be built with multiple different [BuildContext]
  /// arguments over time if the widget is moved around the tree or if the
  /// widget is inserted into the tree in multiple places at once.
  ///
  /// The implementation of this method must only depend on:
  ///
  /// * the fields of the widget, which themselves must not change over time,
  ///   and
  /// * any ambient state obtained from the `context` using
  ///   [BuildContext.dependOnInheritedWidgetOfExactType].
  ///
  /// If a widget's [build] method is to depend on anything else, use a
  /// [StatefulWidget] instead.
  ///
  /// See also:
  ///
  ///  * [StatelessWidget], which contains the discussion on performance considerations.
  @override
  Widget build(BuildContext context) {
    // Config.initialize(flavor: flavor, enableMockup: enableMockup);
    RouteConfig._initialize(routes);
    return UncontrolledProviderScope(
      container: providerContainer ?? AppScoped.providerContainer,
      child: FlavorScope(
        flavor: flavor,
        child: DesignTypeScope(
          designType: designType,
          webStyle: webStyle,
          child: _MaterialApp(
            minTextScaleFactor: minTextScaleFactor,
            maxTextScaleFactor: maxTextScaleFactor,
            home: home,
            builder: builder,
            navigatorKey: navigatorKey,
            initialRoute: initialRoute,
            homeRoute: homeRoute,
            navigatorObservers: navigatorObservers,
            title: title,
            onGenerateTitle: onGenerateTitle,
            onUnknownRoute: onUnknownRoute,
            onBootRoute: onBootRoute,
            color: color,
            theme: theme,
            darkTheme: darkTheme,
            themeMode: themeMode,
            locale: locale,
            localizationsDelegates: localizationsDelegates,
            localeListResolutionCallback: localeListResolutionCallback,
            localeResolutionCallback: localeResolutionCallback,
            supportedLocales: supportedLocales,
            debugShowMaterialGrid: debugShowMaterialGrid,
            showPerformanceOverlay: showPerformanceOverlay,
            checkerboardRasterCacheImages: checkerboardRasterCacheImages,
            checkerboardOffscreenLayers: checkerboardOffscreenLayers,
            showSemanticsDebugger: showSemanticsDebugger,
            debugShowCheckedModeBanner: debugShowCheckedModeBanner,
          ),
        ),
      ),
    );
  }
}

class _MaterialApp extends ConsumerWidget {
  const _MaterialApp({
    Key? key,
    this.home,
    this.navigatorKey,
    this.initialRoute = "/",
    this.navigatorObservers = const <NavigatorObserver>[],
    this.title = "",
    this.onGenerateTitle,
    this.onUnknownRoute,
    this.onBootRoute,
    this.color,
    this.theme,
    this.darkTheme,
    this.homeRoute,
    this.themeMode = ThemeMode.system,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[
      Locale("en"),
      Locale("ja"),
      Locale("zh"),
    ],
    this.debugShowMaterialGrid = false,
    this.showPerformanceOverlay = false,
    this.checkerboardRasterCacheImages = false,
    this.checkerboardOffscreenLayers = false,
    this.showSemanticsDebugger = false,
    this.builder,
    this.debugShowCheckedModeBanner = true,
    this.minTextScaleFactor = 0.8,
    this.maxTextScaleFactor = 1.2,
  }) : super(key: key);

  final double minTextScaleFactor;
  final double maxTextScaleFactor;
  final WidgetBuilder? home;
  final Widget Function(BuildContext, Widget?)? builder;
  final GlobalKey<NavigatorState>? navigatorKey;
  final String initialRoute;
  final String? homeRoute;
  final List<NavigatorObserver> navigatorObservers;
  final String title;
  final RouteFactory? onGenerateTitle;
  final RouteConfig? onUnknownRoute;
  final RouteConfig? onBootRoute;
  final Color? color;
  final AppTheme? theme;
  final AppTheme? darkTheme;
  final ThemeMode themeMode;
  final Locale? locale;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;
  final Locale? Function(List<Locale>?, Iterable<Locale>)?
      localeListResolutionCallback;
  final Locale? Function(Locale?, Iterable<Locale>)? localeResolutionCallback;
  final Iterable<Locale> supportedLocales;
  final bool debugShowMaterialGrid;
  final bool showPerformanceOverlay;
  final bool checkerboardRasterCacheImages;
  final bool checkerboardOffscreenLayers;
  final bool showSemanticsDebugger;
  final bool debugShowCheckedModeBanner;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      key: key,
      navigatorKey: navigatorKey,
      initialRoute: initialRoute,
      home: home?.call(context),
      onGenerateRoute: home != null
          ? null
          : (settings) => RouteConfig.onGenerateRoute(context, settings),
      onGenerateInitialRoutes: home != null
          ? null
          : (initialRouteName) => RouteConfig._onGenerateInitialRoute(
                context,
                homeRoute ?? initialRouteName,
                boot: onBootRoute,
              ),
      navigatorObservers: [
        ...navigatorObservers,
      ],
      builder: (context, child) {
        final platformFactor = MediaQuery.of(context).textScaleFactor;
        final mediaQuery = MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: platformFactor.limit(
              minTextScaleFactor,
              maxTextScaleFactor,
            ),
          ),
          child: child ?? const SizedBox(),
        );
        if (builder != null) {
          return builder!.call(context, mediaQuery);
        }
        return mediaQuery;
      },
      title: title,
      onUnknownRoute: onUnknownRoute == null
          ? null
          : (settings) =>
              RouteConfig.onSingleRoute(context, settings, onUnknownRoute!),
      color: color,
      theme: theme?.toThemeData(),
      darkTheme: darkTheme?.toThemeData(),
      themeMode: themeMode,
      localeListResolutionCallback: localeListResolutionCallback,
      localeResolutionCallback: localeResolutionCallback,
      debugShowMaterialGrid: debugShowMaterialGrid,
      showPerformanceOverlay: showPerformanceOverlay,
      checkerboardRasterCacheImages: checkerboardRasterCacheImages,
      checkerboardOffscreenLayers: checkerboardOffscreenLayers,
      showSemanticsDebugger: showSemanticsDebugger,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        if (localizationsDelegates != null) ...localizationsDelegates!,
      ],
      supportedLocales: supportedLocales,
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
  const FlavorScope({
    Key? key,
    required this.flavor,
    required Widget child,
  }) : super(key: key, child: child);

  /// Get FlavorScope.
  ///
  /// You can check the current Flavor setting.
  static FlavorScope of(BuildContext context) {
    return context
        .getElementForInheritedWidgetOfExactType<FlavorScope>()!
        .widget as FlavorScope;
  }

  /// Flavor.
  final String flavor;

  /// Whether the framework should notify widgets that inherit from this widget.
  ///
  /// When this widget is rebuilt, sometimes we need to rebuild the widgets that inherit from this widget but sometimes we do not. For example,
  /// if the data held by this widget is the same as the data held by oldWidget, then we do not need to rebuild the widgets that inherited the data held by oldWidget.
  ///
  /// The framework distinguishes these cases by calling this function with the widget that previously occupied this location in the tree as an argument.
  /// The given widget is guaranteed to have the same [runtimeType] as this object.
  @override
  bool updateShouldNotify(FlavorScope oldWidget) {
    return true;
  }
}

/// Widget to get the design type.
///
/// You can get the widget with [DesignTypeScope.of(context)].
class DesignTypeScope extends InheritedWidget {
  /// Widget to get the design type.
  ///
  /// You can get the widget with [DesignTypeScope.of(context)].
  const DesignTypeScope({
    Key? key,
    required this.designType,
    required this.webStyle,
    required Widget child,
  }) : super(key: key, child: child);

  /// Get DesignTypeScope.
  ///
  /// You can check the current whdget theme setting.
  static DesignTypeScope of(BuildContext context) {
    return context
        .getElementForInheritedWidgetOfExactType<DesignTypeScope>()!
        .widget as DesignTypeScope;
  }

  /// Design type.
  final DesignType designType;

  /// If you want to use the style for web when you are on the web, use `true`.
  final bool webStyle;

  /// Whether the framework should notify widgets that inherit from this widget.
  ///
  /// When this widget is rebuilt, sometimes we need to rebuild the widgets that inherit from this widget but sometimes we do not. For example,
  /// if the data held by this widget is the same as the data held by oldWidget, then we do not need to rebuild the widgets that inherited the data held by oldWidget.
  ///
  /// The framework distinguishes these cases by calling this function with the widget that previously occupied this location in the tree as an argument.
  /// The given widget is guaranteed to have the same [runtimeType] as this object.
  @override
  bool updateShouldNotify(DesignTypeScope oldWidget) {
    return true;
  }
}
