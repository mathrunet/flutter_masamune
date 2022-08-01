part of katana_module;

/// Widget which extended [MaterialApp] for Path.
class UIModuleMaterialApp extends StatelessWidget {
  /// Widget which extended [MaterialApp] for Path.
  const UIModuleMaterialApp({
    Key? key,
    this.flavor = "",
    this.home,
    this.navigatorKey,
    this.routes = const <String, RouteConfig>{},
    this.initialRoute = "/",
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
    this.enableModules = const [],
    this.availableModules = const [],
    this.designType = DesignType.modern,
    this.webStyle = true,
    this.moduleTags = const [
      _ContextModuleTag(),
      _UserModuleTag(),
      _DocumentModuleTag(),
      _CollectionModuleTag(),
    ],
  }) : super(key: key);

  final DesignType designType;
  final bool webStyle;
  final String flavor;
  final double minTextScaleFactor;
  final double maxTextScaleFactor;
  final List<ModuleTag> moduleTags;
  final WidgetBuilder? home;
  final Widget Function(BuildContext, Widget?)? builder;
  final GlobalKey<NavigatorState>? navigatorKey;
  final Map<String, RouteConfig> routes;
  final String initialRoute;
  final List<NavigatorObserver> navigatorObservers;
  final String title;
  final RouteFactory? onGenerateTitle;
  final RouteConfig? onUnknownRoute;
  final RouteConfig? onBootRoute;
  final List<Module> enableModules;
  final List<Module> availableModules;
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
  Widget build(BuildContext context) {
    final enableModules = GroupModule._extractModules(this.enableModules);
    final availableModules = GroupModule._extractModules(this.availableModules);
    Module.registerModules([
      ...enableModules,
      ...availableModules,
    ]);
    final appModule = enableModules.whereType<AppModule>().firstOrNull;
    final moduleConfig = PageModule.merge(enableModules);
    final analytics = enableModules.whereType<AnalyticsAdapter>().firstOrNull;
    final template = this.enableModules.whereType<TemplateModule>().firstOrNull;
    return AppScope(
      app: appModule,
      template: template,
      child: AdapterScope(
        modelAdapter: enableModules.whereType<ModelAdapter>().firstOrNull,
        platformAdapter: enableModules.whereType<PlatformAdapter>().firstOrNull,
        plugin: AdapterPlugins(
          analytics: analytics,
          ads: enableModules.whereType<AdsAdapter>().firstOrNull,
          purchase: enableModules.whereType<PurchaseAdapter>().firstOrNull,
          messaging: enableModules.whereType<MessagingAdapter>().firstOrNull,
          location: enableModules.whereType<LocationAdapter>().firstOrNull,
          streaming: enableModules.whereType<StreamingAdapter>().firstOrNull,
          dynamicLinks:
              enableModules.whereType<DynamicLinksAdapter>().firstOrNull,
          marketPlace:
              enableModules.whereType<MarketPlaceAdapter>().firstOrNull,
          signIns: enableModules.whereType<SignInAdapter>().toList(),
          functions: enableModules.whereType<FunctionAdapter>().toList(),
        ),
        child: _ModuleTagScope(
          tags: [
            if (template != null) ...template.moduleTags,
            ...moduleTags,
          ],
          child: UIMaterialApp(
            key: key,
            designType: appModule?.designType ?? designType,
            webStyle: appModule?.webStyle ?? webStyle,
            flavor: flavor,
            home: home,
            navigatorKey: navigatorKey,
            routes: moduleConfig?.routeSettings.merge(routes) ?? routes,
            initialRoute: appModule?.initialRoute ?? initialRoute,
            navigatorObservers: [
              if (analytics?.observer != null) analytics!.observer!,
              ...navigatorObservers,
            ],
            title: appModule?.title ?? moduleConfig?.title ?? title,
            onGenerateTitle: onGenerateTitle,
            onUnknownRoute: appModule?.unknownPage != null
                ? RouteConfig((_) => appModule!.unknownPage!)
                : onUnknownRoute,
            onBootRoute: appModule?.bootConfig.bootPage != null
                ? RouteConfig((_) => appModule!.bootConfig.bootPage!)
                : onBootRoute,
            color: color,
            theme: appModule?.lightTheme ?? theme,
            darkTheme: appModule?.darkTheme ?? darkTheme,
            themeMode: appModule?.themeMode ?? themeMode,
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
            builder: builder,
            debugShowCheckedModeBanner: appModule?.debugShowCheckedModeBanner ??
                debugShowCheckedModeBanner,
            minTextScaleFactor: minTextScaleFactor,
            maxTextScaleFactor: maxTextScaleFactor,
          ),
        ),
      ),
    );
  }
}

class _ModuleTagScope extends InheritedWidget {
  const _ModuleTagScope({
    Key? key,
    this.tags = const [],
    required Widget child,
  }) : super(key: key, child: child);

