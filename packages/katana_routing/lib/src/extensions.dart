part of katana_routing;

/// Extended method for Navigator.
extension NavigatorStateExtensions on NavigatorState {
  /// Pops the page to the page with the specified path.
  ///
  /// Enter the pathname of the page in [name].
  void popUntilNamed(String name) {
    popUntil((route) {
      return route.settings.name == name;
    });
  }

  /// Reset all history and go to a specific page.
  ///
  /// After all pages are [pop()],
  /// the page specified by [newRouteName] is [pushNamed()].
  ///
  /// In [arguments], put [RouteQuery] and so on.
  ///
  /// Ideal for moving after logging out.
  Future<T?> resetAndPushNamed<T extends Object?>(
    String newRouteName, {
    Object? arguments,
  }) {
    return pushNamedAndRemoveUntil(
      newRouteName,
      (route) => false,
      arguments: arguments,
    );
  }

  /// Pops the page to the page with the specified path.
  ///
  /// Enter the pathname of the page in [name].
  void popUntilPage(PageQuery pageQuery) {
    return popUntilNamed(pageQuery.toString());
  }

  /// Reset all history and go to a specific page.
  ///
  /// After all pages are [pop()],
  /// the page specified by [newRouteName] is [pushNamed()].
  ///
  /// In [arguments], put [RouteQuery] and so on.
  ///
  /// Ideal for moving after logging out.
  Future<T?> resetAndPushPage<T extends Object?>(
    PageQuery newRoutePage, {
    RouteQuery? arguments,
  }) {
    return resetAndPushNamed<T>(
      newRoutePage.toString(),
      arguments: _arguments(newRoutePage, arguments),
    );
  }

  /// Pop the current route off the navigator and push a named route in its place.
  Future<T?> popAndPushPage<T extends Object?, TO extends Object?>(
    PageQuery routePage, {
    TO? result,
    RouteQuery? arguments,
  }) {
    return popAndPushNamed<T, TO>(
      routePage.toString(),
      result: result,
      arguments: _arguments(routePage, arguments),
    );
  }

  /// Push a named route onto the navigator.
  Future<T?> pushPage<T extends Object?>(
    PageQuery routePage, {
    RouteQuery? arguments,
  }) {
    return pushNamed<T>(
      routePage.toString(),
      arguments: _arguments(routePage, arguments),
    );
  }

  /// Push the route with the given name onto the navigator,
  /// and then remove all the previous routes until the predicate returns true.
  Future<T?> pushPageAndRemoveUntil<T extends Object?>(
    PageQuery newRoutePage,
    RoutePredicate predicate, {
    RouteQuery? arguments,
  }) {
    return pushNamedAndRemoveUntil<T>(
      newRoutePage.toString(),
      predicate,
      arguments: _arguments(newRoutePage, arguments),
    );
  }

  /// Replace the current route of the navigator by pushing the route named [routeName] and then disposing the previous route once the new route has finished animating in.
  Future<T?> pushReplacementPage<T extends Object?, TO extends Object?>(
    PageQuery routePage, {
    TO? result,
    RouteQuery? arguments,
  }) {
    return pushReplacementNamed<T, TO>(
      routePage.toString(),
      result: result,
      arguments: _arguments(routePage, arguments),
    );
  }

  /// Pop the current route off the navigator and push a named route in its place.
  String restorablePopAndPushPage<T extends Object?, TO extends Object?>(
    PageQuery routePage, {
    TO? result,
    RouteQuery? arguments,
  }) {
    return restorablePopAndPushNamed<T, TO>(
      routePage.toString(),
      result: result,
      arguments: _arguments(routePage, arguments),
    );
  }

  /// Push a named route onto the navigator.
  String restorablePushPage<T extends Object?>(
    PageQuery routePage, {
    RouteQuery? arguments,
  }) {
    return restorablePushNamed<T>(
      routePage.toString(),
      arguments: _arguments(routePage, arguments),
    );
  }

