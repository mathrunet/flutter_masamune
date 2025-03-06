// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field, unused_element, require_trailing_commas, prefer_const_constructors, unnecessary_overrides, prefer_const_literals_to_create_immutables,  unnecessary_null_in_if_null_operators, library_prefixes, directives_ordering, no_leading_underscores_for_local_identifiers, unnecessary_brace_in_string_interps

part of 'main.dart';

// **************************************************************************
// GoogleSpreadSheetLocalizeGenerator
// **************************************************************************

abstract class _$AppLocalize extends AppLocalizeBase {
  @override
  List<LocalizationsDelegate> delegates([
    List<LocalizationsDelegate> delegates = const [],
  ]) {
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
    var res = _$appLocalizeLocalizations.entries.firstWhereOrNull(
      (e) => e.key == locale,
    );
    if (res != null) {
      return res.value;
    }
    res = _$appLocalizeLocalizations.entries.firstWhereOrNull(
      (e) => e.key.languageCode == locale.languageCode,
    );
    if (res != null) {
      return res.value;
    }
    return _$appLocalizeLocalizations.values.first;
  }
}

final _$appLocalizeLocalizations = {
  Locale("en", "US"): _$AppLocalizeEnus(),
  Locale("ja", "JP"): _$AppLocalizeJajp(),
  Locale("zh", "CN"): _$AppLocalizeZhcn(),
  Locale("ko", "KR"): _$AppLocalizeKokr(),
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

  String get toNext => throw UnimplementedError();

  String get toPrev => throw UnimplementedError();

  String get skip => throw UnimplementedError();

  String get result => throw UnimplementedError();

  String get done => throw UnimplementedError();

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

  String get registration => throw UnimplementedError();

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

  String get dateTime => throw UnimplementedError();

  String get review => throw UnimplementedError();

  String get buy => throw UnimplementedError();

  String get buying => throw UnimplementedError();

  String get alreadyBought => throw UnimplementedError();

  String get alreadyRegistered => throw UnimplementedError();

  String get restore => throw UnimplementedError();

  String get public => throw UnimplementedError();

  String get private => throw UnimplementedError();

  String get agreement => throw UnimplementedError();

  String get termsOfUse => throw UnimplementedError();

  String get privacyPolicy => throw UnimplementedError();

  String get user => throw UnimplementedError();

  String get content => throw UnimplementedError();

  String get member => throw UnimplementedError();

  String get message => throw UnimplementedError();

  String get title => throw UnimplementedError();

  String get text => throw UnimplementedError();

  String get comment => throw UnimplementedError();

  String get icon => throw UnimplementedError();

  String get share => throw UnimplementedError();

  String get tag => throw UnimplementedError();

  String get tags => throw UnimplementedError();

  String get category => throw UnimplementedError();

  String get block => throw UnimplementedError();

  String get talk => throw UnimplementedError();

  String get scenario => throw UnimplementedError();

  String get random => throw UnimplementedError();

  String get unchangeable => throw UnimplementedError();

  String get seeMore => throw UnimplementedError();

  String get latest => throw UnimplementedError();

  String get sns => throw UnimplementedError();

  String get store => throw UnimplementedError();

  String get subscription => throw UnimplementedError();

  String get billingStatus => throw UnimplementedError();

  String get menu => throw UnimplementedError();

  String get home => throw UnimplementedError();

  String get contact => throw UnimplementedError();

  String get calendar => throw UnimplementedError();

  String get profile => throw UnimplementedError();

  String get mypage => throw UnimplementedError();

  String get account => throw UnimplementedError();

  String get userInformation => throw UnimplementedError();

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

  String get profileSettings => throw UnimplementedError();

  String get accountDeletion => throw UnimplementedError();

  String get addMediaByTakingPicturesWithTheCamera =>
      throw UnimplementedError();

  String get addMediaFromTheLibrary => throw UnimplementedError();

  String get enterThe6DigitCodeFromTheSMS => throw UnimplementedError();

  String get youWillLogOutAreYouOK => throw UnimplementedError();

  String
      get passwordResetEmailHasBeenSentToYouPleaseUseTheLinkInTheEmailToSetANewPassword =>
          throw UnimplementedError();

  String get pleaseRegisterAgain => throw UnimplementedError();

  String get pleaseTryAgain => throw UnimplementedError();

  String
      get doYouWantToDeleteYourAccountOnceAnAccountIsDeletedItCannotBeRestored =>
          throw UnimplementedError();

  String
      get sinceYourSubscriptionIsActiveYouCannotDeleteYourAccountPleaseCancelYourSubscriptionAndTryAgain =>
          throw UnimplementedError();

  String get couldNotLoginPleaseCheckYourLoginInformationAgain =>
      throw UnimplementedError();

  _$ee3cdde455f5dd463564a735df43c1a8f5dad3b8Base
      get initializationFailedExitTheApplication => throw UnimplementedError();

  String get thereIsANewUpdate => throw UnimplementedError();

  String
      get thereIsANewUpdatePleaseUpdateTheApplicationInTheStoreAndThenLaunchTheApplicationAgain =>
          throw UnimplementedError();

  _$a1dd18c1c4364639c09234f7ad8df55d6c7a6328Base $(Object? _p1) =>
      throw UnimplementedError();

  _$b44b04c9b27cca846b55b5015c24d2fe11b4ad27Base get pleaseEnter =>
      throw UnimplementedError();

  _$a833ede9f85bddd383d93fef040f5fa1cfe21fc2Base get pleaseSelect =>
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

  _$8188dd5c635a839e3c04a430552a5c708948c159Base get registerTo =>
      throw UnimplementedError();

  _$74668b3ca73e99afbde0a422d31e6a07ed6cd315Base get releaseFrom =>
      throw UnimplementedError();

  String get english => throw UnimplementedError();

  String get japanese => throw UnimplementedError();

  String get chinese => throw UnimplementedError();

  String get korean => throw UnimplementedError();

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

  String get monday => throw UnimplementedError();

  String get tuesday => throw UnimplementedError();

  String get wednesday => throw UnimplementedError();

  String get thursday => throw UnimplementedError();

  String get friday => throw UnimplementedError();

  String get saturday => throw UnimplementedError();

  String get sunday => throw UnimplementedError();

  String get holiday => throw UnimplementedError();

  String get google => throw UnimplementedError();

  String get apple => throw UnimplementedError();

  String get facebook => throw UnimplementedError();

  String get amazon => throw UnimplementedError();

  String get mathruNet => throw UnimplementedError();

  _$00d0796f61e7ee7614446fbc3f31ae7dbab192adBase get thereAre =>
      throw UnimplementedError();

  String get copyToClipboard => throw UnimplementedError();

  String get wouldYouLikeToReviewTheApp => throw UnimplementedError();
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
  String get toNext => "Next";

  @override
  String get toPrev => "Prev";

  @override
  String get skip => "Skip";

  @override
  String get result => "Result";

  @override
  String get done => "Done";

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
  String get registration => "Registration";

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
  String get dateTime => "DateTime";

  @override
  String get review => "Review";

  @override
  String get buy => "Buy";

  @override
  String get buying => "Buying";

  @override
  String get alreadyBought => "Already bought";

  @override
  String get alreadyRegistered => "Already registered";

  @override
  String get restore => "Restore";

  @override
  String get public => "Public";

  @override
  String get private => "Private";

  @override
  String get agreement => "Agreement";

  @override
  String get termsOfUse => "Terms of Use";

  @override
  String get privacyPolicy => "Privacy Policy";

  @override
  String get user => "User";

  @override
  String get content => "Content";

  @override
  String get member => "Member";

  @override
  String get message => "Message";

  @override
  String get title => "Title";

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
  String get talk => "Talk";

  @override
  String get scenario => "Scenario";

  @override
  String get random => "Random";

  @override
  String get unchangeable => "Unchangeable";

  @override
  String get seeMore => "See more";

  @override
  String get latest => "Latest";

  @override
  String get sns => "SNS";

  @override
  String get store => "Store";

  @override
  String get subscription => "Subscription";

  @override
  String get billingStatus => "Billing status";

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
  String get userInformation => "User Information";

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
  String get profileSettings => "Profile Settings";

  @override
  String get accountDeletion => "Account Deletion";

  @override
  String get addMediaByTakingPicturesWithTheCamera =>
      "Add media by taking pictures with the camera";

  @override
  String get addMediaFromTheLibrary => "Add media from the library";

  @override
  String get enterThe6DigitCodeFromTheSMS =>
      "Enter the 6-digit code from the SMS.";

  @override
  String get youWillLogOutAreYouOK => "You will log out.\n\nAre you OK?";

  @override
  String get passwordResetEmailHasBeenSentToYouPleaseUseTheLinkInTheEmailToSetANewPassword =>
      "Password reset email has been sent to you.\n\nPlease use the link in the email to set a new password.";

  @override
  String get pleaseRegisterAgain => "Please register again.";

  @override
  String get pleaseTryAgain => "Please try again.";

  @override
  String get doYouWantToDeleteYourAccountOnceAnAccountIsDeletedItCannotBeRestored =>
      "Do you want to delete your account?\n\nOnce an account is deleted, it cannot be restored.";

  @override
  String get sinceYourSubscriptionIsActiveYouCannotDeleteYourAccountPleaseCancelYourSubscriptionAndTryAgain =>
      "Since your subscription is active, you cannot delete your account.\n\nPlease cancel your subscription and try again.";

  @override
  String get couldNotLoginPleaseCheckYourLoginInformationAgain =>
      "Could not login. Please check your login information again.";

  @override
  _$ee3cdde455f5dd463564a735df43c1a8f5dad3b8Enus
      get initializationFailedExitTheApplication =>
          _$ee3cdde455f5dd463564a735df43c1a8f5dad3b8Enus();

  @override
  String get thereIsANewUpdate => "There is a new update";

  @override
  String get thereIsANewUpdatePleaseUpdateTheApplicationInTheStoreAndThenLaunchTheApplicationAgain =>
      "There is a new update.\n\nPlease update the application in the store and then launch the application again.";

  @override
  _$a1dd18c1c4364639c09234f7ad8df55d6c7a6328Enus $(Object? _p1) =>
      _$a1dd18c1c4364639c09234f7ad8df55d6c7a6328Enus(p1: _p1);

  @override
  _$b44b04c9b27cca846b55b5015c24d2fe11b4ad27Enus get pleaseEnter =>
      _$b44b04c9b27cca846b55b5015c24d2fe11b4ad27Enus();

  @override
  _$a833ede9f85bddd383d93fef040f5fa1cfe21fc2Enus get pleaseSelect =>
      _$a833ede9f85bddd383d93fef040f5fa1cfe21fc2Enus();

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
  _$8188dd5c635a839e3c04a430552a5c708948c159Enus get registerTo =>
      _$8188dd5c635a839e3c04a430552a5c708948c159Enus();

  @override
  _$74668b3ca73e99afbde0a422d31e6a07ed6cd315Enus get releaseFrom =>
      _$74668b3ca73e99afbde0a422d31e6a07ed6cd315Enus();

  @override
  String get english => "English";

  @override
  String get japanese => "Japanese";

  @override
  String get chinese => "Chinese";

  @override
  String get korean => "Korean";

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
  String get monday => "Monday";

  @override
  String get tuesday => "Tuesday";

  @override
  String get wednesday => "Wednesday";

  @override
  String get thursday => "Thursday";

  @override
  String get friday => "Friday";

  @override
  String get saturday => "Saturday";

  @override
  String get sunday => "Sunday";

  @override
  String get holiday => "Holiday";

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

  @override
  String get wouldYouLikeToReviewTheApp => "Would you like to review the app?";
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
  String get toNext => "次へ";

  @override
  String get toPrev => "前へ";

  @override
  String get skip => "スキップ";

  @override
  String get result => "結果";

  @override
  String get done => "完了";

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
  String get registration => "登録";

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
  String get dateTime => "日時";

  @override
  String get review => "評価";

  @override
  String get buy => "購入";

  @override
  String get buying => "購入";

  @override
  String get alreadyBought => "購入済み";

  @override
  String get alreadyRegistered => "登録済み";

  @override
  String get restore => "復元";

  @override
  String get public => "公開";

  @override
  String get private => "非公開";

  @override
  String get agreement => "注意事項";

  @override
  String get termsOfUse => "利用規約";

  @override
  String get privacyPolicy => "プライバシーポリシー";

  @override
  String get user => "ユーザー";

  @override
  String get content => "コンテンツ";

  @override
  String get member => "メンバー";

  @override
  String get message => "メッセージ";

  @override
  String get title => "タイトル";

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
  String get talk => "トーク";

  @override
  String get scenario => "シナリオ";

  @override
  String get random => "ランダム";

  @override
  String get unchangeable => "変更不可";

  @override
  String get seeMore => "もっと見る";

  @override
  String get latest => "最新";

  @override
  String get sns => "SNS";

  @override
  String get store => "ストア";

  @override
  String get subscription => "サブスクリプション";

  @override
  String get billingStatus => "課金状態";

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
  String get userInformation => "ユーザー情報";

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
  String get profileSettings => "プロフィール設定";

  @override
  String get accountDeletion => "アカウント削除";

  @override
  String get addMediaByTakingPicturesWithTheCamera => "カメラで撮影してメディアを追加";

  @override
  String get addMediaFromTheLibrary => "ライブラリからメディアを追加";

  @override
  String get enterThe6DigitCodeFromTheSMS => "SMSに記載されている6桁のコードを入力してください。";

  @override
  String get youWillLogOutAreYouOK => "ログアウトします。\n\nよろしいですか？";

  @override
  String
      get passwordResetEmailHasBeenSentToYouPleaseUseTheLinkInTheEmailToSetANewPassword =>
          "パスワードリセットメールを送信しました。\n\nメール中に記載されているリンクから新しいパスワードを設定してください。";

  @override
  String get pleaseRegisterAgain => "お手数ですが、再度新規登録をお願いします。";

  @override
  String get pleaseTryAgain => "もう一度お試しください。";

  @override
  String
      get doYouWantToDeleteYourAccountOnceAnAccountIsDeletedItCannotBeRestored =>
          "アカウントを削除しますか？\n\n一度削除すると元に戻すことはできません。";

  @override
  String
      get sinceYourSubscriptionIsActiveYouCannotDeleteYourAccountPleaseCancelYourSubscriptionAndTryAgain =>
          "サブスクリプションが有効のため、アカウント削除はできません。\n\n一度サブスクリプションを解約した後、再度お試しください。";

  @override
  String get couldNotLoginPleaseCheckYourLoginInformationAgain =>
      "ログインできませんでした。ログイン情報を再度ご確認ください。";

  @override
  _$ee3cdde455f5dd463564a735df43c1a8f5dad3b8Jajp
      get initializationFailedExitTheApplication =>
          _$ee3cdde455f5dd463564a735df43c1a8f5dad3b8Jajp();

  @override
  String get thereIsANewUpdate => "新しいアップデート";

  @override
  String
      get thereIsANewUpdatePleaseUpdateTheApplicationInTheStoreAndThenLaunchTheApplicationAgain =>
          "新しいアップデートがあります。\n\nストアでアプリをアップデートしてから再度アプリを起動してください。";

  @override
  _$a1dd18c1c4364639c09234f7ad8df55d6c7a6328Jajp $(Object? _p1) =>
      _$a1dd18c1c4364639c09234f7ad8df55d6c7a6328Jajp(p1: _p1);

  @override
  _$b44b04c9b27cca846b55b5015c24d2fe11b4ad27Jajp get pleaseEnter =>
      _$b44b04c9b27cca846b55b5015c24d2fe11b4ad27Jajp();

  @override
  _$a833ede9f85bddd383d93fef040f5fa1cfe21fc2Jajp get pleaseSelect =>
      _$a833ede9f85bddd383d93fef040f5fa1cfe21fc2Jajp();

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
  _$8188dd5c635a839e3c04a430552a5c708948c159Jajp get registerTo =>
      _$8188dd5c635a839e3c04a430552a5c708948c159Jajp();

  @override
  _$74668b3ca73e99afbde0a422d31e6a07ed6cd315Jajp get releaseFrom =>
      _$74668b3ca73e99afbde0a422d31e6a07ed6cd315Jajp();

  @override
  String get english => "英語";

  @override
  String get japanese => "日本語";

  @override
  String get chinese => "中国語";

  @override
  String get korean => "韓国語";

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
  String get monday => "月曜日";

  @override
  String get tuesday => "火曜日";

  @override
  String get wednesday => "水曜日";

  @override
  String get thursday => "木曜日";

  @override
  String get friday => "金曜日";

  @override
  String get saturday => "土曜日";

  @override
  String get sunday => "日曜日";

  @override
  String get holiday => "假期";

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

  @override
  String get wouldYouLikeToReviewTheApp => "アプリを評価してみませんか？";
}

