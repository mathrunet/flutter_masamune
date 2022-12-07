// ignore_for_file: prefer_final_fields

part of katana_auth;

const _kIsVerifiedKey = "isVerified";
const _kIsAnonymouslyKey = "isAnonymously";
const _kUserIdKey = "userId";
const _kUserNameKey = "userName";
const _kUserEmailKey = "userEmail";
const _kUserPasswordKey = "userPassword";
const _kUserPhoneNumberKey = "userPhoneNumber";
const _kUserPhotoURLKey = "userPhotoURL";
const _kEmailLinkUrlKey = "emailLinkUrl";
const _kSmsCodeKey = "smsCode";
const _kActiveProvidersKey = "activeProviders";

const _kTempUserEmailKey = "tmpUserEmail";
const _kTempUserPhoneNumberKey = "tmpPhoneNumber";

/// A database for managing authentication information locally.
///
/// It is used for testing authentication, for example.
///
/// It is possible to implement settings during initialization with [onInitialize].
///
/// You can describe the process of restoring authentication information with [tryRestoreAuth] in [onLoad], and when there is a change in authentication, you can save the information with [onSaved].
///
/// This also allows authentication information to be stored locally within the terminal.
///
/// It is possible to test each email and SMS sending process with [onSendRegisteredEmail], [onSendEmailLink], [onSendSMS], [onResetPassword] and [onSendVerificationEmail].
///
/// The password to be reset when [reset] is executed can be specified in [resetPassword].
///
/// ローカルで認証情報を管理するためのデータベース。
///
/// 認証をテストする際などに利用します。
///
/// [onInitialize]で初期化時の設定を実装することが可能です。
///
/// [onLoad]で[tryRestoreAuth]で認証情報を復元する際の処理を記述することができ、認証に変更があった場合、[onSaved]で情報を保存することができます。
///
/// これにより、端末ローカル内に認証情報を保存することも可能です。
///
/// [onSendRegisteredEmail]や[onSendEmailLink]、[onSendSMS]、[onResetPassword]、[onSendVerificationEmail]で各メールやSMSの送信処理をテストすることが可能です。
///
/// [reset]が実行された場合リセットされるパスワードを[resetPassword]で指定することが可能です。
class AuthDatabase {
  /// A database for managing authentication information locally.
  ///
  /// It is used for testing authentication, for example.
  ///
  /// It is possible to implement settings during initialization with [onInitialize].
  ///
  /// You can describe the process of restoring authentication information with [tryRestoreAuth] in [onLoad], and when there is a change in authentication, you can save the information with [onSaved].
  ///
  /// This also allows authentication information to be stored locally within the terminal.
  ///
  /// It is possible to test each email and SMS sending process with [onSendRegisteredEmail], [onSendEmailLink], [onSendSMS], [onResetPassword] and [onSendVerificationEmail].
  ///
  /// The password to be reset when [reset] is executed can be specified in [resetPassword].
  ///
  /// ローカルで認証情報を管理するためのデータベース。
  ///
  /// 認証をテストする際などに利用します。
  ///
  /// [onInitialize]で初期化時の設定を実装することが可能です。
  ///
  /// [onLoad]で[tryRestoreAuth]で認証情報を復元する際の処理を記述することができ、認証に変更があった場合、[onSaved]で情報を保存することができます。
  ///
  /// これにより、端末ローカル内に認証情報を保存することも可能です。
  ///
  /// [onSendRegisteredEmail]や[onSendEmailLink]、[onSendSMS]、[onResetPassword]、[onSendVerificationEmail]で各メールやSMSの送信処理をテストすることが可能です。
  ///
  /// [reset]が実行された場合リセットされるパスワードを[resetPassword]で指定することが可能です。
  AuthDatabase({
    this.onInitialize,
    this.onLoad,
    this.onSaved,
    this.onSendRegisteredEmail,
    this.onSendEmailLink,
    this.onSendSMS,
    this.onResetPassword,
    this.onSendVerificationEmail,
    this.resetPassword = "01234567",
    this.defaultLocale = const Locale("en", "US"),
  }) {
    onInitialize?.call(this);
  }
  DynamicMap _data = {};

  /// Default locale when [Locale] is not set.
  ///
  /// The `en_US` is set as default.
  ///
  /// [Locale]が設定されていないときのデフォルトロケール。
  ///
  /// `en_US`がデフォルトとして設定されています。
  final Locale defaultLocale;

  /// Password to be reset when [reset] is executed.
  ///
  /// [reset]が実行された場合リセットされるパスワード。
  final String resetPassword;

