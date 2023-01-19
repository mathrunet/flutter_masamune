part of katana_theme;

/// White for design.
///
/// デザイン用の白色。
const kWhiteColor = Color(0xFFF7F7F7);

/// Black for design.
///
/// デザイン用の黒色。
const kBlackColor = Color(0xFF212121);

/// {@template app_theme_data}
/// Set the theme of the application.
///
/// [ColorScheme] and [TextTheme] of MaterialDesign3 can be specified.
///
/// You can use `context.theme` to get this value, or you can pass [ThemeData] converted by [toThemeData] to [MaterialApp] and other widgets in Flutter.
///
/// [ColorScheme] can be obtained by [color]. [TextTheme] can be obtained by [text]. [widget] allows you to retrieve the theme used for the widget. In [asset], you can get the assets of the application specified in pubspec.yaml. You can get the font of the app specified in pubspec.yaml at [font].
///
/// You can also set up your own theme by extending [ColorThemeData], [TextThemeData], [WidgetThemeData], [AssetThemeData], and [FontThemeData] with extensions, respectively.
///
/// アプリのテーマを設定します。
///
/// MaterialDesign3の[ColorScheme]と[TextTheme]を指定することが可能です。
///
/// `context.theme`でこの値を取得できる様になっている他、[MaterialApp]等に[toThemeData]で変換した[ThemeData]を渡すことでFlutter内の各種ウィジェットに伝えることができます。
///
/// [color]で[ColorScheme]を取得することができます。[text]で[TextTheme]を取得することができます。[widget]でウィジェットで使うテーマを取得することができます。[asset]でpubspec.yamlで指定したアプリのアセットを取得することができます。[font]でpubspec.yamlで指定したアプリのフォントを取得することができます。
///
/// またそれぞれ[ColorThemeData]、[TextThemeData]、[WidgetThemeData]、[AssetThemeData]、[FontThemeData]をエクステンションで拡張することにより独自のテーマを設定することも可能です。
///
/// See also:
///
///   - https://m3.material.io/styles/color/the-color-system/color-roles
///   - https://m3.material.io/styles/typography/type-scale-tokens
/// {@endtemplate}
@immutable
class AppThemeData {
  /// The light theme defines the initial color.
  ///
  /// ライトテーマで初期色を定義しています。
  ///
  /// {@macro app_theme_data}
  AppThemeData({
    Color primary = Colors.blue,
    Color secondary = Colors.cyan,
    Color tertiary = Colors.lightBlue,
    Color primaryContainer = Colors.blueAccent,
    Color secondaryContainer = Colors.cyanAccent,
    Color tertiaryContainer = Colors.lightBlueAccent,
    Color disabled = Colors.grey,
    Color weak = Colors.grey,
    Color outline = Colors.grey,
    Color error = Colors.red,
    Color warning = Colors.amber,
    Color info = Colors.blue,
    Color success = Colors.green,
    Color surface = kWhiteColor,
    Color background = kWhiteColor,
    Color onPrimary = kWhiteColor,
    Color onSecondary = kWhiteColor,
    Color onTertiary = kWhiteColor,
    Color onPrimaryContainer = kWhiteColor,
    Color onSecondaryContainer = kWhiteColor,
    Color onTertiaryContainer = kWhiteColor,
    Color onDisabled = kWhiteColor,
    Color onSurface = kBlackColor,
    Color onBackground = kBlackColor,
    Color onWeak = kWhiteColor,
    Color onError = kWhiteColor,
    Color onInfo = kWhiteColor,
    Color onSuccess = kBlackColor,
    Color onWarning = kWhiteColor,
    Color splashColor = const Color(0xaaFFFFFF),
    Color shadow = Colors.black,
    Color inverseSurface = kBlackColor,
    Color onInverseSurface = kWhiteColor,
    Color inversePrimary = kWhiteColor,
    Color? appBarColor,
    Color? onAppBarColor,
    Color scaffoldBackgroundColor = kWhiteColor,
    TextStyle displayLarge = const TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    TextStyle displayMedium = const TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    TextStyle displaySmall = const TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    TextStyle headlineLarge = const TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w400,
      height: 1.25,
      leadingDistribution: TextLeadingDistribution.proportional,
    ),
    TextStyle headlineMedium = const TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w400,
      height: 1.29,
      leadingDistribution: TextLeadingDistribution.proportional,
    ),
    TextStyle headlineSmall = const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      height: 1.33,
      leadingDistribution: TextLeadingDistribution.proportional,
    ),
    TextStyle titleLarge = const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    TextStyle titleMedium = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    TextStyle titleSmall = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    TextStyle bodyLarge = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    TextStyle bodyMedium = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    TextStyle bodySmall = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    TextStyle labelLarge = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    TextStyle labelMedium = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    TextStyle labelSmall = const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    double fontSizeFactor = 1.0,
    double fontSizeDelta = 0.0,
    String? defaultFontFamily,
    this.useMaterial3 = true,
    this.platform = TargetPlatform.iOS,
    Brightness brightness = Brightness.light,
  })  : color = ColorThemeData._(
          brightness: brightness,
          primary: primary,
          secondary: secondary,
          tertiary: tertiary,
          primaryContainer: primaryContainer,
          secondaryContainer: secondaryContainer,
          tertiaryContainer: tertiaryContainer,
          disabled: disabled,
          weak: weak,
          outline: outline,
          error: error,
          warning: warning,
          info: info,
          success: success,
          surface: surface,
          background: background,
          onPrimary: onPrimary,
          onSecondary: onSecondary,
          onTertiary: onTertiary,
          onPrimaryContainer: onPrimaryContainer,
          onSecondaryContainer: onSecondaryContainer,
          onTertiaryContainer: onTertiaryContainer,
          onDisabled: onDisabled,
          onSurface: onSurface,
          onBackground: onBackground,
          onWeak: onWeak,
          onError: onError,
          onInfo: onInfo,
          onSuccess: onSuccess,
          onWarning: onWarning,
          splashColor: splashColor,
          shadow: shadow,
          inverseSurface: inverseSurface,
          onInverseSurface: onInverseSurface,
          inversePrimary: inversePrimary,
          appBarColor: appBarColor,
          onAppBarColor: onAppBarColor,
          scaffoldBackgroundColor: scaffoldBackgroundColor,
        ),
        text = TextThemeData._(
          displayLarge: displayLarge,
          displayMedium: displayMedium,
          displaySmall: displaySmall,
          headlineLarge: headlineLarge,
          headlineMedium: headlineMedium,
          headlineSmall: headlineSmall,
          titleLarge: titleLarge,
          titleMedium: titleMedium,
          titleSmall: titleSmall,
          bodyLarge: bodyLarge,
          bodyMedium: bodyMedium,
          bodySmall: bodySmall,
          labelLarge: labelLarge,
          labelMedium: labelMedium,
          labelSmall: labelSmall,
          fontSizeFactor: fontSizeFactor,
          fontSizeDelta: fontSizeDelta,
          defaultFontFamily: defaultFontFamily,
        );

  /// The light theme defines the initial color.
  ///
  /// ライトテーマで初期色を定義しています。
  ///
  /// {@macro app_theme_data}
  AppThemeData.light({
    Color primary = Colors.blue,
    Color secondary = Colors.cyan,
    Color tertiary = Colors.lightBlue,
    Color primaryContainer = Colors.blueAccent,
    Color secondaryContainer = Colors.cyanAccent,
    Color tertiaryContainer = Colors.lightBlueAccent,
    Color disabled = Colors.grey,
    Color weak = Colors.grey,
    Color outline = Colors.grey,
    Color error = Colors.red,
    Color warning = Colors.amber,
    Color info = Colors.blue,
    Color success = Colors.green,
    Color surface = kWhiteColor,
    Color background = kWhiteColor,
    Color onPrimary = kWhiteColor,
    Color onSecondary = kWhiteColor,
    Color onTertiary = kWhiteColor,
    Color onPrimaryContainer = kWhiteColor,
    Color onSecondaryContainer = kWhiteColor,
    Color onTertiaryContainer = kWhiteColor,
    Color onDisabled = kWhiteColor,
    Color onSurface = kBlackColor,
    Color onBackground = kBlackColor,
    Color onWeak = kWhiteColor,
    Color onError = kWhiteColor,
    Color onInfo = kWhiteColor,
    Color onSuccess = kBlackColor,
    Color onWarning = kWhiteColor,
    Color splashColor = const Color(0xaaFFFFFF),
    Color shadow = Colors.black,
    Color inverseSurface = kBlackColor,
    Color onInverseSurface = kWhiteColor,
    Color inversePrimary = kWhiteColor,
    Color? appBarColor,
    Color? onAppBarColor,
    Color scaffoldBackgroundColor = kWhiteColor,
    TextStyle displayLarge = const TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    TextStyle displayMedium = const TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    TextStyle displaySmall = const TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    TextStyle headlineLarge = const TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w400,
      height: 1.25,
      leadingDistribution: TextLeadingDistribution.proportional,
    ),
    TextStyle headlineMedium = const TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w400,
      height: 1.29,
      leadingDistribution: TextLeadingDistribution.proportional,
    ),
    TextStyle headlineSmall = const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      height: 1.33,
      leadingDistribution: TextLeadingDistribution.proportional,
    ),
    TextStyle titleLarge = const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    TextStyle titleMedium = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    TextStyle titleSmall = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    TextStyle bodyLarge = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    TextStyle bodyMedium = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    TextStyle bodySmall = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    TextStyle labelLarge = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    TextStyle labelMedium = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    TextStyle labelSmall = const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    double fontSizeFactor = 1.0,
    double fontSizeDelta = 0.0,
    String? defaultFontFamily,
    this.useMaterial3 = true,
    this.platform = TargetPlatform.iOS,
  })  : color = ColorThemeData._(
          brightness: Brightness.light,
          primary: primary,
          secondary: secondary,
          tertiary: tertiary,
          primaryContainer: primaryContainer,
          secondaryContainer: secondaryContainer,
          tertiaryContainer: tertiaryContainer,
          disabled: disabled,
          weak: weak,
          outline: outline,
          error: error,
          warning: warning,
          info: info,
          success: success,
          surface: surface,
          background: background,
          onPrimary: onPrimary,
          onSecondary: onSecondary,
          onTertiary: onTertiary,
          onPrimaryContainer: onPrimaryContainer,
          onSecondaryContainer: onSecondaryContainer,
          onTertiaryContainer: onTertiaryContainer,
          onDisabled: onDisabled,
          onSurface: onSurface,
          onBackground: onBackground,
          onWeak: onWeak,
          onError: onError,
          onInfo: onInfo,
          onSuccess: onSuccess,
          onWarning: onWarning,
          splashColor: splashColor,
          shadow: shadow,
          inverseSurface: inverseSurface,
          onInverseSurface: onInverseSurface,
          inversePrimary: inversePrimary,
          appBarColor: appBarColor,
          onAppBarColor: onAppBarColor,
          scaffoldBackgroundColor: scaffoldBackgroundColor,
        ),
        text = TextThemeData._(
          displayLarge: displayLarge,
          displayMedium: displayMedium,
          displaySmall: displaySmall,
          headlineLarge: headlineLarge,
          headlineMedium: headlineMedium,
          headlineSmall: headlineSmall,
          titleLarge: titleLarge,
          titleMedium: titleMedium,
          titleSmall: titleSmall,
          bodyLarge: bodyLarge,
          bodyMedium: bodyMedium,
          bodySmall: bodySmall,
          labelLarge: labelLarge,
          labelMedium: labelMedium,
          labelSmall: labelSmall,
          fontSizeFactor: fontSizeFactor,
          fontSizeDelta: fontSizeDelta,
          defaultFontFamily: defaultFontFamily,
        );

  /// The dark theme defines the initial color.
  ///
  /// ダークテーマで初期色を定義しています。
  ///
  /// {@macro app_theme_data}
  AppThemeData.dark({
    Color primary = Colors.blue,
    Color secondary = Colors.cyan,
    Color tertiary = Colors.lightBlue,
    Color primaryContainer = Colors.blueAccent,
    Color secondaryContainer = Colors.cyanAccent,
    Color tertiaryContainer = Colors.lightBlueAccent,
    Color disabled = Colors.grey,
    Color weak = Colors.grey,
    Color outline = Colors.grey,
    Color error = Colors.red,
    Color warning = Colors.amber,
    Color info = Colors.blue,
    Color success = Colors.green,
    Color surface = kBlackColor,
    Color background = kBlackColor,
    Color onPrimary = kBlackColor,
    Color onSecondary = kBlackColor,
    Color onTertiary = kBlackColor,
    Color onPrimaryContainer = kBlackColor,
    Color onSecondaryContainer = kBlackColor,
    Color onTertiaryContainer = kBlackColor,
    Color onDisabled = kWhiteColor,
    Color onSurface = kWhiteColor,
    Color onBackground = kWhiteColor,
    Color onWeak = kBlackColor,
    Color onError = kBlackColor,
    Color onInfo = kBlackColor,
    Color onSuccess = kWhiteColor,
    Color onWarning = kBlackColor,
    Color splashColor = const Color(0xaaFFFFFF),
    Color shadow = Colors.black,
    Color inverseSurface = kWhiteColor,
    Color onInverseSurface = kBlackColor,
    Color inversePrimary = kBlackColor,
    Color? appBarColor,
    Color? onAppBarColor,
    Color scaffoldBackgroundColor = kBlackColor,
    TextStyle displayLarge = const TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    TextStyle displayMedium = const TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    TextStyle displaySmall = const TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    TextStyle headlineLarge = const TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w400,
      height: 1.25,
      leadingDistribution: TextLeadingDistribution.proportional,
    ),
    TextStyle headlineMedium = const TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w400,
      height: 1.29,
      leadingDistribution: TextLeadingDistribution.proportional,
    ),
    TextStyle headlineSmall = const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      height: 1.33,
      leadingDistribution: TextLeadingDistribution.proportional,
    ),
    TextStyle titleLarge = const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    TextStyle titleMedium = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    TextStyle titleSmall = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    TextStyle bodyLarge = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    TextStyle bodyMedium = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    TextStyle bodySmall = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    TextStyle labelLarge = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    TextStyle labelMedium = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    TextStyle labelSmall = const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    double fontSizeFactor = 1.0,
    double fontSizeDelta = 0.0,
    String? defaultFontFamily,
    this.useMaterial3 = true,
    this.platform = TargetPlatform.iOS,
  })  : color = ColorThemeData._(
          brightness: Brightness.dark,
          primary: primary,
          secondary: secondary,
          tertiary: tertiary,
          primaryContainer: primaryContainer,
          secondaryContainer: secondaryContainer,
          tertiaryContainer: tertiaryContainer,
          disabled: disabled,
          weak: weak,
          outline: outline,
          error: error,
          warning: warning,
          info: info,
          success: success,
          surface: surface,
          background: background,
          onPrimary: onPrimary,
          onSecondary: onSecondary,
          onTertiary: onTertiary,
          onPrimaryContainer: onPrimaryContainer,
          onSecondaryContainer: onSecondaryContainer,
          onTertiaryContainer: onTertiaryContainer,
          onDisabled: onDisabled,
          onSurface: onSurface,
          onBackground: onBackground,
          onWeak: onWeak,
          onError: onError,
          onInfo: onInfo,
          onSuccess: onSuccess,
          onWarning: onWarning,
          splashColor: splashColor,
          shadow: shadow,
          inverseSurface: inverseSurface,
          onInverseSurface: onInverseSurface,
          inversePrimary: inversePrimary,
          appBarColor: appBarColor,
          onAppBarColor: onAppBarColor,
          scaffoldBackgroundColor: scaffoldBackgroundColor,
        ),
        text = TextThemeData._(
          displayLarge: displayLarge,
          displayMedium: displayMedium,
          displaySmall: displaySmall,
          headlineLarge: headlineLarge,
          headlineMedium: headlineMedium,
          headlineSmall: headlineSmall,
          titleLarge: titleLarge,
          titleMedium: titleMedium,
          titleSmall: titleSmall,
          bodyLarge: bodyLarge,
          bodyMedium: bodyMedium,
          bodySmall: bodySmall,
          labelLarge: labelLarge,
          labelMedium: labelMedium,
          labelSmall: labelSmall,
          fontSizeFactor: fontSizeFactor,
          fontSizeDelta: fontSizeDelta,
          defaultFontFamily: defaultFontFamily,
        );

  /// Retrieve the color scheme.
  ///
  /// New themes can be defined by extending [ColorThemeData].
  ///
  /// カラースキームを取得します。
  ///
  /// [ColorThemeData]をエクステンションすることで新しいテーマを定義することが可能です。
  ///
  /// See also:
  ///
  ///   - https://m3.material.io/styles/color/the-color-system/color-roles
  final ColorThemeData color;

  /// Retrieve the text theme.
  ///
  /// New themes can be defined by extending [TextThemeData].
  ///
  /// テキストテーマを取得します。
  ///
  /// [TextThemeData]をエクステンションすることで新しいテーマを定義することが可能です。
  ///
  /// See also:
  ///
  ///   - https://m3.material.io/styles/typography/type-scale-tokens
  // TextThemeData get text => TextThemeData._(
  //       displayLarge: _displayLarge,
  //       displayMedium: _displayMedium,
  //       displaySmall: _displaySmall,
  //       headlineLarge: _headlineLarge,
  //       headlineMedium: _headlineMedium,
  //       headlineSmall: _headlineSmall,
  //       titleLarge: _titleLarge,
  //       titleMedium: _titleMedium,
  //       titleSmall: _titleSmall,
  //       bodyLarge: _bodyLarge,
  //       bodyMedium: _bodyMedium,
  //       bodySmall: _bodySmall,
  //       labelLarge: _labelLarge,
  //       labelMedium: _labelMedium,
  //       labelSmall: _labelSmall,
  //       fontSizeFactor: _fontSizeFactor,
  //       fontSizeDelta: _fontSizeDelta,
  //       defaultFontFamily: _defaultFontFamily,
  //     );
  final TextThemeData text;

  /// Retrieve font themes.
  ///
  /// The builder will allow you to retrieve the font families defined in pubspec.yaml.
  ///
  /// New themes can be defined by extending [FontThemeData].
  ///
  /// フォントテーマを取得します。
  ///
  /// ビルダーによってpubspec.yaml内に定義されたフォントファミリーを取得することができるようになります。
  ///
  /// [FontThemeData]をエクステンションすることで新しいテーマを定義することが可能です。
  FontThemeData get font => const FontThemeData._();

  /// Obtains a list of asset paths.
  ///
  /// The builder will allow you to retrieve the assets defined in pubspec.yaml.
  ///
  /// New themes can be defined by extending [AssetThemeData].
  ///
  /// アセットのパス一覧を取得します。
  ///
  /// ビルダーによってpubspec.yaml内に定義されたアセットを取得することができるようになります。
  ///
  /// [AssetThemeData]をエクステンションすることで新しいテーマを定義することが可能です。
  AssetThemeData get asset => const AssetThemeData._();

  /// Get the theme of the widget.
  ///
  /// New themes can be defined by extending [WidgetThemeData].
  ///
  /// ウィジェットのテーマを取得します。
  ///
  /// [WidgetThemeData]をエクステンションすることで新しいテーマを定義することが可能です。
  WidgetThemeData get widget => const WidgetThemeData._();

  /// If this is set to `true`, the app will be designed with Material3 design.
  ///
  /// これを`true`にした場合、Material3のデザインでアプリがデザインされます。
  ///
  /// See also:
  ///
  ///   - https://m3.material.io/
  final bool useMaterial3;

  /// Specify the target platform for the design.
  ///
  /// The design will be tailored to this platform.
  ///
  /// デザインのターゲットプラットフォームを指定します。
  ///
  /// このプラットフォームに合わせたデザインになります。
  final TargetPlatform platform;

  /// Get [AppThemeData] placed on the widget tree.
  ///
  /// ウィジェットツリー上に配置されている[AppThemeData]を取得します。
  static AppThemeData of(BuildContext context) {
    final scope = context
        .getElementForInheritedWidgetOfExactType<AppThemeScope>()
        ?.widget as AppThemeScope?;
    assert(scope != null, "AppThemeData is not found.");
    return scope!.theme;
  }

  /// Convert to [ThemeData] in Flutter.
  ///
  /// Passing this to [MaterialApp] and others will change the Flutter widget to a design suitable for [AppThemeData].
  ///
  /// [defaultFontFamily] allows you to specify the default font for the app.
  ///
  /// Flutterの[ThemeData]に変換します。
  ///
  /// これを[MaterialApp]などに渡すとFlutterのウィジェットが[AppThemeData]に適したデザインに変更されます。
  ///
  /// [defaultFontFamily]を指定するとアプリのデフォルトのフォントを指定することができます。
  ThemeData toThemeData({
    String? defaultFontFamily,
  }) {
    final color = this.color;
    final text = this.text;
    defaultFontFamily ??= text.defaultFontFamily;

    switch (color.brightness) {
      case Brightness.dark:
        final theme = ThemeData.dark();
        final colorScheme = theme.colorScheme.copyWith(
          primary: color.primary,
          primaryContainer: color.primaryContainer,
          secondary: color.secondary,
          secondaryContainer: color.secondaryContainer,
          tertiary: color.tertiary,
          tertiaryContainer: color.tertiaryContainer,
          surface: color.surface,
          background: color.background,
          error: color.error,
          errorContainer: color.warning,
          onPrimary: color.onPrimary,
          onPrimaryContainer: color.onPrimaryContainer,
          onSecondary: color.onSecondary,
          onSecondaryContainer: color.onSecondaryContainer,
          onTertiary: color.onTertiary,
          onTertiaryContainer: color.onTertiaryContainer,
          onBackground: color.onBackground,
          onSurface: color.onSurface,
          onError: color.onError,
          onErrorContainer: color.onWarning,
          brightness: color.brightness,
          outline: color.outline,
          inversePrimary: color.inversePrimary,
          inverseSurface: color.inverseSurface,
          onInverseSurface: color.onInverseSurface,
        );
        final textTheme = theme.textTheme.copyWith(
          displayLarge:
              text.displayLarge.copyWith(fontFamily: text.defaultFontFamily),
          displayMedium:
              text.displayMedium.copyWith(fontFamily: text.defaultFontFamily),
          displaySmall:
              text.displaySmall.copyWith(fontFamily: text.defaultFontFamily),
          headlineLarge:
              text.headlineLarge.copyWith(fontFamily: text.defaultFontFamily),
          headlineMedium:
              text.headlineMedium.copyWith(fontFamily: text.defaultFontFamily),
          headlineSmall:
              text.headlineSmall.copyWith(fontFamily: text.defaultFontFamily),
          titleLarge:
              text.titleLarge.copyWith(fontFamily: text.defaultFontFamily),
          titleMedium:
              text.titleMedium.copyWith(fontFamily: text.defaultFontFamily),
          titleSmall:
              text.titleSmall.copyWith(fontFamily: text.defaultFontFamily),
          bodyLarge:
              text.bodyLarge.copyWith(fontFamily: text.defaultFontFamily),
          bodyMedium:
              text.bodyMedium.copyWith(fontFamily: text.defaultFontFamily),
          bodySmall:
              text.bodySmall.copyWith(fontFamily: text.defaultFontFamily),
          labelLarge:
              text.labelLarge.copyWith(fontFamily: text.defaultFontFamily),
          labelMedium:
              text.labelMedium.copyWith(fontFamily: text.defaultFontFamily),
          labelSmall:
              text.labelSmall.copyWith(fontFamily: text.defaultFontFamily),
        );
        final appBarForegroundColor = color.appBarColor == Colors.transparent
            ? color.onBackground
            : color.onAppBarColor;
        return ThemeData(
          fontFamily: defaultFontFamily,
          useMaterial3: useMaterial3,
          platform: platform,
          colorScheme: colorScheme,
          splashColor: color.splashColor,
          canvasColor: color.canvas,
          scaffoldBackgroundColor: color.scaffoldBackgroundColor,
          textTheme: textTheme.apply(
            fontFamily: text.defaultFontFamily,
            bodyColor: color.onBackground,
            displayColor: color.onBackground,
            fontSizeFactor: text.fontSizeFactor,
            fontSizeDelta: text.fontSizeDelta,
          ),
          appBarTheme: theme.appBarTheme.copyWith(
            backgroundColor: color.appBarColor,
            elevation: color.appBarColor == Colors.transparent ? 0 : null,
            foregroundColor: appBarForegroundColor,
            toolbarTextStyle: theme.appBarTheme.toolbarTextStyle?.copyWith(
                  color: appBarForegroundColor,
                ) ??
                (appBarForegroundColor != null
                    ? TextStyle(color: appBarForegroundColor)
                    : null),
            titleTextStyle: theme.appBarTheme.titleTextStyle?.copyWith(
                  color: appBarForegroundColor,
                ) ??
                (appBarForegroundColor != null
                    ? TextStyle(color: appBarForegroundColor)
                    : null),
            iconTheme: theme.appBarTheme.iconTheme?.copyWith(
                  color: appBarForegroundColor,
                ) ??
                (appBarForegroundColor != null
                    ? IconThemeData(color: appBarForegroundColor)
                    : null),
            actionsIconTheme: theme.appBarTheme.actionsIconTheme?.copyWith(
                  color: appBarForegroundColor,
                ) ??
                (appBarForegroundColor != null
                    ? IconThemeData(color: appBarForegroundColor)
                    : null),
          ),
          buttonTheme: theme.buttonTheme.copyWith(
            textTheme: theme.buttonTheme.textTheme,
            buttonColor: color.primary,
            disabledColor: color.disabled,
            colorScheme: colorScheme,
          ),
          inputDecorationTheme: theme.inputDecorationTheme.copyWith(
            labelStyle: TextStyle(color: color.weak),
            helperStyle: TextStyle(color: color.weak),
            hintStyle: TextStyle(color: color.weak),
            counterStyle: TextStyle(color: color.weak),
            errorStyle: TextStyle(color: color.error),
            prefixStyle: TextStyle(color: color.onBackground),
            suffixStyle: TextStyle(color: color.onBackground),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: color.weak, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: color.weak, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: color.weak, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: color.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: color.error, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: color.error, width: 2),
            ),
          ),
          indicatorColor: color.secondary,
          brightness: color.brightness,
          primaryColor: color.primary,
          disabledColor: color.disabled,
          dividerColor: color.outline,
          errorColor: color.error,
          backgroundColor: color.background,
        );
      default:
        final theme = ThemeData.light();
        final colorScheme = theme.colorScheme.copyWith(
          primary: color.primary,
          primaryContainer: color.primaryContainer,
          secondary: color.secondary,
          secondaryContainer: color.secondaryContainer,
          tertiary: color.tertiary,
          tertiaryContainer: color.tertiaryContainer,
          surface: color.surface,
          background: color.background,
          error: color.error,
          onPrimary: color.onPrimary,
          onPrimaryContainer: color.onPrimaryContainer,
          onSecondary: color.onSecondary,
          onSecondaryContainer: color.onSecondaryContainer,
          onTertiary: color.onTertiary,
          onTertiaryContainer: color.onTertiaryContainer,
          onBackground: color.onBackground,
          onSurface: color.onSurface,
          onError: color.onError,
          brightness: color.brightness,
          outline: color.outline,
          inversePrimary: color.inversePrimary,
          inverseSurface: color.inverseSurface,
          onInverseSurface: color.onInverseSurface,
        );
        final textTheme = theme.textTheme.copyWith(
          displayLarge:
              text.displayLarge.copyWith(fontFamily: text.defaultFontFamily),
          displayMedium:
              text.displayMedium.copyWith(fontFamily: text.defaultFontFamily),
          displaySmall:
              text.displaySmall.copyWith(fontFamily: text.defaultFontFamily),
          headlineLarge:
              text.headlineLarge.copyWith(fontFamily: text.defaultFontFamily),
          headlineMedium:
              text.headlineMedium.copyWith(fontFamily: text.defaultFontFamily),
          headlineSmall:
              text.headlineSmall.copyWith(fontFamily: text.defaultFontFamily),
          titleLarge:
              text.titleLarge.copyWith(fontFamily: text.defaultFontFamily),
          titleMedium:
              text.titleMedium.copyWith(fontFamily: text.defaultFontFamily),
          titleSmall:
              text.titleSmall.copyWith(fontFamily: text.defaultFontFamily),
          bodyLarge:
              text.bodyLarge.copyWith(fontFamily: text.defaultFontFamily),
          bodyMedium:
              text.bodyMedium.copyWith(fontFamily: text.defaultFontFamily),
          bodySmall:
              text.bodySmall.copyWith(fontFamily: text.defaultFontFamily),
          labelLarge:
              text.labelLarge.copyWith(fontFamily: text.defaultFontFamily),
          labelMedium:
              text.labelMedium.copyWith(fontFamily: text.defaultFontFamily),
          labelSmall:
              text.labelSmall.copyWith(fontFamily: text.defaultFontFamily),
        );
        final appBarForegroundColor = color.appBarColor == Colors.transparent
            ? color.onBackground
            : color.onAppBarColor;
        return ThemeData(
          fontFamily: defaultFontFamily,
          useMaterial3: useMaterial3,
          platform: platform,
          colorScheme: colorScheme,
          splashColor: color.splashColor,
          canvasColor: color.canvas,
          scaffoldBackgroundColor: color.scaffoldBackgroundColor,
          appBarTheme: theme.appBarTheme.copyWith(
            backgroundColor: color.appBarColor,
            elevation: color.appBarColor == Colors.transparent ? 0 : null,
            foregroundColor: appBarForegroundColor,
            toolbarTextStyle: theme.appBarTheme.toolbarTextStyle?.copyWith(
                  color: appBarForegroundColor,
                ) ??
                (appBarForegroundColor != null
                    ? TextStyle(color: appBarForegroundColor)
                    : null),
            titleTextStyle: theme.appBarTheme.titleTextStyle?.copyWith(
                  color: appBarForegroundColor,
                ) ??
                (appBarForegroundColor != null
                    ? TextStyle(color: appBarForegroundColor)
                    : null),
            iconTheme: theme.appBarTheme.iconTheme?.copyWith(
                  color: appBarForegroundColor,
                ) ??
                (appBarForegroundColor != null
                    ? IconThemeData(color: appBarForegroundColor)
                    : null),
            actionsIconTheme: theme.appBarTheme.actionsIconTheme?.copyWith(
                  color: appBarForegroundColor,
                ) ??
                (appBarForegroundColor != null
                    ? IconThemeData(color: appBarForegroundColor)
                    : null),
          ),
          textTheme: textTheme.apply(
            fontFamily: text.defaultFontFamily,
            bodyColor: color.onBackground,
            displayColor: color.onBackground,
            fontSizeFactor: text.fontSizeFactor,
            fontSizeDelta: text.fontSizeDelta,
          ),
          buttonTheme: theme.buttonTheme.copyWith(
            buttonColor: color.primary,
            disabledColor: color.disabled,
            colorScheme: colorScheme,
          ),
          inputDecorationTheme: theme.inputDecorationTheme.copyWith(
            labelStyle: TextStyle(color: color.weak),
            helperStyle: TextStyle(color: color.weak),
            hintStyle: TextStyle(color: color.weak),
            counterStyle: TextStyle(color: color.weak),
            errorStyle: TextStyle(color: color.error),
            prefixStyle: TextStyle(color: color.onBackground),
            suffixStyle: TextStyle(color: color.onBackground),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: color.weak, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: color.weak, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: color.weak, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: color.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: color.error, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: color.error, width: 2),
            ),
          ),
          indicatorColor: color.secondary,
          brightness: color.brightness,
          primaryColor: color.primary,
          disabledColor: color.disabled,
          dividerColor: color.outline,
          errorColor: color.error,
          backgroundColor: color.background,
        );
    }
  }

  /// Copy [AppThemeData] as LightTheme.
  ///
  /// Basically, text and background colors are replaced with LightTheme defaults unless specified otherwise.
  ///
  /// Text and other colors are copied as they are from the existing settings.
  ///
  /// [AppThemeData]をLightThemeとしてコピーします。
  ///
  /// 基本的に文字色や背景色は指定しない限りLightThemeのデフォルトに置き換えられます。
  ///
  /// 文字やその他の色は既存の設定がそのままコピーされます。
  AppThemeData copyWithLight({
    Color? primary,
    Color? secondary,
    Color? tertiary,
    Color? primaryContainer,
    Color? secondaryContainer,
    Color? tertiaryContainer,
    Color disabled = Colors.grey,
    Color weak = Colors.grey,
    Color outline = Colors.grey,
    Color? error,
    Color? warning,
    Color? info,
    Color? success,
    Color surface = kWhiteColor,
    Color background = kWhiteColor,
    Color onPrimary = kWhiteColor,
    Color onSecondary = kWhiteColor,
    Color onTertiary = kWhiteColor,
    Color onPrimaryContainer = kWhiteColor,
    Color onSecondaryContainer = kWhiteColor,
    Color onTertiaryContainer = kWhiteColor,
    Color onDisabled = kWhiteColor,
    Color onSurface = kBlackColor,
    Color onBackground = kBlackColor,
    Color onWeak = kWhiteColor,
    Color onError = kWhiteColor,
    Color onInfo = kWhiteColor,
    Color onSuccess = kBlackColor,
    Color onWarning = kWhiteColor,
    Color splashColor = const Color(0xaaFFFFFF),
    Color shadow = Colors.black,
    Color inverseSurface = kBlackColor,
    Color onInverseSurface = kWhiteColor,
    Color inversePrimary = kWhiteColor,
    Color? appBarColor,
    Color? onAppBarColor,
    Color scaffoldBackgroundColor = kWhiteColor,
  }) {
    return AppThemeData(
      primary: primary ?? color.primary,
      secondary: secondary ?? color.secondary,
      tertiary: tertiary ?? color.tertiary,
      primaryContainer: primaryContainer ?? color.primaryContainer,
      secondaryContainer: secondaryContainer ?? color.secondaryContainer,
      tertiaryContainer: tertiaryContainer ?? color.tertiaryContainer,
      disabled: disabled,
      weak: weak,
      outline: outline,
      error: error ?? color.error,
      warning: warning ?? color.warning,
      info: info ?? color.info,
      success: success ?? color.success,
      surface: surface,
      background: background,
      onPrimary: onPrimary,
      onSecondary: onSecondary,
      onTertiary: onTertiary,
      onPrimaryContainer: onPrimaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      onTertiaryContainer: onTertiaryContainer,
      onDisabled: onDisabled,
      onSurface: onSurface,
      onBackground: onBackground,
      onWeak: onWeak,
      onError: onError,
      onInfo: onInfo,
      onSuccess: onSuccess,
      onWarning: onWarning,
      splashColor: splashColor,
      shadow: shadow,
      inverseSurface: inverseSurface,
      onInverseSurface: onInverseSurface,
      inversePrimary: inversePrimary,
      appBarColor: appBarColor ?? color.appBarColor,
      onAppBarColor: onAppBarColor ?? color.onAppBarColor,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      displayLarge: text.displayLarge,
      displayMedium: text.displayMedium,
      displaySmall: text.displaySmall,
      headlineLarge: text.headlineLarge,
      headlineMedium: text.headlineMedium,
      headlineSmall: text.headlineSmall,
      titleLarge: text.titleLarge,
      titleMedium: text.titleMedium,
      titleSmall: text.titleSmall,
      bodyLarge: text.bodyLarge,
      bodyMedium: text.bodyMedium,
      bodySmall: text.bodySmall,
      labelLarge: text.labelLarge,
      labelMedium: text.labelMedium,
      labelSmall: text.labelSmall,
      fontSizeFactor: text.fontSizeFactor,
      fontSizeDelta: text.fontSizeDelta,
      defaultFontFamily: text.defaultFontFamily,
      useMaterial3: useMaterial3,
      platform: platform,
      brightness: Brightness.light,
    );
  }

  /// Copy [AppThemeData] as DarkTheme.
  ///
  /// Basically, text and background colors are replaced with DarkTheme defaults unless specified otherwise.
  ///
  /// Text and other colors are copied as they are from the existing settings.
  ///
  /// [AppThemeData]をDarkThemeとしてコピーします。
  ///
  /// 基本的に文字色や背景色は指定しない限りDarkThemeのデフォルトに置き換えられます。
  ///
  /// 文字やその他の色は既存の設定がそのままコピーされます。
  AppThemeData copyWithDark({
    Color? primary,
    Color? secondary,
    Color? tertiary,
    Color? primaryContainer,
    Color? secondaryContainer,
    Color? tertiaryContainer,
    Color disabled = Colors.grey,
    Color weak = Colors.grey,
    Color outline = Colors.grey,
    Color? error,
    Color? warning,
    Color? info,
    Color? success,
    Color surface = kBlackColor,
    Color background = kBlackColor,
    Color onPrimary = kBlackColor,
    Color onSecondary = kBlackColor,
    Color onTertiary = kBlackColor,
    Color onPrimaryContainer = kBlackColor,
    Color onSecondaryContainer = kBlackColor,
    Color onTertiaryContainer = kBlackColor,
    Color onDisabled = kWhiteColor,
    Color onSurface = kWhiteColor,
    Color onBackground = kWhiteColor,
    Color onWeak = kBlackColor,
    Color onError = kBlackColor,
    Color onInfo = kBlackColor,
    Color onSuccess = kWhiteColor,
    Color onWarning = kBlackColor,
    Color splashColor = const Color(0xaaFFFFFF),
    Color shadow = Colors.black,
    Color inverseSurface = kWhiteColor,
    Color onInverseSurface = kBlackColor,
    Color inversePrimary = kBlackColor,
    Color? appBarColor,
    Color? onAppBarColor,
    Color scaffoldBackgroundColor = kBlackColor,
  }) {
    return AppThemeData(
      primary: primary ?? color.primary,
      secondary: secondary ?? color.secondary,
      tertiary: tertiary ?? color.tertiary,
      primaryContainer: primaryContainer ?? color.primaryContainer,
      secondaryContainer: secondaryContainer ?? color.secondaryContainer,
      tertiaryContainer: tertiaryContainer ?? color.tertiaryContainer,
      disabled: disabled,
      weak: weak,
      outline: outline,
      error: error ?? color.error,
      warning: warning ?? color.warning,
      info: info ?? color.info,
      success: success ?? color.success,
      surface: surface,
      background: background,
      onPrimary: onPrimary,
      onSecondary: onSecondary,
      onTertiary: onTertiary,
      onPrimaryContainer: onPrimaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      onTertiaryContainer: onTertiaryContainer,
      onDisabled: onDisabled,
      onSurface: onSurface,
      onBackground: onBackground,
      onWeak: onWeak,
      onError: onError,
      onInfo: onInfo,
      onSuccess: onSuccess,
      onWarning: onWarning,
      splashColor: splashColor,
      shadow: shadow,
      inverseSurface: inverseSurface,
      onInverseSurface: onInverseSurface,
      inversePrimary: inversePrimary,
      appBarColor: appBarColor ?? color.appBarColor,
      onAppBarColor: onAppBarColor ?? color.onAppBarColor,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      displayLarge: text.displayLarge,
      displayMedium: text.displayMedium,
      displaySmall: text.displaySmall,
      headlineLarge: text.headlineLarge,
      headlineMedium: text.headlineMedium,
      headlineSmall: text.headlineSmall,
      titleLarge: text.titleLarge,
      titleMedium: text.titleMedium,
      titleSmall: text.titleSmall,
      bodyLarge: text.bodyLarge,
      bodyMedium: text.bodyMedium,
      bodySmall: text.bodySmall,
      labelLarge: text.labelLarge,
      labelMedium: text.labelMedium,
      labelSmall: text.labelSmall,
      fontSizeFactor: text.fontSizeFactor,
      fontSizeDelta: text.fontSizeDelta,
      defaultFontFamily: text.defaultFontFamily,
      useMaterial3: useMaterial3,
      platform: platform,
      brightness: Brightness.dark,
    );
  }

  /// Returns the inverted Brightness of [AppThemeData].
  ///
  /// Basically, text and background colors are replaced with the defaults of each theme unless specified otherwise.
  ///
  /// Text and other colors are copied as they are from the existing settings.
  ///
  /// [AppThemeData]のBrightnessを反転したものを返します。
  ///
  /// 基本的に文字色や背景色は指定しない限り各テーマのデフォルトに置き換えられます。
  ///
  /// 文字やその他の色は既存の設定がそのままコピーされます。
  AppThemeData copyWithInvert({
    Color? primary,
    Color? secondary,
    Color? tertiary,
    Color? primaryContainer,
    Color? secondaryContainer,
    Color? tertiaryContainer,
    Color? disabled,
    Color? weak,
    Color? outline,
    Color? error,
    Color? warning,
    Color? info,
    Color? success,
    Color? surface,
    Color? background,
    Color? onPrimary,
    Color? onSecondary,
    Color? onTertiary,
    Color? onPrimaryContainer,
    Color? onSecondaryContainer,
    Color? onTertiaryContainer,
    Color? onDisabled,
    Color? onSurface,
    Color? onBackground,
    Color? onWeak,
    Color? onError,
    Color? onInfo,
    Color? onSuccess,
    Color? onWarning,
    Color? splashColor,
    Color? shadow,
    Color? inverseSurface,
    Color? onInverseSurface,
    Color? inversePrimary,
    Color? appBarColor,
    Color? onAppBarColor,
    Color? scaffoldBackgroundColor,
  }) {
    if (color.brightness == Brightness.light) {
      return copyWithDark(
        primary: primary,
        secondary: secondary,
        tertiary: tertiary,
        primaryContainer: primaryContainer,
        secondaryContainer: secondaryContainer,
        tertiaryContainer: tertiaryContainer,
        disabled: disabled ?? Colors.grey,
        weak: weak ?? Colors.grey,
        outline: outline ?? Colors.grey,
        error: error,
        warning: warning,
        info: info,
        success: success,
        surface: surface ?? kBlackColor,
        background: background ?? kBlackColor,
        onPrimary: onPrimary ?? kBlackColor,
        onSecondary: onSecondary ?? kBlackColor,
        onTertiary: onTertiary ?? kBlackColor,
        onPrimaryContainer: onPrimaryContainer ?? kBlackColor,
        onSecondaryContainer: onSecondaryContainer ?? kBlackColor,
        onTertiaryContainer: onTertiaryContainer ?? kBlackColor,
        onDisabled: onDisabled ?? kWhiteColor,
        onSurface: onSurface ?? kWhiteColor,
        onBackground: onBackground ?? kWhiteColor,
        onWeak: onWeak ?? kBlackColor,
        onError: onError ?? kBlackColor,
        onInfo: onInfo ?? kBlackColor,
        onSuccess: onSuccess ?? kWhiteColor,
        onWarning: onWarning ?? kBlackColor,
        splashColor: splashColor ?? const Color(0xaaFFFFFF),
        shadow: shadow ?? Colors.black,
        inverseSurface: inverseSurface ?? kWhiteColor,
        onInverseSurface: onInverseSurface ?? kBlackColor,
        inversePrimary: inversePrimary ?? kBlackColor,
        appBarColor: appBarColor,
        onAppBarColor: onAppBarColor,
        scaffoldBackgroundColor: scaffoldBackgroundColor ?? kBlackColor,
      );
    } else {
      return copyWithLight(
        primary: primary,
        secondary: secondary,
        tertiary: tertiary,
        primaryContainer: primaryContainer,
        secondaryContainer: secondaryContainer,
        tertiaryContainer: tertiaryContainer,
        disabled: disabled ?? Colors.grey,
        weak: weak ?? Colors.grey,
        outline: outline ?? Colors.grey,
        error: error,
        warning: warning,
        info: info,
        success: success,
        surface: surface ?? kWhiteColor,
        background: background ?? kWhiteColor,
        onPrimary: onPrimary ?? kWhiteColor,
        onSecondary: onSecondary ?? kWhiteColor,
        onTertiary: onTertiary ?? kWhiteColor,
        onPrimaryContainer: onPrimaryContainer ?? kWhiteColor,
        onSecondaryContainer: onSecondaryContainer ?? kWhiteColor,
        onTertiaryContainer: onTertiaryContainer ?? kWhiteColor,
        onDisabled: onDisabled ?? kWhiteColor,
        onSurface: onSurface ?? kBlackColor,
        onBackground: onBackground ?? kBlackColor,
        onWeak: onWeak ?? kWhiteColor,
        onError: onError ?? kWhiteColor,
        onInfo: onInfo ?? kWhiteColor,
        onSuccess: onSuccess ?? kBlackColor,
        onWarning: onWarning ?? kWhiteColor,
        splashColor: splashColor ?? const Color(0xaaFFFFFF),
        shadow: shadow ?? Colors.black,
        inverseSurface: inverseSurface ?? kBlackColor,
        onInverseSurface: onInverseSurface ?? kWhiteColor,
        inversePrimary: inversePrimary ?? kWhiteColor,
        appBarColor: appBarColor,
        onAppBarColor: onAppBarColor,
        scaffoldBackgroundColor: scaffoldBackgroundColor ?? kWhiteColor,
      );
    }
  }
}

