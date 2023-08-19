// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps

part of 'main.dart';

// **************************************************************************
// GoogleSpreadSheetLocalizeGenerator
// **************************************************************************

abstract class _$AppLocalize extends AppLocalizeBase {
  @override
  List<LocalizationsDelegate> delegates(
      [List<LocalizationsDelegate> delegates = const []]) {
    final supportDelegates = <LocalizationsDelegate>[];
    for (final d in delegates) {
      if (supportDelegates.any((element) => element.type == d.type)) {
        continue;
      }
      supportDelegates.add(d);
    }
    for (final d in AppLocalizationSettings.delegates) {
      if (supportDelegates.any((element) => element.type == d.type)) {
        continue;
      }
      supportDelegates.add(d);
    }
    return supportDelegates;
  }

  @override
  List<Locale> supportedLocales() {
    return _$appLocalizeLocalizations.keys.toList();
  }

  _$AppLocalizeBase call([BuildContext? context]) {
    final l = context != null ? Localizations.localeOf(context) : locale;
    return get(l);
  }

  _$AppLocalizeBase get(Locale locale) {
    var res = _$appLocalizeLocalizations.entries
        .firstWhereOrNull((e) => e.key == locale);
    if (res != null) {
      return res.value;
    }
    res = _$appLocalizeLocalizations.entries
        .firstWhereOrNull((e) => e.key.languageCode == locale.languageCode);
    if (res != null) {
      return res.value;
    }
    return _$appLocalizeLocalizations.values.first;
  }
}

final _$appLocalizeLocalizations = {
  Locale("en", "US"): _$AppLocalizeEnus(),
  Locale("ja", "JP"): _$AppLocalizeJajp()
};

abstract class _$AppLocalizeBase {
  const _$AppLocalizeBase();

  String get appTitle => throw UnimplementedError();
  String get subTitle => throw UnimplementedError();
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
  String get none => throw UnimplementedError();
  String get success => throw UnimplementedError();
  String get error => throw UnimplementedError();
  String get warning => throw UnimplementedError();
  String get notice => throw UnimplementedError();
  String get confirm => throw UnimplementedError();
  String get decision => throw UnimplementedError();
  String get cancel => throw UnimplementedError();
  String get confirmation => throw UnimplementedError();
  String get refresh => throw UnimplementedError();
  String get update => throw UnimplementedError();
  String get change => throw UnimplementedError();
  String get send => throw UnimplementedError();
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
  String get create => throw UnimplementedError();
  String get register => throw UnimplementedError();
  String get save => throw UnimplementedError();
  String get data => throw UnimplementedError();
  String get fetch => throw UnimplementedError();
  String get add => throw UnimplementedError();
  String get edit => throw UnimplementedError();
  String get remove => throw UnimplementedError();
  String get delete => throw UnimplementedError();
  String get join => throw UnimplementedError();
  String get manage => throw UnimplementedError();
  String get management => throw UnimplementedError();
  String get search => throw UnimplementedError();
  String get article => throw UnimplementedError();
  String get report => throw UnimplementedError();
  String get user => throw UnimplementedError();
  String get content => throw UnimplementedError();
  String get member => throw UnimplementedError();
  String get message => throw UnimplementedError();
  String get text => throw UnimplementedError();
  String get comment => throw UnimplementedError();
  String get icon => throw UnimplementedError();
  String get share => throw UnimplementedError();
  String get tag => throw UnimplementedError();
  String get tags => throw UnimplementedError();
  String get category => throw UnimplementedError();
  String get block => throw UnimplementedError();
  String get unchangeable => throw UnimplementedError();
  String get seeMore => throw UnimplementedError();
  String get latest => throw UnimplementedError();
  String get menu => throw UnimplementedError();
  String get home => throw UnimplementedError();
  String get contact => throw UnimplementedError();
  String get calendar => throw UnimplementedError();
  String get profile => throw UnimplementedError();
  String get mypage => throw UnimplementedError();
  String get account => throw UnimplementedError();
  String get login => throw UnimplementedError();
  String get logout => throw UnimplementedError();
  String get id => throw UnimplementedError();
  String get name => throw UnimplementedError();
  String get nickname => throw UnimplementedError();
  String get guest => throw UnimplementedError();
  String get gender => throw UnimplementedError();
  String get male => throw UnimplementedError();
  String get female => throw UnimplementedError();
  String get address => throw UnimplementedError();
  String get age => throw UnimplementedError();
  String get birthday => throw UnimplementedError();
  String get work => throw UnimplementedError();
  String get phoneNumber => throw UnimplementedError();
  String get email => throw UnimplementedError();
  String get password => throw UnimplementedError();
  String get confirmPassword => throw UnimplementedError();
  String get resetPassword => throw UnimplementedError();
  String get forgotYourPassword => throw UnimplementedError();
  String get reauthentication => throw UnimplementedError();
  _$e45975972292dd2cace745efd3b9606d0d570babBase get signInWith =>
      throw UnimplementedError();
  String get pleaseReEnterYourPasswordToReAuthenticate =>
      throw UnimplementedError();
  String get sendEmail => throw UnimplementedError();
  String get sendCode => throw UnimplementedError();
  String get enterThe6DigitCodeFromTheSMS => throw UnimplementedError();
  String get youWillLogOutAreYouOK => throw UnimplementedError();
  String
      get passwordResetEmailHasBeenSentToYouPleaseUseTheLinkInTheEmailToSetANewPassword =>
          throw UnimplementedError();
  String get pleaseTryAgain => throw UnimplementedError();
  String get couldNotLoginPleaseCheckYourLoginInformationAgain =>
      throw UnimplementedError();
  _$ee3cdde455f5dd463564a735df43c1a8f5dad3b8Base
      get initializationFailedExitTheApplication => throw UnimplementedError();
  _$a1dd18c1c4364639c09234f7ad8df55d6c7a6328Base $(Object? _p1) =>
      throw UnimplementedError();
  _$b44b04c9b27cca846b55b5015c24d2fe11b4ad27Base get pleaseEnter =>
      throw UnimplementedError();
  _$6adf8b0c22ee4670d3ed659c0600bd8968824bfdBase get youWillDelete =>
      throw UnimplementedError();
  _$8a438be392348d81ac50aaadb1da949eef9c3934Base get wouldYouLikeToReport =>
      throw UnimplementedError();
  _$829e6374acf4ab691be4fc6ce556e2576add22e7Base get upTo =>
      throw UnimplementedError();
  _$67f61375c8b62f901352632a07aded48a57ff85fBase get backTo =>
      throw UnimplementedError();
  _$20fad005e0b3bb9dde825fc81961b62b2c73efd2Base get goTo =>
      throw UnimplementedError();
  String get english => throw UnimplementedError();
  String get japanese => throw UnimplementedError();
  String get year => throw UnimplementedError();
  String get years => throw UnimplementedError();
  String get month => throw UnimplementedError();
  String get months => throw UnimplementedError();
  String get day => throw UnimplementedError();
  String get days => throw UnimplementedError();
  String get week => throw UnimplementedError();
  String get weeks => throw UnimplementedError();
  String get hour => throw UnimplementedError();
  String get hours => throw UnimplementedError();
  String get minute => throw UnimplementedError();
  String get minutes => throw UnimplementedError();
  String get second => throw UnimplementedError();
  String get seconds => throw UnimplementedError();
  String get google => throw UnimplementedError();
  String get apple => throw UnimplementedError();
  String get facebook => throw UnimplementedError();
  String get amazon => throw UnimplementedError();
  String get mathruNet => throw UnimplementedError();
  _$00d0796f61e7ee7614446fbc3f31ae7dbab192adBase get thereAre =>
      throw UnimplementedError();
  String get copyToClipboard => throw UnimplementedError();
}

