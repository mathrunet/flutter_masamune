// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps

part of 'main.dart';

// **************************************************************************
// GoogleSpreadSheetLocalizeGenerator
// **************************************************************************

abstract class _$AppLocalize extends AppLocalizeBase {
  @override
  List<LocalizationsDelegate> delegates(
      [List<LocalizationsDelegate> delegates =
          GlobalMaterialLocalizations.delegates]) {
    return [
      const _$AppLocalizeDelegate(),
      ...delegates,
    ];
  }

  @override
  List<Locale> supportedLocales() {
    return _$appLocalizeLocalizations.keys.toList();
  }

  _$AppLocalizeBase call([BuildContext? context]) {
    final l = context != null ? Localizations.localeOf(context) : locale;
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
  String get decision => throw UnimplementedError();
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
  String get register => throw UnimplementedError();
  String get save => throw UnimplementedError();
  String get data => throw UnimplementedError();
  String get add => throw UnimplementedError();
  String get edit => throw UnimplementedError();
  String get remove => throw UnimplementedError();
  String get delete => throw UnimplementedError();
  String get user => throw UnimplementedError();
  String get content => throw UnimplementedError();
  String get member => throw UnimplementedError();
  String get account => throw UnimplementedError();
  String get message => throw UnimplementedError();
  String get login => throw UnimplementedError();
  String get logout => throw UnimplementedError();
  String get id => throw UnimplementedError();
  String get password => throw UnimplementedError();
  _$a4ee6521902b45c58cf3feff69dd35e0Base $(Object? _p1) =>
      throw UnimplementedError();
  String get english => throw UnimplementedError();
  String get japanese => throw UnimplementedError();
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
  String get decision => "Decision";
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
  String get register => "Register";
  @override
  String get save => "Save";
  @override
  String get data => "Data";
  @override
  String get add => "Add";
  @override
  String get edit => "Edit";
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
  String get message => "Message";
  @override
  String get login => "Login";
  @override
  String get logout => "Logout";
  @override
  String get id => "ID";
  @override
  String get password => "Password";
  @override
  _$a4ee6521902b45c58cf3feff69dd35e0Enus $(Object? _p1) =>
      _$a4ee6521902b45c58cf3feff69dd35e0Enus(p1: _p1);
  @override
  String get english => "English";
  @override
  String get japanese => "Japanese";
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
  String get decision => "確定";
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
  String get register => "登録";
  @override
  String get save => "保存";
  @override
  String get data => "データ";
  @override
  String get add => "追加";
  @override
  String get edit => "編集";
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
  String get message => "メッセージ";
  @override
  String get login => "ログイン";
  @override
  String get logout => "ログアウト";
  @override
  String get id => "ID";
  @override
  String get password => "パスワード";
  @override
  _$a4ee6521902b45c58cf3feff69dd35e0Jajp $(Object? _p1) =>
      _$a4ee6521902b45c58cf3feff69dd35e0Jajp(p1: _p1);
  @override
  String get english => "英語";
  @override
  String get japanese => "日本語";
}

abstract class _$a4ee6521902b45c58cf3feff69dd35e0Base {
  const _$a4ee6521902b45c58cf3feff69dd35e0Base({Object? p1}) : _p1 = p1;

  final Object? _p1;