/// Define a color scheme.
///
/// New themes can be defined by extending [ColorThemeData].
///
/// カラースキームを定義します。
///
/// [ColorThemeData]をエクステンションすることで新しいテーマを定義することが可能です。
///
/// See also:
///
///   - https://m3.material.io/styles/color/the-color-system/color-roles
@immutable
class ColorThemeData {
  const ColorThemeData._({
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.primaryContainer,
    required this.secondaryContainer,
    required this.tertiaryContainer,
    required this.disabled,
    required this.weak,
    required this.outline,
    required this.error,
    required this.warning,
    required this.info,
    required this.success,
    required this.surface,
    required this.background,
    required this.onPrimary,
    required this.onSecondary,
    required this.onTertiary,
    required this.onPrimaryContainer,
    required this.onSecondaryContainer,
    required this.onTertiaryContainer,
    required this.onDisabled,
    required this.onSurface,
    required this.onBackground,
    required this.onWeak,
    required this.onError,
    required this.onInfo,
    required this.onSuccess,
    required this.onWarning,
    required this.splashColor,
    required this.shadow,
    required this.inverseSurface,
    required this.onInverseSurface,
    required this.inversePrimary,
    required this.brightness,
    this.appBarColor,
    this.onAppBarColor,
    Color? canvasColor,
    Color? scaffoldBackgroundColor,
  })  : _scaffoldBackgroundColor = scaffoldBackgroundColor,
        _canvas = canvasColor;