class _$AppLocalizeEnus extends _$AppLocalizeBase {
  const _$AppLocalizeEnus();

  @override
  String get appTitle => "AppTitle";
  @override
  String get subTitle => "SubTitle";
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
  String get none => "None";
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
  String get update => "Update";
  @override
  String get change => "Change";
  @override
  String get send => "Send";
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
  String get create => "Create";
  @override
  String get register => "Register";
  @override
  String get save => "Save";
  @override
  String get data => "Data";
  @override
  String get fetch => "Fetch";
  @override
  String get add => "Add";
  @override
  String get edit => "Edit";
  @override
  String get remove => "Remove";
  @override
  String get delete => "Delete";
  @override
  String get join => "Join";
  @override
  String get manage => "Manage";
  @override
  String get management => "Management";
  @override
  String get search => "Search";
  @override
  String get article => "Article";
  @override
  String get report => "Report";
  @override
  String get user => "User";
  @override
  String get content => "Content";
  @override
  String get member => "Member";
  @override
  String get message => "Message";
  @override
  String get text => "Text";
  @override
  String get comment => "Comment";
  @override
  String get icon => "Icon";
  @override
  String get share => "Share";
  @override
  String get tag => "Tag";
  @override
  String get tags => "Tags";
  @override
  String get category => "Category";
  @override
  String get block => "Block";
  @override
  String get unchangeable => "Unchangeable";
  @override
  String get seeMore => "See more";
  @override
  String get latest => "Latest";
  @override
  String get menu => "Menu";
  @override
  String get home => "Home";
  @override
  String get contact => "Contact";
  @override
  String get calendar => "Calendar";
  @override
  String get profile => "Profile";
  @override
  String get mypage => "Mypage";
  @override
  String get account => "Account";
  @override
  String get login => "Login";
  @override
  String get logout => "Logout";
  @override
  String get id => "ID";
  @override
  String get name => "Name";
  @override
  String get nickname => "Nickname";
  @override
  String get guest => "Guest";
  @override
  String get gender => "Gender";
  @override
  String get male => "Male";
  @override
  String get female => "Female";
  @override
  String get address => "Address";
  @override
  String get age => "Age";
  @override
  String get birthday => "Birthday";
  @override
  String get work => "Work";
  @override
  String get phoneNumber => "Phone number";
  @override
  String get email => "Email";
  @override
  String get password => "Password";
  @override
  String get confirmPassword => "Confirm password";
  @override
  String get resetPassword => "Reset password";
  @override
  String get forgotYourPassword => "Forgot your password?";
  @override
  String get reauthentication => "Reauthentication";
  @override
  _$e45975972292dd2cace745efd3b9606d0d570babEnus get signInWith =>
      _$e45975972292dd2cace745efd3b9606d0d570babEnus();
  @override
  String get pleaseReEnterYourPasswordToReAuthenticate =>
      "Please re-enter your password to re-authenticate.";
  @override
  String get sendEmail => "Send email";
  @override
  String get sendCode => "Send code";
  @override
  String get enterThe6DigitCodeFromTheSMS =>
      "Enter the 6-digit code from the SMS.";
  @override
  String get youWillLogOutAreYouOK => "You will log out.\n\nAre you OK?";
  @override
  String get passwordResetEmailHasBeenSentToYouPleaseUseTheLinkInTheEmailToSetANewPassword =>
      "Password reset email has been sent to you.\n\nPlease use the link in the email to set a new password.";
  @override
  String get pleaseTryAgain => "Please try again.";
  @override
  String get couldNotLoginPleaseCheckYourLoginInformationAgain =>
      "Could not login. Please check your login information again.";
  @override
  _$ee3cdde455f5dd463564a735df43c1a8f5dad3b8Enus
      get initializationFailedExitTheApplication =>
          _$ee3cdde455f5dd463564a735df43c1a8f5dad3b8Enus();
  @override
  _$a1dd18c1c4364639c09234f7ad8df55d6c7a6328Enus $(Object? _p1) =>
      _$a1dd18c1c4364639c09234f7ad8df55d6c7a6328Enus(p1: _p1);
  @override
  _$b44b04c9b27cca846b55b5015c24d2fe11b4ad27Enus get pleaseEnter =>
      _$b44b04c9b27cca846b55b5015c24d2fe11b4ad27Enus();
  @override
  _$6adf8b0c22ee4670d3ed659c0600bd8968824bfdEnus get youWillDelete =>
      _$6adf8b0c22ee4670d3ed659c0600bd8968824bfdEnus();
  @override
  _$8a438be392348d81ac50aaadb1da949eef9c3934Enus get wouldYouLikeToReport =>
      _$8a438be392348d81ac50aaadb1da949eef9c3934Enus();
  @override
  _$829e6374acf4ab691be4fc6ce556e2576add22e7Enus get upTo =>
      _$829e6374acf4ab691be4fc6ce556e2576add22e7Enus();
  @override
  _$67f61375c8b62f901352632a07aded48a57ff85fEnus get backTo =>
      _$67f61375c8b62f901352632a07aded48a57ff85fEnus();
  @override
  _$20fad005e0b3bb9dde825fc81961b62b2c73efd2Enus get goTo =>
      _$20fad005e0b3bb9dde825fc81961b62b2c73efd2Enus();
  @override
  String get english => "English";
  @override
  String get japanese => "Japanese";
  @override
  String get year => "year";
  @override
  String get years => "years";
  @override
  String get month => "month";
  @override
  String get months => "months";
  @override
  String get day => "day";
  @override
  String get days => "days";
  @override
  String get week => "week";
  @override
  String get weeks => "weeks";
  @override
  String get hour => "hour";
  @override
  String get hours => "hours";
  @override
  String get minute => "minute";
  @override
  String get minutes => "minutes";
  @override
  String get second => "second";
  @override
  String get seconds => "seconds";
  @override
  String get google => "Google";
  @override
  String get apple => "Apple";
  @override
  String get facebook => "Facebook";
  @override
  String get amazon => "Amazon";
  @override
  String get mathruNet => "mathru.net";
  @override
  _$00d0796f61e7ee7614446fbc3f31ae7dbab192adEnus get thereAre =>
      _$00d0796f61e7ee7614446fbc3f31ae7dbab192adEnus();
  @override
  String get copyToClipboard => "Copy to clipboard";
}

