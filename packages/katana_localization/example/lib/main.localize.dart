// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering

part of 'main.dart';

// **************************************************************************
// GoogleSpreadSheetLocalizeGenerator
// **************************************************************************

abstract class AppLocalizeBase {
  Locale get currentLocale => _locale;
  Locale _locale = Locale("en", "US");

  void setCurrentLocale(BuildContext context) {
    _locale = Localizations.localeOf(context);
  }
}

abstract class _$AppLocalize extends AppLocalizeBase {
  List<LocalizationsDelegate> delegates() {
    return const [_$AppLocalizeDelegate()];
  }

  List<Locale> supportedLocales() {
    return _$appLocalizeLocalizations.keys.toList();
  }

  _$AppLocalizeBase call([BuildContext? context]) {
    final l = context != null ? Localizations.localeOf(context) : currentLocale;
    if (!_$appLocalizeLocalizations.containsKey(l)) {
      return _$appLocalizeLocalizations[l]!;
    } else {
      return _$appLocalizeLocalizations.values.first;
    }
  }
}

class _$AppLocalizeDelegate extends LocalizationsDelegate<_$AppLocalizeBase> {
  const _$AppLocalizeDelegate();

  @override
  bool isSupported(Locale locale) =>
      _$appLocalizeLocalizations.containsKey(locale);
  @override
  Future<_$AppLocalizeBase> load(Locale locale) =>
      SynchronousFuture(_$appLocalizeLocalizations[locale] ??
          _$appLocalizeLocalizations.values.first);
  @override
  bool shouldReload(LocalizationsDelegate<_$AppLocalizeBase> old) => false;
}

final _$appLocalizeLocalizations = {
  Locale("en", "US"): _$AppLocalizeEnus(),
  Locale("ja", "JP"): _$AppLocalizeJajp()
};

abstract class _$AppLocalizeBase {
  const _$AppLocalizeBase();

  String get appTitle => throw UnimplementedError();
  String get yes => throw UnimplementedError();
  String get no => throw UnimplementedError();
  String get ok => throw UnimplementedError();
  String get open => throw UnimplementedError();
  String get close => throw UnimplementedError();
  String get forward => throw UnimplementedError();
  String get back => throw UnimplementedError();
  String get next => throw UnimplementedError();
  String get prev => throw UnimplementedError();
  String get complete => throw UnimplementedError();
  String get success => throw UnimplementedError();
  String get error => throw UnimplementedError();
  String get warning => throw UnimplementedError();
  String get notice => throw UnimplementedError();
  String get confirm => throw UnimplementedError();
  String get cancel => throw UnimplementedError();
  String get confirmation => throw UnimplementedError();
  String get refresh => throw UnimplementedError();
  String get resend => throw UnimplementedError();
  String get retry => throw UnimplementedError();
  String get quit => throw UnimplementedError();
  String get property => throw UnimplementedError();
  String get allDay => throw UnimplementedError();
  String get others => throw UnimplementedError();
  String get note => throw UnimplementedError();
  String get detail => throw UnimplementedError();
  String get setting => throw UnimplementedError();
  String get config => throw UnimplementedError();
  String get post => throw UnimplementedError();
  String get submit => throw UnimplementedError();
  String get save => throw UnimplementedError();
  String get data => throw UnimplementedError();
  String get add => throw UnimplementedError();
  String get remove => throw UnimplementedError();
  String get delete => throw UnimplementedError();
  String get invite => throw UnimplementedError();
  String get user => throw UnimplementedError();
  String get content => throw UnimplementedError();
  String get member => throw UnimplementedError();
  String get account => throw UnimplementedError();
}

class _$AppLocalizeEnus extends _$AppLocalizeBase {
  const _$AppLocalizeEnus();

  @override
  String get appTitle => "AppTitle";
  @override
  String get yes => "Yes";
  @override
  String get no => "No";
  @override
  String get ok => "Okay";
  @override
  String get open => "Open";
  @override
  String get close => "Close";
  @override
  String get forward => "Forward";
  @override
  String get back => "Back";
  @override
  String get next => "Next";
  @override
  String get prev => "Prev";
  @override
  String get complete => "Complete";
  @override
  String get success => "Success";
  @override
  String get error => "Error";
  @override
  String get warning => "Warning";
  @override
  String get notice => "Notice";
  @override
  String get confirm => "Confirm";
  @override
  String get cancel => "Cancel";
  @override
  String get confirmation => "Confirmation";
  @override
  String get refresh => "Refresh";
  @override
  String get resend => "Resend";
  @override
  String get retry => "Retry";
  @override
  String get quit => "Quit";
  @override
  String get property => "Property";
  @override
  String get allDay => "All day";
  @override
  String get others => "Others";
  @override
  String get note => "Note";
  @override
  String get detail => "Detail";
  @override
  String get setting => "Setting";
  @override
  String get config => "Config";
  @override
  String get post => "Post";
  @override
  String get submit => "Submit";
  @override
  String get save => "Save";
  @override
  String get data => "Data";
  @override
  String get add => "Add";
  @override
  String get remove => "Remove";
  @override
  String get delete => "Delete";
  @override
  String get invite => "Invite";
  @override
  String get user => "User";
  @override
  String get content => "Content";
  @override
  String get member => "Member";
  @override
  String get account => "Account";
}

class _$AppLocalizeJajp extends _$AppLocalizeBase {
  const _$AppLocalizeJajp();

  @override
  String get appTitle => "アプリタイトル";
  @override
  String get yes => "はい";
  @override
  String get no => "いいえ";
  @override
  String get ok => "OK";
  @override
  String get open => "開く";
  @override
  String get close => "閉じる";
  @override
  String get forward => "進む";
  @override
  String get back => "戻る";
  @override
  String get next => "次";
  @override
  String get prev => "前";
  @override
  String get complete => "完了";
  @override
  String get success => "成功";
  @override
  String get error => "エラー";
  @override
  String get warning => "警告";
  @override
  String get notice => "注意";
  @override
  String get confirm => "決定";
  @override
  String get cancel => "キャンセル";
  @override
  String get confirmation => "確認";
  @override
  String get refresh => "更新";
  @override
  String get resend => "再送信";
  @override
  String get retry => "リトライ";
  @override
  String get quit => "終了";
  @override
  String get property => "プロパティ";
  @override
  String get allDay => "終日";
  @override
  String get others => "その他";
  @override
  String get note => "ノート";
  @override
  String get detail => "詳細";
  @override
  String get setting => "設定";
  @override
  String get config => "設定";
  @override
  String get post => "投稿";
  @override
  String get submit => "決定";
  @override
  String get save => "保存";
  @override
  String get data => "データ";
  @override
  String get add => "追加";
  @override
  String get remove => "削除";
  @override
  String get delete => "削除";
  @override
  String get invite => "招待";
  @override
  String get user => "ユーザー";
  @override
  String get content => "コンテンツ";
  @override
  String get member => "メンバー";
  @override
  String get account => "アカウント";
}
