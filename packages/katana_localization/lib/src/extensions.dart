part of katana_localization;

/// Extension to extend [Locale].
///
/// [Locale]の拡張を行うエクステンション。
extension LocalizeLocaleExtensions on Locale {
  /// Convert to [languageCode] only locale.
  ///
  /// [languageCode]のみのロケールに変換します。
  Locale toLanguage() {
    return Locale(languageCode);
  }
}