class _$AppLocalizeJajp extends _$AppLocalizeBase {
  const _$AppLocalizeJajp();

  @override
  String get appTitle => "アプリタイトル";
  @override
  String get subTitle => "サブタイトル";
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
  String get none => "なし";
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
  String get update => "更新";
  @override
  String get change => "変更";
  @override
  String get send => "送信";
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
  String get create => "作成";
  @override
  String get register => "登録";
  @override
  String get save => "保存";
  @override
  String get data => "データ";
  @override
  String get fetch => "取得";
  @override
  String get add => "追加";
  @override
  String get edit => "編集";
  @override
  String get remove => "削除";
  @override
  String get delete => "削除";
  @override
  String get join => "参加";
  @override
  String get manage => "管理";
  @override
  String get management => "管理";
  @override
  String get search => "検索";
  @override
  String get article => "記事";
  @override
  String get report => "通報";
  @override
  String get user => "ユーザー";
  @override
  String get content => "コンテンツ";
  @override
  String get member => "メンバー";
  @override
  String get message => "メッセージ";
  @override
  String get text => "テキスト";
  @override
  String get comment => "コメント";
  @override
  String get icon => "アイコン";
  @override
  String get share => "シェア";
  @override
  String get tag => "タグ";
  @override
  String get tags => "タグ";
  @override
  String get category => "カテゴリー";
  @override
  String get block => "ブロック";
  @override
  String get unchangeable => "変更不可";
  @override
  String get seeMore => "もっと見る";
  @override
  String get latest => "最新";
  @override
  String get menu => "メニュー";
  @override
  String get home => "ホーム";
  @override
  String get contact => "お問い合わせ";
  @override
  String get calendar => "カレンダー";
  @override
  String get profile => "プロフィール";
  @override
  String get mypage => "マイページ";
  @override
  String get account => "アカウント";
  @override
  String get login => "ログイン";
  @override
  String get logout => "ログアウト";
  @override
  String get id => "ID";
  @override
  String get name => "名前";
  @override
  String get nickname => "ニックネーム";
  @override
  String get guest => "ゲスト";
  @override
  String get gender => "性別";
  @override
  String get male => "男性";
  @override
  String get female => "女性";
  @override
  String get address => "住所";
  @override
  String get age => "年齢";
  @override
  String get birthday => "生年月日";
  @override
  String get work => "職業";
  @override
  String get phoneNumber => "電話番号";
  @override
  String get email => "メールアドレス";
  @override
  String get password => "パスワード";
  @override
  String get confirmPassword => "パスワードの確認";
  @override
  String get resetPassword => "パスワードリセット";
  @override
  String get forgotYourPassword => "パスワードを忘れた方はこちら";
  @override
  String get reauthentication => "再認証";
  @override
  _$e45975972292dd2cace745efd3b9606d0d570babJajp get signInWith =>
      _$e45975972292dd2cace745efd3b9606d0d570babJajp();
  @override
  String get pleaseReEnterYourPasswordToReAuthenticate =>
      "パスワードを再度入力して再認証をしてください。";
  @override
  String get sendEmail => "メールを送信";
  @override
  String get sendCode => "コードを送信";
  @override
  String get enterThe6DigitCodeFromTheSMS => "SMSに記載されている6桁のコードを入力してください。";
  @override
  String get youWillLogOutAreYouOK => "ログアウトします。\n\nよろしいですか？";
  @override
  String
      get passwordResetEmailHasBeenSentToYouPleaseUseTheLinkInTheEmailToSetANewPassword =>
          "パスワードリセットメールを送信しました。\n\nメール中に記載されているリンクから新しいパスワードを設定してください。";
  @override
  String get pleaseTryAgain => "もう一度お試しください。";
  @override
  String get couldNotLoginPleaseCheckYourLoginInformationAgain =>
      "ログインできませんでした。ログイン情報を再度ご確認ください。";
  @override
  _$ee3cdde455f5dd463564a735df43c1a8f5dad3b8Jajp
      get initializationFailedExitTheApplication =>
          _$ee3cdde455f5dd463564a735df43c1a8f5dad3b8Jajp();
  @override
  _$a1dd18c1c4364639c09234f7ad8df55d6c7a6328Jajp $(Object? _p1) =>
      _$a1dd18c1c4364639c09234f7ad8df55d6c7a6328Jajp(p1: _p1);
  @override
  _$b44b04c9b27cca846b55b5015c24d2fe11b4ad27Jajp get pleaseEnter =>
      _$b44b04c9b27cca846b55b5015c24d2fe11b4ad27Jajp();
  @override
  _$6adf8b0c22ee4670d3ed659c0600bd8968824bfdJajp get youWillDelete =>
      _$6adf8b0c22ee4670d3ed659c0600bd8968824bfdJajp();
  @override
  _$8a438be392348d81ac50aaadb1da949eef9c3934Jajp get wouldYouLikeToReport =>
      _$8a438be392348d81ac50aaadb1da949eef9c3934Jajp();
  @override
  _$829e6374acf4ab691be4fc6ce556e2576add22e7Jajp get upTo =>
      _$829e6374acf4ab691be4fc6ce556e2576add22e7Jajp();
  @override
  _$67f61375c8b62f901352632a07aded48a57ff85fJajp get backTo =>
      _$67f61375c8b62f901352632a07aded48a57ff85fJajp();
  @override
  _$20fad005e0b3bb9dde825fc81961b62b2c73efd2Jajp get goTo =>
      _$20fad005e0b3bb9dde825fc81961b62b2c73efd2Jajp();
  @override
  String get english => "英語";
  @override
  String get japanese => "日本語";
  @override
  String get year => "年";
  @override
  String get years => "年";
  @override
  String get month => "月";
  @override
  String get months => "月";
  @override
  String get day => "日";
  @override
  String get days => "日";
  @override
  String get week => "週";
  @override
  String get weeks => "週";
  @override
  String get hour => "時";
  @override
  String get hours => "時";
  @override
  String get minute => "分";
  @override
  String get minutes => "分";
  @override
  String get second => "秒";
  @override
  String get seconds => "秒";
  @override
  String get google => "Google";
  @override
  String get apple => "Apple";
  @override
  String get facebook => "Facebook";
  @override
  String get amazon => "Amazon";
  @override
  String get mathruNet => "mathru.net";
  @override
  _$00d0796f61e7ee7614446fbc3f31ae7dbab192adJajp get thereAre =>
      _$00d0796f61e7ee7614446fbc3f31ae7dbab192adJajp();
  @override
  String get copyToClipboard => "クリップボードにコピー";
}

