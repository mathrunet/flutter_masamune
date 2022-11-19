part of katana_theme_annotation;

/// Annotation to be given to the theme of the application.
///
/// Granting this will create the assets and font data defined in pubspec.yaml in the target application theme.
///
/// アプリのテーマに対して付与するアノテーション。
///
/// これを付与することで対象となるアプリテーマにpubspec.yamlで定義されているアセットとフォントのデータが作成されます。
///
/// ```dart
/// @appTheme
/// final theme = AppThemeData();
/// ```
const appTheme = AppTheme();

/// Annotation to be given to the theme of the application.
///
/// Granting this will create the assets and font data defined in pubspec.yaml in the target application theme.
///
/// アプリのテーマに対して付与するアノテーション。
///
/// これを付与することで対象となるアプリテーマにpubspec.yamlで定義されているアセットとフォントのデータが作成されます。
///
/// ```dart
/// @appTheme
/// final theme = AppThemeData();
/// ```
class AppTheme {
  const AppTheme();
}
