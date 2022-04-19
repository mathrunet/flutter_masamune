part of masamune;

class InlineAppPreview extends StatelessWidget {
  const InlineAppPreview({
    this.initialRoute,
    this.controller,
    this.routes,
    this.widgetTheme,
    this.lightTheme,
    this.darkTheme,
    this.enableModules = const [],
    this.availableModules = const [],
    this.prefix,
    this.suffix,
  });
  final String? initialRoute;
  final ThemeData? lightTheme;
  final ThemeData? darkTheme;
  final NavigatorController? controller;
  final Map<String, RouteConfig>? routes;
  final WidgetTheme? widgetTheme;
  final List<Module> enableModules;
  final List<Module> availableModules;
  final String? prefix;
  final String? suffix;

  @override
  Widget build(BuildContext context) {
    Module.registerModules([
      ...enableModules,
      ...availableModules,
    ]);
    final moduleConfig = PageModule.merge(enableModules);
    final appModule = enableModules.whereType<AppModule>().firstOrNull;
    final brightness = MediaQuery.platformBrightnessOf(context);
    return AppScope(
      app: appModule ?? context.app,
      child: AdapterScope(
        plugin: AdapterPlugins(
          ads: enableModules.whereType<AdsAdapter>().firstOrNull ??
              context.plugin?.ads,
          purchase: enableModules.whereType<PurchaseAdapter>().firstOrNull ??
              context.plugin?.purchase,
          messaging: enableModules.whereType<MessagingAdapter>().firstOrNull ??
              context.plugin?.messaging,
          streaming: enableModules.whereType<StreamingAdapter>().firstOrNull ??
              context.plugin?.streaming,
          location: enableModules.whereType<LocationAdapter>().firstOrNull ??
              context.plugin?.location,
        ),
        modelAdapter: enableModules.whereType<ModelAdapter>().firstOrNull ??
            context.model,
        platformAdapter:
            enableModules.whereType<PlatformAdapter>().firstOrNull ??
                context.platform,
        child: WidgetThemeScope(
          widgetTheme: widgetTheme ?? context.widgetTheme,
          child: Theme(
            data: (brightness == Brightness.light
                    ? (appModule?.lightTheme?.toThemeData() ?? lightTheme)
                    : (appModule?.darkTheme?.toThemeData() ?? darkTheme)) ??
                context.theme,
            child: InlinePageBuilder(
              prefix: prefix ?? "",
              suffix: suffix ?? "",
              initialRoute: initialRoute,
              controller: controller,
              routes: moduleConfig?.routeSettings.merge(routes) ?? routes,
            ),
          ),
        ),
      ),
    );
  }
}