  /// Executed at Database initialization time.
  ///
  /// Databaseの初期化時に実行されます。
  final Future<void> Function(AuthDatabase database)? onInitialize;

  /// Executed when saving the Database.
  ///
  /// Databaseの保存時に実行されます。
  final Future<void> Function(AuthDatabase database)? onSaved;

  /// Executed when loading Database.
  ///
  /// Databaseの読み込み時に実行されます。
  final Future<void> Function(AuthDatabase database)? onLoad;

  /// It is executed when the registration completion email is sent.
  ///
  /// The recipient's email address is passed to `email`, the password to `password`, and the language setting to `locale`.
  ///
  /// 登録完了メールを送信する際に実行されます。
  ///
  /// `email`に送信先のメールアドレス、`password`にパスワード、`locale`に言語設定が渡されます。
  final Future<void> Function(String email, String password, Locale locale)?
      onSendRegisteredEmail;

  /// Executed when issuing a mail link.
  ///
  /// The `email` is the email address of the recipient, the `url` is the email link, and the `locale` is the language setting.
  ///
  /// メールリンクを発行する際に実行されます。
  ///
  /// `email`に送信先のメールアドレス、`url`にメールリンク、`locale`に言語設定が渡されます。
  final Future<void> Function(String email, String url, Locale locale)?
      onSendEmailLink;

  /// It is executed when sending an SMS.
  ///
  /// The `phoneNumber` is the phone number of the recipient, the `code` is the generated authentication code, and the `locale` is the language setting.
  ///
  /// Please return the code for authentication that you sent.
  ///
  /// SMSを送信する際に実行されます。
  ///
  /// `phoneNumber`に送信先の電話番号、`code`に生成された認証用コード、`locale`に言語設定が渡されます。
  ///
  /// 送信した認証用コードを返してください。
  final Future<String> Function(String phoneNumber, String code, Locale locale)?
      onSendSMS;

  /// It is executed when sending an authentication email.
  ///
  /// The `email` is the email address of the recipient and `locale` is the language setting.
  ///
  /// 認証用メールを送る際に実行されます。
  ///
  /// `email`に送信先のメールアドレス、locale`に言語設定が渡されます。
  final Future<void> Function(String email, Locale locale)?
      onSendVerificationEmail;

  /// This is performed when resetting a password.
  ///
  /// The `newPassword` is passed [resetPassword] and the `locale` is passed the language setting.
  ///
  /// Returns the actual password to be changed.
  ///
  /// パスワードをリセットする際に実行されます。
  ///
  /// `newPassword`に[resetPassword]、`locale`に言語設定が渡されます。
  ///
  /// 実際に変更されるパスワードを返します。
  final Future<String> Function(String newPassword, Locale locale)?
      onResetPassword;

  /// If you are signed in, `true` is returned.
  ///
  /// サインインしている場合、`true`が返されます。
  bool get isSignedIn => _data.get(_kUserIdKey, "").isNotEmpty;

  /// Returns `true` if the registration has been authenticated.
  ///
  /// 登録が認証済みの場合`true`を返します。
  bool get isVerified => _data.get(_kIsVerifiedKey, false);

  /// Returns `true` in case of anonymous or guest authentication.
  ///
  /// 匿名認証、ゲスト認証の場合、`true`を返します。
  bool get isAnonymously => _data.get(_kIsAnonymouslyKey, false);

  /// Returns `true` if [confirmSignIn] or [confirmChange] is required.
  ///
  /// [confirmSignIn]や[confirmChange]の実行を必要とする場合`true`を返します。
  bool get isWaitingConfirmation =>
      _data.get(_kEmailLinkUrlKey, "").isNotEmpty ||
      _data.get(_kSmsCodeKey, "").isNotEmpty;

  /// Returns the user ID on the authentication platform during sign-in.
  ///
  /// This ID is unique and can be used as a unique ID to register in the user's DB.
  ///
  /// サインイン時、認証プラットフォーム上のユーザーIDを返します。
  ///
  /// このIDはユニークなものとなっているためユーザーのDBに登録するユニークIDとして利用可能です。
  String get userId => _data.get(_kUserIdKey, "");

  /// Returns the user name on the authentication platform during sign-in.
  ///
  /// サインイン時、、認証プラットフォーム上のユーザー名を返します。
  String get userName => _data.get(_kUserNameKey, "");

  /// Returns the email address registered with the authentication platform upon sign-in.
  ///
  /// サインイン時、認証プラットフォームに登録されたメールアドレスを返します。
  String get userEmail => _data.get(_kUserEmailKey, "");

