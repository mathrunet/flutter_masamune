// ignore_for_file: prefer_final_fields

part of katana_auth;

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
/// It is possible to test each email and SMS sending process with [onSendRegisteredEmail], [onSendEmailLink], [onSendSMS], [onResetPassword] and [onVerify].
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
/// [onSendRegisteredEmail]や[onSendEmailLink]、[onSendSMS]、[onResetPassword]、[onVerify]で各メールやSMSの送信処理をテストすることが可能です。
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
  /// It is possible to test each email and SMS sending process with [onSendRegisteredEmail], [onSendEmailLink], [onSendSMS], [onResetPassword] and [onVerify].
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
  /// [onSendRegisteredEmail]や[onSendEmailLink]、[onSendSMS]、[onResetPassword]、[onVerify]で各メールやSMSの送信処理をテストすることが可能です。
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
    this.onVerify,
    this.resetPassword = "01234567",
    this.debugSmsCode,
    this.debugUserId,
    this.defaultLocale = const Locale("en", "US"),
  });

  bool _initialized = false;
  Completer<void>? _completer;
  DynamicMap _data = {};
  String? _activeId;
  String? _registeredCurrentId;
  final Map<String, DynamicMap> _registeredInitialValue = {};
  final List<String> _appliedInitialValue = [];

  /// Key to authenticated or not.
  ///
  /// 認証済みかどうかのキー。
  static const verifiedKey = "verified";

  /// Key to anonymous or not.
  ///
  /// 匿名かどうかのキー。
  static const anonymouslyKey = "anonymously";

  /// User ID key.
  ///
  /// ユーザーIDのキー。
  static const userIdKey = "uid";

  /// User name key.
  ///
  /// ユーザー名のキー。
  static const userNameKey = "name";

  /// User email key.
  ///
  /// ユーザーのメールアドレスのキー。
  static const userEmailKey = "email";

  /// User password key.
  ///
  /// ユーザーのパスワードのキー。
  static const userPasswordKey = "password";

  /// User phone number key.
  ///
  /// ユーザーの電話番号のキー。
  static const userPhoneNumberKey = "phoneNumber";

  /// User photo URL key.
  ///
  /// ユーザーのアイコンのURLのキー。
  static const userPhotoURLKey = "photoURL";

  /// URL for email link.
  ///
  /// メールリンク用のURL。
  static const emailLinkUrlKey = "emailLinkUrl";

  /// SMS code key.
  ///
  /// SMSコードのキー。
  static const smsCodeKey = "smsCode";

  /// User's active provider ID key.
  ///
  /// ユーザーのアクティブなプロバイダーIDのキー。
  static const activeProvidersKey = "activeProviders";

  /// Key for temporary email address.
  ///
  /// 仮のメールアドレス用のキー。
  static const tmpUserEmailKey = "tmpEmail";

  /// Key for temporary phone number.
  ///
  /// 仮の電話番号用のキー。
  static const tmpUserPhoneNumberKey = "tmpPhoneNumber";

  /// If this string is specified, it will be used preferentially when creating [_uuid].
  ///
  /// Use for debugging.
  ///
  /// こちらが指定されている場合、[uuid]を作成する際にこちらの文字列が優先的に利用されます。
  ///
  /// デバッグに利用してください。
  final String? debugUserId;

  /// If this is specified, this string will be used preferentially when generating Sms code.
  ///
  /// Use for debugging.
  ///
  /// こちらが指定されている場合、Smsのコード生成時にこちらの文字列が優先的に利用されます。
  ///
  /// デバッグに利用してください。
  final String? debugSmsCode;

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
  final Future<bool> Function(String email, Locale locale)? onVerify;

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

  String get _uuid {
    return debugUserId ?? uuid();
  }

  Future<void> _initialize() async {
    if (_completer != null) {
      return _completer?.future;
    }
    if (!_initialized) {
      _completer = Completer();
      try {
        _initialized = true;
        await onInitialize?.call(this);
        _completer?.complete();
        _completer = null;
      } catch (e) {
        _completer?.completeError(e);
        _completer = null;
      } finally {
        _completer?.complete();
        _completer = null;
      }
    }
    _applyRawData();
  }

  /// A list of currently registered accounts.
  ///
  /// 現在登録されているアカウントのリスト。
  List<DynamicMap> get accounts {
    return _data._getAccounts();
  }

  /// An active, logged-in account.
  ///
  /// ログイン済みのアクティブなアカウント。
  DynamicMap? get active {
    if (_activeId.isEmpty) {
      return null;
    }
    return _data._getAccount(_activeId!);
  }

  /// Account being prepared for login.
  ///
  /// ログイン準備中のアカウント。
  DynamicMap? get temporary {
    final temporary = _data._getTemporary();
    if (temporary.isEmpty) {
      return null;
    }
    return temporary;
  }

  /// An account that is not logged in but can be restored with [tryRestoreAuth].
  ///
  /// 未ログインであるが[tryRestoreAuth]で復元できるアカウント。
  DynamicMap? get current {
    final current = _data._getCurrent();
    if (current.isEmpty) {
      return null;
    }
    return current;
  }

  /// If you are signed in, `true` is returned.
  ///
  /// サインインしている場合、`true`が返されます。
  bool get isSignedIn => active.isNotEmpty;

  /// Returns `true` if the registration has been authenticated.
  ///
  /// 登録が認証済みの場合`true`を返します。
  bool get isVerified => isSignedIn && active.get(verifiedKey, false);

  /// Returns `true` in case of anonymous or guest authentication.
  ///
  /// 匿名認証、ゲスト認証の場合、`true`を返します。
  bool get isAnonymously => isSignedIn && active.get(anonymouslyKey, false);

  /// Returns `true` if [confirmSignIn] or [confirmChange] is required.
  ///
  /// [confirmSignIn]や[confirmChange]の実行を必要とする場合`true`を返します。
  bool get isWaitingConfirmation =>
      active.get(emailLinkUrlKey, "").isNotEmpty ||
      active.get(smsCodeKey, "").isNotEmpty;

  /// Returns the user ID on the authentication platform during sign-in.
  ///
  /// This ID is unique and can be used as a unique ID to register in the user's DB.
  ///
  /// サインイン時、認証プラットフォーム上のユーザーIDを返します。
  ///
  /// このIDはユニークなものとなっているためユーザーのDBに登録するユニークIDとして利用可能です。
  String get userId => !isSignedIn ? "" : active.get(userIdKey, "");

  /// Returns the user name on the authentication platform during sign-in.
  ///
  /// サインイン時、、認証プラットフォーム上のユーザー名を返します。
  String get userName => !isSignedIn ? "" : active.get(userNameKey, "");

  /// Returns the email address registered with the authentication platform upon sign-in.
  ///
  /// サインイン時、認証プラットフォームに登録されたメールアドレスを返します。
  String get userEmail => !isSignedIn ? "" : active.get(userEmailKey, "");

  /// Returns the phone number registered with the authentication platform upon sign-in.
  ///
  /// サインイン時、認証プラットフォームに登録された電話番号を返します。
  String get userPhoneNumber =>
      !isSignedIn ? "" : active.get(userPhoneNumberKey, "");

  /// Returns the URL of the user's icon registered on the authentication platform during sign-in.
  ///
  /// Basically, it is used to obtain icons registered on social networking sites.
  /// (Some SNS platforms may not be able to obtain this information.)
  ///
  /// サインイン時、認証プラットフォームに登録されたのユーザーアイコンのURLを返します。
  ///
  /// 基本的にSNSで登録されているアイコンを取得するために利用します。
  /// （SNSプラットフォームによっては取得できない場合もあります。）
  String get userPhotoURL => !isSignedIn ? "" : active.get(userPhotoURLKey, "");

  /// Returns a list of authenticated provider IDs upon sign-in.
  ///
  /// サインイン時、認証されたプロバイダーのID一覧を返します。
  List<String> get activeProviderIds =>
      !isSignedIn ? [] : active.getAsList(activeProvidersKey);

  /// Returns the stored password.
  ///
  /// 保存されたパスワードを返します。
  String get userPassword => !isSignedIn ? "" : active.get(userPasswordKey, "");

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
    await _initialize();
    await onLoad?.call(this);
    final current = _data._getCurrent();
    _activeId = current.get(userIdKey, nullOfString) ?? _registeredCurrentId;
    return isSignedIn;
  }

  /// Register a user by passing a class inheriting from [CreateAuthProvider] in [provider].
  ///
  /// [CreateAuthProvider]を継承したクラスを[provider]で渡すことにより、ユーザーの登録を行います。
  Future<String?> create({
    required CreateAuthProvider provider,
  }) async {
    String? userId;
    await _initialize();
    if (provider is EmailAndPasswordCreateAuthProvider) {
      if (_data.containsKey(userEmailKey)) {
        throw Exception(
          "This Email address is already registered. Please register another email address.",
        );
      }
      final accounts = _data._getAccounts();
      if (accounts
          .any((element) => element.get(userEmailKey, "") == provider.email)) {
        throw Exception(
          "This Email address is already registered. Please register another email address.",
        );
      }
      userId = _uuid;
      _data._setAccount(
        userId,
        {
          userIdKey: userId,
          userEmailKey: provider.email,
          userPasswordKey: provider.password,
          activeProvidersKey: [
            ...activeProviderIds,
            provider.providerId,
          ].distinct(),
        },
      );
      await onSendRegisteredEmail?.call(
        provider.email,
        provider.password,
        provider.locale ?? defaultLocale,
      );
    }
    await onSaved?.call(this);
    return userId;
  }

  /// Register a user by passing a class inheriting from [RegisterAuthProvider] in [provider].
  ///
  /// [RegisterAuthProvider]を継承したクラスを[provider]で渡すことにより、ユーザーの登録を行います。
  Future<void> register({
    required RegisterAuthProvider provider,
  }) async {
    await _initialize();
    if (isSignedIn) {
      await signOut();
    }
    if (provider is EmailAndPasswordRegisterAuthProvider) {
      final accounts = _data._getAccounts();
      if (accounts
          .any((element) => element.get(userEmailKey, "") == provider.email)) {
        throw Exception(
          "This Email address is already registered. Please register another email address.",
        );
      }
      final userId = _uuid;
      _data._setAccount(
        userId,
        {
          userIdKey: userId,
          userEmailKey: provider.email,
          userPasswordKey: provider.password,
          activeProvidersKey: [
            ...activeProviderIds,
            provider.providerId,
          ].distinct(),
        },
      );
      _data._setCurrent(userId);
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
    await _initialize();
    final accounts = _data._getAccounts();
    if (provider is AnonymouslySignInAuthProvider ||
        provider is SnsSignInAuthProvider) {
      final active = this.active;
      if (active.isEmpty) {
        final current = _data._getCurrent();
        final userId = current.get(userIdKey, "");
        if (userId.isEmpty) {
          final userId = _uuid;
          _data._setAccount(userId, {
            userIdKey: userId,
            anonymouslyKey: true,
            activeProvidersKey: [provider.providerId].distinct(),
          });
          _data._setCurrent(userId);
          _activeId = userId;
        } else {
          final current = _data._getAccount(userId);
          _data._setAccount(userId, {
            ...current,
            anonymouslyKey: true,
            activeProvidersKey: [
              ...current.getAsList(activeProvidersKey),
              provider.providerId
            ].distinct(),
          });
          _activeId = userId;
        }
      } else {
        final userId = _activeId!;
        final current = _data._getAccount(userId);
        _data._setAccount(userId, {
          ...current,
          anonymouslyKey: true,
          activeProvidersKey: [
            ...current.getAsList(activeProvidersKey),
            provider.providerId
          ].distinct(),
        });
      }
    } else if (provider is EmailAndPasswordSignInAuthProvider) {
      final accounts = _data._getAccounts();
      final account = accounts.firstWhereOrNull((e) =>
          e.get(userEmailKey, "") == provider.email &&
          e.get(userPasswordKey, "") == provider.password);
      if (account == null) {
        throw Exception("Email or Password is invalid.");
      }
      final userId = account.get(userIdKey, "");
      _data._setCurrent(userId);
      _activeId = userId;
    } else if (provider is EmailLinkSignInAuthProvider) {
      await onSendEmailLink?.call(
        provider.email,
        provider.url,
        provider.locale ?? defaultLocale,
      );
      final account = accounts
          .firstWhereOrNull((e) => e.get(userEmailKey, "") == provider.email);
      if (account == null) {
        final userId = _uuid;
        _data._setAccount(userId, {
          userIdKey: userId,
          emailLinkUrlKey: provider.url,
          tmpUserEmailKey: provider.email,
        });
        _data._setTemporary(userId);
      } else {
        final userId = account.get(userIdKey, "");
        _data._setAccount(userId, {
          ...account,
          emailLinkUrlKey: provider.url,
          tmpUserEmailKey: provider.email,
        });
        _data._setTemporary(userId);
      }
    } else if (provider is SmsSignInAuthProvider) {
      final account = accounts.firstWhereOrNull(
          (e) => e.get(userPhoneNumberKey, "") == provider.phoneNumber);
      final code = debugSmsCode ?? generateCode(6, charSet: "0123456789");
      await onSendSMS?.call(
        provider.phoneNumber,
        code,
        provider.locale ?? defaultLocale,
      );
      if (account == null) {
        final userId = _uuid;
        _data._setAccount(userId, {
          userIdKey: userId,
          tmpUserPhoneNumberKey: provider.phoneNumber,
          smsCodeKey: code,
        });
        _data._setTemporary(userId);
      } else {
        final userId = account.get(userIdKey, "");
        _data._setAccount(userId, {
          ...account,
          tmpUserPhoneNumberKey: provider.phoneNumber,
          smsCodeKey: code,
        });
        _data._setTemporary(userId);
      }
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
    await _initialize();
    if (provider is EmailLinkConfirmSignInAuthProvider) {
      final temporary = _data._getTemporary();
      final emailLink = temporary.get(emailLinkUrlKey, "");
      final email = temporary.get(tmpUserEmailKey, "");
      if (temporary.isEmpty || emailLink != provider.url || email.isEmpty) {
        throw Exception(
          "Your Email is not registered. Please register it with [signIn] beforehand.",
        );
      }
      final userId = temporary.get(userIdKey, "");
      _data._setTemporary(null);
      _data._setAccount(userId, {
        ...temporary,
        AuthDatabase.userEmailKey: email,
        activeProvidersKey: [
          ...temporary.getAsList(activeProvidersKey),
          provider.providerId
        ].distinct()
      });
      _data._setCurrent(userId);
      _activeId = userId;
    } else if (provider is SmsConfirmSignInAuthProvider) {
      final temporary = _data._getTemporary();
      final phoenNumber = temporary.get(tmpUserPhoneNumberKey, "");
      if (temporary.isEmpty || phoenNumber.isEmpty) {
        throw Exception(
          "Phone number is not registered. Please register it with [signIn] beforehand.",
        );
      }
      if (provider.code != temporary.get(smsCodeKey, "")) {
        throw Exception(
          "The code is invalid. Please check the code.",
        );
      }
      final userId = temporary.get(userIdKey, "");
      _data._setTemporary(null);
      _data._setAccount(userId, {
        ...temporary,
        AuthDatabase.userPhoneNumberKey: phoenNumber,
        activeProvidersKey: [
          ...temporary.getAsList(activeProvidersKey),
          provider.providerId
        ].distinct()
      });
      _data._setCurrent(userId);
      _activeId = userId;
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
    await _initialize();
    final account = active;
    if (account == null) {
      throw Exception(
        "You are not signed in. Please sign in with [signIn] first.",
      );
    }
    if (provider is EmailAndPasswordReAuthProvider) {
      return account.get(userPasswordKey, "") == provider.password;
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
    await _initialize();
    if (provider is EmailAndPasswordResetAuthProvider) {
      final account = _data._getAccounts().firstWhereOrNull(
            (item) => item.get(userEmailKey, "") == provider.email,
          );
      if (account == null) {
        throw Exception("Account not found.");
      }
      final password = await onResetPassword?.call(
        resetPassword,
        provider.locale ?? defaultLocale,
      );
      account[userPasswordKey] = password;
      _data._setAccount(userId, account);
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
    await _initialize();
    final account = active;
    if (account == null) {
      throw Exception(
        "You are not signed in. Please sign in with [signIn] first.",
      );
    }
    final userId = account.get(userIdKey, "");
    if (provider is EmailAndPasswordVerifyAuthProvider) {
      final verified = await onVerify?.call(
        userEmail,
        provider.locale ?? defaultLocale,
      );
      _data._setAccount(userId, {
        ...account,
        verifiedKey: verified,
      });
    } else if (provider is EmailLinkVerifyAuthProvider) {
      final verified = await onVerify?.call(
        userEmail,
        provider.locale ?? defaultLocale,
      );
      _data._setAccount(userId, {
        ...account,
        verifiedKey: verified,
      });
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
    await _initialize();
    final account = active;
    if (account == null) {
      throw Exception(
        "You are not signed in. Please sign in with [signIn] first.",
      );
    }
    final userId = account.get(userIdKey, "");
    if (provider is ChangeEmailAuthProvider) {
      _data._setAccount(userId, {
        ...account,
        userEmailKey: provider.email,
      });
    } else if (provider is ChangePasswordAuthProvider) {
      _data._setAccount(userId, {
        ...account,
        userPasswordKey: provider.password,
      });
    } else if (provider is ChangePhoneNumberAuthProvider) {
      final code = debugSmsCode ?? generateCode(6, charSet: "01223456789");
      await onSendSMS?.call(
        provider.phoneNumber,
        code,
        provider.locale ?? defaultLocale,
      );
      _data._setAccount(userId, {
        ...account,
        tmpUserPhoneNumberKey: provider.phoneNumber,
        smsCodeKey: code,
      });
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
    await _initialize();
    final account = active;
    if (account == null) {
      throw Exception(
        "You are not signed in. Please sign in with [signIn] first.",
      );
    }
    final userId = account.get(userIdKey, "");
    if (provider is ConfirmChangePhoneNumberAuthProvider) {
      final phoneNumber = account.get(tmpUserPhoneNumberKey, "");
      if (phoneNumber.isEmpty) {
        throw Exception(
          "Phone number is not registered. Please register it with [signIn] beforehand.",
        );
      }
      if (provider.code != temporary.get(smsCodeKey, "")) {
        throw Exception(
          "The code is invalid. Please check the code.",
        );
      }
      _data._setAccount(userId, {
        ...account,
        userPhoneNumberKey: phoneNumber,
      });
    }
    await onSaved?.call(this);
  }

  /// Sign out if you are already signed in.
  ///
  /// すでにサインインしている場合サインアウトします。
  Future<void> signOut() async {
    await _initialize();
    final account = active;
    if (account == null) {
      throw Exception(
        "You are not signed in. Please sign in with [signIn] first.",
      );
    }
    _activeId = null;
    _data._setTemporary(null);
    _data._setCurrent(null);
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
    await _initialize();
    final account = active;
    if (account == null) {
      throw Exception(
        "You are not signed in. Please sign in with [signIn] first.",
      );
    }
    final userId = account.get(userIdKey, "");
    _data._removeAccount(userId);
    _activeId = null;
    _data._setTemporary(null);
    _data._setCurrent(null);
  }

  /// Add/update the data of [value] at the position of [path].
  ///
  /// Unlike other storage methods, you will not be notified of data updates.
  ///
  /// Also, actual data is written after [_initialize] is executed.
  ///
  /// Please use this function when you want to include mock data or other data in advance.
  ///
  /// [path]の位置に[value]のデータを追加・更新します。
  ///
  /// 他の保存用メソッドと違ってデータの更新が通知されることはありません。
  ///
  /// また、[_initialize]実行後に実際のデータが書き込まれます。
  ///
  /// モックデータなど予めデータを入れておきたい場合などにご利用ください。
  void setInitialValue(AuthInitialValue value) {
    if (value.userId.isEmpty) {
      return;
    }
    final path = value.userId.trimQuery().trimString("/");
    final paths = path.split("/");
    if (paths.isEmpty) {
      return;
    }
    if (_registeredInitialValue.containsKey(path)) {
      return;
    }
    _registeredInitialValue[path] = value._toMap();
  }

  void setInitialId(String? uid) {
    _registeredCurrentId = uid;
  }

  /// Returns a list of registered initial value paths.
  ///
  /// 登録されている初期値のパスの一覧を返します。
  List<String> get registeredInitialValuePaths {
    return _registeredInitialValue.keys.toList();
  }

  /// Returns `true` if data is registered with [setInitialValue].
  ///
  /// [setInitialValue]でデータが登録されている場合は`true`を返します。
  bool get isInitialValueRegistered => _registeredInitialValue.isNotEmpty;

  void _applyRawData() {
    if (_registeredInitialValue.isEmpty) {
      return;
    }
    for (final tmp in _registeredInitialValue.entries) {
      if (_appliedInitialValue.contains(tmp.key)) {
        continue;
      }
      final path = tmp.key;
      final value = tmp.value;
      _appliedInitialValue.add(path);
      _data._setAccount(path, value);
    }
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

extension _AuthDatabaseDynamicMapExtensions on Map {
  static const _currentKey = "current";
  static const _temporaryKey = "temporary";
  static const _accountKey = "account";

  void _initialize() {
    if (containsKey(_accountKey)) {
      return;
    }
    this[_accountKey] = <String, dynamic>{};
  }

  void _setAccount(String userId, DynamicMap value) {
    _initialize();
    final filtered = value.where((key, value) => value != null);
    this[_accountKey][userId] = filtered;
  }

  void _removeAccount(String userId) {
    _initialize();
    getAsMap(_accountKey).remove(userId);
  }

  DynamicMap _getAccount(String userId) {
    _initialize();
    return Map<String, dynamic>.unmodifiable(
      Map<String, dynamic>.from(getAsMap(_accountKey).getAsMap(userId)),
    );
  }

  List<DynamicMap> _getAccounts() {
    _initialize();
    return getAsMap(_accountKey).values.cast<DynamicMap>().toList();
  }

  DynamicMap _getTemporary() {
    _initialize();
    return _getAccount(get(_temporaryKey, ""));
  }

  void _setTemporary(String? userId) {
    if (userId.isEmpty) {
      return;
    }
    _initialize();
    this[_temporaryKey] = userId;
  }

  DynamicMap _getCurrent() {
    _initialize();
    return _getAccount(get(_currentKey, ""));
  }

  void _setCurrent(String? userId) {
    if (userId.isEmpty) {
      return;
    }
    _initialize();
    this[_currentKey] = userId;
  }
}

/// Class for entering initial values for authentication information.
///
/// 認証情報の初期値を入力するためのクラス。
class AuthInitialValue {
  /// Class for entering initial values for authentication information.
  ///
  /// 認証情報の初期値を入力するためのクラス。
  const AuthInitialValue({
    this.isVerified = false,
    this.isAnonymously = false,
    required this.userId,
    this.name,
    this.email,
    this.phoneNumber,
    this.photoURL,
    this.password,
    this.activeProviders,
  });

  /// Enter [email] and [password] to register with email address [AuthInitialValue].
  ///
  /// [email]と[password]を入力してメールアドレスでの登録を行う[AuthInitialValue]。
  const AuthInitialValue.email({
    required this.userId,
    required this.email,
    required this.password,
    this.name,
  })  : isAnonymously = true,
        isVerified = false,
        activeProviders = const ["password"],
        phoneNumber = null,
        photoURL = null;

  /// Enter [phoneNumber] to register with phone number [AuthInitialValue].
  ///
  /// [phoneNumber]を入力して電話番号での登録を行う[AuthInitialValue]。
  const AuthInitialValue.phone({
    required this.userId,
    required this.phoneNumber,
    this.name,
  })  : isAnonymously = true,
        isVerified = false,
        activeProviders = const ["phone"],
        email = null,
        photoURL = null,
        password = null;

  /// Enter [userId] to register with anonymous [AuthInitialValue].
  ///
  /// [userId]を入力して匿名での登録を行う[AuthInitialValue]。
  const AuthInitialValue.anonymously({
    required this.userId,
    this.name,
  })  : isAnonymously = true,
        isVerified = false,
        activeProviders = const ["anonymous"],
        email = null,
        phoneNumber = null,
        photoURL = null,
        password = null;

  /// true` if authenticated.
  ///
  /// 認証済みの場合`true`。
  final bool isVerified;

  /// If anonymous, `true`.
  ///
  /// 匿名の場合`true`。
  final bool isAnonymously;

  /// User ID.
  ///
  /// ユーザーID。
  final String userId;

  /// User name.
  ///
  /// ユーザー名。
  final String? name;

  /// Email address.
  ///
  /// メールアドレス。
  final String? email;

  /// Phone number.
  ///
  /// 電話番号。
  final String? phoneNumber;

  /// URL of user icon.
  ///
  /// ユーザーアイコンのURL。
  final String? photoURL;

  /// Password.
  ///
  /// パスワード。
  final String? password;

  /// List of authenticated provider IDs.
  ///
  /// 認証されたプロバイダーのID一覧。
  final List<String>? activeProviders;

  DynamicMap _toMap() {
    return {
      AuthDatabase.verifiedKey: isVerified,
      AuthDatabase.anonymouslyKey: isAnonymously,
      AuthDatabase.userIdKey: userId,
      AuthDatabase.userNameKey: name,
      AuthDatabase.userEmailKey: email,
      AuthDatabase.userPhoneNumberKey: phoneNumber,
      AuthDatabase.userPhotoURLKey: photoURL,
      AuthDatabase.userPasswordKey: password,
      AuthDatabase.activeProvidersKey: activeProviders,
    };
  }
}