  /// Define [Brightness] for the application. [Brightness.dark] will set it to dark mode and [Brightness.light] will set it to light mode.
  ///
  /// アプリの[Brightness]を定義します。[Brightness.dark]でダークモードに、[Brightness.light]でライトモードになります。
  final Brightness brightness;

  /// Primary key color.
  ///
  /// プライマリーのキーカラー。
  ///
  /// See also:
  ///
  ///   - https://m3.material.io/styles/color/the-color-system/color-roles
  final Color primary;

  /// Secondary key color.
  ///
  /// セカンダリーのキーカラー。
  ///
  /// See also:
  ///
  ///   - https://m3.material.io/styles/color/the-color-system/color-roles
  final Color secondary;

  /// Tertiary key color.
  ///
  /// サーシャリーのキーカラー。
  ///
  /// See also:
  ///
  ///   - https://m3.material.io/styles/color/the-color-system/color-roles
  final Color tertiary;

  /// Primary container color.
  ///
  /// プライマリーのコンテナカラー。
  ///
  /// See also:
  ///
  ///   - https://m3.material.io/styles/color/the-color-system/color-roles
  final Color primaryContainer;

  /// Secondary container color.
  ///
  /// セカンダリーのコンテナカラー。
  ///
  /// See also:
  ///
  ///   - https://m3.material.io/styles/color/the-color-system/color-roles
  final Color secondaryContainer;