  /// Returns the phone number registered with the authentication platform upon sign-in.
  ///
  /// サインイン時、認証プラットフォームに登録された電話番号を返します。
  String get userPhoneNumber => _data.get(_kUserPhoneNumberKey, "");

  /// Returns the URL of the user's icon registered on the authentication platform during sign-in.
  ///
  /// Basically, it is used to obtain icons registered on social networking sites.
  /// (Some SNS platforms may not be able to obtain this information.)
  ///
  /// サインイン時、認証プラットフォームに登録されたのユーザーアイコンのURLを返します。
  ///
  /// 基本的にSNSで登録されているアイコンを取得するために利用します。
  /// （SNSプラットフォームによっては取得できない場合もあります。）
  String get userPhotoURL => _data.get(_kUserPhotoURLKey, "");

  /// Returns a list of authenticated provider IDs upon sign-in.
  ///
  /// サインイン時、認証されたプロバイダーのID一覧を返します。
  List<String> get activeProviderIds => _data.getAsList(_kActiveProvidersKey);

  /// Returns the stored password.
  ///
  /// 保存されたパスワードを返します。
  String get userPassword => _data.get(_kUserPasswordKey, "");

  /// The respective authentication data can be entered directly.
  ///
  /// それぞれの認証データを直接入力することができます。
  void setRawData({
    bool? isVerified,
    bool? isAnonymously,
    String? userId,
    String? userName,
    String? userEmail,
    String? userPhoneNumber,
    String? userPhotoURL,
    String? userPassword,
  }) {
    _data.addAll({
      if (isVerified != null) _kIsVerifiedKey: isVerified,
      if (isAnonymously != null) _kIsAnonymouslyKey: isAnonymously,
      if (userId != null) _kUserIdKey: userId,
      if (userName != null) _kUserNameKey: userName,
      if (userEmail != null) _kUserEmailKey: userEmail,
      if (userPhoneNumber != null) _kUserPhoneNumberKey: userPhoneNumber,
      if (userPhotoURL != null) _kUserPhotoURLKey: userPhotoURL,
      if (userPassword != null) _kUserPasswordKey: userPassword,
    });
  }

  /// Running the application at startup will automatically re-authenticate the user.
  ///
  /// [onLoad] is executed and [isSignedIn] is returned.
  /// Therefore, it returns `true` if you are signed in with the loaded credentials.
  ///
  /// アプリ起動時に実行することで自動的に再認証を行ないます。
  ///
  /// [onLoad]が実行され、[isSignedIn]が返されます。
  /// そのため読み込んだ認証情報でサインインされていれば`true`を返します。
  Future<bool> tryRestoreAuth() async {
    await onLoad?.call(this);
    return isSignedIn;
  }

  /// Register a user by passing a class inheriting from [RegisterAuthProvider] in [provider].
  ///
  /// [RegisterAuthProvider]を継承したクラスを[provider]で渡すことにより、ユーザーの登録を行います。
  Future<void> register({
    required RegisterAuthProvider provider,
  }) async {
    await signOut();
    if (provider is EmailAndPasswordRegisterAuthProvider) {
      if (_data.containsKey(_kUserEmailKey)) {
        throw Exception(
          "This Email address is already registered. Please register another email address.",
        );
      }
      _data[_kUserIdKey] = uuid;
      _data[_kUserEmailKey] = provider.email;
      _data[_kUserPasswordKey] = provider.password;
      _data[_kActiveProvidersKey] = {
        ...activeProviderIds,
        provider.providerId,
      }.toList();
      await onSendRegisteredEmail?.call(
        provider.email,
        provider.password,
        provider.locale ?? defaultLocale,
      );
    }
    await onSaved?.call(this);
  }

  /// Sign-in is performed by passing a class inheriting from [SignInAuthProvider] as [provider].
  ///
  /// [SignInAuthProvider]を継承したクラスを[provider]で渡すことにより、サインインを行ないます。
  Future<void> signIn({
    required SignInAuthProvider provider,
  }) async {
    await signOut();
    if (provider is AnonymouslySignInAuthProvider ||
        provider is SnsSignInAuthProvider) {
      _data[_kUserIdKey] = uuid;
      _data[_kIsAnonymouslyKey] = true;
      _data[_kActiveProvidersKey] = {
        ...activeProviderIds,
        provider.providerId,
      }.toList();
    } else if (provider is EmailAndPasswordSignInAuthProvider) {
      if (_data[_kUserEmailKey] != provider.email ||
          _data[_kUserPasswordKey] != provider.password) {
        throw Exception("ID or Password is invalid.");
      }
      _data[_kUserIdKey] = uuid;
      _data[_kActiveProvidersKey] = {
        ...activeProviderIds,
        provider.providerId,
      }.toList();
    } else if (provider is EmailLinkSignInAuthProvider) {
      await onSendEmailLink?.call(
        provider.email,
        provider.url,
        provider.locale ?? defaultLocale,
      );
      _data[_kEmailLinkUrlKey] = provider.url;
      _data[_kTempUserEmailKey] = provider.email;
    } else if (provider is SmsSignInAuthProvider) {
      final code = generateCode(6, charSet: "01223456789");
      await onSendSMS?.call(
        provider.phoneNumber,
        code,
        provider.locale ?? defaultLocale,
      );
      _data[_kTempUserPhoneNumberKey] = provider.phoneNumber;
      _data[_kSmsCodeKey] = code;
    }
    await onSaved?.call(this);
  }