  final List<ModuleTag> tags;

  static List<ModuleTag> of(BuildContext context) {
    return (context
                .getElementForInheritedWidgetOfExactType<_ModuleTagScope>()
                ?.widget as _ModuleTagScope?)
            ?.tags ??
        [];
  }

  /// Whether the framework should notify widgets that inherit from this widget.
  ///
  /// When widget: widget, sometimes we need to rebuild the widgets that inherit from widget: widget,
  /// if the data held by widget: widget, then we do not need to rebuild the widgets that inherited the data held by oldWidget.
  ///
  /// The framework distinguishes these cases by calling this function with the widget that previously occupied this location in the tree as an argument.
  /// The given widget is guaranteed to have the same [runtimeType] as this object.
  @override
  bool updateShouldNotify(_ModuleTagScope oldWidget) {
    return true;
  }
}

/// Widget to get the adapter.
///
/// You can get the widget with [AdapterScope.of(context)].
class AdapterScope extends InheritedWidget {
  /// Widget to get the adapter.
  ///
  /// You can get the widget with [AdapterScope.of(context)].
  const AdapterScope({
    Key? key,
    required this.modelAdapter,
    required this.plugin,
    required this.platformAdapter,
    required Widget child,
  }) : super(key: key, child: child);

  /// Get AdapterScope.
  ///
  /// You can check the current Adapter setting.
  static AdapterScope? of(BuildContext context) {
    return context
        .getElementForInheritedWidgetOfExactType<AdapterScope>()
        ?.widget as AdapterScope?;
  }

  /// Model adapter.
  final ModelAdapter? modelAdapter;

  /// Adapter plugins.
  final AdapterPlugins plugin;

  /// Platform adapter.
  final PlatformAdapter? platformAdapter;

  /// Whether the framework should notify widgets that inherit from this widget.
  ///
  /// When widget: widget, sometimes we need to rebuild the widgets that inherit from widget: widget,
  /// if the data held by widget: widget, then we do not need to rebuild the widgets that inherited the data held by oldWidget.
  ///
  /// The framework distinguishes these cases by calling this function with the widget that previously occupied this location in the tree as an argument.
  /// The given widget is guaranteed to have the same [runtimeType] as this object.
  @override
  bool updateShouldNotify(AdapterScope oldWidget) {
    return true;
  }
}

/// Adapter for plug-in.
class AdapterPlugins {
  /// Adapter for plug-in.
  const AdapterPlugins({
    this.ads,
    this.purchase,
    this.messaging,
    this.streaming,
    this.location,
    this.analytics,
    this.dynamicLinks,
    this.marketPlace,
    this.signIns = const [],
    this.functions = const [],
  });

  /// Function adapters.
  final List<FunctionAdapter> functions;

  /// The SignIn adapters.
  final List<SignInAdapter> signIns;

  /// Ads adapter.
  final AdsAdapter? ads;

  /// Analytics adapter.
  final AnalyticsAdapter? analytics;

  /// Purchasing adapter.
  final PurchaseAdapter? purchase;

  /// Messaging adapter.
  final MessagingAdapter? messaging;

  /// Streaming  adapter.
  final StreamingAdapter? streaming;

  /// Location adapter.
  final LocationAdapter? location;

  /// Dynamic links adapter.
  final DynamicLinksAdapter? dynamicLinks;

  /// Market place adapter.
  final MarketPlaceAdapter? marketPlace;

  /// The SignIn adapter corresponding to [providerId].
  SignInAdapter? signIn(String providerId) {
    return signIns.firstWhereOrNull((item) => item.provider == providerId);
  }
}

/// Widget to get the app module.
///
/// You can get the widget with [AppScope.of(context)].
class AppScope extends InheritedWidget {
  /// Widget to get the app module.
  ///
  /// You can get the widget with [AppScope.of(context)].
  const AppScope({
    Key? key,
    required this.app,
    this.template,
    required Widget child,
  }) : super(key: key, child: child);

  /// Get AppScope.
  ///
  /// You can check the current App Module setting.
  static AppScope? of(BuildContext context) {
    return context.getElementForInheritedWidgetOfExactType<AppScope>()?.widget
        as AppScope?;
  }

  /// App module.
  final AppModule? app;

  final TemplateModule? template;

  /// Whether the framework should notify widgets that inherit from this widget.
  ///
  /// When widget: widget, sometimes we need to rebuild the widgets that inherit from widget: widget,
  /// if the data held by widget: widget, then we do not need to rebuild the widgets that inherited the data held by oldWidget.
  ///
  /// The framework distinguishes these cases by calling this function with the widget that previously occupied this location in the tree as an argument.
  /// The given widget is guaranteed to have the same [runtimeType] as this object.
  @override
  bool updateShouldNotify(AppScope oldWidget) {
    return true;
  }
}