abstract class _$e45975972292dd2cace745efd3b9606d0d570babBase {
  const _$e45975972292dd2cace745efd3b9606d0d570babBase();

  String $(Object? _p1) => throw UnimplementedError();
}

class _$e45975972292dd2cace745efd3b9606d0d570babEnus
    extends _$e45975972292dd2cace745efd3b9606d0d570babBase {
  const _$e45975972292dd2cace745efd3b9606d0d570babEnus();

  @override
  String $(Object? _p1) => "Sign in with ${_p1}";
}

class _$e45975972292dd2cace745efd3b9606d0d570babJajp
    extends _$e45975972292dd2cace745efd3b9606d0d570babBase {
  const _$e45975972292dd2cace745efd3b9606d0d570babJajp();

  @override
  String $(Object? _p1) => "${_p1}でサインイン";
}

abstract class _$ee3cdde455f5dd463564a735df43c1a8f5dad3b8Base {
  const _$ee3cdde455f5dd463564a735df43c1a8f5dad3b8Base();

  _$cadc55701b4f9552b1fe34fd09932839a799de9bBase $(Object? _p1) =>
      throw UnimplementedError();
}

class _$ee3cdde455f5dd463564a735df43c1a8f5dad3b8Enus
    extends _$ee3cdde455f5dd463564a735df43c1a8f5dad3b8Base {
  const _$ee3cdde455f5dd463564a735df43c1a8f5dad3b8Enus();

  @override
  _$cadc55701b4f9552b1fe34fd09932839a799de9bEnus $(Object? _p1) =>
      _$cadc55701b4f9552b1fe34fd09932839a799de9bEnus(p1: _p1);
}

class _$ee3cdde455f5dd463564a735df43c1a8f5dad3b8Jajp
    extends _$ee3cdde455f5dd463564a735df43c1a8f5dad3b8Base {
  const _$ee3cdde455f5dd463564a735df43c1a8f5dad3b8Jajp();

  @override
  _$cadc55701b4f9552b1fe34fd09932839a799de9bJajp $(Object? _p1) =>
      _$cadc55701b4f9552b1fe34fd09932839a799de9bJajp(p1: _p1);
}

abstract class _$cadc55701b4f9552b1fe34fd09932839a799de9bBase {
  const _$cadc55701b4f9552b1fe34fd09932839a799de9bBase({Object? p1}) : _p1 = p1;

  final Object? _p1;

  String $(Object? _p2) => throw UnimplementedError();
}

class _$cadc55701b4f9552b1fe34fd09932839a799de9bEnus
    extends _$cadc55701b4f9552b1fe34fd09932839a799de9bBase {
  const _$cadc55701b4f9552b1fe34fd09932839a799de9bEnus({super.p1});

  @override
  String $(Object? _p2) =>
      "Initialization failed. Exit the application. \n\n${_p1}\n${_p2}";
}

class _$cadc55701b4f9552b1fe34fd09932839a799de9bJajp
    extends _$cadc55701b4f9552b1fe34fd09932839a799de9bBase {
  const _$cadc55701b4f9552b1fe34fd09932839a799de9bJajp({super.p1});

  @override
  String $(Object? _p2) => "初期化に失敗しました。アプリを終了します。\n\n${_p1}\n${_p2}";
}

abstract class _$a1dd18c1c4364639c09234f7ad8df55d6c7a6328Base {
  const _$a1dd18c1c4364639c09234f7ad8df55d6c7a6328Base({Object? p1}) : _p1 = p1;

  final Object? _p1;