class _$AppLocalizeZhcn extends _$AppLocalizeBase {
  const _$AppLocalizeZhcn();

  @override
  String get appTitle => "应用标题";

  @override
  String get subTitle => "字幕";

  @override
  String get yes => "是的";

  @override
  String get no => "不";

  @override
  String get ok => "好的";

  @override
  String get open => "打开";

  @override
  String get close => "关闭";

  @override
  String get forward => "继续前行";

  @override
  String get back => "返回";

  @override
  String get next => "下一个";

  @override
  String get prev => "前";

  @override
  String get toNext => "到下一个";

  @override
  String get toPrev => "以前的";

  @override
  String get skip => "跳过";

  @override
  String get result => "结果";

  @override
  String get done => "完成";

  @override
  String get complete => "完成";

  @override
  String get none => "没有任何";

  @override
  String get success => "成功";

  @override
  String get error => "错误";

  @override
  String get warning => "警告";

  @override
  String get notice => "笔记";

  @override
  String get confirm => "决定";

  @override
  String get decision => "确认";

  @override
  String get cancel => "取消";

  @override
  String get confirmation => "确认";

  @override
  String get refresh => "更新";

  @override
  String get update => "更新";

  @override
  String get change => "改变";

  @override
  String get send => "发送";

  @override
  String get resend => "重新传播";

