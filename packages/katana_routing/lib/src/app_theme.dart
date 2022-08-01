part of katana_routing;

/// Color definition for the theme.
@immutable
class AppTheme {
  /// Color definition for the theme.
  const AppTheme({
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
    this.brightness = Brightness.light,
    this.appBarColor,
    this.scaffoldBackgroundColor,
    this.fontFamily,
    this.useMaterial3 = true,
    this.displayLarge = const TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      // height: 1.12,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    this.displayMedium = const TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      // height: 1.15,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    this.displaySmall = const TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      // height: 1.22,
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
      // height: 1.27,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    this.titleMedium = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      // height: 1.5,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    this.titleSmall = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      // height: 1.43,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    this.bodyLarge = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      // height: 1.5,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    this.bodyMedium = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      // height: 1.43,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    this.bodySmall = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      // height: 1.33,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    this.labelLarge = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      // height: 1.43,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    this.labelMedium = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      // height: 1.33,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    this.labelSmall = const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      // height: 1.45,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    this.fontSizeFactor = 1.0,
    this.fontSizeDelta = 0.0,
    this.widgetTheme = const WidgetTheme(),
    this.imageTheme = const ImageTheme(),
  });

  /// Color definition for the theme.
  const AppTheme.light({
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
    this.onSurface = const Color(0xFF212121),
    this.onBackground = const Color(0xFF212121),
    this.onWeak = const Color(0xFFFFFFFF),
    this.onError = const Color(0xFFFFFFFF),
    this.onInfo = const Color(0xFFFFFFFF),
    this.onSuccess = const Color(0xFFFFFFFF),
    this.onWarning = const Color(0xFFFFFFFF),
    this.appBarColor,
    this.scaffoldBackgroundColor,
    this.fontFamily,
    this.useMaterial3 = true,
    this.displayLarge = const TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      // height: 1.12,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    this.displayMedium = const TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      // height: 1.15,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    this.displaySmall = const TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      // height: 1.22,
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
      // height: 1.27,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    this.titleMedium = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      // height: 1.5,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    this.titleSmall = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      // height: 1.43,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    this.bodyLarge = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      // height: 1.5,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    this.bodyMedium = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      // height: 1.43,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    this.bodySmall = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      // height: 1.33,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    this.labelLarge = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      // height: 1.43,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    this.labelMedium = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      // height: 1.33,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    this.labelSmall = const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      // height: 1.45,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    this.fontSizeFactor = 1.0,
    this.fontSizeDelta = 0.0,
    this.widgetTheme = const WidgetTheme(),
    this.imageTheme = const ImageTheme(),
  }) : brightness = Brightness.light;

  /// Color definition for the theme.
  const AppTheme.dark({
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
    this.surface = const Color(0xFF212121),
    this.background = const Color(0xFF212121),
    this.onPrimary = const Color(0xFFFFFFFF),
    this.onSecondary = const Color(0xFFFFFFFF),
    this.onTertiary = const Color(0xFFFFFFFF),
    this.onPrimaryContainer = const Color(0xFFFFFFFF),
    this.onSecondaryContainer = const Color(0xFFFFFFFF),
    this.onTertiaryContainer = const Color(0xFFFFFFFF),
    this.onDisabled = const Color(0xFFFFFFFF),
    this.onSurface = const Color(0xFFFFFFFF),
    this.onBackground = const Color(0xFFFFFFFF),
    this.onWeak = const Color(0xFFFFFFFF),
    this.onError = const Color(0xFFFFFFFF),
    this.onInfo = const Color(0xFFFFFFFF),
    this.onSuccess = const Color(0xFFFFFFFF),
    this.onWarning = const Color(0xFFFFFFFF),
    this.appBarColor,
    this.scaffoldBackgroundColor,
    this.fontFamily,
    this.useMaterial3 = true,
    this.displayLarge = const TextStyle(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      // height: 1.12,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    this.displayMedium = const TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      // height: 1.15,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    this.displaySmall = const TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      // height: 1.22,
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
      // height: 1.27,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    this.titleMedium = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      // height: 1.5,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    this.titleSmall = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      // height: 1.43,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    this.bodyLarge = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      // height: 1.5,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    this.bodyMedium = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      // height: 1.43,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    this.bodySmall = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      // height: 1.33,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    this.labelLarge = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      // height: 1.43,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    this.labelMedium = const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      // height: 1.33,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    this.labelSmall = const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      // height: 1.45,
      leadingDistribution: TextLeadingDistribution.even,
    ),
    this.fontSizeFactor = 1.0,
    this.fontSizeDelta = 0.0,
    this.widgetTheme = const WidgetTheme(),
    this.imageTheme = const ImageTheme(),
  }) : brightness = Brightness.dark;

  /// Default font family.
  final String? fontFamily;

  /// Primary color.
  final Color primary;

  /// Secondary color.
  final Color secondary;

  /// Tertiary color.
  final Color tertiary;

  /// Primary color container.
  final Color primaryContainer;

  /// Secondary color container.
  final Color secondaryContainer;

  /// Tertiary color container.
  final Color tertiaryContainer;