  /// If you [signIn] with [EmailLinkSignInAuthProvider] or [SmsSignInAuthProvider], you need to check the authentication code received from email or SMS.
  /// In that case, use this method to finalize the sign-in.
  ///
  /// Confirm sign-in is confirmed by passing a class inheriting from [ConfirmSignInAuthProvider] in [provider].
  ///
  /// [EmailLinkSignInAuthProvider]や[SmsSignInAuthProvider]などで[signIn]した場合、メールやSMSから受け取った認証コードをチェックする必要があります。
  /// その場合、このメソッドを利用してサインインを確定させてください。
  ///
  /// [ConfirmSignInAuthProvider]を継承したクラスを[provider]で渡すことにより、サインインを確定させます。
  Future<void> confirmSignIn({
    required ConfirmSignInAuthProvider provider,
  }) async {
    if (provider is EmailLinkConfirmSignInAuthProvider) {
      final emailLink = _data.get(_kEmailLinkUrlKey, "");
      final email = _data.get(_kTempUserEmailKey, "");
      if (emailLink != provider.url || email.isEmpty) {
        throw Exception(
          "Your Email is not registered. Please register it with [signIn] beforehand.",
        );
      }
      _data[_kUserIdKey] = uuid;
      _data[_kUserEmailKey] = email;
      _data.remove(_kEmailLinkUrlKey);
      _data.remove(_kTempUserEmailKey);
      _data[_kActiveProvidersKey] = {
        ...activeProviderIds,
        provider.providerId,
      }.toList();
    } else if (provider is SmsConfirmSignInAuthProvider) {
      final phoenNumber = _data.get(_kTempUserPhoneNumberKey, "");
      if (phoenNumber.isEmpty) {
        throw Exception(
          "Phone number is not registered. Please register it with [signIn] beforehand.",
        );
      }
      _data[_kUserIdKey] = uuid;
      _data[_kUserPhoneNumberKey] = phoenNumber;
      _data.remove(_kSmsCodeKey);
      _data.remove(_kTempUserPhoneNumberKey);
      _data[_kActiveProvidersKey] = {
        ...activeProviderIds,
        provider.providerId,
      }.toList();
    }
    await onSaved?.call(this);
  }

  /// If you are signed in, this is used to perform an authentication check just before changing information for authentication (e.g., email address).
  ///
  /// Reauthentication is performed by passing a class inheriting from [ReAuthProvider] in [provider].
  ///
  /// サインインしている場合、認証用の情報（メールアドレスなど）を変更する直前に認証チェックを行うために利用します。
  ///
  /// [ReAuthProvider]を継承したクラスを[provider]で渡すことにより、再認証を行ないます。
  Future<bool> reauth({
    required ReAuthProvider provider,
  }) async {
    if (provider is EmailAndPasswordReAuthProvider) {
      return _data[_kUserPasswordKey] == provider.password;
    } else {
      throw Exception(
        "This provider is not supported: ${provider.runtimeType}",
      );
    }
  }

  /// Used to reset the password.
  ///
  /// Reset is performed by passing a class inheriting from [ResetAuthProvider] in [provider].
  ///
  /// パスワードをリセットする場合に利用します。
  ///
  /// [ResetAuthProvider]を継承したクラスを[provider]で渡すことにより、リセットを行ないます。
  Future<void> reset({
    required ResetAuthProvider provider,
  }) async {
    if (provider is EmailAndPasswordResetAuthProvider) {
      final password = await onResetPassword?.call(
        resetPassword,
        provider.locale ?? defaultLocale,
      );
      _data[_kUserPasswordKey] = password;
    } else {
      throw Exception(
        "This provider is not supported: ${provider.runtimeType}",
      );
    }
    await onSaved?.call(this);
  }