  @override
  String get retry => "重试";

  @override
  String get quit => "结尾";

  @override
  String get property => "财产";

  @override
  String get allDay => "一整天";

  @override
  String get others => "其他的";

  @override
  String get note => "笔记";

  @override
  String get process => "过程";

  @override
  String get detail => "细节";

  @override
  String get setting => "环境";

  @override
  String get config => "环境";

  @override
  String get post => "发布";

  @override
  String get submit => "决定";

  @override
  String get create => "创造";

  @override
  String get register => "登记";

  @override
  String get registration => "登记";

  @override
  String get save => "保持";

  @override
  String get data => "数据";

  @override
  String get fetch => "获得";

  @override
  String get add => "添加";

  @override
  String get edit => "编辑";

  @override
  String get remove => "删除";

  @override
  String get delete => "删除";

  @override
  String get join => "参与";

  @override
  String get manage => "管理";

  @override
  String get management => "管理";

  @override
  String get search => "搜索";

  @override
  String get article => "文章";

  @override
  String get report => "报告";

  @override
  String get dateTime => "时间日期";

  @override
  String get review => "评估";

  @override
  String get buy => "购买";

  @override
  String get buying => "购买";

  @override
  String get alreadyBought => "已购买";

  @override
  String get alreadyRegistered => "挂号的";

  @override
  String get restore => "恢复";

  @override
  String get public => "公开";

  @override
  String get private => "非公开";

  @override
  String get agreement => "协议";

  @override
  String get termsOfUse => "使用条款";

  @override
  String get privacyPolicy => "隐私政策";

  @override
  String get user => "用户";

  @override
  String get content => "内容";

  @override
  String get member => "成员";

  @override
  String get message => "信息";

  @override
  String get title => "标题";

  @override
  String get text => "文本";

  @override
  String get comment => "评论";

  @override
  String get icon => "图标";

  @override
  String get share => "分享";

  @override
  String get tag => "标签";

  @override
  String get tags => "标签";

  @override
  String get category => "类别";

  @override
  String get block => "堵塞";

  @override
  String get talk => "讲话";

  @override
  String get scenario => "设想";

  @override
  String get random => "随机的";

  @override
  String get unchangeable => "它不能更改";

  @override
  String get seeMore => "查看更多";

  @override
  String get latest => "最新的";

  @override
  String get sns => "SNS";

  @override
  String get store => "店铺";

  @override
  String get subscription => "订阅";

  @override
  String get billingStatus => "计费状态";

  @override
  String get menu => "菜单";

  @override
  String get home => "家";

  @override
  String get contact => "询问";

  @override
  String get calendar => "日历";

  @override
  String get profile => "轮廓";

  @override
  String get mypage => "我的页面";

  @override
  String get account => "帐户";

  @override
  String get userInformation => "用户信息";

  @override
  String get login => "登录";

  @override
  String get logout => "登出";

  @override
  String get id => "ID";

  @override
  String get name => "姓名";

  @override
  String get nickname => "昵称";

  @override
  String get guest => "客人";

  @override
  String get gender => "性别";

  @override
  String get male => "男性";

  @override
  String get female => "女士";

  @override
  String get address => "地址";

  @override
  String get age => "年龄";

  @override
  String get birthday => "出生日期";

  @override
  String get work => "职业";

  @override
  String get phoneNumber => "电话号码";

  @override
  String get email => "邮件地址";

  @override
  String get password => "密码";

  @override
  String get confirmPassword => "确认密码";

  @override
  String get resetPassword => "重设密码";

  @override
  String get forgotYourPassword => "如果您忘记了密码，请单击此处";

  @override
  String get reauthentication => "重新认证";

  @override
  _$e45975972292dd2cace745efd3b9606d0d570babZhcn get signInWith =>
      _$e45975972292dd2cace745efd3b9606d0d570babZhcn();

  @override
  String get pleaseReEnterYourPasswordToReAuthenticate => "再次输入密码并重新实现。";

  @override
  String get sendEmail => "发送电子邮件";

  @override
  String get sendCode => "发送代码";

  @override
  String get profileSettings => "个人资料设置";

  @override
  String get accountDeletion => "帐户删除";

  @override
  String get addMediaByTakingPicturesWithTheCamera => "通过相机拍摄添加媒体";

  @override
  String get addMediaFromTheLibrary => "从库中添加媒体";

  @override
  String get enterThe6DigitCodeFromTheSMS => "输入SMS中列出的6个数字代码。";

  @override
  String get youWillLogOutAreYouOK => "登出。\n\n您确定吗？";

  @override
  String
      get passwordResetEmailHasBeenSentToYouPleaseUseTheLinkInTheEmailToSetANewPassword =>
          "我发送了密码重置电子邮件。\n\n从电子邮件中列出的链接中设置一个新密码。";

  @override
  String get pleaseRegisterAgain => "对于给您带来的不便，我们深表歉意，但请重新注册。";

  @override
  String get pleaseTryAgain => "请再试一次。";

  @override
  String
      get doYouWantToDeleteYourAccountOnceAnAccountIsDeletedItCannotBeRestored =>
          "您想删除您的帐户吗？ \n\n一旦删除，将无法恢复。";

  @override
  String
      get sinceYourSubscriptionIsActiveYouCannotDeleteYourAccountPleaseCancelYourSubscriptionAndTryAgain =>
          "您的帐户无法删除，因为您的订阅处于活动状态。 \n\n请取消您的订阅并重试。";

  @override
  String get couldNotLoginPleaseCheckYourLoginInformationAgain =>
      "我无法登录。请再次检查登录信息。";

  @override
  _$ee3cdde455f5dd463564a735df43c1a8f5dad3b8Zhcn
      get initializationFailedExitTheApplication =>
          _$ee3cdde455f5dd463564a735df43c1a8f5dad3b8Zhcn();

  @override
  String get thereIsANewUpdate => "新更新";

  @override
  String
      get thereIsANewUpdatePleaseUpdateTheApplicationInTheStoreAndThenLaunchTheApplicationAgain =>
          "有新的更新。\n\n请从商店更新应用程序，然后再次启动该应用程序。";

  @override
  _$a1dd18c1c4364639c09234f7ad8df55d6c7a6328Zhcn $(Object? _p1) =>
      _$a1dd18c1c4364639c09234f7ad8df55d6c7a6328Zhcn(p1: _p1);

  @override
  _$b44b04c9b27cca846b55b5015c24d2fe11b4ad27Zhcn get pleaseEnter =>
      _$b44b04c9b27cca846b55b5015c24d2fe11b4ad27Zhcn();

  @override
  _$a833ede9f85bddd383d93fef040f5fa1cfe21fc2Zhcn get pleaseSelect =>
      _$a833ede9f85bddd383d93fef040f5fa1cfe21fc2Zhcn();

  @override
  _$6adf8b0c22ee4670d3ed659c0600bd8968824bfdZhcn get youWillDelete =>
      _$6adf8b0c22ee4670d3ed659c0600bd8968824bfdZhcn();

  @override
  _$8a438be392348d81ac50aaadb1da949eef9c3934Zhcn get wouldYouLikeToReport =>
      _$8a438be392348d81ac50aaadb1da949eef9c3934Zhcn();

  @override
  _$829e6374acf4ab691be4fc6ce556e2576add22e7Zhcn get upTo =>
      _$829e6374acf4ab691be4fc6ce556e2576add22e7Zhcn();

  @override
  _$67f61375c8b62f901352632a07aded48a57ff85fZhcn get backTo =>
      _$67f61375c8b62f901352632a07aded48a57ff85fZhcn();

  @override
  _$20fad005e0b3bb9dde825fc81961b62b2c73efd2Zhcn get goTo =>
      _$20fad005e0b3bb9dde825fc81961b62b2c73efd2Zhcn();