  String $(Object? _p2) => throw UnimplementedError();
  _$ef2e0f8463f74a3498fd304e8750f3aaBase get on => throw UnimplementedError();
  _$b32a73c3268e47faad0e99be239e85e8Base get in_ => throw UnimplementedError();
  _$1229daeef0c54b52be5e6eca93194fe1Base get of => throw UnimplementedError();
  _$3e4e6a5b872449edaccc3045be9c735dBase get and => throw UnimplementedError();
  _$f02b1d258a824c72817f79de07881d96Base get or => throw UnimplementedError();
  String get hasBeenCompleted => throw UnimplementedError();
  String get haveBeenCompleted => throw UnimplementedError();
  String get hasBeenSuccessful => throw UnimplementedError();
  String get haveBeenSuccessful => throw UnimplementedError();
  String get hasFailed => throw UnimplementedError();
  String get haveFailed => throw UnimplementedError();
  String get isNotEntered => throw UnimplementedError();
  String get mayBeIncorrect => throw UnimplementedError();
}

class _$a4ee6521902b45c58cf3feff69dd35e0Enus
    extends _$a4ee6521902b45c58cf3feff69dd35e0Base {
  const _$a4ee6521902b45c58cf3feff69dd35e0Enus({super.p1});

  @override
  String $(Object? _p2) => "${_p1} ${_p2}";
  @override
  _$ef2e0f8463f74a3498fd304e8750f3aaEnus get on =>
      _$ef2e0f8463f74a3498fd304e8750f3aaEnus(p1: _p1);
  @override
  _$b32a73c3268e47faad0e99be239e85e8Enus get in_ =>
      _$b32a73c3268e47faad0e99be239e85e8Enus(p1: _p1);
  @override
  _$1229daeef0c54b52be5e6eca93194fe1Enus get of =>
      _$1229daeef0c54b52be5e6eca93194fe1Enus(p1: _p1);
  @override
  _$3e4e6a5b872449edaccc3045be9c735dEnus get and =>
      _$3e4e6a5b872449edaccc3045be9c735dEnus(p1: _p1);
  @override
  _$f02b1d258a824c72817f79de07881d96Enus get or =>
      _$f02b1d258a824c72817f79de07881d96Enus(p1: _p1);
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
  @override
  String get isNotEntered => "${_p1} is not entered.";
  @override
  String get mayBeIncorrect => "${_p1} may be incorrect.";
}

class _$a4ee6521902b45c58cf3feff69dd35e0Jajp
    extends _$a4ee6521902b45c58cf3feff69dd35e0Base {
  const _$a4ee6521902b45c58cf3feff69dd35e0Jajp({super.p1});

  @override
  String $(Object? _p2) => "${_p2}${_p1}";
  @override
  _$ef2e0f8463f74a3498fd304e8750f3aaJajp get on =>
      _$ef2e0f8463f74a3498fd304e8750f3aaJajp(p1: _p1);
  @override
  _$b32a73c3268e47faad0e99be239e85e8Jajp get in_ =>
      _$b32a73c3268e47faad0e99be239e85e8Jajp(p1: _p1);
  @override
  _$1229daeef0c54b52be5e6eca93194fe1Jajp get of =>
      _$1229daeef0c54b52be5e6eca93194fe1Jajp(p1: _p1);
  @override
  _$3e4e6a5b872449edaccc3045be9c735dJajp get and =>
      _$3e4e6a5b872449edaccc3045be9c735dJajp(p1: _p1);
  @override
  _$f02b1d258a824c72817f79de07881d96Jajp get or =>
      _$f02b1d258a824c72817f79de07881d96Jajp(p1: _p1);
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
  @override
  String get isNotEntered => "${_p1}が入力されていません。";
  @override
  String get mayBeIncorrect => "${_p1}が間違っている可能性があります。";
}

abstract class _$ef2e0f8463f74a3498fd304e8750f3aaBase {
  const _$ef2e0f8463f74a3498fd304e8750f3aaBase({Object? p1}) : _p1 = p1;

  final Object? _p1;