  /// Push the route with the given name onto the navigator,
  /// and then remove all the previous routes until the predicate returns true.
  String restorablePushPageAndRemoveUntil<T extends Object?>(
    PageQuery newRoutePage,
    RoutePredicate predicate, {
    RouteQuery? arguments,
  }) {
    return restorablePushNamedAndRemoveUntil<T>(
      newRoutePage.toString(),
      predicate,
      arguments: _arguments(newRoutePage, arguments),
    );
  }

  /// Replace the current route of the navigator by pushing the route named [routeName] and then disposing the previous route once the new route has finished animating in.
  String restorablePushReplacementPage<T extends Object?, TO extends Object?>(
    PageQuery routePage, {
    TO? result,
    RouteQuery? arguments,
  }) {
    return restorablePushReplacementNamed<T, TO>(
      routePage.toString(),
      result: result,
      arguments: _arguments(routePage, arguments),
    );
  }

  Object? _arguments(PageQuery query, Object? arguments) {
    if (arguments is DynamicMap) {
      return <String, dynamic>{
        ...query.toArguments(),
        ...arguments,
      };
    } else if (arguments is RouteQuery) {
      return arguments.copyWith(
        parameters: <String, dynamic>{
          ...query.toArguments(),
          ...arguments._parameters,
        },
      );
    }
    return null;
  }
}

extension BuildContextNavigatorStateExtensions
    on _BuildContextNavigatorContainer {
  /// Pops the page to the page with the specified path.
  ///
  /// Enter the pathname of the page in [name].
  Future<void> popUntilNamed(String name) async {
    final parsedName = _parse(name);
    popUntil((route) {
      return _parse(route.settings.name ?? "") == parsedName;
    });
  }

  /// Reset all history and go to a specific page.
  ///
  /// After all pages are [pop()],
  /// the page specified by [newRouteName] is [pushNamed()].
  ///
  /// In [arguments], put [RouteQuery] and so on.
  ///
  /// Ideal for moving after logging out.
  Future<T?> resetAndPushNamed<T extends Object?>(
    String newRouteName, {
    Object? arguments,
  }) {
    return pushNamedAndRemoveUntil(
      newRouteName,
      (route) => false,
      arguments: arguments,
    );
  }
}

/// Extension methods for BuildContext.
extension BuildContedxtExtensions on BuildContext {
  DynamicMap get _arg {
    final pageScoped = PageScoped._of(this);
    return pageScoped._modalRoute?.settings.arguments as DynamicMap? ??
        pageScoped._map;
  }

  /// Outputs the theme related to the context.
  ThemeData get theme => Theme.of(this);

  /// Get the Navigator related to context.
  NavigatorState get navigator {
    final navigator = Navigator.of(this);
    return _BuildContextNavigatorContainer(navigator, this);
  }

  /// Get the Root navigator related to context.
  NavigatorState get rootNavigator {
    final navigator = Navigator.of(this, rootNavigator: true);
    return _BuildContextNavigatorContainer(navigator, this);
  }

  /// Get the Flavor.
  String get flavor => FlavorScope.of(this).flavor;

  /// Get the Design type.
  DesignType get designType => DesignTypeScope.of(this).designType;

  /// If you want to use the style for web when you are on the web, use `true`.
  bool get webStyle => DesignTypeScope.of(this).webStyle;

  /// Get the route settins.
  RouteSettings get route =>
      ModalRoute.of(this)?.settings ?? const RouteSettings();

  /// Get the media qury related to context
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Releases focus such as text field.
  void unfocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  /// True if the specified [key] is contained in scoped.
  bool containsKey(Object? key) {
    return _arg.containsKey(key);
  }

  /// True if the specified [value] is contained in scoped.
  bool containsValue(Object? value) {
    return _arg.containsValue(value);
  }

  /// Gets the value from the [key] of the map stored in scoped.
  ///
  /// If [key] does not exist in the map, [orElse] is returned.
  T get<T>(String key, T orElse) {
    return _arg.get(key, orElse);
  }

