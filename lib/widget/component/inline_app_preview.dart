part of masamune;

class InlineAppPreview extends StatelessWidget {
  const InlineAppPreview({
    this.initialRoute,
    this.controller,
    this.routes,
    this.widgetTheme,
    this.theme,
    this.enableModules = const [],
    this.availableModules = const [],
    this.prefix,
    this.suffix,
  });
  final String? initialRoute;
  final ThemeData? theme;
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
    return AppScope(
      app: appModule ?? context.app,
      child: AdapterScope(
        modelAdapter: enableModules.whereType<ModelAdapter>().firstOrNull ??
            context.model,
        platformAdapter:
            enableModules.whereType<PlatformAdapter>().firstOrNull ??
                context.platform,
        child: RoleScope(
          roles: appModule?.roles ?? context.roles,
          child: WidgetThemeScope(
            widgetTheme: widgetTheme ?? context.widgetTheme,
            child: Theme(
              data: appModule?.themeColor?.toThemeData() ??
                  theme ??
                  context.theme,
              child: InlinePageBuilder(
                prefix: prefix ?? "",
                suffix: suffix ?? "",
                initialRoute: initialRoute,
                controller: controller,
                routes: moduleConfig?.routeSettings?.merge(routes) ?? routes,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
