part of masamune;

/// Color definition for the theme.
class ThemeColor {
  /// Primary color.
  final Color primary;

  /// Secondary color.
  final Color secondary;

  /// Primary color variant.
  final Color primaryVariant;

  /// Secondary color variant.
  final Color secondaryVariant;

  /// The color when disabled.
  final Color disabled;

  /// The color of the outside line and the dividing line.
  final Color weak;

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

  /// Color definition for the theme.
  const ThemeColor(
      {this.primary = Colors.blue,
      this.secondary = Colors.cyan,
      this.primaryVariant = Colors.blueAccent,
      this.secondaryVariant = Colors.cyanAccent,
      this.disabled = Colors.grey,
      this.weak = Colors.grey,
      this.error = Colors.red,
      this.warning = Colors.amber,
      this.info = Colors.blue,
      this.success = Colors.green,
      this.surface = Colors.white,
      this.background = Colors.white,
      this.onPrimary = Colors.white,
      this.onSecondary = Colors.white,
      this.onDisabled = Colors.white,
      this.onSurface = Colors.white,
      this.onBackground = Colors.black,
      this.onWeak = Colors.white,
      this.onError = Colors.white,
      this.onInfo = Colors.white,
      this.onSuccess = Colors.black,
      this.onWarning = Colors.white,
      this.brightness = Brightness.light});

  /// Color definition for the theme.
  factory ThemeColor.light(
          {Color primary = Colors.blue,
          Color secondary = Colors.cyan,
          Color primaryVariant = Colors.blueAccent,
          Color secondaryVariant = Colors.cyanAccent,
          Color disabled = Colors.grey,
          Color weak = Colors.grey,
          Color error = Colors.red,
          Color warning = Colors.amber,
          Color info = Colors.blue,
          Color success = Colors.green,
          Color surface = Colors.white,
          Color background = Colors.white,
          Color onPrimary = Colors.white,
          Color onSecondary = Colors.white,
          Color onDisabled = Colors.white,
          Color onSurface = Colors.black,
          Color onBackground = Colors.black,
          Color onWeak = Colors.white,
          Color onError = Colors.white,
          Color onInfo = Colors.white,
          Color onSuccess = Colors.white,
          Color onWarning = Colors.white}) =>
      ThemeColor(
          primary: primary,
          secondary: secondary,
          primaryVariant: primaryVariant,
          secondaryVariant: secondaryVariant,
          disabled: disabled,
          weak: weak,
          error: error,
          warning: warning,
          info: info,
          success: success,
          surface: surface,
          background: background,
          onPrimary: onPrimary,
          onSecondary: onSecondary,
          onDisabled: onDisabled,
          onSurface: onSurface,
          onBackground: onBackground,
          onWeak: onWeak,
          onError: onError,
          onInfo: onInfo,
          onSuccess: onSuccess,
          onWarning: onWarning,
          brightness: Brightness.light);

  /// Color definition for the theme.
  factory ThemeColor.dark(
          {Color primary = Colors.blue,
          Color secondary = Colors.cyan,
          Color primaryVariant = Colors.blueAccent,
          Color secondaryVariant = Colors.cyanAccent,
          Color disabled = Colors.grey,
          Color weak = Colors.grey,
          Color error = Colors.red,
          Color warning = Colors.amber,
          Color info = Colors.blue,
          Color success = Colors.green,
          Color surface = Colors.black12,
          Color background = Colors.black26,
          Color onPrimary = Colors.white,
          Color onSecondary = Colors.white,
          Color onDisabled = Colors.white,
          Color onSurface = Colors.white,
          Color onBackground = Colors.white,
          Color onWeak = Colors.white,
          Color onError = Colors.white,
          Color onInfo = Colors.white,
          Color onSuccess = Colors.white,
          Color onWarning = Colors.white}) =>
      ThemeColor(
          primary: primary,
          secondary: secondary,
          primaryVariant: primaryVariant,
          secondaryVariant: secondaryVariant,
          disabled: disabled,
          weak: weak,
          error: error,
          warning: warning,
          info: info,
          success: success,
          surface: surface,
          background: background,
          onPrimary: onPrimary,
          onSecondary: onSecondary,
          onDisabled: onDisabled,
          onSurface: onSurface,
          onBackground: onBackground,
          onWeak: onWeak,
          onError: onError,
          onInfo: onInfo,
          onSuccess: onSuccess,
          onWarning: onWarning,
          brightness: Brightness.dark);

