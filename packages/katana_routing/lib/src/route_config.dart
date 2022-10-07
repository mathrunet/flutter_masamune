part of katana_routing;

/// Key for redirection.
const kRedirectTo = "redirect_to";

/// Key for transition.
const kTransition = "transition";

/// Key for fullscreen.
const kFullscreen = "fullscreen";

/// Key for additional.
const kAdditional = "additional";

/// Class for recording the routing.
///
/// Basically, it is used in [UIMaterialApp] and [InternalPageScopedWidget].
class RouteConfig {
  /// Class for recording the routing.
  ///
  /// Basically, it is used in [UIMaterialApp] and [InternalPageScopedWidget].
  ///
  /// Specify the page widget to pass when the route is loaded in [builder].
  ///
  /// If you set [reroute], you can switch to that route when the condition is met.
  ///
  /// By specifying [platform], you can enable only specific platforms.
  ///
  /// If you set [fullScreen] to [true], the page will be launched in full screen.
  /// You can specify more detailed animation with [transition].
  ///
  /// You can pass arguments to the next page by specifying [parameters].
  /// The [additional] is a special parameter to pass to a new data creation page.
  RouteConfig(
    this.builder, {
    this.fullScreen = false,
    this.parameters = const {},
    this.transition = PageTransition.initial,
    this.additional = false,
    this.reroute = const {},
    this.platform = const {},
  });

  /// Route builder.
  final WidgetBuilder builder;

  /// True to launch in full screen.
  final bool fullScreen;

  /// Transition animation.
  final PageTransition transition;

  /// Parameter to add when switching pages.
  final DynamicMap parameters;

  /// Route definitions by platform.
  ///
  /// By default, the route builder is set.
  final Map<RoutePlatform, WidgetBuilder> platform;

  /// True for pages that add new elements.
  final bool additional;

  /// Map for rerouting according to conditions.
  ///
  /// Enter the redirect path in [String] and enter the condition in the callback.
  ///
  /// If the condition is true, redirect.
  final Map<String, bool Function(BuildContext context)> reroute;

  /// Copy the RouteConfig.
  RouteConfig copyWith({
    WidgetBuilder? builder,
    bool? fullScreen,
    PageTransition? transition,
    DynamicMap? parameters,
    Map<RoutePlatform, WidgetBuilder>? platform,
    bool? additional,
    Map<String, bool Function(BuildContext context)>? reroute,
  }) {
    return RouteConfig(
      builder ?? this.builder,
      fullScreen: fullScreen ?? this.fullScreen,
      transition: transition ?? this.transition,
      parameters: parameters ?? this.parameters,
      platform: platform ?? this.platform,
      additional: additional ?? this.additional,
      reroute: reroute ?? this.reroute,
    );
  }

  /// True if the config has been initialized.
  static bool get isInitialized => _routes.isNotEmpty;
  RegExp? _regex;
  final List<String> _keys = [];
  static final RegExp _keyRegex = RegExp(r"\{([^\}]+)\}");
  static final Map<String, RouteConfig> _routes = {};

  /// Initialize the route.
  static void _initialize(Map<String, RouteConfig> configs) {
    if (isInitialized) {
      return;
    }
    addRoutes(configs);
  }

  /// Add the routes.
  static void addRoutes(Map<String, RouteConfig> configs) {
    configs.forEach((key, value) {
      if (_routes.containsKey(key)) {
        return;
      }
      key = key.replaceAllMapped(_keyRegex, (match) {
        value._keys.add(match.group(1) ?? "");
        return r"([^\/]+?)";
      });
      value._regex = RegExp(r"^" + key + r"$");
      _routes[key] = value;
    });
  }

  /// Remove the routes.
  static void removeRoutes(Map<String, RouteConfig> configs) {
    configs.forEach((key, value) {
      if (!_routes.containsKey(key)) {
        return;
      }
      _routes.remove(key);
    });
  }

  /// Create a new [Route] with [config] and [settings].
  static Route? onSingleRoute(
    BuildContext context,
    RouteSettings settings,
    RouteConfig config,
  ) {
    final map = <String, dynamic>{};
    final arguments = settings.arguments;
    if (arguments is DynamicMap) {
      map.addAll(arguments);
    } else if (arguments is RouteQuery) {
      map.addAll(arguments._parameters);
      switch (arguments._transition) {
        case PageTransition.none:
        case PageTransition.fade:
        case PageTransition.modal:
          map[kTransition] = arguments._transition;
          break;
        case PageTransition.fullscreen:
          map[kTransition] = true;
          map[kTransition] = arguments._transition;
          break;
        default:
          break;
      }
    }
    for (final reroute in config.reroute.entries) {
      if (!reroute.value.call(context)) {
        continue;
      }
      map[kRedirectTo] = settings.name;
      return onGenerateRoute(
        context,
        settings.copyWith(name: reroute.key, arguments: map),
      );
    }
    map[kRedirectTo] = settings.name;
    return UIPageRoute(
      builder: config.builder,
      settings: settings.copyWith(name: settings.name, arguments: map),
    );
  }

