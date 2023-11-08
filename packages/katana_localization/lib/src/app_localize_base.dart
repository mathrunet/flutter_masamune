part of '/katana_localization.dart';

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
abstract class AppLocalizeBase with ChangeNotifier {
  /// Returns the current locale.
  ///
  /// If [setCurrentLocale] has not yet been executed, `en_US` will be set.
  ///
  /// 現在のロケールを返します。
  ///
  /// [setCurrentLocale]がまだ実行されていない場合`en_US`が設定されます。
  Locale get locale => _locale ?? const Locale("en", "US");
  Locale? _locale;

  /// Pass [context] to set the locale for the current device.
  ///
  /// [context]を渡して現在のデバイスのロケールを設定します。
  void setCurrentLocaleWithContext(BuildContext context) {
    final locale = Localizations.localeOf(context);
    setCurrentLocale(locale);
  }

  /// Pass [locale] to set the locale for the current device.
  ///
  /// [locale]を渡して現在のデバイスのロケールを設定します。
  void setCurrentLocale(Locale locale) {
    if (!supportedLocales().contains(locale)) {
      throw UnsupportedError("This Locale is not supported: $locale");
    }
    if (_locale != locale) {
      _locale = locale;
      notifyListeners();
    }
  }

  /// Delegate list to be passed to `localizationsDelegates` such as MaterialApp.
  ///
  /// Additional delegates can be specified in [delegates]. If not specified, an empty array is passed.
  ///
  /// Pass this to `localizationsDelegates` such as MaterialApp as shown below.
  ///
  /// MaterialAppなどの`localizationsDelegates`に渡すためのデリゲートリスト。
  ///
  /// [delegates]に追加のデリゲートを指定可能です。指定しない場合は空の配列が渡されます。
  ///
  /// これを下記のようにMaterialAppなどの`localizationsDelegates`に渡してください。
  ///
  /// ```dart
  /// MaterialApp(
  ///   locale: appLocalize.locale,
  ///   localizationsDelegates: appLocalize.delegates(),
  ///   supportedLocales: appLocalize.supportedLocales(),
  ///   localeResolutionCallback: appLocalize.localeResolutionCallback(),
  /// );
  /// ```
  List<LocalizationsDelegate> delegates([
    List<LocalizationsDelegate> delegates = const [],
  ]);

  /// Locale list to pass to `supportedLocales` such as MaterialApp.
  ///
  /// Available locales are automatically calculated from GoogleSpreadSheet.
  ///
  /// Pass this to `supportedLocales` such as MaterialApp as shown below.
  ///
  /// MaterialAppなどの`supportedLocales`に渡すためのロケールリスト。
  ///
  /// 使用可能なロケールはGoogleSpreadSheetから自動的に算出されます。
  ///
  /// これを下記のようにMaterialAppなどの`supportedLocales`に渡してください。
  ///
  /// ```dart
  /// MaterialApp(
  ///   locale: appLocalize.locale,
  ///   localizationsDelegates: appLocalize.delegates(),
  ///   supportedLocales: appLocalize.supportedLocales(),
  ///   localeResolutionCallback: appLocalize.localeResolutionCallback(),
  /// );
  /// ```
  List<Locale> supportedLocales();

  /// Callback to set initial language.
  ///
  /// Pass this to the `localeResolutionCallback` of MaterialApp, etc. as follows.
  ///
  /// 初期言語を設定するためのコールバック。
  ///
  /// これを下記のようにMaterialAppなどの`localeResolutionCallback`に渡してください。
  ///
  /// ```dart
  /// MaterialApp(
  ///   locale: appLocalize.locale,
  ///   localizationsDelegates: appLocalize.delegates(),
  ///   supportedLocales: appLocalize.supportedLocales(),
  ///   localeResolutionCallback: appLocalize.localeResolutionCallback(),
  /// );
  /// ```
  Locale? Function(
    Locale? locale,
    Iterable<Locale> supportedLocales,
  ) localeResolutionCallback() => (locale, supportedLocales) {
        if (_locale != null) {
          return _locale;
        }
        if (kIsWeb || locale == null) {
          final locale =
              Locale(PlatformDispatcher.instance.locale.languageCode, "");
          for (final supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              _locale ??= supportedLocale;
              return _locale = supportedLocale;
            }
          }
        } else {
          for (final supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode ||
                supportedLocale.countryCode == locale.countryCode) {
              _locale ??= supportedLocale;
              return supportedLocale;
            }
          }
          for (final supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode) {
              _locale ??= supportedLocale;
              return supportedLocale;
            }
          }
        }
        _locale ??= supportedLocales.first;
        return supportedLocales.first;
      };
}
