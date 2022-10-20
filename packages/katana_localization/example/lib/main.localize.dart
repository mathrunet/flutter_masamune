// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps

part of 'main.dart';

// **************************************************************************
// GoogleSpreadSheetLocalizeGenerator
// **************************************************************************

abstract class _$AppLocalize extends AppLocalizeBase {
  List<LocalizationsDelegate> delegates() {
    return const [_$AppLocalizeDelegate()];
  }

  List<Locale> supportedLocales() {
    return _$appLocalizeLocalizations.keys.toList();
  }

  _$AppLocalizeBase call([BuildContext? context]) {
    final l = context != null ? Localizations.localeOf(context) : currentLocale;
    if (_$appLocalizeLocalizations.containsKey(l)) {
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
  String get process => throw UnimplementedError();
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
  String get user => throw UnimplementedError();
  String get content => throw UnimplementedError();
  String get member => throw UnimplementedError();
  String get account => throw UnimplementedError();
  _$c2db8e3922694f2d948bd936b3e4e872Base $(Object? _p1) =>
      throw UnimplementedError();
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
  String get process => "Process";
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
  String get user => "User";
  @override
  String get content => "Content";
  @override
  String get member => "Member";
  @override
  String get account => "Account";
  @override
  _$c2db8e3922694f2d948bd936b3e4e872Enus $(Object? _p1) =>
      _$c2db8e3922694f2d948bd936b3e4e872Enus(p1: _p1);
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
  String get process => "処理";
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
  String get user => "ユーザー";
  @override
  String get content => "コンテンツ";
  @override
  String get member => "メンバー";
  @override
  String get account => "アカウント";
  @override
  _$c2db8e3922694f2d948bd936b3e4e872Jajp $(Object? _p1) =>
      _$c2db8e3922694f2d948bd936b3e4e872Jajp(p1: _p1);
}

abstract class _$c2db8e3922694f2d948bd936b3e4e872Base {
  const _$c2db8e3922694f2d948bd936b3e4e872Base({Object? p1}) : _p1 = p1;

  final Object? _p1;

  _$310bd525f89b4731ba62a5ea70175400Base get on => throw UnimplementedError();
  _$b4955da361c94eee92d63871cce214d8Base get in_ => throw UnimplementedError();
  _$dab7e2f2b0304220908311920eb82435Base get of => throw UnimplementedError();
  _$9be4b831af634880a6f09f8ba7329642Base get and => throw UnimplementedError();
  _$7334128089784c76b7a4d384becf862eBase get or => throw UnimplementedError();
  String get hasBeenCompleted => throw UnimplementedError();
  String get haveBeenCompleted => throw UnimplementedError();
  String get hasBeenSuccessful => throw UnimplementedError();
  String get haveBeenSuccessful => throw UnimplementedError();
  String get hasFailed => throw UnimplementedError();
  String get haveFailed => throw UnimplementedError();
}

class _$c2db8e3922694f2d948bd936b3e4e872Enus
    extends _$c2db8e3922694f2d948bd936b3e4e872Base {
  const _$c2db8e3922694f2d948bd936b3e4e872Enus({super.p1});

  @override
  _$310bd525f89b4731ba62a5ea70175400Enus get on =>
      _$310bd525f89b4731ba62a5ea70175400Enus(p1: _p1);
  @override
  _$b4955da361c94eee92d63871cce214d8Enus get in_ =>
      _$b4955da361c94eee92d63871cce214d8Enus(p1: _p1);
  @override
  _$dab7e2f2b0304220908311920eb82435Enus get of =>
      _$dab7e2f2b0304220908311920eb82435Enus(p1: _p1);
  @override
  _$9be4b831af634880a6f09f8ba7329642Enus get and =>
      _$9be4b831af634880a6f09f8ba7329642Enus(p1: _p1);
  @override
  _$7334128089784c76b7a4d384becf862eEnus get or =>
      _$7334128089784c76b7a4d384becf862eEnus(p1: _p1);
  @override
  String get hasBeenCompleted => "${_p1} has been completed.";
  @override
  String get haveBeenCompleted => "${_p1} have been completed.";
  @override
  String get hasBeenSuccessful => "${_p1} has been successful.";
  @override
  String get haveBeenSuccessful => "${_p1} have been successful.";
  @override
  String get hasFailed => "${_p1} has failed.";
  @override
  String get haveFailed => "${_p1} have failed.";
}

class _$c2db8e3922694f2d948bd936b3e4e872Jajp
    extends _$c2db8e3922694f2d948bd936b3e4e872Base {
  const _$c2db8e3922694f2d948bd936b3e4e872Jajp({super.p1});

  @override
  _$310bd525f89b4731ba62a5ea70175400Jajp get on =>
      _$310bd525f89b4731ba62a5ea70175400Jajp(p1: _p1);
  @override
  _$b4955da361c94eee92d63871cce214d8Jajp get in_ =>
      _$b4955da361c94eee92d63871cce214d8Jajp(p1: _p1);
  @override
  _$dab7e2f2b0304220908311920eb82435Jajp get of =>
      _$dab7e2f2b0304220908311920eb82435Jajp(p1: _p1);
  @override
  _$9be4b831af634880a6f09f8ba7329642Jajp get and =>
      _$9be4b831af634880a6f09f8ba7329642Jajp(p1: _p1);
  @override
  _$7334128089784c76b7a4d384becf862eJajp get or =>
      _$7334128089784c76b7a4d384becf862eJajp(p1: _p1);
  @override
  String get hasBeenCompleted => "${_p1}が完了しました。";
  @override
  String get haveBeenCompleted => "${_p1}が完了しました。";
  @override
  String get hasBeenSuccessful => "${_p1}に成功しました。";
  @override
  String get haveBeenSuccessful => "${_p1}に成功しました。";
  @override
  String get hasFailed => "${_p1}に失敗しました。";
  @override
  String get haveFailed => "${_p1}に失敗しました。";
}

abstract class _$310bd525f89b4731ba62a5ea70175400Base {
  const _$310bd525f89b4731ba62a5ea70175400Base({Object? p1}) : _p1 = p1;

  final Object? _p1;

  String $(Object? _p2) => throw UnimplementedError();
}

class _$310bd525f89b4731ba62a5ea70175400Enus
    extends _$310bd525f89b4731ba62a5ea70175400Base {
  const _$310bd525f89b4731ba62a5ea70175400Enus({super.p1});

  @override
  String $(Object? _p2) => "${_p1} on ${_p2}";
}

class _$310bd525f89b4731ba62a5ea70175400Jajp
    extends _$310bd525f89b4731ba62a5ea70175400Base {
  const _$310bd525f89b4731ba62a5ea70175400Jajp({super.p1});

  @override
  String $(Object? _p2) => "${_p2}上の${_p1}";
}

abstract class _$b4955da361c94eee92d63871cce214d8Base {
  const _$b4955da361c94eee92d63871cce214d8Base({Object? p1}) : _p1 = p1;

  final Object? _p1;

  String $(Object? _p2) => throw UnimplementedError();
}

class _$b4955da361c94eee92d63871cce214d8Enus
    extends _$b4955da361c94eee92d63871cce214d8Base {
  const _$b4955da361c94eee92d63871cce214d8Enus({super.p1});

  @override
  String $(Object? _p2) => "${_p1} in ${_p2}";
}

class _$b4955da361c94eee92d63871cce214d8Jajp
    extends _$b4955da361c94eee92d63871cce214d8Base {
  const _$b4955da361c94eee92d63871cce214d8Jajp({super.p1});

  @override
  String $(Object? _p2) => "${_p2}中の${_p1}";
}

abstract class _$dab7e2f2b0304220908311920eb82435Base {
  const _$dab7e2f2b0304220908311920eb82435Base({Object? p1}) : _p1 = p1;

  final Object? _p1;

  String $(Object? _p2) => throw UnimplementedError();
}

class _$dab7e2f2b0304220908311920eb82435Enus
    extends _$dab7e2f2b0304220908311920eb82435Base {
  const _$dab7e2f2b0304220908311920eb82435Enus({super.p1});

  @override
  String $(Object? _p2) => "${_p1} of ${_p2}";
}

class _$dab7e2f2b0304220908311920eb82435Jajp
    extends _$dab7e2f2b0304220908311920eb82435Base {
  const _$dab7e2f2b0304220908311920eb82435Jajp({super.p1});

  @override
  String $(Object? _p2) => "${_p2}の${_p1}";
}

abstract class _$9be4b831af634880a6f09f8ba7329642Base {
  const _$9be4b831af634880a6f09f8ba7329642Base({Object? p1}) : _p1 = p1;

  final Object? _p1;

  String $(Object? _p2) => throw UnimplementedError();
}

class _$9be4b831af634880a6f09f8ba7329642Enus
    extends _$9be4b831af634880a6f09f8ba7329642Base {
  const _$9be4b831af634880a6f09f8ba7329642Enus({super.p1});

  @override
  String $(Object? _p2) => "${_p1} and ${_p2}";
}

class _$9be4b831af634880a6f09f8ba7329642Jajp
    extends _$9be4b831af634880a6f09f8ba7329642Base {
  const _$9be4b831af634880a6f09f8ba7329642Jajp({super.p1});

  @override
  String $(Object? _p2) => "${_p2}と${_p1}";
}

abstract class _$7334128089784c76b7a4d384becf862eBase {
  const _$7334128089784c76b7a4d384becf862eBase({Object? p1}) : _p1 = p1;

  final Object? _p1;

  String $(Object? _p2) => throw UnimplementedError();
}

class _$7334128089784c76b7a4d384becf862eEnus
    extends _$7334128089784c76b7a4d384becf862eBase {
  const _$7334128089784c76b7a4d384becf862eEnus({super.p1});

  @override
  String $(Object? _p2) => "${_p1} or ${_p2}";
}

class _$7334128089784c76b7a4d384becf862eJajp
    extends _$7334128089784c76b7a4d384becf862eBase {
  const _$7334128089784c76b7a4d384becf862eJajp({super.p1});

  @override
  String $(Object? _p2) => "${_p2}または${_p1}";
}
