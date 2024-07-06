part of '/katana_auth.dart';

/// Authentication implemented by [AuthAdapter].
///
/// [register] to register the user, and [signIn] to sign in.
///
/// Depending on the [AuthProvider], it may be necessary to confirm the sign-in by doing [confirmSignIn] after executing [signIn].
/// You must also confirm your registration by [verify].
///
/// If you restart the app after registering and signing in, please execute [tryRestoreAuth] when the app starts in order to re-authenticate.
///
/// You can reset your password by doing [reset].
///
/// When changing authentication information, after reconfirming the authentication information with [reauth] (not necessary depending on the [AuthProvider]), the information can be changed with [change].
/// Then, depending on the [AuthProvider], [confirmChange] must be executed to confirm the change.
///
/// You can sign out with [signOut] and delete authentication with [delete].
///
/// It is possible to change the authentication platform used by specifying [adapter].
///
/// You can log authentication events by specifying [loggerAdapters].
///
/// [AuthAdapter]で実装された認証を行います。
///
/// [register]でユーザーの登録を行ない、[signIn]でサインインを行ないます。
///
/// [AuthProvider]によっては[signIn]実行後、[confirmSignIn]を行うことでサインインを確定する必要があります。
/// また[verify]によって登録を確定させる必要があります。
///
/// 登録、サインイン後にアプリを再起動した場合、再認証を行うためにアプリ起動時に[tryRestoreAuth]を実行してください。
///
/// [reset]を行うことでパスワードをリセットすることが可能です。
///
/// 認証情報を変更する際、[reauth]で認証情報を再確認した後（[AuthProvider]によっては必要ありません）[change]で情報を変更することが可能です。
/// その後、[AuthProvider]によっては[confirmChange]を実行して変更を確定させる必要があります。
///
/// [signOut]でサインアウトし、[delete]で認証を削除することができます。
///
/// [adapter]を指定することで利用する認証プラットフォームを変更することが可能です。
///
/// [loggerAdapters]を指定することによって認証イベントのログを取得することができます。
class Authentication extends ChangeNotifier {
  /// Authentication implemented by [AuthAdapter].
  ///
  /// [register] to register the user, and [signIn] to sign in.
  ///
  /// Depending on the [AuthProvider], it may be necessary to confirm the sign-in by doing [confirmSignIn] after executing [signIn].
  /// You must also confirm your registration by [verify].
  ///
  /// If you restart the app after registering and signing in, please execute [tryRestoreAuth] when the app starts in order to re-authenticate.
  ///
  /// You can reset your password by doing [reset].
  ///
  /// When changing authentication information, after reconfirming the authentication information with [reauth] (not necessary depending on the [AuthProvider]), the information can be changed with [change].
  /// Then, depending on the [AuthProvider], [confirmChange] must be executed to confirm the change.
  ///
  /// You can sign out with [signOut] and delete authentication with [delete].
  ///
  /// It is possible to change the authentication platform used by specifying [adapter].
  ///
  /// You can log authentication events by specifying [loggerAdapters].
  ///
  /// [AuthAdapter]で実装された認証を行います。
  ///
  /// [register]でユーザーの登録を行ない、[signIn]でサインインを行ないます。
  ///
  /// [AuthProvider]によっては[signIn]実行後、[confirmSignIn]を行うことでサインインを確定する必要があります。
  /// また[verify]によって登録を確定させる必要があります。
  ///
  /// 登録、サインイン後にアプリを再起動した場合、再認証を行うためにアプリ起動時に[tryRestoreAuth]を実行してください。
  ///
  /// [reset]を行うことでパスワードをリセットすることが可能です。
  ///
  /// 認証情報を変更する際、[reauth]で認証情報を再確認した後（[AuthProvider]によっては必要ありません）[change]で情報を変更することが可能です。
  /// その後、[AuthProvider]によっては[confirmChange]を実行して変更を確定させる必要があります。
  ///
  /// [signOut]でサインアウトし、[delete]で認証を削除することができます。
  ///
  /// [adapter]を指定することで利用する認証プラットフォームを変更することが可能です。
  ///
  /// [loggerAdapters]を指定することによって認証イベントのログを取得することができます。
  Authentication({
    AuthAdapter? adapter,
    List<LoggerAdapter> loggerAdapters = const [],
    this.authActions = const [],
  })  : _adapter = adapter,
        _loggerAdapters = loggerAdapters;

