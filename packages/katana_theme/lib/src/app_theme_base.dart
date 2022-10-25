part of katana_theme;

@immutable
class ColorThemeBase {
  const ColorThemeBase({
    this.primary = Colors.blue,
    this.secondary = Colors.cyan,
    this.tertiary = Colors.lightBlue,
    this.primaryContainer = Colors.blueAccent,
    this.secondaryContainer = Colors.cyanAccent,
    this.tertiaryContainer = Colors.lightBlueAccent,
    this.disabled = Colors.grey,
    this.weak = Colors.grey,
    this.outline = Colors.grey,
    this.error = Colors.red,
    this.warning = Colors.amber,
    this.info = Colors.blue,
    this.success = Colors.green,
    this.surface = const Color(0xFFFFFFFF),
    this.background = const Color(0xFFFFFFFF),
    this.onPrimary = const Color(0xFFFFFFFF),
    this.onSecondary = const Color(0xFFFFFFFF),
    this.onTertiary = const Color(0xFFFFFFFF),
    this.onPrimaryContainer = const Color(0xFFFFFFFF),
    this.onSecondaryContainer = const Color(0xFFFFFFFF),
    this.onTertiaryContainer = const Color(0xFFFFFFFF),
    this.onDisabled = const Color(0xFFFFFFFF),
    this.onSurface = const Color(0xFFFFFFFF),
    this.onBackground = const Color(0xFF212121),
    this.onWeak = const Color(0xFFFFFFFF),
    this.onError = const Color(0xFFFFFFFF),
    this.onInfo = const Color(0xFFFFFFFF),
    this.onSuccess = const Color(0xFF212121),
    this.onWarning = const Color(0xFFFFFFFF),
    this.splashColor = const Color(0xaaFFFFFF),
    this.appBarColor,
    this.onAppBarColor,
    this.scaffoldBackgroundColor,
  });

  final Color primary;

  final Color secondary;

  final Color tertiary;

  final Color primaryContainer;

  final Color secondaryContainer;

  final Color tertiaryContainer;

  final Color disabled;

  final Color weak;

  final Color outline;

  final Color error;

  final Color warning;

  final Color info;

  final Color success;

  final Color surface;

  final Color background;

  final Color onPrimary;

  final Color onSecondary;

  final Color onTertiary;

  final Color onPrimaryContainer;

  final Color onSecondaryContainer;

  final Color onTertiaryContainer;

  final Color onDisabled;

  final Color onSurface;

  final Color onBackground;

  final Color onWeak;

  final Color onError;

  final Color onInfo;

  final Color onSuccess;

  final Color onWarning;

  final Color? appBarColor;

  final Color? onAppBarColor;

  final Color? scaffoldBackgroundColor;

  final Color? splashColor;
}

@immutable
class TextThemeBase {
  const TextThemeBase({
    this.fontFamily,
    this.displayLarge = const TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    this.displayMedium = const TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    this.displaySmall = const TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    this.headlineLarge = const TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w400,
      height: 1.25,
      leadingDistribution: TextLeadingDistribution.proportional,
    ),
    this.headlineMedium = const TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w400,
      height: 1.29,
      leadingDistribution: TextLeadingDistribution.proportional,
    ),
    this.headlineSmall = const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      height: 1.33,
      leadingDistribution: TextLeadingDistribution.proportional,
    ),
    this.titleLarge = const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    this.titleMedium = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    this.titleSmall = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    this.bodyLarge = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    this.bodyMedium = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    this.bodySmall = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    this.labelLarge = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    this.labelMedium = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    this.labelSmall = const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    this.fontSizeFactor = 1.0,
    this.fontSizeDelta = 0.0,
  });

  final String? fontFamily;

  final TextStyle displayLarge;

  final TextStyle displayMedium;

  final TextStyle displaySmall;

  final TextStyle headlineLarge;

  final TextStyle headlineMedium;

  final TextStyle headlineSmall;

  final TextStyle titleLarge;

  final TextStyle titleMedium;

  final TextStyle titleSmall;

  final TextStyle bodyLarge;

  final TextStyle bodyMedium;

  final TextStyle bodySmall;

  final TextStyle labelLarge;

  final TextStyle labelMedium;

  final TextStyle labelSmall;

  final double fontSizeFactor;

  final double fontSizeDelta;
}

@immutable
class WidgetThemeBase {
  const WidgetThemeBase({
    this.indicator = const CircularProgressIndicator(),
  });

  final Widget indicator;
}

@immutable
class AssetThemeBase {
  const AssetThemeBase();
}