  /// Conversion to theme data.
  ThemeData toThemeData() {
    switch (this.brightness) {
      case Brightness.dark:
        final colorScheme = ColorScheme.dark().copyWith(
            primary: this.primary,
            primaryVariant: this.primaryVariant,
            secondary: this.secondary,
            secondaryVariant: this.secondaryVariant,
            surface: this.surface,
            background: this.background,
            error: this.error,
            onPrimary: this.onPrimary,
            onSecondary: this.onSecondary,
            onBackground: this.onBackground,
            onSurface: this.onSurface,
            onError: this.onError,
            brightness: this.brightness);
        return ThemeData.dark().copyWith(
            platform: TargetPlatform.iOS,
            colorScheme: colorScheme,
            buttonColor: this.primary,
            textTheme: ThemeData.light().textTheme.apply(
                bodyColor: this.onBackground, displayColor: this.onBackground),
            buttonTheme: ThemeData.dark().buttonTheme.copyWith(
                textTheme: ThemeData.dark().buttonTheme.textTheme,
                buttonColor: this.primary,
                disabledColor: this.disabled,
                colorScheme: colorScheme),
            inputDecorationTheme: ThemeData.dark()
                .inputDecorationTheme
                .copyWith(
                  labelStyle: TextStyle(color: this.weak),
                  helperStyle: TextStyle(color: this.weak),
                  hintStyle: TextStyle(color: this.weak),
                  counterStyle: TextStyle(color: this.weak),
                  errorStyle: TextStyle(color: this.error),
                  prefixStyle: TextStyle(color: this.onBackground),
                  suffixStyle: TextStyle(color: this.onBackground),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: this.weak, width: 2)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: this.weak, width: 2)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: this.weak, width: 2)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: this.primary, width: 2)),
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: this.error, width: 2)),
                  focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: this.error, width: 2)),
                ),
            indicatorColor: this.secondary,
            brightness: this.brightness,
            primaryColorBrightness: this.brightness,
            primaryColor: this.primary,
            accentColor: this.secondary,
            disabledColor: this.disabled,
            dividerColor: this.weak,
            errorColor: this.error,
            backgroundColor: this.background,
            canvasColor: this.background);
      default:
        final colorScheme = ColorScheme.light().copyWith(
            primary: this.primary,
            primaryVariant: this.primaryVariant,
            secondary: this.secondary,
            secondaryVariant: this.secondaryVariant,
            surface: this.surface,
            background: this.background,
            error: this.error,
            onPrimary: this.onPrimary,
            onSecondary: this.onSecondary,
            onBackground: this.onBackground,
            onSurface: this.onSurface,
            onError: this.onError,
            brightness: this.brightness);
        return ThemeData.light().copyWith(
            platform: TargetPlatform.iOS,
            colorScheme: colorScheme,
            buttonColor: this.primary,
            textTheme: ThemeData.light().textTheme.apply(
                bodyColor: this.onBackground, displayColor: this.onBackground),
            buttonTheme: ThemeData.light().buttonTheme.copyWith(
                buttonColor: this.primary,
                disabledColor: this.disabled,
                colorScheme: colorScheme),
            inputDecorationTheme: ThemeData.light()
                .inputDecorationTheme
                .copyWith(
                  labelStyle: TextStyle(color: this.weak),
                  helperStyle: TextStyle(color: this.weak),
                  hintStyle: TextStyle(color: this.weak),
                  counterStyle: TextStyle(color: this.weak),
                  errorStyle: TextStyle(color: this.error),
                  prefixStyle: TextStyle(color: this.onBackground),
                  suffixStyle: TextStyle(color: this.onBackground),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: this.weak, width: 2)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: this.weak, width: 2)),
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: this.weak, width: 2)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: this.primary, width: 2)),
                  errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: this.error, width: 2)),
                  focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: this.error, width: 2)),
                ),
            indicatorColor: this.secondary,
            brightness: this.brightness,
            primaryColorBrightness: this.brightness,
            primaryColor: this.primary,
            accentColor: this.secondary,
            disabledColor: this.disabled,
            dividerColor: this.weak,
            errorColor: this.error,
            backgroundColor: this.background,
            canvasColor: this.background);
    }
  }
}
