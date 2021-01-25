part of masamune;

/// Set the theme for the widget.
///
/// If you pass the theme data to [UIMaterialApp],
/// it will be used internally as the default for various widgets.
class WidgetTheme {
  /// Get WidgetTheme.
  ///
  /// You can check the current widget setting.
  static WidgetTheme of(BuildContext context) {
    return (context
            .getElementForInheritedWidgetOfExactType<_UIMaterialAppScope>()
            ?.widget as _UIMaterialAppScope)
        ?.state
        ?.widget
        ?.widgetTheme;
  }

  /// Loading indicator.
  final Widget Function(BuildContext context, Color color) loadingIndicator;

  /// Set the theme for the widget.
  ///
  /// If you pass the theme data to [UIMaterialApp],
  /// it will be used internally as the default for various widgets.
  const WidgetTheme({this.loadingIndicator});
}