  String $(Object? _p2) => throw UnimplementedError();
  _$597f8738dba99655c0ca9b79249adc5905900579Base get on =>
      throw UnimplementedError();
  _$4fcbb22fb2ccb6326be9df179283c03d805ec200Base get in_ =>
      throw UnimplementedError();
  _$9b6d2d9e6aeea98cebd6d49f0bad35cbb8ddcb98Base get of =>
      throw UnimplementedError();
  _$d8a744834c10acaf98f07597f40b1ce70a17741bBase get and =>
      throw UnimplementedError();
  _$6ecad9b466c3326c4cd3efd2c4d1a27a6c363c35Base get or =>
      throw UnimplementedError();
  String get hasBeenCompleted => throw UnimplementedError();
  String get haveBeenCompleted => throw UnimplementedError();
  String get hasBeenSuccessful => throw UnimplementedError();
  String get haveBeenSuccessful => throw UnimplementedError();
  String get hasFailed => throw UnimplementedError();
  String get haveFailed => throw UnimplementedError();
  String get isNotEntered => throw UnimplementedError();
  String get mayBeIncorrect => throw UnimplementedError();
  String get doesNotMatch => throw UnimplementedError();
  String get year => throw UnimplementedError();
  String get yearsOld => throw UnimplementedError();
  String get month => throw UnimplementedError();
  String get day => throw UnimplementedError();
  String get hour => throw UnimplementedError();
  String get minute => throw UnimplementedError();
  String get second => throw UnimplementedError();
  String get hours => throw UnimplementedError();
  String get minutes => throw UnimplementedError();
  String get seconds => throw UnimplementedError();
}

class _$a1dd18c1c4364639c09234f7ad8df55d6c7a6328Enus
    extends _$a1dd18c1c4364639c09234f7ad8df55d6c7a6328Base {
  const _$a1dd18c1c4364639c09234f7ad8df55d6c7a6328Enus({super.p1});

  @override
  String $(Object? _p2) => "${_p1} ${_p2}";
  @override
  _$597f8738dba99655c0ca9b79249adc5905900579Enus get on =>
      _$597f8738dba99655c0ca9b79249adc5905900579Enus(p1: _p1);
  @override
  _$4fcbb22fb2ccb6326be9df179283c03d805ec200Enus get in_ =>
      _$4fcbb22fb2ccb6326be9df179283c03d805ec200Enus(p1: _p1);
  @override
  _$9b6d2d9e6aeea98cebd6d49f0bad35cbb8ddcb98Enus get of =>
      _$9b6d2d9e6aeea98cebd6d49f0bad35cbb8ddcb98Enus(p1: _p1);
  @override
  _$d8a744834c10acaf98f07597f40b1ce70a17741bEnus get and =>
      _$d8a744834c10acaf98f07597f40b1ce70a17741bEnus(p1: _p1);
  @override
  _$6ecad9b466c3326c4cd3efd2c4d1a27a6c363c35Enus get or =>
      _$6ecad9b466c3326c4cd3efd2c4d1a27a6c363c35Enus(p1: _p1);
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
  @override
  String get doesNotMatch => "${_p1} does not match.";
  @override
  String get year => "${_p1}";
  @override
  String get yearsOld => "${_p1} years old";
  @override
  String get month => "${_p1}";
  @override
  String get day => "${_p1}";
  @override
  String get hour => "${_p1}";
  @override
  String get minute => "${_p1}";
  @override
  String get second => "${_p1}";
  @override
  String get hours => "${_p1} h";
  @override
  String get minutes => "${_p1} m";
  @override
  String get seconds => "${_p1} s";
}

class _$a1dd18c1c4364639c09234f7ad8df55d6c7a6328Jajp
    extends _$a1dd18c1c4364639c09234f7ad8df55d6c7a6328Base {
  const _$a1dd18c1c4364639c09234f7ad8df55d6c7a6328Jajp({super.p1});

  @override
  String $(Object? _p2) => "${_p2}${_p1}";
  @override
  _$597f8738dba99655c0ca9b79249adc5905900579Jajp get on =>
      _$597f8738dba99655c0ca9b79249adc5905900579Jajp(p1: _p1);
  @override
  _$4fcbb22fb2ccb6326be9df179283c03d805ec200Jajp get in_ =>
      _$4fcbb22fb2ccb6326be9df179283c03d805ec200Jajp(p1: _p1);
  @override
  _$9b6d2d9e6aeea98cebd6d49f0bad35cbb8ddcb98Jajp get of =>
      _$9b6d2d9e6aeea98cebd6d49f0bad35cbb8ddcb98Jajp(p1: _p1);
  @override
  _$d8a744834c10acaf98f07597f40b1ce70a17741bJajp get and =>
      _$d8a744834c10acaf98f07597f40b1ce70a17741bJajp(p1: _p1);
  @override
  _$6ecad9b466c3326c4cd3efd2c4d1a27a6c363c35Jajp get or =>
      _$6ecad9b466c3326c4cd3efd2c4d1a27a6c363c35Jajp(p1: _p1);
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
  @override
  String get doesNotMatch => "${_p1}が一致しません。";
  @override
  String get year => "${_p1}年";
  @override
  String get yearsOld => "${_p1}歳";
  @override
  String get month => "${_p1}月";
  @override
  String get day => "${_p1}日";
  @override
  String get hour => "${_p1}時";
  @override
  String get minute => "${_p1}分";
  @override
  String get second => "${_p1}秒";
  @override
  String get hours => "${_p1}時間";
  @override
  String get minutes => "${_p1}分";
  @override
  String get seconds => "${_p1}秒";
}

abstract class _$597f8738dba99655c0ca9b79249adc5905900579Base {
  const _$597f8738dba99655c0ca9b79249adc5905900579Base({Object? p1}) : _p1 = p1;

  final Object? _p1;

  String $(Object? _p2) => throw UnimplementedError();
}

class _$597f8738dba99655c0ca9b79249adc5905900579Enus
    extends _$597f8738dba99655c0ca9b79249adc5905900579Base {
  const _$597f8738dba99655c0ca9b79249adc5905900579Enus({super.p1});

  @override
  String $(Object? _p2) => "${_p1} on ${_p2}";
}