  /// Special callbacks can be registered as [AuthAction] by passing [AuthAction] to [action].
  ///
  /// [AuthAction]を[action]に渡すことで特殊なコールバックを[AuthAction]として登録することができます。
  static void registerAuthAction(AuthAction action) {
    _actions.add(action);
  }

  /// You can cancel an already registered [AuthAction] by passing [AuthAction] to [action].
  ///
  /// [action]に[AuthAction]を渡すことですでに登録されている[AuthAction]を解除することができます。
  static void unregisterAuthAction(AuthAction action) {
    _actions.remove(action);
  }

  static final Set<AuthAction> _actions = {};

  /// Callbacks during authentication.
  ///
  /// 認証時のコールバック。
  final List<AuthActionQuery> authActions;

  Set<AuthAction> get _effectiveActions {
    return {
      ..._actions,
      ...adapter.authActions,
      ...authActions,
    };
  }

  /// An adapter that defines the authentication platform.
  ///
  /// 認証プラットフォームを定義するアダプター。
  AuthAdapter get adapter {
    return AuthAdapter._test ?? _adapter ?? AuthAdapter.primary;
  }

  final AuthAdapter? _adapter;

  /// Adapter to define loggers.
  ///
  /// ロガーを定義するアダプター。
  List<LoggerAdapter> get loggerAdapters {
    return [...LoggerAdapter.primary, ..._loggerAdapters];
  }

  final List<LoggerAdapter> _loggerAdapters;

  /// If you are signed in, `true` is returned.
  ///
  /// サインインしている場合、`true`が返されます。
  bool get isSignedIn => adapter.isSignedIn;

  /// Returns `true` if the registration has been authenticated.
  ///
  /// 登録が認証済みの場合`true`を返します。
  bool get isVerified => adapter.isVerified;

  /// Returns `true` in case of anonymous or guest authentication.
  ///
  /// 匿名認証、ゲスト認証の場合、`true`を返します。
  bool get isAnonymously => adapter.isAnonymously;

  /// Returns `true` if [confirmSignIn] or [confirmChange] is required.
  ///
  /// [confirmSignIn]や[confirmChange]の実行を必要とする場合`true`を返します。
  bool get isWaitingConfirmation => adapter.isWaitingConfirmation;

  /// Returns the user ID on the authentication platform during sign-in.
  ///
  /// This ID is unique and can be used as a unique ID to register in the user's DB.
  ///
  /// On sign-out, `null` is returned.
  ///
  /// サインイン時、認証プラットフォーム上のユーザーIDを返します。
  ///
  /// このIDはユニークなものとなっているためユーザーのDBに登録するユニークIDとして利用可能です。
  ///
  /// サインアウト時は`null`が返されます。
  String? get userId => adapter.userId;

  /// Returns the user name on the authentication platform during sign-in.
  ///
  /// On sign-out, `null` is returned.
  ///
  /// サインイン時、、認証プラットフォーム上のユーザー名を返します。
  ///
  /// サインアウト時は`null`が返されます。
  String? get userName => adapter.userName;

  /// Returns the email address registered with the authentication platform upon sign-in.
  ///
  /// On sign-out, `null` is returned.
  ///
  /// サインイン時、認証プラットフォームに登録されたメールアドレスを返します。
  ///
  /// サインアウト時は`null`が返されます。
  String? get userEmail => adapter.userEmail;

  /// Returns the phone number registered with the authentication platform upon sign-in.
  ///
  /// On sign-out, `null` is returned.
  ///
  /// サインイン時、認証プラットフォームに登録された電話番号を返します。
  ///
  /// サインアウト時は`null`が返されます。
  String? get userPhoneNumber => adapter.userPhoneNumber;

  /// Returns the URL of the user's icon registered on the authentication platform during sign-in.
  ///
  /// Basically, it is used to obtain icons registered on social networking sites.
  /// (Some SNS platforms may not be able to obtain this information.)
  ///
  /// On sign-out, `null` is returned.
  ///
  /// サインイン時、認証プラットフォームに登録されたのユーザーアイコンのURLを返します。
  ///
  /// 基本的にSNSで登録されているアイコンを取得するために利用します。
  /// （SNSプラットフォームによっては取得できない場合もあります。）
  ///
  /// サインアウト時は`null`が返されます。
  String? get userPhotoURL => adapter.userPhotoURL;