  @override
  _$8188dd5c635a839e3c04a430552a5c708948c159Zhcn get registerTo =>
      _$8188dd5c635a839e3c04a430552a5c708948c159Zhcn();

  @override
  _$74668b3ca73e99afbde0a422d31e6a07ed6cd315Zhcn get releaseFrom =>
      _$74668b3ca73e99afbde0a422d31e6a07ed6cd315Zhcn();

  @override
  String get english => "英语";

  @override
  String get japanese => "日本语";

  @override
  String get chinese => "中文";

  @override
  String get korean => "韩语";

  @override
  String get year => "年";

  @override
  String get years => "年";

  @override
  String get month => "月";

  @override
  String get months => "月";

  @override
  String get day => "天";

  @override
  String get days => "天";

  @override
  String get week => "星期";

  @override
  String get weeks => "星期";

  @override
  String get hour => "时间";

  @override
  String get hours => "时间";

  @override
  String get minute => "部分";

  @override
  String get minutes => "部分";

  @override
  String get second => "第二";

  @override
  String get seconds => "第二";

  @override
  String get monday => "星期 一";

  @override
  String get tuesday => "星期 二";

  @override
  String get wednesday => "星期 三";

  @override
  String get thursday => "星期 四";

  @override
  String get friday => "星期 五";

  @override
  String get saturday => "星期 六";

  @override
  String get sunday => "星期 天";

  @override
  String get holiday => "휴일";

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
  _$00d0796f61e7ee7614446fbc3f31ae7dbab192adZhcn get thereAre =>
      _$00d0796f61e7ee7614446fbc3f31ae7dbab192adZhcn();

  @override
  String get copyToClipboard => "复制到剪贴板";

  @override
  String get wouldYouLikeToReviewTheApp => "您想评价该应用程序吗？";
}

class _$AppLocalizeKokr extends _$AppLocalizeBase {
  const _$AppLocalizeKokr();

  @override
  String get appTitle => "앱 제목";

  @override
  String get subTitle => "부제";

  @override
  String get yes => "예";

  @override
  String get no => "아니요";

  @override
  String get ok => "좋아요";

  @override
  String get open => "열려 있는";

  @override
  String get close => "닫다";

  @override
  String get forward => "계속 움직입니다";

  @override
  String get back => "반품";

  @override
  String get next => "다음";

  @override
  String get prev => "전에";

  @override
  String get toNext => "다음";

  @override
  String get toPrev => "이전";

  @override
  String get skip => "건너뛰다";

  @override
  String get result => "결과";

  @override
  String get done => "완성";

  @override
  String get complete => "완성";

  @override
  String get none => "없음";

  @override
  String get success => "성공";

  @override
  String get error => "오류";

  @override
  String get warning => "경고";

  @override
  String get notice => "메모";

  @override
  String get confirm => "결정";

  @override
  String get decision => "확인하다";

  @override
  String get cancel => "취소";

  @override
  String get confirmation => "확인";

  @override
  String get refresh => "업데이트";

  @override
  String get update => "업데이트";

  @override
  String get change => "변화";

  @override
  String get send => "보내다";

  @override
  String get resend => "재전송";

  @override
  String get retry => "다시 해 보다";

  @override
  String get quit => "끝";

  @override
  String get property => "재산";

  @override
  String get allDay => "하루 종일";

  @override
  String get others => "기타";

  @override
  String get note => "메모";

  @override
  String get process => "프로세스";

  @override
  String get detail => "세부 사항";

  @override
  String get setting => "환경";

  @override
  String get config => "환경";

  @override
  String get post => "전기";

  @override
  String get submit => "결정";

  @override
  String get create => "만들다";

  @override
  String get register => "등록하다";

  @override
  String get registration => "등록하다";

  @override
  String get save => "유지하다";

  @override
  String get data => "데이터";

  @override
  String get fetch => "인수";

  @override
  String get add => "덧셈";

  @override
  String get edit => "편집하다";

  @override
  String get remove => "삭제";

  @override
  String get delete => "삭제";

  @override
  String get join => "참여";

  @override
  String get manage => "관리";

  @override
  String get management => "관리";

  @override
  String get search => "찾다";

  @override
  String get article => "기사";

  @override
  String get report => "보고서";

  @override
  String get dateTime => "일시";

  @override
  String get review => "평가";

  @override
  String get buy => "구매";

  @override
  String get buying => "구매";

  @override
  String get alreadyBought => "구매됨";

  @override
  String get alreadyRegistered => "등록됨";

  @override
  String get restore => "복원";

  @override
  String get public => "공개";

  @override
  String get private => "비공개";

  @override
  String get agreement => "합의";

  @override
  String get termsOfUse => "이용약관";

  @override
  String get privacyPolicy => "개인 정보 보호 정책";

  @override
  String get user => "사용자";

  @override
  String get content => "콘텐츠";

  @override
  String get member => "회원";

  @override
  String get message => "메시지";

  @override
  String get title => "제목";

  @override
  String get text => "텍스트";

  @override
  String get comment => "논평";

  @override
  String get icon => "상";

  @override
  String get share => "공유하다";

  @override
  String get tag => "꼬리표";

  @override
  String get tags => "꼬리표";

  @override
  String get category => "범주";

  @override
  String get block => "차단하다";

  @override
  String get talk => "말하다";

  @override
  String get scenario => "대본";

  @override
  String get random => "무작위의";

  @override
  String get unchangeable => "변경할 수 없습니다";

  @override
  String get seeMore => "더보기";

  @override
  String get latest => "최신";

  @override
  String get sns => "SNS";

  @override
  String get store => "스토어";

  @override
  String get subscription => "구독";

  @override
  String get billingStatus => "청구 상태";

  @override
  String get menu => "메뉴";

  @override
  String get home => "집";

  @override
  String get contact => "문의";

  @override
  String get calendar => "달력";

  @override
  String get profile => "프로필";

  @override
  String get mypage => "나의 페이지";

  @override
  String get account => "계정";

  @override
  String get userInformation => "사용자 정보";

  @override
  String get login => "로그인";

  @override
  String get logout => "로그 아웃";

  @override
  String get id => "ID";

  @override
  String get name => "이름";

  @override
  String get nickname => "별명";

  @override
  String get guest => "손님들";

  @override
  String get gender => "섹스";

  @override
  String get male => "남성";

  @override
  String get female => "여성";

  @override
  String get address => "주소";

  @override
  String get age => "나이";

  @override
  String get birthday => "생일";

  @override
  String get work => "직업";

  @override
  String get phoneNumber => "전화 번호";

  @override
  String get email => "메일 주소";

  @override
  String get password => "비밀번호";

  @override
  String get confirmPassword => "비밀번호 확인";

  @override
  String get resetPassword => "비밀번호 초기화";

  @override
  String get forgotYourPassword => "비밀번호를 잊어 버린 경우 여기를 클릭하십시오";

  @override
  String get reauthentication => "재 인증";

  @override
  _$e45975972292dd2cace745efd3b9606d0d570babKokr get signInWith =>
      _$e45975972292dd2cace745efd3b9606d0d570babKokr();

  @override
  String get pleaseReEnterYourPasswordToReAuthenticate =>
      "비밀번호를 다시 입력하고 다시 인증하십시오.";

  @override
  String get sendEmail => "이메일을 보내다";

  @override
  String get sendCode => "코드를 보내십시오";

  @override
  String get profileSettings => "프로필 설정";

  @override
  String get accountDeletion => "계정 삭제";

  @override
  String get addMediaByTakingPicturesWithTheCamera => "카메라로 촬영하여 미디어 추가";

  @override
  String get addMediaFromTheLibrary => "라이브러리에서 미디어 추가";

  @override
  String get enterThe6DigitCodeFromTheSMS => "SMS에 나열된 6 자리 코드를 입력하십시오.";

  @override
  String get youWillLogOutAreYouOK => "로그 아웃. \n\n확실합니까?";

  @override
  String
      get passwordResetEmailHasBeenSentToYouPleaseUseTheLinkInTheEmailToSetANewPassword =>
          "비밀번호 재설정 이메일을 보냈습니다. \n\n이메일에 나열된 링크에서 새 비밀번호를 설정합니다.";

  @override
  String get pleaseRegisterAgain => "죄송 합니다만, 다시 신규 등록을 부탁드립니다.";

  @override
  String get pleaseTryAgain => "다시 시도하십시오.";

  @override
  String
      get doYouWantToDeleteYourAccountOnceAnAccountIsDeletedItCannotBeRestored =>
          "계정을 삭제하시겠습니까? \n\n한 번 삭제하면 되돌릴 수 없습니다.";