class _$597f8738dba99655c0ca9b79249adc5905900579Jajp
    extends _$597f8738dba99655c0ca9b79249adc5905900579Base {
  const _$597f8738dba99655c0ca9b79249adc5905900579Jajp({super.p1});

  @override
  String $(Object? _p2) => "${_p2}上の${_p1}";
}

abstract class _$4fcbb22fb2ccb6326be9df179283c03d805ec200Base {
  const _$4fcbb22fb2ccb6326be9df179283c03d805ec200Base({Object? p1}) : _p1 = p1;

  final Object? _p1;

  String $(Object? _p2) => throw UnimplementedError();
}

class _$4fcbb22fb2ccb6326be9df179283c03d805ec200Enus
    extends _$4fcbb22fb2ccb6326be9df179283c03d805ec200Base {
  const _$4fcbb22fb2ccb6326be9df179283c03d805ec200Enus({super.p1});

  @override
  String $(Object? _p2) => "${_p1} in ${_p2}";
}

class _$4fcbb22fb2ccb6326be9df179283c03d805ec200Jajp
    extends _$4fcbb22fb2ccb6326be9df179283c03d805ec200Base {
  const _$4fcbb22fb2ccb6326be9df179283c03d805ec200Jajp({super.p1});

  @override
  String $(Object? _p2) => "${_p2}中の${_p1}";
}

abstract class _$9b6d2d9e6aeea98cebd6d49f0bad35cbb8ddcb98Base {
  const _$9b6d2d9e6aeea98cebd6d49f0bad35cbb8ddcb98Base({Object? p1}) : _p1 = p1;

  final Object? _p1;

  String $(Object? _p2) => throw UnimplementedError();
}

class _$9b6d2d9e6aeea98cebd6d49f0bad35cbb8ddcb98Enus
    extends _$9b6d2d9e6aeea98cebd6d49f0bad35cbb8ddcb98Base {
  const _$9b6d2d9e6aeea98cebd6d49f0bad35cbb8ddcb98Enus({super.p1});

  @override
  String $(Object? _p2) => "${_p1} of ${_p2}";
}

class _$9b6d2d9e6aeea98cebd6d49f0bad35cbb8ddcb98Jajp
    extends _$9b6d2d9e6aeea98cebd6d49f0bad35cbb8ddcb98Base {
  const _$9b6d2d9e6aeea98cebd6d49f0bad35cbb8ddcb98Jajp({super.p1});

  @override
  String $(Object? _p2) => "${_p2}の${_p1}";
}

abstract class _$d8a744834c10acaf98f07597f40b1ce70a17741bBase {
  const _$d8a744834c10acaf98f07597f40b1ce70a17741bBase({Object? p1}) : _p1 = p1;

  final Object? _p1;

  String $(Object? _p2) => throw UnimplementedError();
}

class _$d8a744834c10acaf98f07597f40b1ce70a17741bEnus
    extends _$d8a744834c10acaf98f07597f40b1ce70a17741bBase {
  const _$d8a744834c10acaf98f07597f40b1ce70a17741bEnus({super.p1});

  @override
  String $(Object? _p2) => "${_p1} and ${_p2}";
}

class _$d8a744834c10acaf98f07597f40b1ce70a17741bJajp
    extends _$d8a744834c10acaf98f07597f40b1ce70a17741bBase {
  const _$d8a744834c10acaf98f07597f40b1ce70a17741bJajp({super.p1});

  @override
  String $(Object? _p2) => "${_p2}と${_p1}";
}

abstract class _$6ecad9b466c3326c4cd3efd2c4d1a27a6c363c35Base {
  const _$6ecad9b466c3326c4cd3efd2c4d1a27a6c363c35Base({Object? p1}) : _p1 = p1;

  final Object? _p1;

  String $(Object? _p2) => throw UnimplementedError();
}

class _$6ecad9b466c3326c4cd3efd2c4d1a27a6c363c35Enus
    extends _$6ecad9b466c3326c4cd3efd2c4d1a27a6c363c35Base {
  const _$6ecad9b466c3326c4cd3efd2c4d1a27a6c363c35Enus({super.p1});

  @override
  String $(Object? _p2) => "${_p1} or ${_p2}";
}

class _$6ecad9b466c3326c4cd3efd2c4d1a27a6c363c35Jajp
    extends _$6ecad9b466c3326c4cd3efd2c4d1a27a6c363c35Base {
  const _$6ecad9b466c3326c4cd3efd2c4d1a27a6c363c35Jajp({super.p1});

  @override
  String $(Object? _p2) => "${_p2}または${_p1}";
}

abstract class _$b44b04c9b27cca846b55b5015c24d2fe11b4ad27Base {
  const _$b44b04c9b27cca846b55b5015c24d2fe11b4ad27Base();

  String $(Object? _p1) => throw UnimplementedError();
}

class _$b44b04c9b27cca846b55b5015c24d2fe11b4ad27Enus
    extends _$b44b04c9b27cca846b55b5015c24d2fe11b4ad27Base {
  const _$b44b04c9b27cca846b55b5015c24d2fe11b4ad27Enus();

  @override
  String $(Object? _p1) => "Please enter ${_p1}.";
}

class _$b44b04c9b27cca846b55b5015c24d2fe11b4ad27Jajp
    extends _$b44b04c9b27cca846b55b5015c24d2fe11b4ad27Base {
  const _$b44b04c9b27cca846b55b5015c24d2fe11b4ad27Jajp();

  @override
  String $(Object? _p1) => "${_p1}を入力してください。";
}

abstract class _$6adf8b0c22ee4670d3ed659c0600bd8968824bfdBase {
  const _$6adf8b0c22ee4670d3ed659c0600bd8968824bfdBase();

  _$eb1f6ed39a9fc007b0c0c10cdaf9a1ee3caf9551Base $(Object? _p1) =>
      throw UnimplementedError();
}

class _$6adf8b0c22ee4670d3ed659c0600bd8968824bfdEnus
    extends _$6adf8b0c22ee4670d3ed659c0600bd8968824bfdBase {
  const _$6adf8b0c22ee4670d3ed659c0600bd8968824bfdEnus();

  @override
  _$eb1f6ed39a9fc007b0c0c10cdaf9a1ee3caf9551Enus $(Object? _p1) =>
      _$eb1f6ed39a9fc007b0c0c10cdaf9a1ee3caf9551Enus(p1: _p1);
}