  /// Returns a list of authenticated provider IDs upon sign-in.
  ///
  /// On sign-out, `null` is returned.
  ///
  /// サインイン時、認証されたプロバイダーのID一覧を返します。
  ///
  /// サインアウト時は`null`が返されます。
  List<String>? get activeProviderIds => adapter.activeProviderIds;

  /// Returns a refresh token used during sign-in and authentication.
  ///
  /// On sign-out, `null` is returned.
  ///
  /// サインイン時、認証時に用いられるリフレッシュトークンを返します。
  ///
  /// サインアウト時は`null`が返されます。
  String? get refreshToken => adapter.refreshToken;

  /// Returns the access token used during sign-in and authentication.
  ///
  /// On sign-out, `null` is returned.
  ///
  /// サインイン時、認証時に用いられるアクセストークンを返します。
  ///
  /// サインアウト時は`null`が返されます。
  Future<String?> get accessToken async {
    _accessToken = await adapter.accessToken(
      forceRefresh: _accessToken?._forceRefresh ?? false,
    );
    return _accessToken?.token;
  }

  AccessTokenValue? _accessToken;

  /// Running the application at startup will automatically re-authenticate the user.
  ///
  /// If the user has already logged in before exiting the application, the user is automatically logged in based on the authentication information recorded in the application.
  ///
  /// If [retryWhenTimeout] is `true`, retries are attempted even if the authentication times out.
  ///
  /// アプリ起動時に実行することで自動的に再認証を行ないます。
  ///
  /// アプリ終了前にすでにログインしていた場合、アプリ内に記録されている認証情報を元に自動的にログインを行います。
  ///
  /// [retryWhenTimeout]が`true`になっている場合、認証がタイムアウトした場合でもリトライを試みます。
  Future<Authentication> tryRestoreAuth({
    bool retryWhenTimeout = false,
  }) async {
    await adapter.tryRestoreAuth(
      onUserStateChanged: notifyListeners,
      retryWhenTimeout: retryWhenTimeout,
    );
    if (isSignedIn) {
      for (final action in _effectiveActions) {
        await action.onRestoredAuth();
      }
    }
    return this;
  }

  /// This is used to update the authentication status after executing [verify], for example.
  ///
  /// [verify]を実行したあと等に認証のステータスを更新したいときに利用します。
  Future<Authentication> refresh() => tryRestoreAuth();

  /// Register users by passing a class inheriting from [CreateAuthProvider] in [provider].
  ///
  /// The difference with [register] is that you can create another user even if you are already logged in.
  ///
  /// The ID of the created user is returned in the return value.
  ///
  /// [CreateAuthProvider]を継承したクラスを[provider]で渡すことにより、ユーザーの登録を行います。
  ///
  /// [register]との違いはすでにログインしている場合でも別のユーザーを作成することができることです。
  ///
  /// 戻り値に作成したユーザーのIDが返されます。
  Future<String?> create(CreateAuthProvider provider) async {
    final userId = await adapter.create(
      provider: provider,
      onUserStateChanged: notifyListeners,
    );
    _sendLog(AuthLoggerEvent.create, parameters: {
      AuthLoggerEvent.userIdKey: userId,
      AuthLoggerEvent.providerKey: provider.providerId,
    });
    return userId;
  }

  /// Register a user by passing a class inheriting from [RegisterAuthProvider] in [provider].
  ///
  /// If you are already signed in, [Exception] is returned.
  ///
  /// [RegisterAuthProvider]を継承したクラスを[provider]で渡すことにより、ユーザーの登録を行います。
  ///
  /// すでにサインインしている場合は[Exception]が返されます。
  Future<Authentication> register(RegisterAuthProvider provider) async {
    if (isSignedIn) {
      throw Exception("You are already signed in.");
    }
    await adapter.register(
      provider: provider,
      onUserStateChanged: notifyListeners,
    );
    _sendLog(AuthLoggerEvent.register, parameters: {
      AuthLoggerEvent.userIdKey: isSignedIn ? userId : null,
      AuthLoggerEvent.providerKey: provider.providerId,
    });
    return this;
  }