  /// Used to prove possession of the e-mail address.
  ///
  /// Normally, this is done to send an authentication email.
  ///
  /// Authentication is performed by passing a class inheriting from [VerifyAuthProvider] as [provider].
  ///
  /// メールアドレスの所有を証明するために利用します。
  ///
  /// 通常はこれを実行することで認証用のメールを送信します。
  ///
  /// [VerifyAuthProvider]を継承したクラスを[provider]で渡すことにより、認証を行ないます。
  Future<void> verify({
    required VerifyAuthProvider provider,
  }) async {
    if (provider is EmailAndPasswordVerifyAuthProvider) {
      await onSendVerificationEmail?.call(
        userEmail,
        provider.locale ?? defaultLocale,
      );
      _data[_kIsVerifiedKey] = true;
    } else if (provider is EmailLinkVerifyAuthProvider) {
      await onSendVerificationEmail?.call(
        userEmail,
        provider.locale ?? defaultLocale,
      );
      _data[_kIsVerifiedKey] = true;
    }
    await onSaved?.call(this);
  }

  /// Used to change the registered information.
  ///
  /// Change information by passing a class inheriting from [ChangeAuthProvider] with [provider].
  ///
  /// 登録されている情報を変更する場合に利用します。
  ///
  /// [ChangeAuthProvider]を継承したクラスを[provider]で渡すことにより、情報の変更を行ないます。
  Future<void> change({
    required ChangeAuthProvider provider,
  }) async {
    if (provider is ChangeEmailAuthProvider) {
      _data[_kUserEmailKey] = provider.email;
    } else if (provider is ChangePasswordAuthProvider) {
      _data[_kUserPasswordKey] = provider.password;
    } else if (provider is ChangePhoneNumberAuthProvider) {
      final code = generateCode(6, charSet: "01223456789");
      await onSendSMS?.call(
        provider.phoneNumber,
        code,
        provider.locale ?? defaultLocale,
      );
      _data[_kTempUserPhoneNumberKey] = provider.phoneNumber;
      _data[_kSmsCodeKey] = code;
    }
    await onSaved?.call(this);
  }

  /// If you [change] with [ChangePhoneNumberAuthProvider], for example, you need to check the authentication code you received from an email or SMS.
  /// In that case, use this method to finalize the change.
  ///
  /// Confirm sign-in by passing a class inheriting from [ConfirmChangeAuthProvider] with [provider].
  ///
  /// [ChangePhoneNumberAuthProvider]などで[change]した場合、メールやSMSから受け取った認証コードをチェックする必要があります。
  /// その場合、このメソッドを利用して変更を確定させてください。
  ///
  /// [ConfirmChangeAuthProvider]を継承したクラスを[provider]で渡すことにより、サインインを確定させます。
  Future<void> confirmChange({
    required ConfirmChangeAuthProvider provider,
  }) async {
    if (provider is ConfirmChangePhoneNumberAuthProvider) {
      final phoenNumber = _data.get(_kTempUserPhoneNumberKey, "");
      if (phoenNumber.isEmpty) {
        throw Exception(
          "Phone number is not registered. Please register it with [signIn] beforehand.",
        );
      }
      _data[_kUserPhoneNumberKey] = phoenNumber;
      _data.remove(_kSmsCodeKey);
      _data.remove(_kTempUserPhoneNumberKey);
    }
    await onSaved?.call(this);
  }

  /// Sign out if you are already signed in.
  ///
  /// すでにサインインしている場合サインアウトします。
  Future<void> signOut() async {
    _data.remove(_kIsVerifiedKey);
    _data.remove(_kIsAnonymouslyKey);
    _data.remove(_kUserIdKey);
    _data.remove(_kUserNameKey);
    _data.remove(_kUserEmailKey);
    _data.remove(_kUserPasswordKey);
    _data.remove(_kUserPhoneNumberKey);
    _data.remove(_kUserPhotoURLKey);
    _data.remove(_kEmailLinkUrlKey);
    _data.remove(_kSmsCodeKey);
    _data.remove(_kActiveProvidersKey);
    await onSaved?.call(this);
  }

  /// Deletes already registered users.
  ///
  /// Users created by [AuthProvider] who are registered together with [signIn] even if [register] is not executed are also eligible.
  ///
  /// すでに登録されているユーザーを削除します。
  ///
  /// [register]が実行されていない場合でも[signIn]で合わせて登録が行われる[AuthProvider]で作成されたユーザーも対象となります。
  Future<void> delete() async {
    _data.clear();
    await signOut();
  }

  /// Destroy the database.
  ///
  /// All registered users will be deleted.
  ///
  /// データベースを破棄します。
  ///
  /// 登録されているユーザーはすべて削除されます。
  void dispose() => _data.clear();
}