class _$6adf8b0c22ee4670d3ed659c0600bd8968824bfdJajp
    extends _$6adf8b0c22ee4670d3ed659c0600bd8968824bfdBase {
  const _$6adf8b0c22ee4670d3ed659c0600bd8968824bfdJajp();

  @override
  _$eb1f6ed39a9fc007b0c0c10cdaf9a1ee3caf9551Jajp $(Object? _p1) =>
      _$eb1f6ed39a9fc007b0c0c10cdaf9a1ee3caf9551Jajp(p1: _p1);
}

abstract class _$eb1f6ed39a9fc007b0c0c10cdaf9a1ee3caf9551Base {
  const _$eb1f6ed39a9fc007b0c0c10cdaf9a1ee3caf9551Base({Object? p1}) : _p1 = p1;

  final Object? _p1;

  String get onceDeletedItCannotBeUndone => throw UnimplementedError();
}

class _$eb1f6ed39a9fc007b0c0c10cdaf9a1ee3caf9551Enus
    extends _$eb1f6ed39a9fc007b0c0c10cdaf9a1ee3caf9551Base {
  const _$eb1f6ed39a9fc007b0c0c10cdaf9a1ee3caf9551Enus({super.p1});

  @override
  String get onceDeletedItCannotBeUndone =>
      "You will delete ${_p1}.\n\nOnce deleted, it cannot be undone.";
}

class _$eb1f6ed39a9fc007b0c0c10cdaf9a1ee3caf9551Jajp
    extends _$eb1f6ed39a9fc007b0c0c10cdaf9a1ee3caf9551Base {
  const _$eb1f6ed39a9fc007b0c0c10cdaf9a1ee3caf9551Jajp({super.p1});

  @override
  String get onceDeletedItCannotBeUndone =>
      "${_p1}を削除します。\n\n一度削除すると元に戻すことができません。";
}

abstract class _$8a438be392348d81ac50aaadb1da949eef9c3934Base {
  const _$8a438be392348d81ac50aaadb1da949eef9c3934Base();

  _$6551f44e930f0892d29ae2e6dd357426a7ef3054Base $(Object? _p1) =>
      throw UnimplementedError();
}

class _$8a438be392348d81ac50aaadb1da949eef9c3934Enus
    extends _$8a438be392348d81ac50aaadb1da949eef9c3934Base {
  const _$8a438be392348d81ac50aaadb1da949eef9c3934Enus();

  @override
  _$6551f44e930f0892d29ae2e6dd357426a7ef3054Enus $(Object? _p1) =>
      _$6551f44e930f0892d29ae2e6dd357426a7ef3054Enus(p1: _p1);
}

class _$8a438be392348d81ac50aaadb1da949eef9c3934Jajp
    extends _$8a438be392348d81ac50aaadb1da949eef9c3934Base {
  const _$8a438be392348d81ac50aaadb1da949eef9c3934Jajp();

  @override
  _$6551f44e930f0892d29ae2e6dd357426a7ef3054Jajp $(Object? _p1) =>
      _$6551f44e930f0892d29ae2e6dd357426a7ef3054Jajp(p1: _p1);
}

abstract class _$6551f44e930f0892d29ae2e6dd357426a7ef3054Base {
  const _$6551f44e930f0892d29ae2e6dd357426a7ef3054Base({Object? p1}) : _p1 = p1;

  final Object? _p1;

  String get areYouSure => throw UnimplementedError();
}

class _$6551f44e930f0892d29ae2e6dd357426a7ef3054Enus
    extends _$6551f44e930f0892d29ae2e6dd357426a7ef3054Base {
  const _$6551f44e930f0892d29ae2e6dd357426a7ef3054Enus({super.p1});

  @override
  String get areYouSure => "Would you like to report ${_p1}.\n\nAre you sure?";
}

class _$6551f44e930f0892d29ae2e6dd357426a7ef3054Jajp
    extends _$6551f44e930f0892d29ae2e6dd357426a7ef3054Base {
  const _$6551f44e930f0892d29ae2e6dd357426a7ef3054Jajp({super.p1});

  @override
  String get areYouSure => "${_p1}を通報します。\n\nよろしいでしょうか？";
}

abstract class _$829e6374acf4ab691be4fc6ce556e2576add22e7Base {
  const _$829e6374acf4ab691be4fc6ce556e2576add22e7Base();

  _$7a0a08d617c4156925e99a933907f4ad95f63934Base $(Object? _p1) =>
      throw UnimplementedError();
}

class _$829e6374acf4ab691be4fc6ce556e2576add22e7Enus
    extends _$829e6374acf4ab691be4fc6ce556e2576add22e7Base {
  const _$829e6374acf4ab691be4fc6ce556e2576add22e7Enus();

  @override
  _$7a0a08d617c4156925e99a933907f4ad95f63934Enus $(Object? _p1) =>
      _$7a0a08d617c4156925e99a933907f4ad95f63934Enus(p1: _p1);
}

class _$829e6374acf4ab691be4fc6ce556e2576add22e7Jajp
    extends _$829e6374acf4ab691be4fc6ce556e2576add22e7Base {
  const _$829e6374acf4ab691be4fc6ce556e2576add22e7Jajp();

  @override
  _$7a0a08d617c4156925e99a933907f4ad95f63934Jajp $(Object? _p1) =>
      _$7a0a08d617c4156925e99a933907f4ad95f63934Jajp(p1: _p1);
}

abstract class _$7a0a08d617c4156925e99a933907f4ad95f63934Base {
  const _$7a0a08d617c4156925e99a933907f4ad95f63934Base({Object? p1}) : _p1 = p1;

  final Object? _p1;

  String get count => throw UnimplementedError();
  String get length => throw UnimplementedError();
}

class _$7a0a08d617c4156925e99a933907f4ad95f63934Enus
    extends _$7a0a08d617c4156925e99a933907f4ad95f63934Base {
  const _$7a0a08d617c4156925e99a933907f4ad95f63934Enus({super.p1});

  @override
  String get count => "Up to ${_p1}";
  @override
  String get length => "Up to ${_p1}";
}

