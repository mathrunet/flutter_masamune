part of katana_module;

/// Module for configuring the entire application.
@immutable
class AppModule extends Module implements ModuleHook {
  /// Module for configuring the entire application.
  const AppModule({
    required this.title,
    this.logoUrl,
    this.initialRoute = "/",
    this.officialUrl,
    this.supportUrl,
    this.privacyPolicyUrl,
    this.termsUrl,
    this.menus = const [],
    this.lightTheme,
    this.darkTheme,
    this.themeMode = ThemeMode.system,
    this.initialPageTransition = PageTransition.fade,
    this.designType = DesignType.modern,
    this.webStyle = true,
    this.localizationFile = "assets/Localization.csv",
    this.debugShowCheckedModeBanner = true,
    this.splashScreenMinimumDuration = const Duration(seconds: 1),
    this.rerouteConfigs = const [
      LoginRequiredRerouteConfig(),
    ],
    this.bootConfig = const BootConfig(),
    this.userVariables = const [],
    this.unknownPage,
  }) : super();

  /// Page title.
  final String title;

  /// Initial route path.
  final String initialRoute;

  /// Logo Image URL.
  final String? logoUrl;

  /// Menu Settings.
  final List<MenuConfig> menus;

  /// Official Site URL.
  final String? officialUrl;

  /// URL of the support site.
  final String? supportUrl;

  /// Privacy Policy URL.
  final String? privacyPolicyUrl;

  /// URL of Terms of Use.
  final String? termsUrl;

  /// Theme color for light.
  final AppTheme? lightTheme;

  /// Theme color for dark.
  final AppTheme? darkTheme;

  /// Theme Mode.
  final ThemeMode themeMode;

  /// Initial page transition.
  final PageTransition initialPageTransition;

  /// App design type.
  final DesignType designType;

  /// If you want to use the style for web when you are on the web, use `true`.
  final bool webStyle;

  /// Reroute path settings to configure pages that require conditions.
  final List<RerouteConfig> rerouteConfigs;

  /// Boot screen settings.
  final BootConfig bootConfig;

  /// User's value setting.
  final List<VariableConfig> userVariables;

  /// 404 page.
  final Widget? unknownPage;

  /// True when displaying the banner in debug mode.
  final bool debugShowCheckedModeBanner;

  /// Localization file.
  final String localizationFile;

  /// Minimum splash screen time
  final Duration splashScreenMinimumDuration;

  /// Get the AppModule being used.
  static AppModule? get registered {
    if (_registered != null) {
      return _registered!;
    }
    if (Module._registeredModules.isEmpty) {
      return null;
    }
    return Module._registeredModules.whereType<AppModule>().firstOrNull;
  }

  static AppModule? _registered;

  /// Run it the first time the app is launched.
  @override
  @mustCallSuper
  Future<void> onInit(BuildContext context) async {
    await Future.wait(rerouteConfigs.map((e) => e.onInit(context)));
  }

  /// Runs when restoring authentication.
  @override
  @mustCallSuper
  Future<void> onRestoreAuth(BuildContext context) async {
    await Future.wait(rerouteConfigs.map((e) => e.onRestoreAuth(context)));
  }

  /// Runs after authentication has taken place.
  ///
  /// It is also called after registration or login has been completed.
  @override
  @mustCallSuper
  Future<void> onAfterAuth(BuildContext context) async {
    await Future.wait(rerouteConfigs.map((e) => e.onAfterAuth(context)));
  }

  /// It is executed after the boot process is finished and
  /// before transitioning to another page.
  @override
  @mustCallSuper
  Future<void> onBeforeFinishBoot(BuildContext context) async {
    await Future.wait(rerouteConfigs.map((e) => e.onBeforeFinishBoot(context)));
  }

  /// It is executed after the boot process is finished and
  /// after transitioning to another page.
  @override
  @mustCallSuper
  Future<void> onAfterFinishBoot(BuildContext context) async {
    await Future.wait(rerouteConfigs.map((e) => e.onAfterFinishBoot(context)));
  }
}