  /// The color when disabled.
  final Color disabled;

  /// The color of the outside line and the dividing line.
  final Color weak;

  /// Outline color.
  final Color outline;

  /// Error color.
  final Color error;

  /// Attention color.
  final Color warning;

  /// Information color.
  final Color info;

  /// Color when successful.
  final Color success;

  /// Background color of dialogs, etc.
  final Color surface;

  /// Background color.
  final Color background;

  /// Primary color text color.
  final Color onPrimary;

  /// Secondary color text color.
  final Color onSecondary;

  /// Tertiary color text color.
  final Color onTertiary;

  /// Primary container color text color.
  final Color onPrimaryContainer;

  /// Secondary container color text color.
  final Color onSecondaryContainer;

  /// Tertiary container color text color.
  final Color onTertiaryContainer;

  /// Invalid text color.
  final Color onDisabled;

  /// Character color of the surface.
  final Color onSurface;

  /// Text color for the background color.
  final Color onBackground;

  /// Text color for lines.
  final Color onWeak;

  /// Text color for errors.
  final Color onError;

  /// Text color for information.
  final Color onInfo;

  /// Text color for success color.
  final Color onSuccess;

  /// Text color for attention color.
  final Color onWarning;

  /// Brightness.
  final Brightness brightness;

  /// App bar color.
  final Color? appBarColor;

  /// Scaffold color.
  final Color? scaffoldBackgroundColor;

  /// True when using Material 3.
  final bool useMaterial3;

  /// Display large text.
  final TextStyle displayLarge;

  /// Display medium text.
  final TextStyle displayMedium;

  /// Display small text.
  final TextStyle displaySmall;

  /// Headline large text.
  final TextStyle headlineLarge;

  /// Headline medium text.
  final TextStyle headlineMedium;

  /// Headline small text.
  final TextStyle headlineSmall;

  /// Title large text.
  final TextStyle titleLarge;

  /// Title medium text.
  final TextStyle titleMedium;

  /// Title small text.
  final TextStyle titleSmall;

  /// Body large text.
  final TextStyle bodyLarge;

  /// Body medium text.
  final TextStyle bodyMedium;

  /// Body small text.
  final TextStyle bodySmall;

  /// Label large text.
  final TextStyle labelLarge;

  /// Label medium text.
  final TextStyle labelMedium;

  /// Label small text.
  final TextStyle labelSmall;

  /// Font size factor.
  final double fontSizeFactor;

  /// Font size delta.
  final double fontSizeDelta;

  /// Widget theme.
  final WidgetTheme widgetTheme;

  /// Image theme.
  final ImageTheme imageTheme;