  /// Searshally container color.
  ///
  /// サーシャリーのコンテナカラー。
  ///
  /// See also:
  ///
  ///   - https://m3.material.io/styles/color/the-color-system/color-roles
  final Color tertiaryContainer;

  /// Color when inactive.
  ///
  /// 非アクティブ時のカラー。
  ///
  /// See also:
  ///
  ///   - https://m3.material.io/styles/color/the-color-system/color-roles
  final Color disabled;

  /// Color for light text color.
  ///
  /// These are colors outside of the Material3 color scheme.
  ///
  /// 薄い文字色用のカラー。
  ///
  /// Material3のカラースキーム外のカラーです。
  final Color weak;

  /// Colors for Borderline and Divider.
  ///
  /// ボーダーラインやDivider用のカラー。
  ///
  /// See also:
  ///
  ///   - https://m3.material.io/styles/color/the-color-system/color-roles
  final Color outline;

  /// Color for error.
  ///
  /// エラー用のカラー。
  ///
  /// See also:
  ///
  ///   - https://m3.material.io/styles/color/the-color-system/color-roles
  final Color error;

  /// Colors for Warning.
  ///
  /// These are colors outside of the Material3 color scheme.
  ///
  /// ワーニング用のカラー。
  ///
  /// Material3のカラースキーム外のカラーです。
  final Color warning;