  String $(Object? _p2) => throw UnimplementedError();
}

class _$ef2e0f8463f74a3498fd304e8750f3aaEnus
    extends _$ef2e0f8463f74a3498fd304e8750f3aaBase {
  const _$ef2e0f8463f74a3498fd304e8750f3aaEnus({super.p1});

  @override
  String $(Object? _p2) => "${_p1} on ${_p2}";
}

class _$ef2e0f8463f74a3498fd304e8750f3aaJajp
    extends _$ef2e0f8463f74a3498fd304e8750f3aaBase {
  const _$ef2e0f8463f74a3498fd304e8750f3aaJajp({super.p1});

  @override
  String $(Object? _p2) => "${_p2}上の${_p1}";
}

abstract class _$b32a73c3268e47faad0e99be239e85e8Base {
  const _$b32a73c3268e47faad0e99be239e85e8Base({Object? p1}) : _p1 = p1;

  final Object? _p1;

  String $(Object? _p2) => throw UnimplementedError();
}

class _$b32a73c3268e47faad0e99be239e85e8Enus
    extends _$b32a73c3268e47faad0e99be239e85e8Base {
  const _$b32a73c3268e47faad0e99be239e85e8Enus({super.p1});

  @override
  String $(Object? _p2) => "${_p1} in ${_p2}";
}

class _$b32a73c3268e47faad0e99be239e85e8Jajp
    extends _$b32a73c3268e47faad0e99be239e85e8Base {
  const _$b32a73c3268e47faad0e99be239e85e8Jajp({super.p1});

  @override
  String $(Object? _p2) => "${_p2}中の${_p1}";
}

abstract class _$1229daeef0c54b52be5e6eca93194fe1Base {
  const _$1229daeef0c54b52be5e6eca93194fe1Base({Object? p1}) : _p1 = p1;

  final Object? _p1;

  String $(Object? _p2) => throw UnimplementedError();
}

class _$1229daeef0c54b52be5e6eca93194fe1Enus
    extends _$1229daeef0c54b52be5e6eca93194fe1Base {
  const _$1229daeef0c54b52be5e6eca93194fe1Enus({super.p1});

  @override
  String $(Object? _p2) => "${_p1} of ${_p2}";
}

class _$1229daeef0c54b52be5e6eca93194fe1Jajp
    extends _$1229daeef0c54b52be5e6eca93194fe1Base {
  const _$1229daeef0c54b52be5e6eca93194fe1Jajp({super.p1});

  @override
  String $(Object? _p2) => "${_p2}の${_p1}";
}

abstract class _$3e4e6a5b872449edaccc3045be9c735dBase {
  const _$3e4e6a5b872449edaccc3045be9c735dBase({Object? p1}) : _p1 = p1;

  final Object? _p1;

  String $(Object? _p2) => throw UnimplementedError();
}

class _$3e4e6a5b872449edaccc3045be9c735dEnus
    extends _$3e4e6a5b872449edaccc3045be9c735dBase {
  const _$3e4e6a5b872449edaccc3045be9c735dEnus({super.p1});

  @override
  String $(Object? _p2) => "${_p1} and ${_p2}";
}

class _$3e4e6a5b872449edaccc3045be9c735dJajp
    extends _$3e4e6a5b872449edaccc3045be9c735dBase {
  const _$3e4e6a5b872449edaccc3045be9c735dJajp({super.p1});

  @override
  String $(Object? _p2) => "${_p2}と${_p1}";
}

abstract class _$f02b1d258a824c72817f79de07881d96Base {
  const _$f02b1d258a824c72817f79de07881d96Base({Object? p1}) : _p1 = p1;

  final Object? _p1;

  String $(Object? _p2) => throw UnimplementedError();
}

class _$f02b1d258a824c72817f79de07881d96Enus
    extends _$f02b1d258a824c72817f79de07881d96Base {
  const _$f02b1d258a824c72817f79de07881d96Enus({super.p1});

  @override
  String $(Object? _p2) => "${_p1} or ${_p2}";
}

class _$f02b1d258a824c72817f79de07881d96Jajp
    extends _$f02b1d258a824c72817f79de07881d96Base {
  const _$f02b1d258a824c72817f79de07881d96Jajp({super.p1});

  @override
  String $(Object? _p2) => "${_p2}または${_p1}";
}