  /// Conversion to theme data.
  ThemeData toThemeData() {
    switch (brightness) {
      case Brightness.dark:
        final colorScheme = const ColorScheme.dark().copyWith(
          primary: primary,
          primaryContainer: primaryContainer,
          secondary: secondary,
          secondaryContainer: secondaryContainer,
          tertiary: tertiary,
          tertiaryContainer: tertiaryContainer,
          surface: surface,
          background: background,
          error: error,
          errorContainer: warning,
          onPrimary: onPrimary,
          onPrimaryContainer: onPrimaryContainer,
          onSecondary: onSecondary,
          onSecondaryContainer: onSecondaryContainer,
          onTertiary: onTertiary,
          onTertiaryContainer: onTertiaryContainer,
          onBackground: onBackground,
          onSurface: onSurface,
          onError: onError,
          onErrorContainer: onWarning,
          brightness: brightness,
          outline: outline,
        );
        final theme = ThemeData.dark();
        final textTheme = _convertTextThemeFromFont(
          fontFamily,
          theme.textTheme,
        ).apply(
          fontSizeFactor: fontSizeFactor,
          fontSizeDelta: fontSizeDelta,
        );
        return ThemeData(
          useMaterial3: useMaterial3,
          platform: TargetPlatform.iOS,
          extensions: [
            ...theme.extensions.values,
            widgetTheme,
            imageTheme,
          ],
          // colorSchemeSeed: primary,
          colorScheme: colorScheme,
          splashColor: const Color(0xFFFFFFFF).withOpacity(0.8),
          scaffoldBackgroundColor: scaffoldBackgroundColor,
          textTheme: textTheme.apply(
            bodyColor: onBackground,
            displayColor: onBackground,
          ),
          appBarTheme: appBarColor != null
              ? theme.appBarTheme.copyWith(
                  backgroundColor: appBarColor,
                  elevation: appBarColor == Colors.transparent ? 0 : null,
                  foregroundColor:
                      appBarColor == Colors.transparent ? onBackground : null,
                  toolbarTextStyle: appBarColor == Colors.transparent
                      ? theme.appBarTheme.toolbarTextStyle?.copyWith(
                          color: onBackground,
                        )
                      : null,
                  titleTextStyle: appBarColor == Colors.transparent
                      ? theme.appBarTheme.titleTextStyle?.copyWith(
                          color: onBackground,
                        )
                      : null,
                  iconTheme: appBarColor == Colors.transparent
                      ? theme.iconTheme.copyWith(
                          color: onBackground,
                        )
                      : null,
                  actionsIconTheme: appBarColor == Colors.transparent
                      ? theme.iconTheme.copyWith(
                          color: onBackground,
                        )
                      : null,
                )
              : null,
          buttonTheme: theme.buttonTheme.copyWith(
            textTheme: theme.buttonTheme.textTheme,
            buttonColor: primary,
            disabledColor: disabled,
            colorScheme: colorScheme,
          ),
          inputDecorationTheme: theme.inputDecorationTheme.copyWith(
            labelStyle: TextStyle(color: weak),
            helperStyle: TextStyle(color: weak),
            hintStyle: TextStyle(color: weak),
            counterStyle: TextStyle(color: weak),
            errorStyle: TextStyle(color: error),
            prefixStyle: TextStyle(color: onBackground),
            suffixStyle: TextStyle(color: onBackground),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: weak, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: weak, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: weak, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: error, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: error, width: 2),
            ),
          ),
          indicatorColor: secondary,
          brightness: brightness,
          primaryColor: primary,
          disabledColor: disabled,
          dividerColor: outline,
          errorColor: error,
          backgroundColor: background,
          canvasColor: background,
        );
      default:
        final colorScheme = const ColorScheme.light().copyWith(
          primary: primary,
          primaryContainer: primaryContainer,
          secondary: secondary,
          secondaryContainer: secondaryContainer,
          tertiary: tertiary,
          tertiaryContainer: tertiaryContainer,
          surface: surface,
          background: background,
          error: error,
          onPrimary: onPrimary,
          onPrimaryContainer: onPrimaryContainer,
          onSecondary: onSecondary,
          onSecondaryContainer: onSecondaryContainer,
          onTertiary: onTertiary,
          onTertiaryContainer: onTertiaryContainer,
          onBackground: onBackground,
          onSurface: onSurface,
          onError: onError,
          brightness: brightness,
          outline: outline,
        );
        final theme = ThemeData.light();
        final textTheme = _convertTextThemeFromFont(
          fontFamily,
          theme.textTheme,
        ).apply(
          fontSizeFactor: fontSizeFactor,
          fontSizeDelta: fontSizeDelta,
        );
        return ThemeData(
          useMaterial3: useMaterial3,
          platform: TargetPlatform.iOS,
          extensions: [
            ...theme.extensions.values,
            widgetTheme,
            imageTheme,
          ],
          // colorSchemeSeed: primary,
          colorScheme: colorScheme,
          splashColor: const Color(0xFFFFFFFF).withOpacity(0.8),
          scaffoldBackgroundColor: scaffoldBackgroundColor,
          appBarTheme: appBarColor != null
              ? theme.appBarTheme.copyWith(
                  backgroundColor: appBarColor,
                  elevation: appBarColor == Colors.transparent ? 0 : null,
                  foregroundColor:
                      appBarColor == Colors.transparent ? onBackground : null,
                  toolbarTextStyle: appBarColor == Colors.transparent
                      ? theme.appBarTheme.toolbarTextStyle?.copyWith(
                          color: onBackground,
                        )
                      : null,
                  titleTextStyle: appBarColor == Colors.transparent
                      ? theme.appBarTheme.titleTextStyle?.copyWith(
                          color: onBackground,
                        )
                      : null,
                  iconTheme: appBarColor == Colors.transparent
                      ? theme.iconTheme.copyWith(
                          color: onBackground,
                        )
                      : null,
                  actionsIconTheme: appBarColor == Colors.transparent
                      ? theme.iconTheme.copyWith(
                          color: onBackground,
                        )
                      : null,
                )
              : null,
          textTheme: textTheme.apply(
            bodyColor: onBackground,
            displayColor: onBackground,
          ),
          buttonTheme: theme.buttonTheme.copyWith(
            buttonColor: primary,
            disabledColor: disabled,
            colorScheme: colorScheme,
          ),
          inputDecorationTheme: theme.inputDecorationTheme.copyWith(
            labelStyle: TextStyle(color: weak),
            helperStyle: TextStyle(color: weak),
            hintStyle: TextStyle(color: weak),
            counterStyle: TextStyle(color: weak),
            errorStyle: TextStyle(color: error),
            prefixStyle: TextStyle(color: onBackground),
            suffixStyle: TextStyle(color: onBackground),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: weak, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: weak, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: weak, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: error, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: error, width: 2),
            ),
          ),
          indicatorColor: secondary,
          brightness: brightness,
          primaryColor: primary,
          disabledColor: disabled,
          dividerColor: outline,
          errorColor: error,
          backgroundColor: background,
          canvasColor: background,
        );
    }
  }

  TextTheme _convertTextThemeFromFont(
    String? fontFamily,
    TextTheme textTheme,
  ) {
    textTheme = textTheme.copyWith(
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
    );
    if (fontFamily.isEmpty) {
      return textTheme;
    }
    final fonts = GoogleFonts.asMap();
    final fontGenerator = fonts[fontFamily];
    if (fontGenerator == null) {
      return textTheme;
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