  /// Create the first [Route] from [initilRouteName].
  ///
  /// If [boot] is specified, the initialization page can be displayed before the transition to the first [Route].
  static List<Route> _onGenerateInitialRoute(
    BuildContext context,
    String initialRouteName, {
    String? redirectRouteName,
    RouteConfig? boot,
  }) {
    if (boot == null) {
      return const [];
    }
    final map = <String, dynamic>{};
    map[kRedirectTo] = redirectRouteName ?? initialRouteName;
    return [
      UIPageRoute(
        builder: boot.builder,
        settings: RouteSettings(name: initialRouteName, arguments: map),
      ),
    ];
  }

  /// From [settings], create [Route].
  ///
  /// It is also possible to use [onCheckAuthentication] to check for authentication and
  /// skip to [authenticationRoute] if not authenticated.
  static Route? onGenerateRoute(
    BuildContext context,
    RouteSettings settings, {
    // ignore: unused_element
    String? authenticationRoute,
    // ignore: unused_element
    bool Function(BuildContext context)? onCheckAuthentication,
  }) {
    if (_routes.isEmpty) {
      return null;
    }
    final arguments = settings.arguments;
    final name = settings.name ?? "";
    final uri = Uri.parse(name);
    final path = "/${Uri.decodeFull(uri.path).trimString("/")}";
    for (final tmp in _routes.entries) {
      final match = tmp.value._regex?.firstMatch(path);
      if (match == null) {
        continue;
      }
      final map = <String, dynamic>{};
      if (arguments is DynamicMap) {
        map.addAll(arguments);
      } else if (arguments is RouteQuery) {
        map.addAll(arguments._parameters);
        switch (arguments._transition) {
          case PageTransition.none:
          case PageTransition.fade:
          case PageTransition.modal:
            map[kTransition] = arguments._transition;
            break;
          case PageTransition.fullscreen:
            map[kTransition] = true;
            map[kTransition] = arguments._transition;
            break;
          default:
            break;
        }
      }
      map.addAll(tmp.value.parameters);
      map[kTransition] = tmp.value.additional;
      final replacedPath = path.replaceAllMapped(_keyRegex, (match) {
        final key = match.group(1) ?? "";
        if (map.containsKey(key)) {
          return map[key] ?? "";
        }
        return match.group(0) ?? "";
      });
      if (replacedPath.contains("{") || replacedPath.contains("}")) {
        continue;
      }
      for (final reroute in tmp.value.reroute.entries) {
        if (!reroute.value.call(context)) {
          continue;
        }
        map[kRedirectTo] = settings.name;
        return onGenerateRoute(
          context,
          settings.copyWith(name: reroute.key, arguments: map),
        );
      }
      uri.queryParameters.forEach((key, value) => map[key] = value);
      for (int i = 0; i < match.groupCount; i++) {
        if (tmp.value._keys.length <= i) {
          continue;
        }
        final key = tmp.value._keys[i];
        final value = match.group(i + 1) ?? "";
        if (value.startsWith("{") && value.endsWith("}")) {
          continue;
        }
        map[key] = value;
      }
      WidgetBuilder builder = tmp.value.builder;
      for (final platform in tmp.value.platform.entries) {
        switch (platform.key) {
          case RoutePlatform.web:
            if (kIsWeb) {
              builder = platform.value;
            }
            break;
          case RoutePlatform.mobile:
            if (!kIsWeb) {
              builder = platform.value;
            }
            break;
        }
      }
      final transitionType = _transitionType(map, tmp.value);
      if (transitionType == PageTransition.modal) {
        return UIModalRoute(
          builder: builder,
          settings: settings.copyWith(name: settings.name, arguments: map),
        );
      } else {
        return UIPageRoute(
          builder: builder,
          settings: settings.copyWith(name: settings.name, arguments: map),
          transition: transitionType,
        );
      }
    }
    return null;
  }

  static PageTransition _transitionType(DynamicMap map, RouteConfig config) {
    if (map.get(kTransition, PageTransition.initial) == PageTransition.modal ||
        config.transition == PageTransition.modal) {
      return PageTransition.modal;
    } else if (map.get(kTransition, PageTransition.initial) ==
            PageTransition.none ||
        config.transition == PageTransition.none) {
      return PageTransition.none;
    } else if (map.get(kTransition, PageTransition.initial) ==
            PageTransition.fade ||
        config.transition == PageTransition.fade) {
      return PageTransition.fade;
    } else if (map.containsKey(kTransition) ||
        config.fullScreen ||
        config.transition == PageTransition.fullscreen) {
      return PageTransition.fullscreen;
    } else {
      return PageTransition.initial;
    }
  }
}

/// Platform definition.
enum RoutePlatform {
  /// Mobile.
  mobile,

  /// Web.
  web,
}