  /// Sign-in is performed by passing a class inheriting from [SignInAuthProvider] as [provider].
  ///
  /// If you are already signed in, [Exception] is returned.
  ///
  /// [SignInAuthProvider]を継承したクラスを[provider]で渡すことにより、サインインを行ないます。
  ///
  /// すでにサインインしている場合は[Exception]が返されます。
  Future<Authentication> signIn(SignInAuthProvider provider) async {
    for (final action in _effectiveActions) {
      await action.onSignIn();
    }
    await adapter.signIn(
      provider: provider,
      onUserStateChanged: notifyListeners,
    );
    _sendLog(AuthLoggerEvent.registerOrSignIn, parameters: {
      AuthLoggerEvent.userIdKey: isSignedIn ? userId : null,
      AuthLoggerEvent.providerKey: provider.providerId,
    });
    if (isSignedIn) {
      for (final action in _effectiveActions) {
        await action.onSignedIn();
      }
    }
    return this;
  }

  /// If you [signIn] with [EmailLinkSignInAuthProvider] or [SmsSignInAuthProvider], you need to check the authentication code received from email or SMS.
  /// In that case, use this method to finalize the sign-in.
  ///
  /// Confirm sign-in is confirmed by passing a class inheriting from [ConfirmSignInAuthProvider] in [provider].
  ///
  /// If you are already signed in, [Exception] is returned.
  ///
  /// [EmailLinkSignInAuthProvider]や[SmsSignInAuthProvider]などで[signIn]した場合、メールやSMSから受け取った認証コードをチェックする必要があります。
  /// その場合、このメソッドを利用してサインインを確定させてください。
  ///
  /// [ConfirmSignInAuthProvider]を継承したクラスを[provider]で渡すことにより、サインインを確定させます。
  ///
  /// すでにサインインしている場合は[Exception]が返されます。
  Future<Authentication> confirmSignIn(
    ConfirmSignInAuthProvider provider,
  ) async {
    if (isSignedIn) {
      throw Exception("You are already signed in.");
    }
    await adapter.confirmSignIn(
      provider: provider,
      onUserStateChanged: notifyListeners,
    );
    if (isSignedIn) {
      for (final action in _effectiveActions) {
        await action.onSignedIn();
      }
    }
    return this;
  }

  /// If you are signed in, this is used to perform an authentication check just before changing information for authentication (e.g., email address).
  ///
  /// Reauthentication is performed by passing a class inheriting from [ReAuthProvider] in [provider].
  ///
  /// Throws [Exception] if you are not signed in or your password is incorrect.
  ///
  /// サインインしている場合、認証用の情報（メールアドレスなど）を変更する直前に認証チェックを行うために利用します。
  ///
  /// [ReAuthProvider]を継承したクラスを[provider]で渡すことにより、再認証を行ないます。
  ///
  /// サインインしていない場合やパスワードが間違っていた場合[Exception]をスローします。
  Future<Authentication> reauth(
    ReAuthProvider provider,
  ) async {
    if (!isSignedIn || !activeProviderIds.contains(provider.providerId)) {
      throw Exception(
        "You are not logged in with the proper AuthProvider. Please login with the [signIn] method.",
      );
    }
    if (!await adapter.reauth(provider: provider)) {
      throw Exception("Password is incorrect.");
    }
    return this;
  }

  /// Used to reset the password.
  ///
  /// Reset is performed by passing a class inheriting from [ResetAuthProvider] in [provider].
  ///
  /// Throws [Exception] if already signed in.
  ///
  /// パスワードをリセットする場合に利用します。
  ///
  /// [ResetAuthProvider]を継承したクラスを[provider]で渡すことにより、リセットを行ないます。
  ///
  /// すでにサインインしている場合[Exception]をスローします。
  Future<Authentication> reset(
    ResetAuthProvider provider,
  ) async {
    if (isSignedIn) {
      throw Exception(
        "You are already signed in. Please [signOut] and sign out.",
      );
    }
    await adapter.reset(provider: provider);
    return this;
  }

  /// Used to prove possession of the e-mail address.
  ///
  /// Normally, this is done to send an authentication email.
  ///
  /// Authentication is performed by passing a class inheriting from [VerifyAuthProvider] as [provider].
  ///
  /// Throws [Exception] if already authenticated.
  ///
  /// メールアドレスの所有を証明するために利用します。
  ///
  /// 通常はこれを実行することで認証用のメールを送信します。
  ///
  /// [VerifyAuthProvider]を継承したクラスを[provider]で渡すことにより、認証を行ないます。
  ///
  /// すでに認証されている場合[Exception]をスローします。
  Future<Authentication> verify(
    VerifyAuthProvider provider,
  ) async {
    if (isVerified) {
      throw Exception("This account has already been verified.");
    }
    await adapter.verify(
      provider: provider,
      onUserStateChanged: notifyListeners,
    );
    return this;
  }

