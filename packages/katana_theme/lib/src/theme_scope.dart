part of katana_theme;

/// [InheritedWidget] for placing [AppThemeData] on the widget tree.
///
/// You can take the value of [AppThemeData] passed here in [AppThemeData.of].
///
/// [AppThemeData]をウィジェットツリー上に配置するための[InheritedWidget]。
///
/// [AppThemeData.of]でここで渡した[AppThemeData]の値を取ることができます。
@immutable
class AppThemeScope extends InheritedWidget {
  const AppThemeScope({
    required super.child,
    required this.theme,
    super.key,
  });

  /// Value of [AppThemeData].
  ///
  /// [AppThemeData]の値。
  final AppThemeData theme;

  @override
  bool updateShouldNotify(AppThemeScope oldWidget) {
    return false;
  }
}
