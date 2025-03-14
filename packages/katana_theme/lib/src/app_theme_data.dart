part of '/katana_theme.dart';

/// White for design.
///
/// デザイン用の白色。
const kWhiteColor = Color(0xFFF7F7F7);

/// Dark white for design.
///
/// デザイン用の暗い白色。
const kWhiteSurfaceColor = Color(0xFFE7E7E7);

/// Black for design.
///
/// デザイン用の黒色。
const kBlackColor = Color(0xFF212121);

/// Bright black color for design.
///
/// デザイン用の明るい黒色。
const kBlackSurfaceColor = Color(0xFF474747);

/// Splash color.
///
/// スプラッシュカラー。
const kSplashColor = Color(0xaaFFFFFF);

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
    Color? outlineVariant,
    Color error = Colors.red,
    Color warning = Colors.amber,
    Color info = Colors.blue,
    Color success = Colors.green,
    Color? surface,
    Color? surfaceVariant,
    Color? background,
    Color onPrimary = kWhiteColor,
    Color onSecondary = kWhiteColor,
    Color onTertiary = kWhiteColor,
    Color onPrimaryContainer = kWhiteColor,
    Color onSecondaryContainer = kWhiteColor,
    Color onTertiaryContainer = kWhiteColor,
    Color onDisabled = kWhiteColor,
    Color? onSurface,
    Color? onSurfaceVariant,
    Color? onBackground,
    Color onWeak = kWhiteColor,
    Color onError = kWhiteColor,
    Color onInfo = kWhiteColor,
    Color onSuccess = kWhiteColor,
    Color onWarning = kWhiteColor,
    Color splashColor = kSplashColor,
    Color shadow = Colors.black,
    Color? appBarColor,
    Color? onAppBarColor,
    Color? onExpandedAppBarColor,
    Color? scaffoldBackgroundColor,
    Color? dialogColor,
    Color? onDialogColor,
    Color? inversePrimary,
    Color? inverseSecondary,
    Color? inverseTertiary,
    Color? inversePrimaryContainer,
    Color? inverseSecondaryContainer,
    Color? inverseTertiaryContainer,
    Color? inverseDisabled,
    Color? inverseWeak,
    Color? inverseOutline,
    Color? inverseError,
    Color? inverseWarning,
    Color? inverseInfo,
    Color? inverseSuccess,
    Color? inverseSurface,
    Color? inverseBackground,
    Color? onInversePrimary,
    Color? onInverseSecondary,
    Color? onInverseTertiary,
    Color? onInversePrimaryContainer,
    Color? onInverseSecondaryContainer,
    Color? onInverseTertiaryContainer,
    Color? onInverseDisabled,
    Color? onInverseSurface,
    Color? onInverseBackground,
    Color? onInverseWeak,
    Color? onInverseError,
    Color? onInverseInfo,
    Color? onInverseSuccess,
    Color? onInverseWarning,
    Color? inverseSplashColor,
    Color? inverseShadow,
    Color? inverseAppBarColor,
    Color? onInverseAppBarColor,
    Color? onInverseExpandedAppBarColor,
    Color? inverseScaffoldBackgroundColor,
    Color? inverseDialogColor,
    Color? onInverseDialogColor,
    this.themeMode = ThemeMode.system,
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
    this.centerTitleOnAppBar,
    Brightness brightness = Brightness.light,
    this.statusBarBrightnessOnIOS,
    this.statusBarBrightnessOnAndroid,
    this.fixed = false,
    this.defaultFontFamilyResolver,
  })  : _lightColor = brightness == Brightness.light
            ? ColorThemeData._(
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
                outlineVariant: outlineVariant ?? outline,
                error: error,
                warning: warning,
                info: info,
                success: success,
                surface: surface ?? _surface(brightness),
                surfaceVariant:
                    surfaceVariant ?? surface ?? _surface(brightness),
                background: background ?? _background(brightness),
                onPrimary: onPrimary,
                onSecondary: onSecondary,
                onTertiary: onTertiary,
                onPrimaryContainer: onPrimaryContainer,
                onSecondaryContainer: onSecondaryContainer,
                onTertiaryContainer: onTertiaryContainer,
                onDisabled: onDisabled,
                onSurface: onSurface ?? _onBackgroundOrSurface(brightness),
                onSurfaceVariant: onSurfaceVariant ??
                    onSurface ??
                    _onBackgroundOrSurface(brightness),
                onBackground:
                    onBackground ?? _onBackgroundOrSurface(brightness),
                onWeak: onWeak,
                onError: onError,
                onInfo: onInfo,
                onSuccess: onSuccess,
                onWarning: onWarning,
                splashColor: splashColor,
                shadow: shadow,
                inverseSurface: inverseSurface ??
                    surface ??
                    _surface(_inverse(brightness, fixed)),
                onInverseSurface: onInverseSurface ??
                    onSurface ??
                    _onBackgroundOrSurface(_inverse(brightness, fixed)),
                inversePrimary: inversePrimary ?? primary,
                appBarColor: appBarColor,
                onAppBarColor: onAppBarColor,
                onExpandedAppBarColor: onExpandedAppBarColor,
                scaffoldBackgroundColor:
                    scaffoldBackgroundColor ?? _background(brightness),
                dialogColor: dialogColor ?? surface,
                onDialogColor: onDialogColor ?? onSurface,
              )
            : ColorThemeData._(
                brightness: Brightness.dark,
                primary: inversePrimary ?? primary,
                secondary: inverseSecondary ?? secondary,
                tertiary: inverseTertiary ?? tertiary,
                primaryContainer: inversePrimaryContainer ?? primaryContainer,
                secondaryContainer:
                    inverseSecondaryContainer ?? secondaryContainer,
                tertiaryContainer:
                    inverseTertiaryContainer ?? tertiaryContainer,
                disabled: inverseDisabled ?? disabled,
                weak: inverseWeak ?? weak,
                outline: inverseOutline ?? outline,
                outlineVariant: outlineVariant ?? outline,
                error: inverseError ?? error,
                warning: inverseWarning ?? warning,
                info: inverseInfo ?? info,
                success: inverseSuccess ?? success,
                surface: inverseSurface ??
                    surface ??
                    _surface(_inverse(brightness, fixed)),
                surfaceVariant:
                    surfaceVariant ?? surface ?? _surface(brightness),
                background: inverseBackground ??
                    background ??
                    _background(_inverse(brightness, fixed)),
                onPrimary: onInversePrimary ?? onPrimary,
                onSecondary: onInverseSecondary ?? onSecondary,
                onTertiary: onInverseTertiary ?? onTertiary,
                onPrimaryContainer:
                    onInversePrimaryContainer ?? onPrimaryContainer,
                onSecondaryContainer:
                    onInverseSecondaryContainer ?? onSecondaryContainer,
                onTertiaryContainer:
                    onInverseTertiaryContainer ?? onTertiaryContainer,
                onDisabled: onInverseDisabled ?? onDisabled,
                onSurface: onInverseSurface ??
                    onSurface ??
                    _onBackgroundOrSurface(_inverse(brightness, fixed)),
                onSurfaceVariant: onSurfaceVariant ??
                    onSurface ??
                    _onBackgroundOrSurface(brightness),
                onBackground: onInverseBackground ??
                    onBackground ??
                    _onBackgroundOrSurface(_inverse(brightness, fixed)),
                onWeak: onInverseWeak ?? onWeak,
                onError: onInverseError ?? onError,
                onInfo: onInverseInfo ?? onInfo,
                onSuccess: onInverseSuccess ?? onSuccess,
                onWarning: onInverseWarning ?? onWarning,
                splashColor: inverseSplashColor ?? splashColor,
                shadow: inverseShadow ?? shadow,
                inverseSurface:
                    surface ?? inverseSurface ?? _surface(brightness),
                onInverseSurface: onInverseSurface ??
                    onSurface ??
                    _onBackgroundOrSurface(brightness),
                inversePrimary: primary,
                appBarColor: inverseAppBarColor ?? appBarColor,
                onAppBarColor: onInverseAppBarColor ?? onAppBarColor,
                onExpandedAppBarColor:
                    onInverseExpandedAppBarColor ?? onExpandedAppBarColor,
                scaffoldBackgroundColor: inverseScaffoldBackgroundColor ??
                    scaffoldBackgroundColor ??
                    _background(_inverse(brightness, fixed)),
                dialogColor: inverseDialogColor ??
                    inverseSurface ??
                    dialogColor ??
                    surface,
                onDialogColor: onInverseDialogColor ??
                    onInverseSurface ??
                    onDialogColor ??
                    onSurface,
              ),
        _darkColor = brightness == Brightness.dark
            ? ColorThemeData._(
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
                outlineVariant: outlineVariant ?? outline,
                error: error,
                warning: warning,
                info: info,
                success: success,
                surface: surface ?? _surface(brightness),
                surfaceVariant:
                    surfaceVariant ?? surface ?? _surface(brightness),
                background: background ?? _background(brightness),
                onPrimary: onPrimary,
                onSecondary: onSecondary,
                onTertiary: onTertiary,
                onPrimaryContainer: onPrimaryContainer,
                onSecondaryContainer: onSecondaryContainer,
                onTertiaryContainer: onTertiaryContainer,
                onDisabled: onDisabled,
                onSurface: onSurface ?? _onBackgroundOrSurface(brightness),
                onSurfaceVariant: onSurfaceVariant ??
                    onSurface ??
                    _onBackgroundOrSurface(brightness),
                onBackground:
                    onBackground ?? _onBackgroundOrSurface(brightness),
                onWeak: onWeak,
                onError: onError,
                onInfo: onInfo,
                onSuccess: onSuccess,
                onWarning: onWarning,
                splashColor: splashColor,
                shadow: shadow,
                inverseSurface: inverseSurface ??
                    surface ??
                    _surface(_inverse(brightness, fixed)),
                onInverseSurface: onInverseSurface ??
                    onSurface ??
                    _onBackgroundOrSurface(_inverse(brightness, fixed)),
                inversePrimary: inversePrimary ?? primary,
                appBarColor: appBarColor,
                onAppBarColor: onAppBarColor,
                onExpandedAppBarColor: onExpandedAppBarColor,
                scaffoldBackgroundColor:
                    scaffoldBackgroundColor ?? _background(brightness),
                dialogColor: dialogColor ?? surface,
                onDialogColor: onDialogColor ?? onSurface,
              )
            : ColorThemeData._(
                brightness: Brightness.light,
                primary: inversePrimary ?? primary,
                secondary: inverseSecondary ?? secondary,
                tertiary: inverseTertiary ?? tertiary,
                primaryContainer: inversePrimaryContainer ?? primaryContainer,
                secondaryContainer:
                    inverseSecondaryContainer ?? secondaryContainer,
                tertiaryContainer:
                    inverseTertiaryContainer ?? tertiaryContainer,
                disabled: inverseDisabled ?? disabled,
                weak: inverseWeak ?? weak,
                outline: inverseOutline ?? outline,
                outlineVariant: outlineVariant ?? outline,
                error: inverseError ?? error,
                warning: inverseWarning ?? warning,
                info: inverseInfo ?? info,
                success: inverseSuccess ?? success,
                surface: inverseSurface ??
                    surface ??
                    _surface(_inverse(brightness, fixed)),
                surfaceVariant:
                    surfaceVariant ?? surface ?? _surface(brightness),
                background: inverseBackground ??
                    background ??
                    _background(_inverse(brightness, fixed)),
                onPrimary: onInversePrimary ?? onPrimary,
                onSecondary: onInverseSecondary ?? onSecondary,
                onTertiary: onInverseTertiary ?? onTertiary,
                onPrimaryContainer:
                    onInversePrimaryContainer ?? onPrimaryContainer,
                onSecondaryContainer:
                    onInverseSecondaryContainer ?? onSecondaryContainer,
                onTertiaryContainer:
                    onInverseTertiaryContainer ?? onTertiaryContainer,
                onDisabled: onInverseDisabled ?? onDisabled,
                onSurface: onInverseSurface ??
                    onSurface ??
                    _onBackgroundOrSurface(_inverse(brightness, fixed)),
                onSurfaceVariant: onSurfaceVariant ??
                    onSurface ??
                    _onBackgroundOrSurface(brightness),
                onBackground: onInverseBackground ??
                    onBackground ??
                    _onBackgroundOrSurface(_inverse(brightness, fixed)),
                onWeak: onInverseWeak ?? onWeak,
                onError: onInverseError ?? onError,
                onInfo: onInverseInfo ?? onInfo,
                onSuccess: onInverseSuccess ?? onSuccess,
                onWarning: onInverseWarning ?? onWarning,
                splashColor: inverseSplashColor ?? splashColor,
                shadow: inverseShadow ?? shadow,
                inverseSurface:
                    surface ?? inverseSurface ?? _surface(brightness),
                onInverseSurface: onInverseSurface ??
                    onSurface ??
                    _onBackgroundOrSurface(brightness),
                inversePrimary: primary,
                appBarColor: inverseAppBarColor ?? appBarColor,
                onAppBarColor: onInverseAppBarColor ?? onAppBarColor,
                onExpandedAppBarColor:
                    onInverseExpandedAppBarColor ?? onExpandedAppBarColor,
                scaffoldBackgroundColor: inverseScaffoldBackgroundColor ??
                    scaffoldBackgroundColor ??
                    _background(_inverse(brightness, fixed)),
                dialogColor: inverseDialogColor ??
                    inverseSurface ??
                    dialogColor ??
                    surface,
                onDialogColor: onInverseDialogColor ??
                    onInverseSurface ??
                    onDialogColor ??
                    onSurface,
              ),
        _text = TextThemeData._(
          displayLarge: displayLarge.copyWith(fontFamily: defaultFontFamily),
          displayMedium: displayMedium.copyWith(fontFamily: defaultFontFamily),
          displaySmall: displaySmall.copyWith(fontFamily: defaultFontFamily),
          headlineLarge: headlineLarge.copyWith(fontFamily: defaultFontFamily),
          headlineMedium:
              headlineMedium.copyWith(fontFamily: defaultFontFamily),
          headlineSmall: headlineSmall.copyWith(fontFamily: defaultFontFamily),
          titleLarge: titleLarge.copyWith(fontFamily: defaultFontFamily),
          titleMedium: titleMedium.copyWith(fontFamily: defaultFontFamily),
          titleSmall: titleSmall.copyWith(fontFamily: defaultFontFamily),
          bodyLarge: bodyLarge.copyWith(fontFamily: defaultFontFamily),
          bodyMedium: bodyMedium.copyWith(fontFamily: defaultFontFamily),
          bodySmall: bodySmall.copyWith(fontFamily: defaultFontFamily),
          labelLarge: labelLarge.copyWith(fontFamily: defaultFontFamily),
          labelMedium: labelMedium.copyWith(fontFamily: defaultFontFamily),
          labelSmall: labelSmall.copyWith(fontFamily: defaultFontFamily),
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
    Color? outlineVariant,
    Color error = Colors.red,
    Color warning = Colors.amber,
    Color info = Colors.blue,
    Color success = Colors.green,
    Color? surface,
    Color? surfaceVariant,
    Color? background,
    Color onPrimary = kWhiteColor,
    Color onSecondary = kWhiteColor,
    Color onTertiary = kWhiteColor,
    Color onPrimaryContainer = kWhiteColor,
    Color onSecondaryContainer = kWhiteColor,
    Color onTertiaryContainer = kWhiteColor,
    Color onDisabled = kWhiteColor,
    Color? onSurface,
    Color? onSurfaceVariant,
    Color? onBackground,
    Color onWeak = kWhiteColor,
    Color onError = kWhiteColor,
    Color onInfo = kWhiteColor,
    Color onSuccess = kWhiteColor,
    Color onWarning = kWhiteColor,
    Color splashColor = kSplashColor,
    Color shadow = Colors.black,
    Color? appBarColor,
    Color? onAppBarColor,
    Color? onExpandedAppBarColor,
    Color? scaffoldBackgroundColor,
    Color? dialogColor,
    Color? onDialogColor,
    Color? inversePrimary,
    Color? inverseSecondary,
    Color? inverseTertiary,
    Color? inversePrimaryContainer,
    Color? inverseSecondaryContainer,
    Color? inverseTertiaryContainer,
    Color? inverseDisabled,
    Color? inverseWeak,
    Color? inverseOutline,
    Color? inverseError,
    Color? inverseWarning,
    Color? inverseInfo,
    Color? inverseSuccess,
    Color? inverseSurface,
    Color? inverseBackground,
    Color? onInversePrimary,
    Color? onInverseSecondary,
    Color? onInverseTertiary,
    Color? onInversePrimaryContainer,
    Color? onInverseSecondaryContainer,
    Color? onInverseTertiaryContainer,
    Color? onInverseDisabled,
    Color? onInverseSurface,
    Color? onInverseBackground,
    Color? onInverseWeak,
    Color? onInverseError,
    Color? onInverseInfo,
    Color? onInverseSuccess,
    Color? onInverseWarning,
    Color? inverseSplashColor,
    Color? inverseShadow,
    Color? inverseAppBarColor,
    Color? onInverseAppBarColor,
    Color? onInverseExpandedAppBarColor,
    Color? inverseScaffoldBackgroundColor,
    Color? inverseDialogColor,
    Color? onInverseDialogColor,
    ThemeMode themeMode = ThemeMode.system,
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
    bool useMaterial3 = true,
    TargetPlatform platform = TargetPlatform.iOS,
    bool? centerTitleOnAppBar,
    Brightness? statusBarBrightnessOnIOS,
    Brightness? statusBarBrightnessOnAndroid,
    bool fixed = false,
    String? Function(Locale locale)? defaultFontFamilyResolver,
  }) : this(
          primary: primary,
          secondary: secondary,
          tertiary: tertiary,
          primaryContainer: primaryContainer,
          secondaryContainer: secondaryContainer,
          tertiaryContainer: tertiaryContainer,
          disabled: disabled,
          weak: weak,
          outline: outline,
          outlineVariant: outlineVariant,
          error: error,
          warning: warning,
          info: info,
          success: success,
          surface: surface,
          surfaceVariant: surfaceVariant,
          background: background,
          onPrimary: onPrimary,
          onSecondary: onSecondary,
          onTertiary: onTertiary,
          onPrimaryContainer: onPrimaryContainer,
          onSecondaryContainer: onSecondaryContainer,
          onTertiaryContainer: onTertiaryContainer,
          onDisabled: onDisabled,
          onSurface: onSurface,
          onSurfaceVariant: onSurfaceVariant,
          onBackground: onBackground,
          onWeak: onWeak,
          onError: onError,
          onInfo: onInfo,
          onSuccess: onSuccess,
          onWarning: onWarning,
          splashColor: splashColor,
          shadow: shadow,
          appBarColor: appBarColor,
          onAppBarColor: onAppBarColor,
          onExpandedAppBarColor: onExpandedAppBarColor,
          scaffoldBackgroundColor: scaffoldBackgroundColor,
          dialogColor: dialogColor,
          onDialogColor: onDialogColor,
          inversePrimary: inversePrimary,
          inverseSecondary: inverseSecondary,
          inverseTertiary: inverseTertiary,
          inversePrimaryContainer: inversePrimaryContainer,
          inverseSecondaryContainer: inverseSecondaryContainer,
          inverseTertiaryContainer: inverseTertiaryContainer,
          inverseDisabled: inverseDisabled,
          inverseWeak: inverseWeak,
          inverseOutline: inverseOutline,
          inverseError: inverseError,
          inverseWarning: inverseWarning,
          inverseInfo: inverseInfo,
          inverseSuccess: inverseSuccess,
          inverseSurface: inverseSurface,
          inverseBackground: inverseBackground,
          onInversePrimary: onInversePrimary,
          onInverseSecondary: onInverseSecondary,
          onInverseTertiary: onInverseTertiary,
          onInversePrimaryContainer: onInversePrimaryContainer,
          onInverseSecondaryContainer: onInverseSecondaryContainer,
          onInverseTertiaryContainer: onInverseTertiaryContainer,
          onInverseDisabled: onInverseDisabled,
          onInverseSurface: onInverseSurface,
          onInverseBackground: onInverseBackground,
          onInverseWeak: onInverseWeak,
          onInverseError: onInverseError,
          onInverseInfo: onInverseInfo,
          onInverseSuccess: onInverseSuccess,
          onInverseWarning: onInverseWarning,
          inverseSplashColor: inverseSplashColor,
          inverseShadow: inverseShadow,
          inverseAppBarColor: inverseAppBarColor,
          onInverseAppBarColor: onInverseAppBarColor,
          onInverseExpandedAppBarColor: onInverseExpandedAppBarColor,
          inverseScaffoldBackgroundColor: inverseScaffoldBackgroundColor,
          inverseDialogColor: inverseDialogColor,
          onInverseDialogColor: onInverseDialogColor,
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
          useMaterial3: useMaterial3,
          platform: platform,
          centerTitleOnAppBar: centerTitleOnAppBar,
          brightness: Brightness.light,
          fixed: fixed,
          statusBarBrightnessOnIOS: statusBarBrightnessOnIOS,
          statusBarBrightnessOnAndroid: statusBarBrightnessOnAndroid,
          themeMode: themeMode,
          defaultFontFamilyResolver: defaultFontFamilyResolver,
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
    Color? outlineVariant,
    Color error = Colors.red,
    Color warning = Colors.amber,
    Color info = Colors.blue,
    Color success = Colors.green,
    Color? surface,
    Color? surfaceVariant,
    Color? background,
    Color onPrimary = kWhiteColor,
    Color onSecondary = kWhiteColor,
    Color onTertiary = kWhiteColor,
    Color onPrimaryContainer = kWhiteColor,
    Color onSecondaryContainer = kWhiteColor,
    Color onTertiaryContainer = kWhiteColor,
    Color onDisabled = kWhiteColor,
    Color? onSurface,
    Color? onSurfaceVariant,
    Color? onBackground,
    Color onWeak = kWhiteColor,
    Color onError = kWhiteColor,
    Color onInfo = kWhiteColor,
    Color onSuccess = kWhiteColor,
    Color onWarning = kWhiteColor,
    Color splashColor = kSplashColor,
    Color shadow = Colors.black,
    Color? appBarColor,
    Color? onAppBarColor,
    Color? onExpandedAppBarColor,
    Color? scaffoldBackgroundColor,
    Color? dialogColor,
    Color? onDialogColor,
    Color? inversePrimary,
    Color? inverseSecondary,
    Color? inverseTertiary,
    Color? inversePrimaryContainer,
    Color? inverseSecondaryContainer,
    Color? inverseTertiaryContainer,
    Color? inverseDisabled,
    Color? inverseWeak,
    Color? inverseOutline,
    Color? inverseError,
    Color? inverseWarning,
    Color? inverseInfo,
    Color? inverseSuccess,
    Color? inverseSurface,
    Color? inverseBackground,
    Color? onInversePrimary,
    Color? onInverseSecondary,
    Color? onInverseTertiary,
    Color? onInversePrimaryContainer,
    Color? onInverseSecondaryContainer,
    Color? onInverseTertiaryContainer,
    Color? onInverseDisabled,
    Color? onInverseSurface,
    Color? onInverseBackground,
    Color? onInverseWeak,
    Color? onInverseError,
    Color? onInverseInfo,
    Color? onInverseSuccess,
    Color? onInverseWarning,
    Color? inverseSplashColor,
    Color? inverseShadow,
    Color? inverseAppBarColor,
    Color? onInverseAppBarColor,
    Color? onInverseExpandedAppBarColor,
    Color? inverseScaffoldBackgroundColor,
    Color? inverseDialogColor,
    Color? onInverseDialogColor,
    ThemeMode themeMode = ThemeMode.system,
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
    bool useMaterial3 = true,
    TargetPlatform platform = TargetPlatform.iOS,
    bool? centerTitleOnAppBar,
    Brightness? statusBarBrightnessOnIOS,
    Brightness? statusBarBrightnessOnAndroid,
    bool fixed = false,
    String? Function(Locale locale)? defaultFontFamilyResolver,
  }) : this(
          primary: primary,
          secondary: secondary,
          tertiary: tertiary,
          primaryContainer: primaryContainer,
          secondaryContainer: secondaryContainer,
          tertiaryContainer: tertiaryContainer,
          disabled: disabled,
          weak: weak,
          outline: outline,
          outlineVariant: outlineVariant,
          error: error,
          warning: warning,
          info: info,
          success: success,
          surface: surface,
          surfaceVariant: surfaceVariant,
          background: background,
          onPrimary: onPrimary,
          onSecondary: onSecondary,
          onTertiary: onTertiary,
          onPrimaryContainer: onPrimaryContainer,
          onSecondaryContainer: onSecondaryContainer,
          onTertiaryContainer: onTertiaryContainer,
          onDisabled: onDisabled,
          onSurface: onSurface,
          onSurfaceVariant: onSurfaceVariant,
          onBackground: onBackground,
          onWeak: onWeak,
          onError: onError,
          onInfo: onInfo,
          onSuccess: onSuccess,
          onWarning: onWarning,
          splashColor: splashColor,
          shadow: shadow,
          appBarColor: appBarColor,
          onAppBarColor: onAppBarColor,
          onExpandedAppBarColor: onExpandedAppBarColor,
          scaffoldBackgroundColor: scaffoldBackgroundColor,
          dialogColor: dialogColor,
          onDialogColor: onDialogColor,
          inversePrimary: inversePrimary,
          inverseSecondary: inverseSecondary,
          inverseTertiary: inverseTertiary,
          inversePrimaryContainer: inversePrimaryContainer,
          inverseSecondaryContainer: inverseSecondaryContainer,
          inverseTertiaryContainer: inverseTertiaryContainer,
          inverseDisabled: inverseDisabled,
          inverseWeak: inverseWeak,
          inverseOutline: inverseOutline,
          inverseError: inverseError,
          inverseWarning: inverseWarning,
          inverseInfo: inverseInfo,
          inverseSuccess: inverseSuccess,
          inverseSurface: inverseSurface,
          inverseBackground: inverseBackground,
          onInversePrimary: onInversePrimary,
          onInverseSecondary: onInverseSecondary,
          onInverseTertiary: onInverseTertiary,
          onInversePrimaryContainer: onInversePrimaryContainer,
          onInverseSecondaryContainer: onInverseSecondaryContainer,
          onInverseTertiaryContainer: onInverseTertiaryContainer,
          onInverseDisabled: onInverseDisabled,
          onInverseSurface: onInverseSurface,
          onInverseBackground: onInverseBackground,
          onInverseWeak: onInverseWeak,
          onInverseError: onInverseError,
          onInverseInfo: onInverseInfo,
          onInverseSuccess: onInverseSuccess,
          onInverseWarning: onInverseWarning,
          inverseSplashColor: inverseSplashColor,
          inverseShadow: inverseShadow,
          inverseAppBarColor: inverseAppBarColor,
          onInverseAppBarColor: onInverseAppBarColor,
          onInverseExpandedAppBarColor: onInverseExpandedAppBarColor,
          inverseScaffoldBackgroundColor: inverseScaffoldBackgroundColor,
          inverseDialogColor: inverseDialogColor,
          onInverseDialogColor: onInverseDialogColor,
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
          useMaterial3: useMaterial3,
          platform: platform,
          centerTitleOnAppBar: centerTitleOnAppBar,
          brightness: Brightness.dark,
          fixed: fixed,
          statusBarBrightnessOnIOS: statusBarBrightnessOnIOS,
          statusBarBrightnessOnAndroid: statusBarBrightnessOnAndroid,
          themeMode: themeMode,
          defaultFontFamilyResolver: defaultFontFamilyResolver,
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
  ColorThemeData get color {
    switch (themeMode) {
      case ThemeMode.dark:
        return _darkColor;
      case ThemeMode.light:
        return _lightColor;
      case ThemeMode.system:
        final brightness =
            WidgetsBinding.instance.platformDispatcher.platformBrightness;
        if (brightness == Brightness.dark) {
          return _darkColor;
        } else {
          return _lightColor;
        }
    }
  }

  /// Returns the dark color theme.
  ///
  /// ダークテーマを返します。
  ColorThemeData get darkColor => _darkColor;

  /// Returns the light color theme.
  ///
  /// ライトテーマを返します。
  ColorThemeData get lightColor => _lightColor;

  late ColorThemeData _darkColor;

  late ColorThemeData _lightColor;

  /// Specifies the theme mode.
  ///
  /// When [ThemeMode.system] is selected, it follows the platform theme.
  ///
  /// テーマモードを指定します。
  ///
  /// [ThemeMode.system]が選択されるとプラットフォームのテーマに従います。
  final ThemeMode themeMode;

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
  TextThemeData get text => _text;
  late TextThemeData _text;

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

  /// Specify whether to center the title of [AppBar].
  ///
  /// If `true`, it will be centered, if `false`, it will be left-aligned, and if [null], it will be default alignment for the platform.
  ///
  /// [AppBar]のタイトルを中央寄せするかどうかを指定します。
  ///
  /// `true`の場合中央寄せ、`false`の場合左寄せ、[Null]の場合はプラットフォームに合わせたデフォルトの寄せ方になります。
  final bool? centerTitleOnAppBar;

  /// Get the [Brightness] currently used by the application.
  ///
  /// If [themeMode] is specified, it will take precedence. Otherwise, [WidgetsBinding.instance.platformDispatcher.platformBrightness] will be used.
  ///
  /// アプリで現在利用されている[Brightness]を取得します。
  ///
  /// [themeMode]で指定されている場合はそちらが優先されます。そうでない場合は[WidgetsBinding.instance.platformDispatcher.platformBrightness]が利用されます。
  Brightness get brightness {
    switch (themeMode) {
      case ThemeMode.dark:
        return Brightness.dark;
      case ThemeMode.light:
        return Brightness.light;
      case ThemeMode.system:
        return WidgetsBinding.instance.platformDispatcher.platformBrightness;
    }
  }

  /// Specifies whether to always use the same theme instead of switching between light and dark modes.
  ///
  /// /// If `true`, the same theme is always used without switching between light and dark modes.
  ///
  /// ライトモードやダークモードの切り替えを行うのではなく、常に同じテーマを使用するかどうかを指定します。
  ///
  /// `true`の場合、ライトモードやダークモードの切り替えを行わず、常に同じテーマを使用します。
  final bool fixed;

  /// Explicitly specifies the color of the status bar icon.
  ///
  /// Black for [Brightness.dark] and white for [Brightness.light].
  ///
  /// ステータスバーのアイコンの色を明示的に指定します。
  ///
  /// [Brightness.dark]の場合は黒、[Brightness.light]の場合は白になります。
  final Brightness? statusBarBrightnessOnIOS;

  /// Explicitly specifies the color of the status bar icon.
  ///
  /// Black for [Brightness.dark] and white for [Brightness.light].
  ///
  /// ステータスバーのアイコンの色を明示的に指定します。
  ///
  /// [Brightness.dark]の場合は黒、[Brightness.light]の場合は白になります。
  final Brightness? statusBarBrightnessOnAndroid;

  /// Default font family resolver.
  ///
  /// If this is specified, this is the font family when none is specified.
  ///
  /// デフォルトのフォントファミリーを解決する関数。
  ///
  /// これが指定されている場合、何も指定されないときのフォントファミリーはこれになります。
  final String? Function(Locale locale)? defaultFontFamilyResolver;

  /// Apply the specified properties to the theme.
  ///
  /// 指定されたプロパティをテーマに適用します。
  void applyWith({
    TextThemeData? text,
    ColorThemeData? darkColor,
    ColorThemeData? lightColor,
  }) {
    _text = text ?? _text;
    _darkColor = darkColor ?? _darkColor;
    _lightColor = lightColor ?? _lightColor;
  }

  /// Apply the locale to the text theme.
  ///
  /// If [defaultFontFamilyResolver] is not specified, nothing will be done.
  ///
  /// テキストテーマにロケールを適用します。
  ///
  /// [defaultFontFamilyResolver]が指定されていない場合は何も行われません。
  void applyLocale(Locale locale) {
    if (defaultFontFamilyResolver == null) {
      return;
    }
    final defaultFontFamily = defaultFontFamilyResolver?.call(locale);
    _text = TextThemeData._(
      displayLarge: _text.displayLarge.copyWith(fontFamily: defaultFontFamily),
      displayMedium:
          _text.displayMedium.copyWith(fontFamily: defaultFontFamily),
      displaySmall: _text.displaySmall.copyWith(fontFamily: defaultFontFamily),
      headlineLarge:
          _text.headlineLarge.copyWith(fontFamily: defaultFontFamily),
      headlineMedium:
          _text.headlineMedium.copyWith(fontFamily: defaultFontFamily),
      headlineSmall:
          _text.headlineSmall.copyWith(fontFamily: defaultFontFamily),
      titleLarge: _text.titleLarge.copyWith(fontFamily: defaultFontFamily),
      titleMedium: _text.titleMedium.copyWith(fontFamily: defaultFontFamily),
      titleSmall: _text.titleSmall.copyWith(fontFamily: defaultFontFamily),
      bodyLarge: _text.bodyLarge.copyWith(fontFamily: defaultFontFamily),
      bodyMedium: _text.bodyMedium.copyWith(fontFamily: defaultFontFamily),
      bodySmall: _text.bodySmall.copyWith(fontFamily: defaultFontFamily),
      labelLarge: _text.labelLarge.copyWith(fontFamily: defaultFontFamily),
      labelMedium: _text.labelMedium.copyWith(fontFamily: defaultFontFamily),
      labelSmall: _text.labelSmall.copyWith(fontFamily: defaultFontFamily),
      fontSizeFactor: _text.fontSizeFactor,
      fontSizeDelta: _text.fontSizeDelta,
      defaultFontFamily: defaultFontFamily,
    );
  }

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
  /// If [brightness] is specified, it will change to that color theme.
  ///
  /// [defaultFontFamily] allows you to specify the default font for the app.
  ///
  /// Flutterの[ThemeData]に変換します。
  ///
  /// これを[MaterialApp]などに渡すとFlutterのウィジェットが[AppThemeData]に適したデザインに変更されます。
  ///
  /// [brightness]を指定するとそのカラーテーマに変更されます。
  ///
  /// [defaultFontFamily]を指定するとアプリのデフォルトのフォントを指定することができます。
  ThemeData toThemeData({
    Brightness? brightness,
    String? defaultFontFamily,
  }) {
    final text = this.text;
    defaultFontFamily ??= text.defaultFontFamily;

    switch (brightness ?? color.brightness) {
      case Brightness.dark:
        final color = _darkColor;
        final theme = ThemeData.dark();
        final colorScheme = theme.colorScheme.copyWith(
          primary: color.primary,
          primaryContainer: color.primaryContainer,
          secondary: color.secondary,
          secondaryContainer: color.secondaryContainer,
          tertiary: color.tertiary,
          tertiaryContainer: color.tertiaryContainer,
          surface: color.surface,
          error: color.error,
          errorContainer: color.warning,
          onPrimary: color.onPrimary,
          onPrimaryContainer: color.onPrimaryContainer,
          onSecondary: color.onSecondary,
          onSecondaryContainer: color.onSecondaryContainer,
          onTertiary: color.onTertiary,
          onTertiaryContainer: color.onTertiaryContainer,
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
        );
        final appBarForegroundColor = color.onAppBarColor ?? color.onBackground;
        return ThemeData(
          fontFamily: defaultFontFamily,
          fontFamilyFallback:
              defaultFontFamily != null ? [defaultFontFamily] : null,
          useMaterial3: useMaterial3,
          platform: platform,
          splashColor: color.splashColor,
          canvasColor: color.canvas,
          scaffoldBackgroundColor: color.scaffoldBackgroundColor,
          textTheme: textTheme.apply(
            fontFamily: defaultFontFamily,
            bodyColor: color.onBackground,
            displayColor: color.onBackground,
            fontSizeFactor: text.fontSizeFactor,
            fontSizeDelta: text.fontSizeDelta,
            decorationColor: color.onBackground,
          ),
          iconTheme: theme.iconTheme.copyWith(color: color.onBackground),
          appBarTheme: theme.appBarTheme.copyWith(
            centerTitle: centerTitleOnAppBar,
            backgroundColor: color.appBarColor ?? color.background,
            surfaceTintColor: color.appBarColor ?? color.background,
            elevation: color.appBarColor == Colors.transparent ? 0 : null,
            foregroundColor: appBarForegroundColor,
            toolbarTextStyle: theme.appBarTheme.toolbarTextStyle?.copyWith(
                  color: appBarForegroundColor,
                  decorationColor: appBarForegroundColor,
                ) ??
                TextStyle(
                  color: appBarForegroundColor,
                  decorationColor: appBarForegroundColor,
                  fontFamily: defaultFontFamily,
                ),
            titleTextStyle: theme.appBarTheme.titleTextStyle?.copyWith(
                  color: appBarForegroundColor,
                  decorationColor: appBarForegroundColor,
                  fontFamily: defaultFontFamily,
                ) ??
                text.titleLarge.copyWith(color: appBarForegroundColor),
            iconTheme: theme.appBarTheme.iconTheme?.copyWith(
                  color: appBarForegroundColor,
                ) ??
                IconThemeData(color: appBarForegroundColor),
            actionsIconTheme: theme.appBarTheme.actionsIconTheme?.copyWith(
                  color: appBarForegroundColor,
                ) ??
                IconThemeData(color: appBarForegroundColor),
            systemOverlayStyle: SystemUiOverlayStyle(
              systemNavigationBarIconBrightness:
                  statusBarBrightnessOnIOS != null
                      ? _inverse(statusBarBrightnessOnIOS!, false)
                      : Brightness.dark,
              statusBarBrightness: statusBarBrightnessOnIOS != null
                  ? _inverse(statusBarBrightnessOnIOS!, false)
                  : Brightness.dark,
              statusBarIconBrightness:
                  statusBarBrightnessOnAndroid ?? Brightness.light,
            ),
          ),
          dialogTheme: theme.dialogTheme.copyWith(
            iconColor: color.onDialogColor ?? color.onSurface,
            titleTextStyle: theme.dialogTheme.titleTextStyle?.copyWith(
                  color: color.onDialogColor ?? color.onSurface,
                  fontFamily: defaultFontFamily,
                ) ??
                text.headlineSmall.copyWith(
                  color: color.onDialogColor ?? color.onSurface,
                  fontFamily: defaultFontFamily,
                ),
            contentTextStyle: theme.dialogTheme.contentTextStyle?.copyWith(
                  color: color.onDialogColor ?? color.onSurface,
                  fontFamily: defaultFontFamily,
                ) ??
                text.bodyMedium.copyWith(
                  color: color.onDialogColor ?? color.onSurface,
                  fontFamily: defaultFontFamily,
                ),
            backgroundColor: color.dialogColor ?? color.surface,
            surfaceTintColor: color.dialogColor ?? color.surface,
          ),
          buttonTheme: theme.buttonTheme.copyWith(
            textTheme: theme.buttonTheme.textTheme,
            buttonColor: color.primary,
            disabledColor: color.disabled,
            colorScheme: colorScheme,
          ),
          chipTheme: theme.chipTheme.copyWith(
            side: BorderSide.none,
            backgroundColor: color.surface,
            disabledColor: color.disabled,
            labelStyle: theme.chipTheme.labelStyle?.copyWith(
                  color: color.onSurface,
                  decorationColor: color.onSurface,
                  fontFamily: defaultFontFamily,
                ) ??
                TextStyle(
                  color: color.onSurface,
                  decorationColor: color.onSurface,
                  fontFamily: defaultFontFamily,
                ),
            secondaryLabelStyle: theme.chipTheme.secondaryLabelStyle?.copyWith(
                  color: color.onSurface,
                  decorationColor: color.onSurface,
                  fontFamily: defaultFontFamily,
                ) ??
                TextStyle(
                  color: color.onSurface,
                  decorationColor: color.onSurface,
                  fontFamily: defaultFontFamily,
                ),
            deleteIconColor: color.onSurface,
          ),
          inputDecorationTheme: theme.inputDecorationTheme.copyWith(
            labelStyle: TextStyle(
              color: color.weak,
              decorationColor: color.weak,
              fontFamily: defaultFontFamily,
            ),
            helperStyle: TextStyle(
              color: color.weak,
              decorationColor: color.weak,
              fontFamily: defaultFontFamily,
            ),
            hintStyle: TextStyle(
              color: color.weak,
              decorationColor: color.weak,
              fontFamily: defaultFontFamily,
            ),
            counterStyle: TextStyle(
              color: color.weak,
              decorationColor: color.weak,
              fontFamily: defaultFontFamily,
            ),
            errorStyle: TextStyle(
              color: color.error,
              decorationColor: color.error,
              fontFamily: defaultFontFamily,
            ),
            prefixStyle: TextStyle(
              color: color.onBackground,
              decorationColor: color.onBackground,
              fontFamily: defaultFontFamily,
            ),
            suffixStyle: TextStyle(
              color: color.onBackground,
              decorationColor: color.onBackground,
              fontFamily: defaultFontFamily,
            ),
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
          listTileTheme: theme.listTileTheme.copyWith(
            tileColor: color.background,
            selectedTileColor: color.primary,
            iconColor: color.onBackground,
            textColor: color.onBackground,
          ),
          iconButtonTheme: IconButtonThemeData(
              style: IconButton.styleFrom(
            foregroundColor: color.onBackground,
          )),
          indicatorColor: color.secondary,
          brightness: color.brightness,
          primaryColor: color.primary,
          disabledColor: color.disabled,
          dividerColor: color.outline,
          dividerTheme: DividerThemeData(
            color: color.outline,
          ),
          colorScheme: colorScheme.copyWith(error: color.error),
          extensions: [
            color,
            ScaffoldThemeExtension(
              backgroundColor: color.background,
              foregourendColor: color.onBackground,
            ),
            AppBarThemeExtension(
              collapsedForegroundColor:
                  color.onAppBarColor ?? color.onBackground,
              expandedForegroundColor: color.onExpandedAppBarColor ??
                  color.onAppBarColor ??
                  color.onBackground,
            ),
            ...theme.extensions.values,
          ],
        );
      default:
        final color = _lightColor;
        final theme = ThemeData.light();
        final colorScheme = theme.colorScheme.copyWith(
          primary: color.primary,
          primaryContainer: color.primaryContainer,
          secondary: color.secondary,
          secondaryContainer: color.secondaryContainer,
          tertiary: color.tertiary,
          tertiaryContainer: color.tertiaryContainer,
          surface: color.surface,
          error: color.error,
          onPrimary: color.onPrimary,
          onPrimaryContainer: color.onPrimaryContainer,
          onSecondary: color.onSecondary,
          onSecondaryContainer: color.onSecondaryContainer,
          onTertiary: color.onTertiary,
          onTertiaryContainer: color.onTertiaryContainer,
          onSurface: color.onSurface,
          onError: color.onError,
          brightness: color.brightness,
          outline: color.outline,
          inversePrimary: color.inversePrimary,
          inverseSurface: color.inverseSurface,
          onInverseSurface: color.onInverseSurface,
        );
        final textTheme = theme.textTheme.copyWith(
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
        );
        final appBarForegroundColor = color.onAppBarColor ?? color.onBackground;
        return ThemeData(
          fontFamily: defaultFontFamily,
          fontFamilyFallback:
              defaultFontFamily != null ? [defaultFontFamily] : null,
          useMaterial3: useMaterial3,
          platform: platform,
          splashColor: color.splashColor,
          canvasColor: color.canvas,
          scaffoldBackgroundColor: color.scaffoldBackgroundColor,
          appBarTheme: theme.appBarTheme.copyWith(
            centerTitle: centerTitleOnAppBar,
            backgroundColor: color.appBarColor ?? color.background,
            surfaceTintColor: color.appBarColor ?? color.background,
            elevation: color.appBarColor == Colors.transparent ? 0 : null,
            foregroundColor: appBarForegroundColor,
            toolbarTextStyle: theme.appBarTheme.toolbarTextStyle?.copyWith(
                  color: appBarForegroundColor,
                  decorationColor: appBarForegroundColor,
                  fontFamily: defaultFontFamily,
                ) ??
                TextStyle(
                  color: appBarForegroundColor,
                  decorationColor: appBarForegroundColor,
                  fontFamily: defaultFontFamily,
                ),
            titleTextStyle: theme.appBarTheme.titleTextStyle?.copyWith(
                  color: appBarForegroundColor,
                  decorationColor: appBarForegroundColor,
                  fontFamily: defaultFontFamily,
                ) ??
                text.titleLarge.copyWith(
                  color: appBarForegroundColor,
                  decorationColor: appBarForegroundColor,
                  fontFamily: defaultFontFamily,
                ),
            iconTheme: theme.appBarTheme.iconTheme?.copyWith(
                  color: appBarForegroundColor,
                ) ??
                IconThemeData(color: appBarForegroundColor),
            actionsIconTheme: theme.appBarTheme.actionsIconTheme?.copyWith(
                  color: appBarForegroundColor,
                ) ??
                IconThemeData(color: appBarForegroundColor),
            systemOverlayStyle: SystemUiOverlayStyle(
              systemNavigationBarIconBrightness:
                  statusBarBrightnessOnIOS != null
                      ? _inverse(statusBarBrightnessOnIOS!, false)
                      : Brightness.light,
              statusBarBrightness: statusBarBrightnessOnIOS != null
                  ? _inverse(statusBarBrightnessOnIOS!, false)
                  : Brightness.light,
              statusBarIconBrightness:
                  statusBarBrightnessOnAndroid ?? Brightness.dark,
            ),
          ),
          iconTheme: theme.iconTheme.copyWith(color: color.onBackground),
          dialogTheme: theme.dialogTheme.copyWith(
            iconColor: color.onDialogColor ?? color.onSurface,
            titleTextStyle: theme.dialogTheme.titleTextStyle?.copyWith(
                  color: color.onDialogColor ?? color.onSurface,
                  fontFamily: defaultFontFamily,
                ) ??
                text.headlineSmall.copyWith(
                  color: color.onDialogColor ?? color.onSurface,
                  fontFamily: defaultFontFamily,
                ),
            contentTextStyle: theme.dialogTheme.contentTextStyle?.copyWith(
                  color: color.onDialogColor ?? color.onSurface,
                  fontFamily: defaultFontFamily,
                ) ??
                text.bodyMedium.copyWith(
                  color: color.onDialogColor ?? color.onSurface,
                  fontFamily: defaultFontFamily,
                ),
            backgroundColor: color.dialogColor ?? color.surface,
            surfaceTintColor: color.dialogColor ?? color.surface,
          ),
          textTheme: textTheme.apply(
            fontFamily: defaultFontFamily,
            bodyColor: color.onBackground,
            displayColor: color.onBackground,
            fontSizeFactor: text.fontSizeFactor,
            fontSizeDelta: text.fontSizeDelta,
            decorationColor: color.onBackground,
          ),
          buttonTheme: theme.buttonTheme.copyWith(
            buttonColor: color.primary,
            disabledColor: color.disabled,
            colorScheme: colorScheme,
          ),
          chipTheme: theme.chipTheme.copyWith(
            side: BorderSide.none,
            backgroundColor: color.surface,
            disabledColor: color.disabled,
            labelStyle: theme.chipTheme.labelStyle?.copyWith(
                  color: color.onSurface,
                  decorationColor: color.onSurface,
                  fontFamily: defaultFontFamily,
                ) ??
                TextStyle(
                  color: color.onSurface,
                  decorationColor: color.onSurface,
                  fontFamily: defaultFontFamily,
                ),
            secondaryLabelStyle: theme.chipTheme.secondaryLabelStyle?.copyWith(
                  color: color.onSurface,
                  decorationColor: color.onSurface,
                  fontFamily: defaultFontFamily,
                ) ??
                TextStyle(
                  color: color.onSurface,
                  decorationColor: color.onSurface,
                  fontFamily: defaultFontFamily,
                ),
            deleteIconColor: color.onSurface,
          ),
          listTileTheme: theme.listTileTheme.copyWith(
            tileColor: color.background,
            selectedTileColor: color.primary,
            iconColor: color.onBackground,
            textColor: color.onBackground,
          ),
          iconButtonTheme: IconButtonThemeData(
              style: IconButton.styleFrom(
            foregroundColor: color.onBackground,
          )),
          inputDecorationTheme: theme.inputDecorationTheme.copyWith(
            labelStyle: TextStyle(
              color: color.weak,
              decorationColor: color.weak,
              fontFamily: defaultFontFamily,
            ),
            helperStyle: TextStyle(
              color: color.weak,
              decorationColor: color.weak,
              fontFamily: defaultFontFamily,
            ),
            hintStyle: TextStyle(
              color: color.weak,
              decorationColor: color.weak,
              fontFamily: defaultFontFamily,
            ),
            counterStyle: TextStyle(
              color: color.weak,
              decorationColor: color.weak,
              fontFamily: defaultFontFamily,
            ),
            errorStyle: TextStyle(
              color: color.error,
              decorationColor: color.error,
              fontFamily: defaultFontFamily,
            ),
            prefixStyle: TextStyle(
              color: color.onBackground,
              decorationColor: color.onBackground,
              fontFamily: defaultFontFamily,
            ),
            suffixStyle: TextStyle(
              color: color.onBackground,
              decorationColor: color.onBackground,
              fontFamily: defaultFontFamily,
            ),
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
          dividerTheme: DividerThemeData(
            color: color.outline,
          ),
          colorScheme: colorScheme.copyWith(error: color.error),
          extensions: [
            color,
            ScaffoldThemeExtension(
              backgroundColor: color.background,
              foregourendColor: color.onBackground,
            ),
            AppBarThemeExtension(
              collapsedForegroundColor:
                  color.onAppBarColor ?? color.onBackground,
              expandedForegroundColor: color.onExpandedAppBarColor ??
                  color.onAppBarColor ??
                  color.onBackground,
            ),
            ...theme.extensions.values,
          ],
        );
    }
  }

  static Brightness _inverse(Brightness brightness, bool fixed) {
    if (fixed) {
      return brightness;
    }
    if (brightness == Brightness.light) {
      return Brightness.dark;
    } else {
      return Brightness.light;
    }
  }

  static Color _background(Brightness brightness) {
    if (brightness == Brightness.light) {
      return kWhiteColor;
    } else {
      return kBlackColor;
    }
  }

  static Color _surface(Brightness brightness) {
    if (brightness == Brightness.light) {
      return kWhiteSurfaceColor;
    } else {
      return kBlackSurfaceColor;
    }
  }

  static Color _onBackgroundOrSurface(Brightness brightness) {
    if (brightness == Brightness.light) {
      return kBlackColor;
    } else {
      return kWhiteColor;
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
class ColorThemeData extends ThemeExtension<ColorThemeData> {
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
    required this.outlineVariant,
    required this.error,
    required this.warning,
    required this.info,
    required this.success,
    required this.surface,
    required this.surfaceVariant,
    required this.background,
    required this.onPrimary,
    required this.onSecondary,
    required this.onTertiary,
    required this.onPrimaryContainer,
    required this.onSecondaryContainer,
    required this.onTertiaryContainer,
    required this.onDisabled,
    required this.onSurface,
    required this.onSurfaceVariant,
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
    this.onExpandedAppBarColor,
    this.dialogColor,
    this.onDialogColor,
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

  /// Alternative colors for Borderline and Divider.
  ///
  /// ボーダーラインやDivider用の代替色。
  ///
  /// See also:
  ///
  ///   - https://m3.material.io/styles/color/the-color-system/color-roles
  final Color outlineVariant;

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

  /// Alternate background color for dialogs, cards, etc.
  ///
  /// ダイアログやカードなどの背景の代替色。
  ///
  /// See also:
  ///
  ///   - https://m3.material.io/styles/color/the-color-system/color-roles
  final Color surfaceVariant;

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

  /// Color of text and icons on [surfaceVariant].
  ///
  /// [surfaceVariant]上のテキストやアイコンのカラー。
  ///
  /// See also:
  ///
  ///   - https://m3.material.io/styles/color/the-color-system/color-roles
  final Color onSurfaceVariant;

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

  /// Color of text and icons when [AppBar] is open.
  ///
  /// These are colors outside of the Material3 color scheme.
  ///
  /// [AppBar]が開いているときのテキストやアイコンのカラー。
  ///
  /// Material3のカラースキーム外のカラーです。
  final Color? onExpandedAppBarColor;

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

  /// Background color of the dialog.
  ///
  /// These are colors outside of the Material3 color scheme.
  ///
  /// ダイアログの背景色。
  ///
  /// Material3のカラースキーム外のカラーです。
  final Color? dialogColor;

  /// Color of text and icons on [dialogColor].
  ///
  /// These are colors outside of the Material3 color scheme.
  ///
  /// [dialogColor]上のテキストやアイコンのカラー。
  ///
  /// Material3のカラースキーム外のカラーです。
  final Color? onDialogColor;

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

  @override
  ColorThemeData copyWith({
    Color? primary,
    Color? secondary,
    Color? tertiary,
    Color? primaryContainer,
    Color? secondaryContainer,
    Color? tertiaryContainer,
    Color? disabled,
    Color? weak,
    Color? outline,
    Color? outlineVariant,
    Color? error,
    Color? warning,
    Color? info,
    Color? success,
    Color? surface,
    Color? surfaceVariant,
    Color? background,
    Color? onPrimary,
    Color? onSecondary,
    Color? onTertiary,
    Color? onPrimaryContainer,
    Color? onSecondaryContainer,
    Color? onTertiaryContainer,
    Color? onDisabled,
    Color? onSurface,
    Color? onSurfaceVariant,
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
    Brightness? brightness,
    Color? appBarColor,
    Color? onAppBarColor,
    Color? onExpandedAppBarColor,
    Color? dialogColor,
    Color? onDialogColor,
    Color? canvasColor,
    Color? scaffoldBackgroundColor,
  }) =>
      ColorThemeData._(
        primary: primary ?? this.primary,
        secondary: secondary ?? this.secondary,
        tertiary: tertiary ?? this.tertiary,
        primaryContainer: primaryContainer ?? this.primaryContainer,
        secondaryContainer: secondaryContainer ?? this.secondaryContainer,
        tertiaryContainer: tertiaryContainer ?? this.tertiaryContainer,
        disabled: disabled ?? this.disabled,
        weak: weak ?? this.weak,
        outline: outline ?? this.outline,
        outlineVariant: outlineVariant ?? this.outlineVariant,
        error: error ?? this.error,
        warning: warning ?? this.warning,
        info: info ?? this.info,
        success: success ?? this.success,
        surface: surface ?? this.surface,
        surfaceVariant: surfaceVariant ?? this.surfaceVariant,
        background: background ?? this.background,
        onPrimary: onPrimary ?? this.onPrimary,
        onSecondary: onSecondary ?? this.onSecondary,
        onTertiary: onTertiary ?? this.onTertiary,
        onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
        onSecondaryContainer: onSecondaryContainer ?? this.onSecondaryContainer,
        onTertiaryContainer: onTertiaryContainer ?? this.onTertiaryContainer,
        onDisabled: onDisabled ?? this.onDisabled,
        onSurface: onSurface ?? this.onSurface,
        onSurfaceVariant: onSurfaceVariant ?? this.onSurfaceVariant,
        onBackground: onBackground ?? this.onBackground,
        onWeak: onWeak ?? this.onWeak,
        onError: onError ?? this.onError,
        onInfo: onInfo ?? this.onInfo,
        onSuccess: onSuccess ?? this.onSuccess,
        onWarning: onWarning ?? this.onWarning,
        splashColor: splashColor ?? this.splashColor,
        shadow: shadow ?? this.shadow,
        inverseSurface: inverseSurface ?? this.inverseSurface,
        onInverseSurface: onInverseSurface ?? this.onInverseSurface,
        inversePrimary: inversePrimary ?? this.inversePrimary,
        brightness: brightness ?? this.brightness,
        appBarColor: appBarColor ?? this.appBarColor,
        onAppBarColor: onAppBarColor ?? this.onAppBarColor,
        onExpandedAppBarColor:
            onExpandedAppBarColor ?? this.onExpandedAppBarColor,
        dialogColor: dialogColor ?? this.dialogColor,
        onDialogColor: onDialogColor ?? this.onDialogColor,
        canvasColor: canvasColor,
        scaffoldBackgroundColor: scaffoldBackgroundColor,
      );

  @override
  ThemeExtension<ColorThemeData> lerp(ColorThemeData? other, double t) {
    if (other == null) {
      return this;
    }
    return ColorThemeData._(
      primary: Color.lerp(primary, other.primary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      tertiary: Color.lerp(tertiary, other.tertiary, t)!,
      primaryContainer:
          Color.lerp(primaryContainer, other.primaryContainer, t)!,
      secondaryContainer:
          Color.lerp(secondaryContainer, other.secondaryContainer, t)!,
      tertiaryContainer:
          Color.lerp(tertiaryContainer, other.tertiaryContainer, t)!,
      disabled: Color.lerp(disabled, other.disabled, t)!,
      weak: Color.lerp(weak, other.weak, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      outlineVariant: Color.lerp(outlineVariant, other.outlineVariant, t)!,
      error: Color.lerp(error, other.error, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      success: Color.lerp(success, other.success, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      background: Color.lerp(background, other.background, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      onSecondary: Color.lerp(onSecondary, other.onSecondary, t)!,
      onTertiary: Color.lerp(onTertiary, other.onTertiary, t)!,
      onPrimaryContainer:
          Color.lerp(onPrimaryContainer, other.onPrimaryContainer, t)!,
      onSecondaryContainer:
          Color.lerp(onSecondaryContainer, other.onSecondaryContainer, t)!,
      onTertiaryContainer:
          Color.lerp(onTertiaryContainer, other.onTertiaryContainer, t)!,
      onDisabled: Color.lerp(onDisabled, other.onDisabled, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      onSurfaceVariant:
          Color.lerp(onSurfaceVariant, other.onSurfaceVariant, t)!,
      onBackground: Color.lerp(onBackground, other.onBackground, t)!,
      onWeak: Color.lerp(onWeak, other.onWeak, t)!,
      onError: Color.lerp(onError, other.onError, t)!,
      onInfo: Color.lerp(onInfo, other.onInfo, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      splashColor: Color.lerp(splashColor, other.splashColor, t),
      shadow: Color.lerp(shadow, other.shadow, t)!,
      inverseSurface: Color.lerp(inverseSurface, other.inverseSurface, t)!,
      onInverseSurface:
          Color.lerp(onInverseSurface, other.onInverseSurface, t)!,
      inversePrimary: Color.lerp(inversePrimary, other.inversePrimary, t)!,
      brightness: t < 0.5 ? brightness : other.brightness,
      appBarColor: Color.lerp(appBarColor, other.appBarColor, t),
      onAppBarColor: Color.lerp(onAppBarColor, other.onAppBarColor, t),
      onExpandedAppBarColor:
          Color.lerp(onExpandedAppBarColor, other.onExpandedAppBarColor, t),
      dialogColor: Color.lerp(dialogColor, other.dialogColor, t),
      onDialogColor: Color.lerp(onDialogColor, other.onDialogColor, t),
      canvasColor: Color.lerp(_canvas, other._canvas, t),
      scaffoldBackgroundColor: Color.lerp(
          _scaffoldBackgroundColor, other._scaffoldBackgroundColor, t),
    );
  }
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

  /// Returns a specific text style. Further customization is possible by using [copyWith], etc.
  ///
  /// 特定のテキストスタイルを返します。[copyWith]などを用いることでさらなるカスタマイズが可能なります。
  TextStyleThemeData get styles => const TextStyleThemeData._();

  /// Returns a new text theme with the specified properties.
  ///
  /// 指定されたプロパティを持つ新しいテキストテーマを返します。
  TextThemeData copyWith({
    TextStyle? displayLarge,
    TextStyle? displayMedium,
    TextStyle? displaySmall,
    TextStyle? headlineLarge,
    TextStyle? headlineMedium,
    TextStyle? headlineSmall,
    TextStyle? titleLarge,
    TextStyle? titleMedium,
    TextStyle? titleSmall,
    TextStyle? bodyLarge,
    TextStyle? bodyMedium,
    TextStyle? bodySmall,
    TextStyle? labelLarge,
    TextStyle? labelMedium,
    TextStyle? labelSmall,
    double? fontSizeFactor,
    double? fontSizeDelta,
    String? defaultFontFamily,
  }) =>
      TextThemeData._(
        displayLarge: displayLarge ?? this.displayLarge,
        displayMedium: displayMedium ?? this.displayMedium,
        displaySmall: displaySmall ?? this.displaySmall,
        headlineLarge: headlineLarge ?? this.headlineLarge,
        headlineMedium: headlineMedium ?? this.headlineMedium,
        headlineSmall: headlineSmall ?? this.headlineSmall,
        titleLarge: titleLarge ?? this.titleLarge,
        titleMedium: titleMedium ?? this.titleMedium,
        titleSmall: titleSmall ?? this.titleSmall,
        bodyLarge: bodyLarge ?? this.bodyLarge,
        bodyMedium: bodyMedium ?? this.bodyMedium,
        bodySmall: bodySmall ?? this.bodySmall,
        labelLarge: labelLarge ?? this.labelLarge,
        labelMedium: labelMedium ?? this.labelMedium,
        labelSmall: labelSmall ?? this.labelSmall,
        fontSizeFactor: fontSizeFactor ?? this.fontSizeFactor,
        fontSizeDelta: fontSizeDelta ?? this.fontSizeDelta,
        defaultFontFamily: defaultFontFamily ?? this.defaultFontFamily,
      );
}

/// Class for retrieving text styles.
///
/// テキストスタイルを取得するためのクラス。
class TextStyleThemeData {
  const TextStyleThemeData._();

  /// Returns the text style to be bolded.
  ///
  /// 太字にするためのテキストスタイルを返します。
  TextStyle get bold => const TextStyle(fontWeight: FontWeight.bold);

  /// Returns the text style to be italicized.
  ///
  /// 斜体にするためのテキストスタイルを返します。
  TextStyle get italic => const TextStyle(fontStyle: FontStyle.italic);

  /// Returns the text style to be underlined.
  ///
  /// [color] is the color of the underline.
  ///
  /// [style] is the style of the underline.
  ///
  /// [thickness] is the thickness of the underline.
  ///
  /// 下線を引くためのテキストスタイルを返します。
  ///
  /// [color]は下線の色です。
  ///
  /// [style]は下線のスタイルです。
  ///
  /// [thickness]は下線の太さです。
  TextStyle underline({
    Color? color,
    TextDecorationStyle? style,
    double? thickness,
  }) =>
      TextStyle(
        decoration: TextDecoration.underline,
        decorationColor: color,
        decorationStyle: style,
        decorationThickness: thickness,
      );

  /// Returns a text style that specifies the text color.
  ///
  /// テキストの色を指定するテキストスタイルを返します。
  TextStyle color(Color color) => TextStyle(color: color);

  /// Returns a text style that specifies a font style.
  ///
  /// フォントスタイルを指定するテキストスタイルを返します。
  TextStyle fontFamily(String fontFamily) => TextStyle(fontFamily: fontFamily);

  /// Returns a text style that specifies the font size.
  ///
  /// フォントサイズを指定するテキストスタイルを返します。
  TextStyle fontSize(double fontSize) => TextStyle(fontSize: fontSize);

  /// Returns a text style that specifies character spacing.
  ///
  /// 文字の間隔を指定するテキストスタイルを返します。
  TextStyle letterSpacing(double letterSpacing) =>
      TextStyle(letterSpacing: letterSpacing);

  /// Returns a text style that specifies word spacing.
  ///
  /// 単語の間隔を指定するテキストスタイルを返します。
  TextStyle wordSpacing(double wordSpacing) =>
      TextStyle(wordSpacing: wordSpacing);

  /// Returns a text style that specifies text overflow.
  ///
  /// テキストオーバーフローを指定するテキストスタイルを返します。
  TextStyle overflow(TextOverflow overflow) => TextStyle(overflow: overflow);
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

/// Extended theme to extend the AppBar theme.
///
/// AppBarのテーマを拡張するための拡張テーマ。
class AppBarThemeExtension extends ThemeExtension<AppBarThemeExtension> {
  AppBarThemeExtension({
    this.collapsedForegroundColor,
    this.expandedForegroundColor,
  });

  /// Text color when AppBar is open.
  ///
  /// AppBarが開いているときの文字色。
  final Color? expandedForegroundColor;

  /// Text color when AppBar is closed.
  ///
  /// AppBarが閉じているときの文字色。
  final Color? collapsedForegroundColor;

  @override
  ThemeExtension<AppBarThemeExtension> copyWith({
    Color? expandedForegroundColor,
    Color? collapsedForegroundColor,
  }) {
    return AppBarThemeExtension(
      expandedForegroundColor:
          expandedForegroundColor ?? this.expandedForegroundColor,
      collapsedForegroundColor:
          collapsedForegroundColor ?? this.collapsedForegroundColor,
    );
  }

  @override
  ThemeExtension<AppBarThemeExtension> lerp(
    AppBarThemeExtension? other,
    double t,
  ) {
    if (other == null) {
      return this;
    }
    return AppBarThemeExtension(
      expandedForegroundColor: Color.lerp(
        expandedForegroundColor,
        other.expandedForegroundColor,
        t,
      ),
      collapsedForegroundColor: Color.lerp(
        collapsedForegroundColor,
        other.collapsedForegroundColor,
        t,
      ),
    );
  }
}

/// Extended theme to extend the Scaffold theme.
///
/// Scaffoldのテーマを拡張するための拡張テーマ。
class ScaffoldThemeExtension extends ThemeExtension<ScaffoldThemeExtension> {
  ScaffoldThemeExtension({
    this.backgroundColor,
    this.foregourendColor,
  });

  /// Background color.
  ///
  /// 背景色。
  final Color? backgroundColor;

  /// Text color.
  ///
  /// 文字色。
  final Color? foregourendColor;

  @override
  ThemeExtension<ScaffoldThemeExtension> copyWith({
    Color? backgroundColor,
    Color? foregourendColor,
  }) {
    return ScaffoldThemeExtension(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregourendColor: foregourendColor ?? this.foregourendColor,
    );
  }

  @override
  ThemeExtension<ScaffoldThemeExtension> lerp(
    ScaffoldThemeExtension? other,
    double t,
  ) {
    if (other == null) {
      return this;
    }
    return ScaffoldThemeExtension(
      backgroundColor: Color.lerp(
        backgroundColor,
        other.backgroundColor,
        t,
      ),
      foregourendColor: Color.lerp(
        foregourendColor,
        other.foregourendColor,
        t,
      ),
    );
  }
}