  /// Colors for information display.
  ///
  /// These are colors outside of the Material3 color scheme.
  ///
  /// 情報表示用のカラー。
  ///
  /// Material3のカラースキーム外のカラーです。
  final Color info;

  /// Color for successful processing.
  ///
  /// These are colors outside of the Material3 color scheme.
  ///
  /// 処理成功時用のカラー。
  ///
  /// Material3のカラースキーム外のカラーです。
  final Color success;

  /// Background color for dialogs, cards, etc.
  ///
  /// ダイアログやカードなどの背景色。
  ///
  /// See also:
  ///
  ///   - https://m3.material.io/styles/color/the-color-system/color-roles
  final Color surface;

  /// Background color.
  ///
  /// 背景色。
  ///
  /// See also:
  ///
  ///   - https://m3.material.io/styles/color/the-color-system/color-roles
  final Color background;

  /// Color of text and icons on [primary].
  ///
  /// [primary]上のテキストやアイコンのカラー。
  ///
  /// See also:
  ///
  ///   - https://m3.material.io/styles/color/the-color-system/color-roles
  final Color onPrimary;

  /// Color of text and icons on [secondary].
  ///
  /// [secondary]上のテキストやアイコンのカラー。
  ///
  /// See also:
  ///
  ///   - https://m3.material.io/styles/color/the-color-system/color-roles
  final Color onSecondary;

