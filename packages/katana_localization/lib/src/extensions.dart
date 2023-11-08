part of '/katana_localization.dart';

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

/// Extension to extend [BuildContext].
///
/// [BuildContext]の拡張を行うエクステンション。
extension BuildContextLocaleExtensions on BuildContext {
  /// Get the current [Locale].
  ///
  /// 現在の[Locale]を取得します。
  Locale get locale {
    return Localizations.localeOf(this);
  }
}