  /// Get the list corresponding to [key] in the map.
  ///
  /// If [key] is not found, the list of [orElse] is returned.
  List<T> getAsList<T>(String key, [List<T>? orElse]) {
    if (!_arg.containsKey(key)) {
      return orElse ?? [];
    }
    return (_arg[key] as List?)?.cast<T>() ?? orElse ?? [];
  }

  /// Get the map corresponding to [key] in the map.
  ///
  /// If [key] is not found, the map of [orElse] is returned.
  Map<String, T> getAsMap<T>(String key, [Map<String, T>? orElse]) {
    if (!_arg.containsKey(key)) {
      return orElse ?? {};
    }
    return (_arg[key] as Map?)?.cast<String, T>() ?? orElse ?? {};
  }

  /// Get the set corresponding to [key] in the map.
  ///
  /// If [key] is not found, the set of [orElse] is returned.
  Set<T> getAsSets<T>(String key, [Set<T>? orElse]) {
    if (!_arg.containsKey(key)) {
      return orElse ?? {};
    }
    return (_arg[key] as Set?)?.cast<T>() ?? orElse ?? {};
  }

  /// Get the set corresponding to [key] in the DateTime.
  ///
  /// If [key] is not found, the set of [orElse] is returned.
  DateTime getAsDateTime(String key, [DateTime? orElse]) {
    if (!_arg.containsKey(key)) {
      return orElse ?? DateTime.now();
    }
    final millisecondsSinceEpoch = _arg[key] as int?;
    if (millisecondsSinceEpoch == null) {
      return orElse ?? DateTime.now();
    }
    return DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
  }

  /// Get [key] to [key] of the map stored in [arg].
  ///
  /// The data will be unique within the page and can continue to be used even if the widget is rebuilt.
  dynamic operator [](Object? key) {
    return _arg[key];
  }

  /// Save [value] to [key] of the map stored in [arg].
  ///
  /// The data will be unique within the page and can continue to be used even if the widget is rebuilt.
  void operator []=(String key, dynamic value) {
    _arg[key] = value;
  }
}

/// Extension method for WidgetRef.
extension WidgetRefExtensions on WidgetRef {
  DynamicMap get _arg {
    final scoped = Scoped.of(this as BuildContext);
    return scoped._map;
  }

  /// Explicitly rebuild the widget.
  ///
  /// Basically, do not use it.
  ///
  /// Use this only if you want to force a rebuild.
  void rebuild() {
    Scoped.of(this as BuildContext).rebuild();
  }

  /// Open a new URL or screen.
  ///
  /// If [path] starts with `http`,
  /// it opens a browser, otherwise it opens a screen path.
  ///
  /// It is possible to configure the settings for
  /// opening the screen by specifying [query].
  Future<T?> open<T extends Object?>(String path, [RouteQuery? query]) async {
    if (path.startsWith("http")) {
      await openURL(path);
      return null;
    } else {
      return await (this as BuildContext)
          .navigator
          .pushNamed(path, arguments: query);
    }
  }

  /// A builder for creating and saving scoped value.
  ///
  /// If [key] is specified, the data will be saved with that key.
  ///
  /// Since it is not usually used directly from [get], [prefix] is given to prevent duplication of values.
  ///
  /// It creates a scoped value from [builder].
  ///
  /// If [test] is `true` or the scoped value for the Key is empty, update the value.
  @protected
  TResult valueBuilder<TResult, TScopedValue extends ScopedValue<TResult>>({
    required String key,
    required TScopedValue Function() builder,
    String prefix = r"_$",
  }) {
    key = "$prefix$key";
    final found = _arg.get<ScopedValueState<TResult, TScopedValue>?>(key, null);
    final value = builder.call();
    if (found != null) {
      final oldValue = found.value;
      found._ref = this;
      found._value = value;
      found.didUpdateValue(oldValue);
      return found.build();
    } else {
      final state = value.createState();
      state._ref = this;
      state._value = value;
      state.initValue();
      _arg[key] = state;
      return state.build();
    }
  }
}