  /// Color of text and icons on [tertiary].
  ///
  /// [tertiary]上のテキストやアイコンのカラー。
  ///
  /// See also:
  ///
  ///   - https://m3.material.io/styles/color/the-color-system/color-roles
  final Color onTertiary;

  /// Color of text and icons on [primaryContainer].
  ///
  /// [primaryContainer]上のテキストやアイコンのカラー。
  ///
  /// See also:
  ///
  ///   - https://m3.material.io/styles/color/the-color-system/color-roles
  final Color onPrimaryContainer;

  /// Color of text and icons on [secondaryContainer].
  ///
  /// [secondaryContainer]上のテキストやアイコンのカラー。
  ///
  /// See also:
  ///
  ///   - https://m3.material.io/styles/color/the-color-system/color-roles
  final Color onSecondaryContainer;

  /// Color of text and icons on [tertiaryContainer].
  ///
  /// [tertiaryContainer]上のテキストやアイコンのカラー。
  ///
  /// See also:
  ///
  ///   - https://m3.material.io/styles/color/the-color-system/color-roles
  final Color onTertiaryContainer;

  /// Color of text and icons on [disabled].
  ///
  /// [disabled]上のテキストやアイコンのカラー。
  ///
  /// See also:
  ///
  ///   - https://m3.material.io/styles/color/the-color-system/color-roles
  final Color onDisabled;