  /// Used to change the registered information.
  ///
  /// Change information by passing a class inheriting from [ChangeAuthProvider] with [provider].
  ///
  /// Throws [Exception] if not signed in.
  ///
  /// 登録されている情報を変更する場合に利用します。
  ///
  /// [ChangeAuthProvider]を継承したクラスを[provider]で渡すことにより、情報の変更を行ないます。
  ///
  /// サインインされていない場合[Exception]をスローします。
  Future<Authentication> change(
    ChangeAuthProvider provider,
  ) async {
    if (!isSignedIn || !activeProviderIds.contains(provider.providerId)) {
      throw Exception(
        "You are not logged in with the proper AuthProvider. Please login with the [signIn] method.",
      );
    }
    await adapter.change(
      provider: provider,
      onUserStateChanged: notifyListeners,
    );
    return this;
  }

  /// If you [change] with [ChangePhoneNumberAuthProvider], for example, you need to check the authentication code you received from an email or SMS.
  /// In that case, use this method to finalize the change.
  ///
  /// Confirm sign-in by passing a class inheriting from [ConfirmChangeAuthProvider] with [provider].
  ///
  /// If you are not signed in, [Exception] is returned.
  ///
  /// [ChangePhoneNumberAuthProvider]などで[change]した場合、メールやSMSから受け取った認証コードをチェックする必要があります。
  /// その場合、このメソッドを利用して変更を確定させてください。
  ///
  /// [ConfirmChangeAuthProvider]を継承したクラスを[provider]で渡すことにより、サインインを確定させます。
  ///
  /// サインインしていない場合は[Exception]が返されます。
  Future<Authentication> confirmChange(
    ConfirmChangeAuthProvider provider,
  ) async {
    if (!isSignedIn || !activeProviderIds.contains(provider.providerId)) {
      throw Exception(
        "You are not logged in with the proper AuthProvider. Please login with the [signIn] method.",
      );
    }
    await adapter.confirmChange(
      provider: provider,
      onUserStateChanged: notifyListeners,
    );
    return this;
  }

  /// Sign out if you are already signed in.
  ///
  /// If you have not yet signed in, an [Exception] will be thrown.
  ///
  /// すでにサインインしている場合サインアウトします。
  ///
  /// まだサインインしていない場合[Exception]がスローされます。
  Future<Authentication> signOut() async {
    if (!isSignedIn) {
      throw Exception("Not yet signed in.");
    }
    for (final action in _effectiveActions) {
      await action.onSignOut();
    }
    final userId = this.userId;
    await adapter.signOut(onUserStateChanged: notifyListeners);
    _sendLog(AuthLoggerEvent.signOut, parameters: {
      AuthDatabase.userIdKey: userId,
    });
    if (!isSignedIn) {
      for (final action in _effectiveActions) {
        await action.onSignedOut();
      }
    }
    return this;
  }

  /// Deletes already registered users.
  ///
  /// Users created by [AuthProvider] who are registered together with [signIn] even if [register] is not executed are also eligible.
  ///
  /// すでに登録されているユーザーを削除します。
  ///
  /// [register]が実行されていない場合でも[signIn]で合わせて登録が行われる[AuthProvider]で作成されたユーザーも対象となります。
  Future<Authentication> delete() async {
    if (!isSignedIn) {
      throw Exception("Not yet signed in.");
    }
    for (final action in _effectiveActions) {
      await action.onSignOut();
    }
    final userId = this.userId;
    await adapter.delete(onUserStateChanged: notifyListeners);
    _sendLog(AuthLoggerEvent.delete, parameters: {
      AuthDatabase.userIdKey: userId,
    });
    if (!isSignedIn) {
      for (final action in _effectiveActions) {
        await action.onSignedOut();
      }
    }
    return this;
  }

  @override
  @mustCallSuper
  void dispose() {
    super.dispose();
  }

  void _sendLog(AuthLoggerEvent event, {DynamicMap? parameters}) {
    for (final loggerAdapter in loggerAdapters) {
      loggerAdapter.send(event.toString(), parameters: parameters);
    }
  }
}