  @override
  String
      get sinceYourSubscriptionIsActiveYouCannotDeleteYourAccountPleaseCancelYourSubscriptionAndTryAgain =>
          "구독이 활성화되어 계정을 삭제할 수 없습니다.";

  @override
  String get couldNotLoginPleaseCheckYourLoginInformationAgain =>
      "로그인 할 수 없었습니다. 로그인 정보를 다시 확인하십시오.";

  @override
  _$ee3cdde455f5dd463564a735df43c1a8f5dad3b8Kokr
      get initializationFailedExitTheApplication =>
          _$ee3cdde455f5dd463564a735df43c1a8f5dad3b8Kokr();

  @override
  String get thereIsANewUpdate => "새로운 업데이트";

  @override
  String
      get thereIsANewUpdatePleaseUpdateTheApplicationInTheStoreAndThenLaunchTheApplicationAgain =>
          "새로운 업데이트가 있습니다.\n\n스토어에서 앱을 업데이트한 다음 앱을 다시 시작하세요.";

  @override
  _$a1dd18c1c4364639c09234f7ad8df55d6c7a6328Kokr $(Object? _p1) =>
      _$a1dd18c1c4364639c09234f7ad8df55d6c7a6328Kokr(p1: _p1);

  @override
  _$b44b04c9b27cca846b55b5015c24d2fe11b4ad27Kokr get pleaseEnter =>
      _$b44b04c9b27cca846b55b5015c24d2fe11b4ad27Kokr();

  @override
  _$a833ede9f85bddd383d93fef040f5fa1cfe21fc2Kokr get pleaseSelect =>
      _$a833ede9f85bddd383d93fef040f5fa1cfe21fc2Kokr();

  @override
  _$6adf8b0c22ee4670d3ed659c0600bd8968824bfdKokr get youWillDelete =>
      _$6adf8b0c22ee4670d3ed659c0600bd8968824bfdKokr();

  @override
  _$8a438be392348d81ac50aaadb1da949eef9c3934Kokr get wouldYouLikeToReport =>
      _$8a438be392348d81ac50aaadb1da949eef9c3934Kokr();

  @override
  _$829e6374acf4ab691be4fc6ce556e2576add22e7Kokr get upTo =>
      _$829e6374acf4ab691be4fc6ce556e2576add22e7Kokr();

  @override
  _$67f61375c8b62f901352632a07aded48a57ff85fKokr get backTo =>
      _$67f61375c8b62f901352632a07aded48a57ff85fKokr();

  @override
  _$20fad005e0b3bb9dde825fc81961b62b2c73efd2Kokr get goTo =>
      _$20fad005e0b3bb9dde825fc81961b62b2c73efd2Kokr();

  @override
  _$8188dd5c635a839e3c04a430552a5c708948c159Kokr get registerTo =>
      _$8188dd5c635a839e3c04a430552a5c708948c159Kokr();

  @override
  _$74668b3ca73e99afbde0a422d31e6a07ed6cd315Kokr get releaseFrom =>
      _$74668b3ca73e99afbde0a422d31e6a07ed6cd315Kokr();

  @override
  String get english => "영어";

  @override
  String get japanese => "일본어";

  @override
  String get chinese => "중국어";

  @override
  String get korean => "한국어";

  @override
  String get year => "년도";

  @override
  String get years => "년도";

  @override
  String get month => "월";

  @override
  String get months => "월";

  @override
  String get day => "낮";

  @override
  String get days => "낮";

  @override
  String get week => "주";

  @override
  String get weeks => "주";

  @override
  String get hour => "시간";

  @override
  String get hours => "시간";

  @override
  String get minute => "부분";

  @override
  String get minutes => "부분";

  @override
  String get second => "두번째";

  @override
  String get seconds => "두번째";

  @override
  String get monday => "월요일";

  @override
  String get tuesday => "화요일";

  @override
  String get wednesday => "수요일";

  @override
  String get thursday => "목요일";

  @override
  String get friday => "금요일";

  @override
  String get saturday => "토요일";

  @override
  String get sunday => "일요일";

  @override
  String get holiday => "";

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
  _$00d0796f61e7ee7614446fbc3f31ae7dbab192adKokr get thereAre =>
      _$00d0796f61e7ee7614446fbc3f31ae7dbab192adKokr();

  @override
  String get copyToClipboard => "클립 보드에 복사하십시오";