  /// Color of text and icons on [surface].
  ///
  /// [surface]上のテキストやアイコンのカラー。
  ///
  /// See also:
  ///
  ///   - https://m3.material.io/styles/color/the-color-system/color-roles
  final Color onSurface;

  /// color of text and icons on [background]. Usually the text color.
  ///
  /// [background]上のテキストやアイコンのカラー。通常文字色。
  ///
  /// See also:
  ///
  ///   - https://m3.material.io/styles/color/the-color-system/color-roles
  final Color onBackground;

  /// Color of text and icons on [weak].
  ///
  /// These are colors outside of the Material3 color scheme.
  ///
  /// [weak]上のテキストやアイコンのカラー。
  ///
  /// Material3のカラースキーム外のカラーです。
  final Color onWeak;

  /// Color of text and icons on [error].
  ///
  /// [error]上のテキストやアイコンのカラー。
  ///
  /// See also:
  ///
  ///   - https://m3.material.io/styles/color/the-color-system/color-roles
  final Color onError;

  /// Color of text and icons on [info].
  ///
  /// These are colors outside of the Material3 color scheme.
  ///
  /// [info]上のテキストやアイコンのカラー。
  ///
  /// Material3のカラースキーム外のカラーです。
  final Color onInfo;

  /// Color of text and icons on [success].
  ///
  /// These are colors outside of the Material3 color scheme.
  ///
  /// [success]上のテキストやアイコンのカラー。
  ///
  /// Material3のカラースキーム外のカラーです。
  final Color onSuccess;

  /// Color of text and icons on [warning].
  ///
  /// These are colors outside of the Material3 color scheme.
  ///
  /// [warning]上のテキストやアイコンのカラー。
  ///
  /// Material3のカラースキーム外のカラーです。
  final Color onWarning;

  /// Background color of [AppBar].
  ///
  /// These are colors outside of the Material3 color scheme.
  ///
  /// [AppBar]の背景色。
  ///
  /// Material3のカラースキーム外のカラーです。
  final Color? appBarColor;

  /// Color of text and icons in [AppBar].
  ///
  /// These are colors outside of the Material3 color scheme.
  ///
  /// [AppBar]のテキストやアイコンのカラー。
  ///
  /// Material3のカラースキーム外のカラーです。
  final Color? onAppBarColor;

  /// Background color of [Scaffold].
  ///
  /// These are colors outside of the Material3 color scheme.
  ///
  /// [Scaffold]の背景色。
  ///
  /// Material3のカラースキーム外のカラーです。
  Color get scaffoldBackgroundColor {
    if (_scaffoldBackgroundColor != null) {
      return _scaffoldBackgroundColor!;
    }
    return brightness == Brightness.dark ? Colors.grey[850]! : Colors.grey[50]!;
  }

  final Color? _scaffoldBackgroundColor;

  /// Canvas background color.
  ///
  /// These are colors outside of the Material3 color scheme.
  ///
  /// キャンバスの背景色。
  ///
  /// Material3のカラースキーム外のカラーです。
  Color get canvas {
    if (_canvas != null) {
      return _canvas!;
    }
    return brightness == Brightness.dark ? Colors.grey[850]! : Colors.grey[50]!;
  }

  final Color? _canvas;

  /// Color for the effect when the button is tapped.
  ///
  /// These are colors outside of the Material3 color scheme.
  ///
  /// ボタンをタップしたときのエフェクト用のカラー。
  ///
  /// Material3のカラースキーム外のカラーです。
  final Color? splashColor;

  /// Shadow color.
  ///
  /// These are colors outside of the Material3 color scheme.
  ///
  /// 影の色。
  ///
  /// Material3のカラースキーム外のカラーです。
  final Color shadow;

  /// Inverted black and white [surface] color.
  ///
  /// These are colors outside of the Material3 color scheme.
  ///
  /// 白黒反転させた[surface]の色。
  ///
  /// Material3のカラースキーム外のカラーです。
  final Color inverseSurface;

  /// Color of text and icons on [inverseSurface].
  ///
  /// These are colors outside of the Material3 color scheme.
  ///
  /// [inverseSurface]上のテキストやアイコンのカラー。
  ///
  /// Material3のカラースキーム外のカラーです。
  final Color onInverseSurface;

  /// Inverted black and white [primary] color.
  ///
  /// These are colors outside of the Material3 color scheme.
  ///
  /// 白黒反転させた[primary]の色。
  ///
  /// Material3のカラースキーム外のカラーです。
  final Color inversePrimary;
}

/// Define a text theme.
///
/// New themes can be defined by extending [TextThemeData].
///
/// テキストテーマを定義します。
///
/// [TextThemeData]をエクステンションすることで新しいテーマを定義することが可能です。
///
/// See also:
///
///   - https://m3.material.io/styles/typography/type-scale-tokens
@immutable
class TextThemeData {
  const TextThemeData._({
    required this.displayLarge,
    required this.displayMedium,
    required this.displaySmall,
    required this.headlineLarge,
    required this.headlineMedium,
    required this.headlineSmall,
    required this.titleLarge,
    required this.titleMedium,
    required this.titleSmall,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.labelLarge,
    required this.labelMedium,
    required this.labelSmall,
    this.fontSizeFactor = 1.0,
    this.fontSizeDelta = 0.0,
    this.defaultFontFamily,
  });

  /// Large letters for display.
  ///
  /// Get the larger [TextStyle] of them.
  ///
  /// ディスプレイ用の大きな文字。
  ///
  /// その中でも大きめの[TextStyle]を取得します。
  ///
  /// See also:
  ///
  ///   - https://m3.material.io/styles/typography/type-scale-tokens
  ///   - https://m3.material.io/styles/typography/applying-type
  final TextStyle displayLarge;

