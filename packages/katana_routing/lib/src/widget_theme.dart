part of katana_routing;

/// Set the theme for the widget.
///
/// If you pass the theme data to [UIMaterialApp],
/// it will be used internally as the default for various widgets.
class WidgetTheme extends ThemeExtension<WidgetTheme> {
  /// Set the theme for the widget.
  ///
  /// If you pass the theme data to [UIMaterialApp],
  /// it will be used internally as the default for various widgets.
  const WidgetTheme({
    this.loadingIndicator = _loadingIndicator,
    // ignore: use_late_for_private_fields_and_variables
    this.requiredIcon = const Icon(Icons.check_circle, color: Colors.red),
  });

  /// Loading indicator.
  final Widget Function(BuildContext context, Color? color)? loadingIndicator;

  /// Required icons.
  final Widget requiredIcon;

  static Widget _loadingIndicator(BuildContext context, Color? color) {
    return const CircularProgressIndicator();
  }

  @override
  WidgetTheme copyWith({
    Widget Function(BuildContext context, Color? color)? loadingIndicator,
    Widget? requiredIcon,
  }) {
    return WidgetTheme(
      loadingIndicator: loadingIndicator ?? this.loadingIndicator,
      requiredIcon: requiredIcon ?? this.requiredIcon,
    );
  }

  @override
  WidgetTheme lerp(ThemeExtension? other, double t) {
    throw UnimplementedError();
  }
}