  @override
  String get wouldYouLikeToReviewTheApp => "앱을 평가해 보지 않겠습니까?";
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

class _$e45975972292dd2cace745efd3b9606d0d570babZhcn
    extends _$e45975972292dd2cace745efd3b9606d0d570babBase {
  const _$e45975972292dd2cace745efd3b9606d0d570babZhcn();

  @override
  String $(Object? _p1) => "使用 ${_p1} 登录";
}

class _$e45975972292dd2cace745efd3b9606d0d570babKokr
    extends _$e45975972292dd2cace745efd3b9606d0d570babBase {
  const _$e45975972292dd2cace745efd3b9606d0d570babKokr();

  @override
  String $(Object? _p1) => "${_p1} 로 로그인";
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

class _$ee3cdde455f5dd463564a735df43c1a8f5dad3b8Zhcn
    extends _$ee3cdde455f5dd463564a735df43c1a8f5dad3b8Base {
  const _$ee3cdde455f5dd463564a735df43c1a8f5dad3b8Zhcn();

  @override
  _$cadc55701b4f9552b1fe34fd09932839a799de9bZhcn $(Object? _p1) =>
      _$cadc55701b4f9552b1fe34fd09932839a799de9bZhcn(p1: _p1);
}

class _$ee3cdde455f5dd463564a735df43c1a8f5dad3b8Kokr
    extends _$ee3cdde455f5dd463564a735df43c1a8f5dad3b8Base {
  const _$ee3cdde455f5dd463564a735df43c1a8f5dad3b8Kokr();

  @override
  _$cadc55701b4f9552b1fe34fd09932839a799de9bKokr $(Object? _p1) =>
      _$cadc55701b4f9552b1fe34fd09932839a799de9bKokr(p1: _p1);
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

class _$cadc55701b4f9552b1fe34fd09932839a799de9bZhcn
    extends _$cadc55701b4f9552b1fe34fd09932839a799de9bBase {
  const _$cadc55701b4f9552b1fe34fd09932839a799de9bZhcn({super.p1});

  @override
  String $(Object? _p2) => "初始化失败。结束应用程序。\n\n${_p1}\n${_p2}";
}

class _$cadc55701b4f9552b1fe34fd09932839a799de9bKokr
    extends _$cadc55701b4f9552b1fe34fd09932839a799de9bBase {
  const _$cadc55701b4f9552b1fe34fd09932839a799de9bKokr({super.p1});

  @override
  String $(Object? _p2) => "초기화 실패. 앱을 끝내십시오.\n\n${_p1}\n${_p2}";
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

  String get isNotSelected => throw UnimplementedError();

  String get mayBeIncorrect => throw UnimplementedError();

  String get doesNotMatch => throw UnimplementedError();

  String get notFound => throw UnimplementedError();

  String get hasStarted => throw UnimplementedError();

  String get haveStarted => throw UnimplementedError();

  String get hasFinished => throw UnimplementedError();

  String get haveFinished => throw UnimplementedError();

  String get hasBeenRestored => throw UnimplementedError();

  String get haveBeenRestored => throw UnimplementedError();

  String get isAlreadyDeleted => throw UnimplementedError();

  String get isLoading => throw UnimplementedError();

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
  String get isNotSelected => "${_p1} is not selected.";

  @override
  String get mayBeIncorrect => "${_p1} may be incorrect.";

  @override
  String get doesNotMatch => "${_p1} does not match.";

  @override
  String get notFound => "${_p1} not found.";

  @override
  String get hasStarted => "${_p1} has started.";

  @override
  String get haveStarted => "${_p1} have started.";

  @override
  String get hasFinished => "${_p1} has started.";

  @override
  String get haveFinished => "${_p1} have started.";

  @override
  String get hasBeenRestored => "${_p1} has been restored.";

  @override
  String get haveBeenRestored => "${_p1} have been restored.";

  @override
  String get isAlreadyDeleted => "${_p1} is already deleted.";

  @override
  String get isLoading => "${_p1} is loading...";

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
  String get isNotSelected => "${_p1}が選択されていません。";

  @override
  String get mayBeIncorrect => "${_p1}が間違っている可能性があります。";

  @override
  String get doesNotMatch => "${_p1}が一致しません。";

  @override
  String get notFound => "${_p1}が見つかりません。";

  @override
  String get hasStarted => "${_p1}を開始しました。";

  @override
  String get haveStarted => "${_p1}を開始しました。";

  @override
  String get hasFinished => "${_p1}を終了しました。";

  @override
  String get haveFinished => "${_p1}を終了しました。";

  @override
  String get hasBeenRestored => "${_p1}を復元しました。";

  @override
  String get haveBeenRestored => "${_p1}を復元しました。";

  @override
  String get isAlreadyDeleted => "${_p1}はすでに削除されています。";

  @override
  String get isLoading => "${_p1}読み込み中...";

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

class _$a1dd18c1c4364639c09234f7ad8df55d6c7a6328Zhcn
    extends _$a1dd18c1c4364639c09234f7ad8df55d6c7a6328Base {
  const _$a1dd18c1c4364639c09234f7ad8df55d6c7a6328Zhcn({super.p1});

  @override
  String $(Object? _p2) => "${_p1} ${_p2}";

  @override
  _$597f8738dba99655c0ca9b79249adc5905900579Zhcn get on =>
      _$597f8738dba99655c0ca9b79249adc5905900579Zhcn(p1: _p1);

  @override
  _$4fcbb22fb2ccb6326be9df179283c03d805ec200Zhcn get in_ =>
      _$4fcbb22fb2ccb6326be9df179283c03d805ec200Zhcn(p1: _p1);

  @override
  _$9b6d2d9e6aeea98cebd6d49f0bad35cbb8ddcb98Zhcn get of =>
      _$9b6d2d9e6aeea98cebd6d49f0bad35cbb8ddcb98Zhcn(p1: _p1);

  @override
  _$d8a744834c10acaf98f07597f40b1ce70a17741bZhcn get and =>
      _$d8a744834c10acaf98f07597f40b1ce70a17741bZhcn(p1: _p1);

  @override
  _$6ecad9b466c3326c4cd3efd2c4d1a27a6c363c35Zhcn get or =>
      _$6ecad9b466c3326c4cd3efd2c4d1a27a6c363c35Zhcn(p1: _p1);

  @override
  String get hasBeenCompleted => "${_p1}已完成。";

  @override
  String get haveBeenCompleted => "${_p1}已完成。";

  @override
  String get hasBeenSuccessful => "我成功地${_p1}。";

  @override
  String get haveBeenSuccessful => "我成功地${_p1}。";

  @override
  String get hasFailed => "${_p1}失败。";

  @override
  String get haveFailed => "${_p1}失败。";

  @override
  String get isNotEntered => "${_p1}未输入。";

  @override
  String get isNotSelected => "${_p1}未选择。";

  @override
  String get mayBeIncorrect => "${_p1}可能是错误的。";

  @override
  String get doesNotMatch => "${_p1}不匹配。";

  @override
  String get notFound => "${_p1}找不到。";

  @override
  String get hasStarted => "${_p1} 开始了。";

  @override
  String get haveStarted => "${_p1} 开始了。";

  @override
  String get hasFinished => "${_p1} 已完成。";

  @override
  String get haveFinished => "${_p1} 已完成。";

  @override
  String get hasBeenRestored => "${_p1} 已恢复。";

  @override
  String get haveBeenRestored => "${_p1} 已恢复。";

  @override
  String get isAlreadyDeleted => "${_p1}已被删除。";

  @override
  String get isLoading => "${_p1}正在加载...";

  @override
  String get year => "${_p1}年";

  @override
  String get yearsOld => "${_p1}";

  @override
  String get month => "${_p1}月亮";

  @override
  String get day => "${_p1}一天";

  @override
  String get hour => "${_p1}时间";

  @override
  String get minute => "${_p1}部分";

  @override
  String get second => "${_p1}第二";

  @override
  String get hours => "${_p1}时间";

  @override
  String get minutes => "${_p1}部分";

  @override
  String get seconds => "${_p1}第二";
}

class _$a1dd18c1c4364639c09234f7ad8df55d6c7a6328Kokr
    extends _$a1dd18c1c4364639c09234f7ad8df55d6c7a6328Base {
  const _$a1dd18c1c4364639c09234f7ad8df55d6c7a6328Kokr({super.p1});

  @override
  String $(Object? _p2) => "${_p2} ${_p1}";

  @override
  _$597f8738dba99655c0ca9b79249adc5905900579Kokr get on =>
      _$597f8738dba99655c0ca9b79249adc5905900579Kokr(p1: _p1);

  @override
  _$4fcbb22fb2ccb6326be9df179283c03d805ec200Kokr get in_ =>
      _$4fcbb22fb2ccb6326be9df179283c03d805ec200Kokr(p1: _p1);

  @override
  _$9b6d2d9e6aeea98cebd6d49f0bad35cbb8ddcb98Kokr get of =>
      _$9b6d2d9e6aeea98cebd6d49f0bad35cbb8ddcb98Kokr(p1: _p1);

  @override
  _$d8a744834c10acaf98f07597f40b1ce70a17741bKokr get and =>
      _$d8a744834c10acaf98f07597f40b1ce70a17741bKokr(p1: _p1);

  @override
  _$6ecad9b466c3326c4cd3efd2c4d1a27a6c363c35Kokr get or =>
      _$6ecad9b466c3326c4cd3efd2c4d1a27a6c363c35Kokr(p1: _p1);

  @override
  String get hasBeenCompleted => "${_p1}이 완료되었습니다.";

  @override
  String get haveBeenCompleted => "${_p1}이 완료되었습니다.";

  @override
  String get hasBeenSuccessful => "${_p1}에서 성공했습니다.";

  @override
  String get haveBeenSuccessful => "${_p1}에서 성공했습니다.";

  @override
  String get hasFailed => "${_p1}가 실패했습니다.";

  @override
  String get haveFailed => "${_p1}가 실패했습니다.";

  @override
  String get isNotEntered => "${_p1}이 입력되지 않았습니다.";

  @override
  String get isNotSelected => "${_p1}이 선택되지 않았습니다.";

  @override
  String get mayBeIncorrect => "${_p1}이 잘못 될 수 있습니다.";

  @override
  String get doesNotMatch => "${_p1}이 일치하지 않습니다.";

  @override
  String get notFound => "${_p1}을 찾을 수 없습니다.";

  @override
  String get hasStarted => "${_p1}을 시작했습니다.";

  @override
  String get haveStarted => "${_p1}을 시작했습니다.";

  @override
  String get hasFinished => "${_p1}을 종료했습니다.";

  @override
  String get haveFinished => "${_p1}을 종료했습니다.";

  @override
  String get hasBeenRestored => "${_p1}을 복원했습니다.";

  @override
  String get haveBeenRestored => "${_p1}을 복원했습니다.";

  @override
  String get isAlreadyDeleted => "${_p1}는 이미 삭제되었습니다.";

  @override
  String get isLoading => "${_p1}님이 로드 중입니다...";

  @override
  String get year => "${_p1} 년";

  @override
  String get yearsOld => "${_p1}";

  @override
  String get month => "${_p1} 달";

  @override
  String get day => "${_p1} 낮";

  @override
  String get hour => "${_p1} 시간";

  @override
  String get minute => "${_p1} 부분";

  @override
  String get second => "${_p1} 두번째";

  @override
  String get hours => "${_p1} 시간";

  @override
  String get minutes => "${_p1} 부분";

  @override
  String get seconds => "${_p1} 두번째";
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

class _$597f8738dba99655c0ca9b79249adc5905900579Zhcn
    extends _$597f8738dba99655c0ca9b79249adc5905900579Base {
  const _$597f8738dba99655c0ca9b79249adc5905900579Zhcn({super.p1});

  @override
  String $(Object? _p2) => "${_p1}在${_p2}上";
}

class _$597f8738dba99655c0ca9b79249adc5905900579Kokr
    extends _$597f8738dba99655c0ca9b79249adc5905900579Base {
  const _$597f8738dba99655c0ca9b79249adc5905900579Kokr({super.p1});

  @override
  String $(Object? _p2) => "${_p2}의${_p1}";
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

class _$4fcbb22fb2ccb6326be9df179283c03d805ec200Zhcn
    extends _$4fcbb22fb2ccb6326be9df179283c03d805ec200Base {
  const _$4fcbb22fb2ccb6326be9df179283c03d805ec200Zhcn({super.p1});

  @override
  String $(Object? _p2) => "${_p2}在${_p1}中";
}

class _$4fcbb22fb2ccb6326be9df179283c03d805ec200Kokr
    extends _$4fcbb22fb2ccb6326be9df179283c03d805ec200Base {
  const _$4fcbb22fb2ccb6326be9df179283c03d805ec200Kokr({super.p1});

  @override
  String $(Object? _p2) => "${_p2}의${_p1}";
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

class _$9b6d2d9e6aeea98cebd6d49f0bad35cbb8ddcb98Zhcn
    extends _$9b6d2d9e6aeea98cebd6d49f0bad35cbb8ddcb98Base {
  const _$9b6d2d9e6aeea98cebd6d49f0bad35cbb8ddcb98Zhcn({super.p1});

  @override
  String $(Object? _p2) => "${_p2}的${_p1}";
}

class _$9b6d2d9e6aeea98cebd6d49f0bad35cbb8ddcb98Kokr
    extends _$9b6d2d9e6aeea98cebd6d49f0bad35cbb8ddcb98Base {
  const _$9b6d2d9e6aeea98cebd6d49f0bad35cbb8ddcb98Kokr({super.p1});

  @override
  String $(Object? _p2) => "${_p2}의${_p1}";
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

class _$d8a744834c10acaf98f07597f40b1ce70a17741bZhcn
    extends _$d8a744834c10acaf98f07597f40b1ce70a17741bBase {
  const _$d8a744834c10acaf98f07597f40b1ce70a17741bZhcn({super.p1});

  @override
  String $(Object? _p2) => "${_p2}和${_p1}";
}

class _$d8a744834c10acaf98f07597f40b1ce70a17741bKokr
    extends _$d8a744834c10acaf98f07597f40b1ce70a17741bBase {
  const _$d8a744834c10acaf98f07597f40b1ce70a17741bKokr({super.p1});

  @override
  String $(Object? _p2) => "${_p2}및${_p1}";
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

class _$6ecad9b466c3326c4cd3efd2c4d1a27a6c363c35Zhcn
    extends _$6ecad9b466c3326c4cd3efd2c4d1a27a6c363c35Base {
  const _$6ecad9b466c3326c4cd3efd2c4d1a27a6c363c35Zhcn({super.p1});

  @override
  String $(Object? _p2) => "${_p2}或${_p1}";
}

class _$6ecad9b466c3326c4cd3efd2c4d1a27a6c363c35Kokr
    extends _$6ecad9b466c3326c4cd3efd2c4d1a27a6c363c35Base {
  const _$6ecad9b466c3326c4cd3efd2c4d1a27a6c363c35Kokr({super.p1});

  @override
  String $(Object? _p2) => "${_p2}또는${_p1}";
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

class _$b44b04c9b27cca846b55b5015c24d2fe11b4ad27Zhcn
    extends _$b44b04c9b27cca846b55b5015c24d2fe11b4ad27Base {
  const _$b44b04c9b27cca846b55b5015c24d2fe11b4ad27Zhcn();

  @override
  String $(Object? _p1) => "输入${_p1}。";
}

class _$b44b04c9b27cca846b55b5015c24d2fe11b4ad27Kokr
    extends _$b44b04c9b27cca846b55b5015c24d2fe11b4ad27Base {
  const _$b44b04c9b27cca846b55b5015c24d2fe11b4ad27Kokr();

  @override
  String $(Object? _p1) => "${_p1}을 입력하세요.";
}

abstract class _$a833ede9f85bddd383d93fef040f5fa1cfe21fc2Base {
  const _$a833ede9f85bddd383d93fef040f5fa1cfe21fc2Base();

  String $(Object? _p1) => throw UnimplementedError();
}

class _$a833ede9f85bddd383d93fef040f5fa1cfe21fc2Enus
    extends _$a833ede9f85bddd383d93fef040f5fa1cfe21fc2Base {
  const _$a833ede9f85bddd383d93fef040f5fa1cfe21fc2Enus();

  @override
  String $(Object? _p1) => "Please select ${_p1}.";
}

class _$a833ede9f85bddd383d93fef040f5fa1cfe21fc2Jajp
    extends _$a833ede9f85bddd383d93fef040f5fa1cfe21fc2Base {
  const _$a833ede9f85bddd383d93fef040f5fa1cfe21fc2Jajp();

  @override
  String $(Object? _p1) => "${_p1}を選択してください。";
}

class _$a833ede9f85bddd383d93fef040f5fa1cfe21fc2Zhcn
    extends _$a833ede9f85bddd383d93fef040f5fa1cfe21fc2Base {
  const _$a833ede9f85bddd383d93fef040f5fa1cfe21fc2Zhcn();

  @override
  String $(Object? _p1) => "请选择${_p1}。";
}

class _$a833ede9f85bddd383d93fef040f5fa1cfe21fc2Kokr
    extends _$a833ede9f85bddd383d93fef040f5fa1cfe21fc2Base {
  const _$a833ede9f85bddd383d93fef040f5fa1cfe21fc2Kokr();

  @override
  String $(Object? _p1) => "${_p1}을 선택하세요.";
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

class _$6adf8b0c22ee4670d3ed659c0600bd8968824bfdZhcn
    extends _$6adf8b0c22ee4670d3ed659c0600bd8968824bfdBase {
  const _$6adf8b0c22ee4670d3ed659c0600bd8968824bfdZhcn();

  @override
  _$eb1f6ed39a9fc007b0c0c10cdaf9a1ee3caf9551Zhcn $(Object? _p1) =>
      _$eb1f6ed39a9fc007b0c0c10cdaf9a1ee3caf9551Zhcn(p1: _p1);
}

class _$6adf8b0c22ee4670d3ed659c0600bd8968824bfdKokr
    extends _$6adf8b0c22ee4670d3ed659c0600bd8968824bfdBase {
  const _$6adf8b0c22ee4670d3ed659c0600bd8968824bfdKokr();

  @override
  _$eb1f6ed39a9fc007b0c0c10cdaf9a1ee3caf9551Kokr $(Object? _p1) =>
      _$eb1f6ed39a9fc007b0c0c10cdaf9a1ee3caf9551Kokr(p1: _p1);
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

class _$eb1f6ed39a9fc007b0c0c10cdaf9a1ee3caf9551Zhcn
    extends _$eb1f6ed39a9fc007b0c0c10cdaf9a1ee3caf9551Base {
  const _$eb1f6ed39a9fc007b0c0c10cdaf9a1ee3caf9551Zhcn({super.p1});

  @override
  String get onceDeletedItCannotBeUndone => "删除${_p1}。\n\n一旦删除，它就无法恢复。";
}

class _$eb1f6ed39a9fc007b0c0c10cdaf9a1ee3caf9551Kokr
    extends _$eb1f6ed39a9fc007b0c0c10cdaf9a1ee3caf9551Base {
  const _$eb1f6ed39a9fc007b0c0c10cdaf9a1ee3caf9551Kokr({super.p1});

  @override
  String get onceDeletedItCannotBeUndone =>
      "${_p1}을 삭제합니다. \n\n일단 삭제되면 복원 할 수 없습니다.";
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

class _$8a438be392348d81ac50aaadb1da949eef9c3934Zhcn
    extends _$8a438be392348d81ac50aaadb1da949eef9c3934Base {
  const _$8a438be392348d81ac50aaadb1da949eef9c3934Zhcn();

  @override
  _$6551f44e930f0892d29ae2e6dd357426a7ef3054Zhcn $(Object? _p1) =>
      _$6551f44e930f0892d29ae2e6dd357426a7ef3054Zhcn(p1: _p1);
}

class _$8a438be392348d81ac50aaadb1da949eef9c3934Kokr
    extends _$8a438be392348d81ac50aaadb1da949eef9c3934Base {
  const _$8a438be392348d81ac50aaadb1da949eef9c3934Kokr();

  @override
  _$6551f44e930f0892d29ae2e6dd357426a7ef3054Kokr $(Object? _p1) =>
      _$6551f44e930f0892d29ae2e6dd357426a7ef3054Kokr(p1: _p1);
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

class _$6551f44e930f0892d29ae2e6dd357426a7ef3054Zhcn
    extends _$6551f44e930f0892d29ae2e6dd357426a7ef3054Base {
  const _$6551f44e930f0892d29ae2e6dd357426a7ef3054Zhcn({super.p1});

  @override
  String get areYouSure => "报告${_p1}。\n\n您确定吗？";
}

class _$6551f44e930f0892d29ae2e6dd357426a7ef3054Kokr
    extends _$6551f44e930f0892d29ae2e6dd357426a7ef3054Base {
  const _$6551f44e930f0892d29ae2e6dd357426a7ef3054Kokr({super.p1});

  @override
  String get areYouSure => "보고서 ${_p1}. \n\n 확실합니까?";
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

class _$829e6374acf4ab691be4fc6ce556e2576add22e7Zhcn
    extends _$829e6374acf4ab691be4fc6ce556e2576add22e7Base {
  const _$829e6374acf4ab691be4fc6ce556e2576add22e7Zhcn();

  @override
  _$7a0a08d617c4156925e99a933907f4ad95f63934Zhcn $(Object? _p1) =>
      _$7a0a08d617c4156925e99a933907f4ad95f63934Zhcn(p1: _p1);
}

class _$829e6374acf4ab691be4fc6ce556e2576add22e7Kokr
    extends _$829e6374acf4ab691be4fc6ce556e2576add22e7Base {
  const _$829e6374acf4ab691be4fc6ce556e2576add22e7Kokr();

  @override
  _$7a0a08d617c4156925e99a933907f4ad95f63934Kokr $(Object? _p1) =>
      _$7a0a08d617c4156925e99a933907f4ad95f63934Kokr(p1: _p1);
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

class _$7a0a08d617c4156925e99a933907f4ad95f63934Zhcn
    extends _$7a0a08d617c4156925e99a933907f4ad95f63934Base {
  const _$7a0a08d617c4156925e99a933907f4ad95f63934Zhcn({super.p1});

  @override
  String get count => "最多${_p1}";

  @override
  String get length => "最多${_p1}字符";
}

class _$7a0a08d617c4156925e99a933907f4ad95f63934Kokr
    extends _$7a0a08d617c4156925e99a933907f4ad95f63934Base {
  const _$7a0a08d617c4156925e99a933907f4ad95f63934Kokr({super.p1});

  @override
  String get count => "${_p1}개까지";

  @override
  String get length => "최대 ${_p1} 문자";
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

class _$67f61375c8b62f901352632a07aded48a57ff85fZhcn
    extends _$67f61375c8b62f901352632a07aded48a57ff85fBase {
  const _$67f61375c8b62f901352632a07aded48a57ff85fZhcn();

  @override
  String $(Object? _p1) => "返回${_p1}";
}

class _$67f61375c8b62f901352632a07aded48a57ff85fKokr
    extends _$67f61375c8b62f901352632a07aded48a57ff85fBase {
  const _$67f61375c8b62f901352632a07aded48a57ff85fKokr();

  @override
  String $(Object? _p1) => "${_p1}로 돌아갑니다.";
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

class _$20fad005e0b3bb9dde825fc81961b62b2c73efd2Zhcn
    extends _$20fad005e0b3bb9dde825fc81961b62b2c73efd2Base {
  const _$20fad005e0b3bb9dde825fc81961b62b2c73efd2Zhcn();

  @override
  String $(Object? _p1) => "继续${_p1}";
}

class _$20fad005e0b3bb9dde825fc81961b62b2c73efd2Kokr
    extends _$20fad005e0b3bb9dde825fc81961b62b2c73efd2Base {
  const _$20fad005e0b3bb9dde825fc81961b62b2c73efd2Kokr();

  @override
  String $(Object? _p1) => "${_p1}로 진행";
}

abstract class _$8188dd5c635a839e3c04a430552a5c708948c159Base {
  const _$8188dd5c635a839e3c04a430552a5c708948c159Base();

  String $(Object? _p1) => throw UnimplementedError();
}

class _$8188dd5c635a839e3c04a430552a5c708948c159Enus
    extends _$8188dd5c635a839e3c04a430552a5c708948c159Base {
  const _$8188dd5c635a839e3c04a430552a5c708948c159Enus();

  @override
  String $(Object? _p1) => "Register ${_p1}";
}

class _$8188dd5c635a839e3c04a430552a5c708948c159Jajp
    extends _$8188dd5c635a839e3c04a430552a5c708948c159Base {
  const _$8188dd5c635a839e3c04a430552a5c708948c159Jajp();

  @override
  String $(Object? _p1) => "${_p1}を登録";
}

class _$8188dd5c635a839e3c04a430552a5c708948c159Zhcn
    extends _$8188dd5c635a839e3c04a430552a5c708948c159Base {
  const _$8188dd5c635a839e3c04a430552a5c708948c159Zhcn();

  @override
  String $(Object? _p1) => "注册${_p1}";
}

class _$8188dd5c635a839e3c04a430552a5c708948c159Kokr
    extends _$8188dd5c635a839e3c04a430552a5c708948c159Base {
  const _$8188dd5c635a839e3c04a430552a5c708948c159Kokr();

  @override
  String $(Object? _p1) => "${_p1} 등록";
}

abstract class _$74668b3ca73e99afbde0a422d31e6a07ed6cd315Base {
  const _$74668b3ca73e99afbde0a422d31e6a07ed6cd315Base();

  String $(Object? _p1) => throw UnimplementedError();
}

class _$74668b3ca73e99afbde0a422d31e6a07ed6cd315Enus
    extends _$74668b3ca73e99afbde0a422d31e6a07ed6cd315Base {
  const _$74668b3ca73e99afbde0a422d31e6a07ed6cd315Enus();

  @override
  String $(Object? _p1) => "Release ${_p1}";
}

class _$74668b3ca73e99afbde0a422d31e6a07ed6cd315Jajp
    extends _$74668b3ca73e99afbde0a422d31e6a07ed6cd315Base {
  const _$74668b3ca73e99afbde0a422d31e6a07ed6cd315Jajp();

  @override
  String $(Object? _p1) => "${_p1}を解除";
}

class _$74668b3ca73e99afbde0a422d31e6a07ed6cd315Zhcn
    extends _$74668b3ca73e99afbde0a422d31e6a07ed6cd315Base {
  const _$74668b3ca73e99afbde0a422d31e6a07ed6cd315Zhcn();

  @override
  String $(Object? _p1) => "删除${_p1}";
}

class _$74668b3ca73e99afbde0a422d31e6a07ed6cd315Kokr
    extends _$74668b3ca73e99afbde0a422d31e6a07ed6cd315Base {
  const _$74668b3ca73e99afbde0a422d31e6a07ed6cd315Kokr();

  @override
  String $(Object? _p1) => "${_p1} 해제";
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

class _$00d0796f61e7ee7614446fbc3f31ae7dbab192adZhcn
    extends _$00d0796f61e7ee7614446fbc3f31ae7dbab192adBase {
  const _$00d0796f61e7ee7614446fbc3f31ae7dbab192adZhcn();

  @override
  _$594f7a710f7d9c0e98a472b0f1fc3c80099a96e8Zhcn $(Object? _p1) =>
      _$594f7a710f7d9c0e98a472b0f1fc3c80099a96e8Zhcn(p1: _p1);
}

class _$00d0796f61e7ee7614446fbc3f31ae7dbab192adKokr
    extends _$00d0796f61e7ee7614446fbc3f31ae7dbab192adBase {
  const _$00d0796f61e7ee7614446fbc3f31ae7dbab192adKokr();

  @override
  _$594f7a710f7d9c0e98a472b0f1fc3c80099a96e8Kokr $(Object? _p1) =>
      _$594f7a710f7d9c0e98a472b0f1fc3c80099a96e8Kokr(p1: _p1);
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

class _$594f7a710f7d9c0e98a472b0f1fc3c80099a96e8Zhcn
    extends _$594f7a710f7d9c0e98a472b0f1fc3c80099a96e8Base {
  const _$594f7a710f7d9c0e98a472b0f1fc3c80099a96e8Zhcn({super.p1});

  @override
  _$2fbaf5fc413fd181e48c4ffe1ab411d67289d483Zhcn get unread =>
      _$2fbaf5fc413fd181e48c4ffe1ab411d67289d483Zhcn(p1: _p1);
}

class _$594f7a710f7d9c0e98a472b0f1fc3c80099a96e8Kokr
    extends _$594f7a710f7d9c0e98a472b0f1fc3c80099a96e8Base {
  const _$594f7a710f7d9c0e98a472b0f1fc3c80099a96e8Kokr({super.p1});

  @override
  _$2fbaf5fc413fd181e48c4ffe1ab411d67289d483Kokr get unread =>
      _$2fbaf5fc413fd181e48c4ffe1ab411d67289d483Kokr(p1: _p1);
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

class _$2fbaf5fc413fd181e48c4ffe1ab411d67289d483Zhcn
    extends _$2fbaf5fc413fd181e48c4ffe1ab411d67289d483Base {
  const _$2fbaf5fc413fd181e48c4ffe1ab411d67289d483Zhcn({super.p1});

  @override
  String $(Object? _p2) => "${_p1}情况有一个未读的${_p2}。";
}

class _$2fbaf5fc413fd181e48c4ffe1ab411d67289d483Kokr
    extends _$2fbaf5fc413fd181e48c4ffe1ab411d67289d483Base {
  const _$2fbaf5fc413fd181e48c4ffe1ab411d67289d483Kokr({super.p1});

  @override
  String $(Object? _p2) => "${_p1} 사례의 읽지 않은 ${_p2}가 있습니다.";
}