class _$7a0a08d617c4156925e99a933907f4ad95f63934Jajp
    extends _$7a0a08d617c4156925e99a933907f4ad95f63934Base {
  const _$7a0a08d617c4156925e99a933907f4ad95f63934Jajp({super.p1});

  @override
  String get count => "${_p1}個まで";
  @override
  String get length => "${_p1}文字まで";
}

abstract class _$67f61375c8b62f901352632a07aded48a57ff85fBase {
  const _$67f61375c8b62f901352632a07aded48a57ff85fBase();

  String $(Object? _p1) => throw UnimplementedError();
}

class _$67f61375c8b62f901352632a07aded48a57ff85fEnus
    extends _$67f61375c8b62f901352632a07aded48a57ff85fBase {
  const _$67f61375c8b62f901352632a07aded48a57ff85fEnus();

  @override
  String $(Object? _p1) => "Back to ${_p1}";
}

class _$67f61375c8b62f901352632a07aded48a57ff85fJajp
    extends _$67f61375c8b62f901352632a07aded48a57ff85fBase {
  const _$67f61375c8b62f901352632a07aded48a57ff85fJajp();

  @override
  String $(Object? _p1) => "${_p1}に戻る";
}

abstract class _$20fad005e0b3bb9dde825fc81961b62b2c73efd2Base {
  const _$20fad005e0b3bb9dde825fc81961b62b2c73efd2Base();

  String $(Object? _p1) => throw UnimplementedError();
}

class _$20fad005e0b3bb9dde825fc81961b62b2c73efd2Enus
    extends _$20fad005e0b3bb9dde825fc81961b62b2c73efd2Base {
  const _$20fad005e0b3bb9dde825fc81961b62b2c73efd2Enus();

  @override
  String $(Object? _p1) => "Go to ${_p1}";
}

class _$20fad005e0b3bb9dde825fc81961b62b2c73efd2Jajp
    extends _$20fad005e0b3bb9dde825fc81961b62b2c73efd2Base {
  const _$20fad005e0b3bb9dde825fc81961b62b2c73efd2Jajp();

  @override
  String $(Object? _p1) => "${_p1}へ進む";
}

abstract class _$00d0796f61e7ee7614446fbc3f31ae7dbab192adBase {
  const _$00d0796f61e7ee7614446fbc3f31ae7dbab192adBase();

  _$594f7a710f7d9c0e98a472b0f1fc3c80099a96e8Base $(Object? _p1) =>
      throw UnimplementedError();
}

class _$00d0796f61e7ee7614446fbc3f31ae7dbab192adEnus
    extends _$00d0796f61e7ee7614446fbc3f31ae7dbab192adBase {
  const _$00d0796f61e7ee7614446fbc3f31ae7dbab192adEnus();

  @override
  _$594f7a710f7d9c0e98a472b0f1fc3c80099a96e8Enus $(Object? _p1) =>
      _$594f7a710f7d9c0e98a472b0f1fc3c80099a96e8Enus(p1: _p1);
}

class _$00d0796f61e7ee7614446fbc3f31ae7dbab192adJajp
    extends _$00d0796f61e7ee7614446fbc3f31ae7dbab192adBase {
  const _$00d0796f61e7ee7614446fbc3f31ae7dbab192adJajp();

  @override
  _$594f7a710f7d9c0e98a472b0f1fc3c80099a96e8Jajp $(Object? _p1) =>
      _$594f7a710f7d9c0e98a472b0f1fc3c80099a96e8Jajp(p1: _p1);
}

abstract class _$594f7a710f7d9c0e98a472b0f1fc3c80099a96e8Base {
  const _$594f7a710f7d9c0e98a472b0f1fc3c80099a96e8Base({Object? p1}) : _p1 = p1;

  final Object? _p1;

  _$2fbaf5fc413fd181e48c4ffe1ab411d67289d483Base get unread =>
      throw UnimplementedError();
}

class _$594f7a710f7d9c0e98a472b0f1fc3c80099a96e8Enus
    extends _$594f7a710f7d9c0e98a472b0f1fc3c80099a96e8Base {
  const _$594f7a710f7d9c0e98a472b0f1fc3c80099a96e8Enus({super.p1});

  @override
  _$2fbaf5fc413fd181e48c4ffe1ab411d67289d483Enus get unread =>
      _$2fbaf5fc413fd181e48c4ffe1ab411d67289d483Enus(p1: _p1);
}

class _$594f7a710f7d9c0e98a472b0f1fc3c80099a96e8Jajp
    extends _$594f7a710f7d9c0e98a472b0f1fc3c80099a96e8Base {
  const _$594f7a710f7d9c0e98a472b0f1fc3c80099a96e8Jajp({super.p1});

  @override
  _$2fbaf5fc413fd181e48c4ffe1ab411d67289d483Jajp get unread =>
      _$2fbaf5fc413fd181e48c4ffe1ab411d67289d483Jajp(p1: _p1);
}

abstract class _$2fbaf5fc413fd181e48c4ffe1ab411d67289d483Base {
  const _$2fbaf5fc413fd181e48c4ffe1ab411d67289d483Base({Object? p1}) : _p1 = p1;

  final Object? _p1;

  String $(Object? _p2) => throw UnimplementedError();
}

class _$2fbaf5fc413fd181e48c4ffe1ab411d67289d483Enus
    extends _$2fbaf5fc413fd181e48c4ffe1ab411d67289d483Base {
  const _$2fbaf5fc413fd181e48c4ffe1ab411d67289d483Enus({super.p1});

  @override
  String $(Object? _p2) => "There are ${_p1} unread ${_p2}.";
}

class _$2fbaf5fc413fd181e48c4ffe1ab411d67289d483Jajp
    extends _$2fbaf5fc413fd181e48c4ffe1ab411d67289d483Base {
  const _$2fbaf5fc413fd181e48c4ffe1ab411d67289d483Jajp({super.p1});

  @override
  String $(Object? _p2) => "${_p1}件の未読${_p2}があります。";
}
