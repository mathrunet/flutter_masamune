part of '/katana_localization.dart';

/// Class for retrieving the default [LocalizationsDelegate].
///
/// デフォルトの[LocalizationsDelegate]を取得するためのクラス。
class AppLocalizationSettings {
  const AppLocalizationSettings._();

  /// You can get the default [LocalizationsDelegate] in Material, Cupertino and Widgets.
  ///
  /// This can be used by passing it to [MaterialApp.localizationsDelegates].
  ///
  /// All languages are supported, but output is in English.
  ///
  /// デフォルトの[LocalizationsDelegate]をMaterial、Cupertino、Widgetsで取得することができます。
  ///
  /// これを[MaterialApp.localizationsDelegates]に渡すことで利用することができます。
  ///
  /// すべての言語に対応してますが、出力は英語になります。
  static const List<LocalizationsDelegate<dynamic>> delegates = [
    AppMaterialLocalizationsDelegate(),
    AppCupertinoLocalizationsDelegate(),
    AppWidgetsLocalizationsDelegate(),
  ];
}

/// Class of [LocalizationsDelegate] for Material.
///
/// This can be used by passing it to [MaterialApp.localizationsDelegates].
///
/// All languages are supported, but output is in English.
///
/// Material用の[LocalizationsDelegate]のクラス。
///
/// これを[MaterialApp.localizationsDelegates]に渡すことで利用することができます。
///
/// すべての言語に対応してますが、出力は英語になります。
class AppMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  /// Class of [LocalizationsDelegate] for Material.
  ///
  /// This can be used by passing it to [MaterialApp.localizationsDelegates].
  ///
  /// All languages are supported, but output is in English.
  ///
  /// Material用の[LocalizationsDelegate]のクラス。
  ///
  /// これを[MaterialApp.localizationsDelegates]に渡すことで利用することができます。
  ///
  /// すべての言語に対応してますが、出力は英語になります。
  const AppMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;
  @override
  Future<MaterialLocalizations> load(Locale locale) =>
      SynchronousFuture(const DefaultMaterialLocalizations());
  @override
  bool shouldReload(LocalizationsDelegate<MaterialLocalizations> old) => false;
}

/// Class of [LocalizationsDelegate] for Cupertino.
///
/// This can be used by passing it to [MaterialApp.localizationsDelegates].
///
/// All languages are supported, but output is in English.
///
/// Cupertinoの[LocalizationsDelegate]のクラス。
///
/// これを[MaterialApp.localizationsDelegates]に渡すことで利用することができます。
///
/// すべての言語に対応してますが、出力は英語になります。
class AppCupertinoLocalizationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  /// Class of [LocalizationsDelegate] for Cupertino.
  ///
  /// This can be used by passing it to [MaterialApp.localizationsDelegates].
  ///
  /// All languages are supported, but output is in English.
  ///
  /// Cupertino用の[LocalizationsDelegate]のクラス。
  ///
  /// これを[MaterialApp.localizationsDelegates]に渡すことで利用することができます。
  ///
  /// すべての言語に対応してますが、出力は英語になります。
  const AppCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;
  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      SynchronousFuture(const DefaultCupertinoLocalizations());
  @override
  bool shouldReload(LocalizationsDelegate<CupertinoLocalizations> old) => false;
}

/// Class of [LocalizationsDelegate] for Widget.
///
/// This can be used by passing it to [MaterialApp.localizationsDelegates].
///
/// All languages are supported, but output is in English.
///
/// Widget用の[LocalizationsDelegate]のクラス。
///
/// これを[MaterialApp.localizationsDelegates]に渡すことで利用することができます。
///
/// すべての言語に対応してますが、出力は英語になります。
class AppWidgetsLocalizationsDelegate
    extends LocalizationsDelegate<WidgetsLocalizations> {
  /// Class of [LocalizationsDelegate] for Widget.
  ///
  /// This can be used by passing it to [MaterialApp.localizationsDelegates].
  ///
  /// All languages are supported, but output is in English.
  ///
  /// Widget用の[LocalizationsDelegate]のクラス。
  ///
  /// これを[MaterialApp.localizationsDelegates]に渡すことで利用することができます。
  ///
  /// すべての言語に対応してますが、出力は英語になります。
  const AppWidgetsLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true;
  @override
  Future<WidgetsLocalizations> load(Locale locale) =>
      SynchronousFuture(const DefaultWidgetsLocalizations());
  @override
  bool shouldReload(LocalizationsDelegate<WidgetsLocalizations> old) => false;
}
