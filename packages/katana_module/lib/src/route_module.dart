part of katana_module;

/// Page module for storing routing information.
///
/// It is possible to handle pages outside the module by putting your own page widgets etc. on the routing information.
@immutable
class RouteModule extends PageModule {
  /// Page module for storing routing information.
  ///
  /// It is possible to handle pages outside the module by putting your own page widgets etc. on the routing information.
  const RouteModule(
    this.route, {
    bool enabled = true,
    bool verifyAppReroute = true,
    List<RerouteConfig> rerouteConfigs = const [],
  }) : super(
          enabled: enabled,
          verifyAppReroute: verifyAppReroute,
          rerouteConfigs: rerouteConfigs,
        );

  /// Route setting.
  final Map<String, Widget> route;

  @override
  List<PageConfig<Widget>> get pages => route.toList((key, value) {
        return PageConfig(key, value);
      }).toList();
}
