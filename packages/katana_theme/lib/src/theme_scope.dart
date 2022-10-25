part of katana_theme;

class ThemeScope<T extends AppThemeBase> extends InheritedWidget {
  const ThemeScope({
    required super.child,
    required this.theme,
    super.key,
  });

  final T theme;

  @override
  // ignore: avoid_renaming_method_parameters
  bool updateShouldNotify(ThemeScope old) {
    return true;
  }
}