  /// Large letters for display.
  ///
  /// Get the medium [TextStyle] of them.
  ///
  /// ディスプレイ用の大きな文字。
  ///
  /// その中でも中くらいの[TextStyle]を取得します。
  ///
  /// See also:
  ///
  ///   - https://m3.material.io/styles/typography/type-scale-tokens
  ///   - https://m3.material.io/styles/typography/applying-type
  final TextStyle displayMedium;

  /// Large letters for display.
  ///
  /// Get the smaller [TextStyle] of them.
  ///
  /// ディスプレイ用の大きな文字。
  ///
  /// その中でも小さめの[TextStyle]を取得します。
  ///
  /// See also:
  ///
  ///   - https://m3.material.io/styles/typography/type-scale-tokens
  ///   - https://m3.material.io/styles/typography/applying-type
  final TextStyle displaySmall;

  /// Text for headlines.
  ///
  /// Get the larger [TextStyle] of them.
  ///
  /// ヘッドライン（見出し）用の文字。
  ///
  /// その中でも大きめの[TextStyle]を取得します。
  ///
  /// See also:
  ///
  ///   - https://m3.material.io/styles/typography/type-scale-tokens
  ///   - https://m3.material.io/styles/typography/applying-type
  final TextStyle headlineLarge;

  /// Text for headlines.
  ///
  /// Get the medium [TextStyle] of them.
  ///
  /// ヘッドライン（見出し）用の文字。
  ///
  /// その中でも中くらいの[TextStyle]を取得します。
  ///
  /// See also:
  ///
  ///   - https://m3.material.io/styles/typography/type-scale-tokens
  ///   - https://m3.material.io/styles/typography/applying-type
  final TextStyle headlineMedium;

  /// Text for headlines.
  ///
  /// Get the smaller [TextStyle] of them.
  ///
  /// ヘッドライン（見出し）用の文字。
  ///
  /// その中でも小さめの[TextStyle]を取得します。
  ///
  /// See also:
  ///
  ///   - https://m3.material.io/styles/typography/type-scale-tokens
  ///   - https://m3.material.io/styles/typography/applying-type
  final TextStyle headlineSmall;

  /// Text for the title of each widget.
  ///
  /// Get the larger [TextStyle] of them.
  ///
  /// 各ウィジェットのタイトル用の文字。
  ///
  /// その中でも大きめの[TextStyle]を取得します。
  ///
  /// See also:
  ///
  ///   - https://m3.material.io/styles/typography/type-scale-tokens
  ///   - https://m3.material.io/styles/typography/applying-type
  final TextStyle titleLarge;

  /// Text for the title of each widget.
  ///
  /// Get the medium [TextStyle] of them.
  ///
  /// 各ウィジェットのタイトル用の文字。
  ///
  /// その中でも中くらいの[TextStyle]を取得します。
  ///
  /// See also:
  ///
  ///   - https://m3.material.io/styles/typography/type-scale-tokens
  ///   - https://m3.material.io/styles/typography/applying-type
  final TextStyle titleMedium;

  /// Text for the title of each widget.
  ///
  /// Get the smaller [TextStyle] of them.
  ///
  /// 各ウィジェットのタイトル用の文字。
  ///
  /// その中でも小さめの[TextStyle]を取得します。
  ///
  /// See also:
  ///
  ///   - https://m3.material.io/styles/typography/type-scale-tokens
  ///   - https://m3.material.io/styles/typography/applying-type
  final TextStyle titleSmall;

  /// Text for regular text.
  ///
  /// Get the larger [TextStyle] of them.
  ///
  /// 通常文章用の文字。
  ///
  /// その中でも大きめの[TextStyle]を取得します。
  ///
  /// See also:
  ///
  ///   - https://m3.material.io/styles/typography/type-scale-tokens
  ///   - https://m3.material.io/styles/typography/applying-type
  final TextStyle bodyLarge;

  /// Text for regular text.
  ///
  /// Get the medium [TextStyle] of them.
  ///
  /// 通常文章用の文字。
  ///
  /// その中でも中くらいの[TextStyle]を取得します。
  ///
  /// See also:
  ///
  ///   - https://m3.material.io/styles/typography/type-scale-tokens
  ///   - https://m3.material.io/styles/typography/applying-type
  final TextStyle bodyMedium;

  /// Text for regular text.
  ///
  /// Get the smaller [TextStyle] of them.
  ///
  /// 通常文章用の文字。
  ///
  /// その中でも小さめの[TextStyle]を取得します。
  ///
  /// See also:
  ///
  ///   - https://m3.material.io/styles/typography/type-scale-tokens
  ///   - https://m3.material.io/styles/typography/applying-type
  final TextStyle bodySmall;

  /// Characters used for text, captions, etc. within each widget.
  ///
  /// Get the larger [TextStyle] of them.
  ///
  /// 各ウィジェット内の文字やキャプション等に用いる文字。
  ///
  /// その中でも大きめの[TextStyle]を取得します。
  ///
  /// See also:
  ///
  ///   - https://m3.material.io/styles/typography/type-scale-tokens
  ///   - https://m3.material.io/styles/typography/applying-type
  final TextStyle labelLarge;

  /// Characters used for text, captions, etc. within each widget.
  ///
  /// Get the medium [TextStyle] of them.
  ///
  /// 各ウィジェット内の文字やキャプション等に用いる文字。
  ///
  /// その中でも中くらいの[TextStyle]を取得します。
  ///
  /// See also:
  ///
  ///   - https://m3.material.io/styles/typography/type-scale-tokens
  ///   - https://m3.material.io/styles/typography/applying-type
  final TextStyle labelMedium;

  /// Characters used for text, captions, etc. within each widget.
  ///
  /// Get the smaller [TextStyle] of them.
  ///
  /// 各ウィジェット内の文字やキャプション等に用いる文字。
  ///
  /// その中でも小さめの[TextStyle]を取得します。
  ///
  /// See also:
  ///
  ///   - https://m3.material.io/styles/typography/type-scale-tokens
  ///   - https://m3.material.io/styles/typography/applying-type
  final TextStyle labelSmall;

  /// Increase the font size of the entire app by a multiple of this value.
  ///
  /// For more detailed adjustment, specify [fontSizeDelta].
  ///
  /// アプリ全体のフォントサイズをこの値の倍数だけ大きくします。
  ///
  /// さらに細かい調整をしたい場合は[fontSizeDelta]を指定してください。
  final double fontSizeFactor;

  /// Increase the font size of the entire app by this value.
  ///
  /// For larger adjustments, specify [fontSizeFactor].
  ///
  /// アプリ全体のフォントサイズをこの値分だけ大きくします。
  ///
  /// 大きい調整をしたい場合は[fontSizeFactor]を指定してください。
  final double fontSizeDelta;

  /// Default font family.
  ///
  /// If this is specified, this is the font family when none is specified.
  ///
  /// デフォルトのフォントファミリー。
  ///
  /// これが指定されている場合、何も指定されないときのフォントファミリーはこれになります。
  final String? defaultFontFamily;
}

/// Defines the theme of the widget.
///
/// New themes can be defined by extending [WidgetThemeData].
///
/// ウィジェットのテーマを定義します。
///
/// [WidgetThemeData]をエクステンションすることで新しいテーマを定義することが可能です。
@immutable
class WidgetThemeData {
  const WidgetThemeData._();
}

/// Defines a list of asset paths.
///
/// The builder will allow you to retrieve the assets defined in pubspec.yaml.
///
/// New themes can be defined by extending [AssetThemeData].
///
/// アセットのパス一覧を定義します。
///
/// ビルダーによってpubspec.yaml内に定義されたアセットを取得することができるようになります。
///
/// [AssetThemeData]をエクステンションすることで新しいテーマを定義することが可能です。
@immutable
class AssetThemeData {
  const AssetThemeData._();
}

/// Define font themes.
///
/// The builder will allow you to retrieve the font families defined in pubspec.yaml.
///
/// New themes can be defined by extending [FontThemeData].
///
/// フォントテーマを定義します。
///
/// ビルダーによってpubspec.yaml内に定義されたフォントファミリーを取得することができるようになります。
///
/// [FontThemeData]をエクステンションすることで新しいテーマを定義することが可能です。
@immutable
class FontThemeData {
  const FontThemeData._();
}
