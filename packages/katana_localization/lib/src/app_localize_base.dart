part of katana_localization;

/// Base class for building the localized configuration of the application.
///
/// It is possible to set the locale of the current device by executing [setCurrentLocale] while passing `BuildContext`.
///
/// This way, translations can be used in places where `BuildContext` is not available.
///
/// アプリケーションのローカライズ設定を構築するためのベースクラス。
///
/// `BuildContext`を渡しながら[setCurrentLocale]を実行することで現在のデバイスのロケールを設定することが可能になります。
///
/// そうすることで`BuildContext`が使用できない場所でも翻訳を利用することができるようになります。
abstract class AppLocalizeBase {
  /// Returns the current locale.
  ///
  /// If [setCurrentLocale] has not yet been executed, `en_US` will be set.
  ///
  /// 現在のロケールを返します。
  ///
  /// [setCurrentLocale]がまだ実行されていない場合`en_US`が設定されます。
  Locale get currentLocale => _locale;
  Locale _locale = const Locale("en", "US");

  /// Pass [context] to set the locale for the current device.
  ///
  /// [context]を渡して現在のデバイスのロケールを設定します。
  void setCurrentLocale(BuildContext context) {
    _locale = Localizations.localeOf(context);
  }
}
