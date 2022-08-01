part of katana_module;

/// Page module for rerouting.
///
/// When accessing [routePath], [rerouteConfigs] will take the user to a different page.
///
/// Use it for access destination changes due to roles, etc.
@immutable
class RerouteModule extends PageModule {
  /// Page module for rerouting.
  ///
  /// When accessing [routePath], [rerouteConfigs] will take the user to a different page.
  ///
  /// Use it for access destination changes due to roles, etc.
  const RerouteModule(
    this.routePath,
    List<RerouteConfig> rerouteConfigs, {
    bool enabled = true,
  }) : super(
          enabled: enabled,
          verifyAppReroute: false,
          rerouteConfigs: rerouteConfigs,
        );

  /// Root path to be monitored.
  final String routePath;

  @override
  List<PageConfig<Widget>> get pages => [
        PageConfig(routePath, const SizedBox()),
      ];
}