@immutable
abstract class AppThemeBase<
    TColor extends ColorThemeBase,
    TText extends TextThemeBase,
    TAsset extends AssetThemeBase,
    TWidget extends WidgetThemeBase> {
  const AppThemeBase({
    this.brightness = Brightness.light,
    this.useMaterial3 = true,
    this.platform = TargetPlatform.iOS,
  });

  TColor get color;
  TText get text;
  TAsset get asset;
  TWidget get widget;

  final Brightness brightness;
  final bool useMaterial3;
  final TargetPlatform platform;

  ThemeData toThemeData() {
    switch (brightness) {
      case Brightness.dark:
        final colorScheme = const ColorScheme.dark().copyWith(
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
          brightness: brightness,
          outline: color.outline,
        );
        final theme = ThemeData.dark();
        final textTheme = _convertTextThemeFromFont(
          text.fontFamily,
          theme.textTheme,
        ).apply(
          fontSizeFactor: text.fontSizeFactor,
          fontSizeDelta: text.fontSizeDelta,
        );
        final appBarForegroundColor = color.appBarColor == Colors.transparent
            ? color.onBackground
            : color.onAppBarColor;
        return ThemeData(
          useMaterial3: useMaterial3,
          platform: platform,
          colorScheme: colorScheme,
          splashColor: color.splashColor,
          scaffoldBackgroundColor: color.scaffoldBackgroundColor,
          textTheme: textTheme.apply(
            bodyColor: color.onBackground,
            displayColor: color.onBackground,
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
          brightness: brightness,
          primaryColor: color.primary,
          disabledColor: color.disabled,
          dividerColor: color.outline,
          errorColor: color.error,
          backgroundColor: color.background,
          canvasColor: color.background,
        );
      default:
        final colorScheme = const ColorScheme.light().copyWith(
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
          brightness: brightness,
          outline: color.outline,
        );
        final theme = ThemeData.light();
        final textTheme = _convertTextThemeFromFont(
          text.fontFamily,
          theme.textTheme,
        ).apply(
          fontSizeFactor: text.fontSizeFactor,
          fontSizeDelta: text.fontSizeDelta,
        );
        final appBarForegroundColor = color.appBarColor == Colors.transparent
            ? color.onBackground
            : color.onAppBarColor;
        return ThemeData(
          useMaterial3: useMaterial3,
          platform: platform,
          colorScheme: colorScheme,
          splashColor: color.splashColor,
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
            bodyColor: color.onBackground,
            displayColor: color.onBackground,
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
          brightness: brightness,
          primaryColor: color.primary,
          disabledColor: color.disabled,
          dividerColor: color.outline,
          errorColor: color.error,
          backgroundColor: color.background,
          canvasColor: color.background,
        );
    }
  }

  TextTheme _convertTextThemeFromFont(
    String? fontFamily,
    TextTheme textTheme,
  ) {
    textTheme = textTheme.copyWith(
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
    if (fontFamily.isEmpty) {
      return textTheme;
    }
    final fonts = GoogleFonts.asMap();
    final fontGenerator = fonts[fontFamily];
    if (fontGenerator == null) {
      return TextTheme(
        displayLarge: textTheme.displayLarge?.copyWith(fontFamily: fontFamily),
        displayMedium:
            textTheme.displayMedium?.copyWith(fontFamily: fontFamily),
        displaySmall: textTheme.displaySmall?.copyWith(fontFamily: fontFamily),
        headlineLarge:
            textTheme.headlineLarge?.copyWith(fontFamily: fontFamily),
        headlineMedium:
            textTheme.headlineMedium?.copyWith(fontFamily: fontFamily),
        headlineSmall:
            textTheme.headlineSmall?.copyWith(fontFamily: fontFamily),
        titleLarge: textTheme.titleLarge?.copyWith(fontFamily: fontFamily),
        titleMedium: textTheme.titleMedium?.copyWith(fontFamily: fontFamily),
        titleSmall: textTheme.titleSmall?.copyWith(fontFamily: fontFamily),
        bodyLarge: textTheme.bodyLarge?.copyWith(fontFamily: fontFamily),
        bodyMedium: textTheme.bodyMedium?.copyWith(fontFamily: fontFamily),
        bodySmall: textTheme.bodySmall?.copyWith(fontFamily: fontFamily),
        labelLarge: textTheme.labelLarge?.copyWith(fontFamily: fontFamily),
        labelMedium: textTheme.labelMedium?.copyWith(fontFamily: fontFamily),
        labelSmall: textTheme.labelSmall?.copyWith(fontFamily: fontFamily),
      );
    }
    return TextTheme(
      displayLarge: fontGenerator(textStyle: textTheme.displayLarge),
      displayMedium: fontGenerator(textStyle: textTheme.displayMedium),
      displaySmall: fontGenerator(textStyle: textTheme.displaySmall),
      headlineLarge: fontGenerator(textStyle: textTheme.headlineLarge),
      headlineMedium: fontGenerator(textStyle: textTheme.headlineMedium),
      headlineSmall: fontGenerator(textStyle: textTheme.headlineSmall),
      titleLarge: fontGenerator(textStyle: textTheme.titleLarge),
      titleMedium: fontGenerator(textStyle: textTheme.titleMedium),
      titleSmall: fontGenerator(textStyle: textTheme.titleSmall),
      bodyLarge: fontGenerator(textStyle: textTheme.bodyLarge),
      bodyMedium: fontGenerator(textStyle: textTheme.bodyMedium),
      bodySmall: fontGenerator(textStyle: textTheme.bodySmall),
      labelLarge: fontGenerator(textStyle: textTheme.labelLarge),
      labelMedium: fontGenerator(textStyle: textTheme.labelMedium),
      labelSmall: fontGenerator(textStyle: textTheme.labelSmall),
    );
  }
}