/// Gradient color extension for Routing.
extension GradientColorExtensions on Color {
  /// Gets the color for the gradient.
  ///
  /// If GradientColor is specified in Theme, an array of it can be obtained.
  ///
  /// If specified, the [stops] argument must have the same number of entries as [colors] (this is also not verified until the [createShader] method is called).
  ///
  /// The [transform] argument can be applied to transform only the gradient, without rotating the canvas itself or other geometry on the canvas.
  /// For example, a GradientRotation(math.pi/4) will result in a [SweepGradient] that starts from a position of 6 o'clock instead of 3 o'clock,
  /// assuming no other rotation or perspective transformations have been applied to the [Canvas]. If null, no transformation is applied.
  Gradient toLinearGradient({
    AlignmentGeometry begin = Alignment.centerLeft,
    AlignmentGeometry end = Alignment.centerRight,
    TileMode tileMode = TileMode.clamp,
    List<double>? stops,
    GradientTransform? transform,
  }) {
    final color = this;
    if (color is GradientColor) {
      return LinearGradient(
        colors: color._toGradient(),
        stops: stops,
        transform: transform,
        begin: begin,
        end: end,
        tileMode: tileMode,
      );
    } else {
      return LinearGradient(
        colors: [this],
        stops: stops,
        transform: transform,
        begin: begin,
        end: end,
        tileMode: tileMode,
      );
    }
  }

  /// True if the color is a gradient color.
  bool get isGradient {
    return this is GradientColor;
  }
}

/// TextStyle extension for Routing.
extension RoutingTextStyleExtensions on TextStyle {
  /// Makes the text color darker.
  ///
  /// The higher the value(0.0 - 1.0), the darker the image becomes.
  TextStyle darken([double amount = 0.1]) {
    return copyWith(
      color: color?.darken(amount),
    );
  }

  /// Makes the text color lighter.
  ///
  /// The higher the value(0.0 - 1.0), the lighter the image becomes.
  TextStyle lighten([double amount = 0.1]) {
    return copyWith(
      color: color?.lighten(amount),
    );
  }

  /// Set the transparency of the text color to [opacity].
  TextStyle withOpacity(double opacity) {
    return copyWith(color: color?.withOpacity(opacity));
  }

  /// Decrease the font size of TextStyle by [amount].
  TextStyle smallize([double amount = 1]) {
    return copyWith(fontSize: fontSize == null ? null : (fontSize! - amount));
  }

  /// Increase the font size of TextStyle by [amount].
  TextStyle largize([double amount = 1]) {
    return copyWith(fontSize: fontSize == null ? null : (fontSize! + amount));
  }

  /// Set text color.
  TextStyle withColor(Color color) {
    return copyWith(color: color);
  }
}

/// Theme extension for Routing.
extension RoutingThemeExtension on ThemeData {
  /// Text color.
  Color get textColor {
    return colorScheme.onBackground;
  }

  /// Weak text color.
  Color get weakTextColor {
    return disabledColor;
  }

  /// Text color on primary.
  Color get textColorOnPrimary {
    return colorScheme.onPrimary;
  }

  /// Text color on secondary.
  Color get textColorOnSecondary {
    return colorScheme.onSecondary;
  }

  /// Text color on tertiary.
  Color get textColorOnTertiary {
    return colorScheme.onTertiary;
  }

  /// Text color on surface.
  Color get textColorOnSurface {
    return colorScheme.onSurface;
  }

  /// Text color on error.
  Color get textColorOnError {
    return colorScheme.onError;
  }

  /// Text color on warning.
  Color get textColorOnWarning {
    return colorScheme.onError;
  }

  /// Secondary color.
  Color get secondaryColor {
    return colorScheme.secondary;
  }

