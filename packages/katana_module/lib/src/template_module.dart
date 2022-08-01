part of katana_module;

/// Group module for creating application templates.
@immutable
abstract class TemplateModule extends GroupModule {
  /// Group module for creating application templates.
  const TemplateModule({
    this.mockUserId = "Fa4utmTazAd5FcxLZr5W5A8Jt6ahE6Be",
    this.mockData = const {},
  });

  /// Mock userId.
  final String mockUserId;

  /// Mock data.
  final Map<String, Map<String, dynamic>> mockData;

  /// App Module.
  AppModule get app;

  /// Model adapter.
  ModelAdapter get model;

  /// Platform adapter.
  PlatformAdapter get platform;

  /// List of page modules.
  List<PageModule> get pages;

  /// List of other modules.
  List<Module> get plugins;

  /// Set other widgets, if any.
  Map<String, Widget> get routes;

  /// Settings to reroute the page.
  List<RerouteConfig> get reroutes;

  /// Module tags list.
  List<ModuleTag> get moduleTags;

  /// List of modules that are grouped.
  @override
  @protected
  @mustCallSuper
  List<Module> get modules => [
        app,
        model,
        platform,
        ...plugins,
        ...pages,
        if (routes.isNotEmpty)
          RouteModule(
            routes,
          ),
      ];
}