  /// Tertiary color.
  Color get tertiaryColor {
    return colorScheme.tertiary;
  }

  /// Surface color.
  Color get surfaceColor {
    return colorScheme.surface;
  }

  /// Warning color.
  Color get warningColor {
    return colorScheme.errorContainer;
  }

  /// Widget theme.
  WidgetTheme get widget {
    return extension<WidgetTheme>() ?? const WidgetTheme();
  }

  /// Image theme.
  ImageTheme get image {
    return extension<ImageTheme>() ?? const ImageTheme();
  }

  /// Display large text style.
  TextStyle get textDisplayLarge {
    return textTheme.displayLarge ??
        const TextStyle(
          fontSize: 57,
          fontWeight: FontWeight.w400,
          leadingDistribution: TextLeadingDistribution.even,
          // height: 1.12,
        );
  }

  /// Display medium text style.
  TextStyle get textDisplayMedium {
    return textTheme.displayMedium ??
        const TextStyle(
          fontSize: 45,
          fontWeight: FontWeight.w400,
          leadingDistribution: TextLeadingDistribution.even,
          // height: 1.15,
        );
  }

  /// Display small text style.
  TextStyle get textDisplaySmall {
    return textTheme.displaySmall ??
        const TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w400,
          leadingDistribution: TextLeadingDistribution.even,
          // height: 1.22,
        );
  }

  /// Headline large text style.
  TextStyle get textHeadlineLarge {
    return textTheme.headlineLarge ??
        const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w400,
          leadingDistribution: TextLeadingDistribution.proportional,
          height: 1.25,
        );
  }

  /// Headline medium text style.
  TextStyle get textHeadlineMedium {
    return textTheme.headlineMedium ??
        const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w400,
          leadingDistribution: TextLeadingDistribution.proportional,
          height: 1.29,
        );
  }

  /// Headline small text style.
  TextStyle get textHeadlineSmall {
    return textTheme.headlineSmall ??
        const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w400,
          leadingDistribution: TextLeadingDistribution.proportional,
          height: 1.33,
        );
  }

  /// Title large text style.
  TextStyle get textTitleLarge {
    return textTheme.titleLarge ??
        const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          leadingDistribution: TextLeadingDistribution.even,
          // height: 1.27,
        );
  }

  /// Title medium text style.
  TextStyle get textTitleMedium {
    return textTheme.titleMedium ??
        const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          leadingDistribution: TextLeadingDistribution.even,
          // height: 1.5,
        );
  }

  /// Title small text style.
  TextStyle get textTitleSmall {
    return textTheme.titleSmall ??
        const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          leadingDistribution: TextLeadingDistribution.even,
          // height: 1.43,
        );
  }

  /// Body large text style.
  TextStyle get textBodyLarge {
    return textTheme.bodyLarge ??
        const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          leadingDistribution: TextLeadingDistribution.even,
          // height: 1.5,
        );
  }

  /// Body medium text style.
  TextStyle get textBodyMedium {
    return textTheme.bodyMedium ??
        const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          leadingDistribution: TextLeadingDistribution.even,
          // height: 1.43,
        );
  }

  /// Body small text style.
  TextStyle get textBodySmall {
    return textTheme.bodySmall ??
        const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          leadingDistribution: TextLeadingDistribution.even,
          // height: 1.33,
        );
  }

  /// Label large text style.
  TextStyle get textLabelLarge {
    return textTheme.labelLarge ??
        const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          leadingDistribution: TextLeadingDistribution.even,
          // height: 1.43,
        );
  }

  /// Label medium text style.
  TextStyle get textLabelMedium {
    return textTheme.labelMedium ??
        const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          leadingDistribution: TextLeadingDistribution.even,
          // height: 1.33,
        );
  }

  /// Label label text style.
  TextStyle get textLabelSmall {
    return textTheme.labelSmall ??
        const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          leadingDistribution: TextLeadingDistribution.even,
          // height: 1.45,
        );
  }
}
