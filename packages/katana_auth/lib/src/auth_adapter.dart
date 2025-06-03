part of "/katana_auth.dart";

/// Adapters to change the behavior of authentication on different platforms.
///
/// By passing an object inheriting from this in [AuthAdapterScope], you can change the authentication for the entire app.
///
/// The actual authentication commands are performed using the [Authentication] class, but all internal implementation is done via this [AuthAdapter].
///
/// プラットフォームごとの認証の振る舞いを変えるためのアダプター。
///
/// これを継承したオブジェクトを[AuthAdapterScope]で渡すことによりアプリ全体の認証を変更することができます。
///
/// 実際に認証コマンドを利用する際は[Authentication]のクラスを用いて行ないますが、内部実装はすべてこの[AuthAdapter]経由で行われます。
///
/// ```dart
/// class MyApp extends StatelessWidget {
///   const MyApp({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     return AuthAdapterScope(
///       adapter: const RuntimeAuthAdapter(),
///       child: MaterialApp(
///         home: const AuthPage(),
///       ),
///     );
///   }
/// }
/// ```
abstract class AuthAdapter {
  /// Adapters to change the behavior of authentication on different platforms.
  ///
  /// By passing an object inheriting from this in [AuthAdapterScope], you can change the authentication for the entire app.
  ///
  /// The actual authentication commands are performed using the [Authentication] class, but all internal implementation is done via this [AuthAdapter].
  ///
  /// プラットフォームごとの認証の振る舞いを変えるためのアダプター。
  ///
  /// これを継承したオブジェクトを[AuthAdapterScope]で渡すことによりアプリ全体の認証を変更することができます。
  ///
  /// 実際に認証コマンドを利用する際は[Authentication]のクラスを用いて行ないますが、内部実装はすべてこの[AuthAdapter]経由で行われます。
  ///
  /// ```dart
  /// class MyApp extends StatelessWidget {
  ///   const MyApp({super.key});
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return AuthAdapterScope(
  ///       adapter: const RuntimeAuthAdapter(),
  ///       child: MaterialApp(
  ///         home: const AuthPage(),
  ///       ),
  ///     );
  ///   }
  /// }
  /// ```
  const AuthAdapter({this.authActions = const []});

  /// Callbacks during authentication.
  ///
  /// 認証時のコールバック。
  final List<AuthActionQuery> authActions;

  /// You can retrieve the [AuthAdapter] first given by [AuthAdapterScope].
  ///
  /// 最初に[AuthAdapterScope]で与えた[AuthAdapter]を取得することができます。
  static AuthAdapter get primary {
    assert(
      _primary != null,
      "AuthAdapter is not set. Place [AuthAdapterScope] widget closer to the root.",
    );
    return _primary ?? const RuntimeAuthAdapter();
  }

  static AuthAdapter? _primary;
  static AuthAdapter? _test;

  /// If you are signed in, return `true`.
  ///
  /// サインインしている場合、`true`を返すようにしてください。
  bool get isSignedIn;

  /// Return `true` if the registration has been authenticated.
  ///
  /// 登録が認証済みの場合`true`を返すようにしてください。
  bool get isVerified;

  /// For anonymous or guest authentication, return `true`.
  ///
  /// 匿名認証、ゲスト認証の場合、`true`を返すようにしてください。
  bool get isAnonymously;

  /// Return `true` if [confirmSignIn] or [confirmChange] is required.
  ///
  /// [confirmSignIn]や[confirmChange]の実行を必要とする場合`true`を返すようにしてください。
  bool get isWaitingConfirmation;

  /// When signing in, make sure to return the user ID on the authentication platform.
  ///
  /// This ID should be unique and available as a unique ID to be registered in the user's DB.
  ///
  /// Return `null` when signing out.
  ///
  /// サインイン時、認証プラットフォーム上のユーザーIDを返すようにしてください。
  ///
  /// このIDはユニークなものにして、ユーザーのDBに登録するユニークIDとして利用可能にしてください。
  ///
  /// サインアウト時は`null`を返すようにしてください。
  String? get userId;

  /// Make sure to return the user name.
  ///
  /// Return `null` when signing out.
  ///
  /// ユーザー名を返すようにしてください。
  ///
  /// サインアウト時は`null`を返すようにしてください。
  String? get userName;

  /// Make sure to return the user's email address.
  ///
  /// Return `null` when signing out.
  ///
  /// ユーザーのメールアドレスを返すようにしてください。
  ///
  /// サインアウト時は`null`を返すようにしてください。
  String? get userEmail;

  /// Be sure to return the user's phone number.
  ///
  /// Return `null` when signing out.
  ///
  /// ユーザーの電話番号を返すようにしてください。
  ///
  /// サインアウト時は`null`を返すようにしてください。
  String? get userPhoneNumber;

  /// Please make sure to return the URL of the user's icon image.
  ///
  /// Return `null` when signing out.
  ///
  /// ユーザーのアイコン画像のURLを返すようにしてください。
  ///
  /// サインアウト時は`null`を返すようにしてください。
  String? get userPhotoURL;

  /// Please return a list of IDs of authenticated providers.
  ///
  /// Return `null` when signing out.
  ///
  /// 認証されたプロバイダーのID一覧を返すようにしてください。
  ///
  /// サインアウト時は`null`を返すようにしてください。
  List<String>? get activeProviderIds;

  /// Returns a refresh token used during sign-in and authentication.
  ///
  /// Return `null` when signing out.
  ///
  /// サインイン時、認証時に用いられるリフレッシュトークンを返します。
  ///
  /// サインアウト時は`null`を返すようにしてください。
  String? get refreshToken;

  /// Returns the access token used during sign-in and authentication.
  ///
  /// Return `null` when signing out.
  ///
  /// If [forceRefresh] is set to `true`, force a refresh.
  ///
  /// サインイン時、認証時に用いられるアクセストークンを返します。
  ///
  /// サインアウト時は`null`を返すようにしてください。
  ///
  /// [forceRefresh]を`true`にした場合、強制的にリフレッシュを行います。
  Future<AccessTokenValue?> accessToken({bool forceRefresh = false});

  /// Running the application at startup will automatically re-authenticate the user.
  ///
  /// If the user has already logged in before exiting the application, the user is automatically logged in based on the authentication information recorded in the application.
  ///
  /// If [retryWhenTimeout] is `true`, retries are attempted even if the authentication times out.
  ///
  /// Execute [onUserStateChanged] when a user's authentication state is changed.
  ///
  /// アプリ起動時に実行することで自動的に再認証を行ないます。
  ///
  /// アプリ終了前にすでにログインしていた場合、アプリ内に記録されている認証情報を元に自動的にログインを行います。
  ///
  /// [retryWhenTimeout]が`true`になっている場合、認証がタイムアウトした場合でもリトライを試みます。
  ///
  /// ユーザーの認証状態が変更されたときに[onUserStateChanged]を実行します。
  Future<bool> tryRestoreAuth({
    required VoidCallback onUserStateChanged,
    bool retryWhenTimeout = false,
  });

  /// Register users by passing a class inheriting from [CreateAuthProvider] in [provider].
  ///
  /// The difference with [register] is that you can create another user even if you are already logged in.
  ///
  /// Execute [onUserStateChanged] when a user's authentication state is changed.
  ///
  /// Returns the user's ID as the return value.
  ///
  /// [CreateAuthProvider]を継承したクラスを[provider]で渡すことにより、ユーザーの登録を行います。
  ///
  /// [register]との違いはすでにログインしている場合でも別のユーザーを作成することができることです。
  ///
  /// ユーザーの認証状態が変更されたときに[onUserStateChanged]を実行します。
  ///
  /// 戻り値にユーザーのIDを返します。
  Future<String?> create({
    required CreateAuthProvider provider,
    required VoidCallback onUserStateChanged,
  });

  /// Register a user by passing a class inheriting from [RegisterAuthProvider] in [provider].
  ///
  /// Execute [onUserStateChanged] when a user's authentication state is changed.
  ///
  /// [RegisterAuthProvider]を継承したクラスを[provider]で渡すことにより、ユーザーの登録を行います。
  ///
  /// ユーザーの認証状態が変更されたときに[onUserStateChanged]を実行します。
  Future<void> register({
    required RegisterAuthProvider provider,
    required VoidCallback onUserStateChanged,
  });

  /// Sign-in is performed by passing a class inheriting from [SignInAuthProvider] as [provider].
  ///
  /// Execute [onUserStateChanged] when a user's authentication state is changed.
  ///
  /// [SignInAuthProvider]を継承したクラスを[provider]で渡すことにより、サインインを行ないます。
  ///
  /// ユーザーの認証状態が変更されたときに[onUserStateChanged]を実行します。
  Future<void> signIn({
    required SignInAuthProvider provider,
    required VoidCallback onUserStateChanged,
  });

  /// If you [signIn] with [EmailLinkSignInAuthProvider] or [SmsSignInAuthProvider], you need to check the authentication code received from email or SMS.
  /// In that case, use this method to finalize the sign-in.
  ///
  /// Confirm sign-in is confirmed by passing a class inheriting from [ConfirmSignInAuthProvider] in [provider].
  ///
  /// Execute [onUserStateChanged] when a user's authentication state is changed.
  ///
  /// [EmailLinkSignInAuthProvider]や[SmsSignInAuthProvider]などで[signIn]した場合、メールやSMSから受け取った認証コードをチェックする必要があります。
  /// その場合、このメソッドを利用してサインインを確定させてください。
  ///
  /// [ConfirmSignInAuthProvider]を継承したクラスを[provider]で渡すことにより、サインインを確定させます。
  ///
  /// ユーザーの認証状態が変更されたときに[onUserStateChanged]を実行します。
  Future<void> confirmSignIn({
    required ConfirmSignInAuthProvider provider,
    required VoidCallback onUserStateChanged,
  });

  /// If you are signed in, this is used to perform an authentication check just before changing information for authentication (e.g., email address).
  ///
  /// Reauthentication is performed by passing a class inheriting from [ReAuthProvider] in [provider].
  ///
  /// サインインしている場合、認証用の情報（メールアドレスなど）を変更する直前に認証チェックを行うために利用します。
  ///
  /// [ReAuthProvider]を継承したクラスを[provider]で渡すことにより、再認証を行ないます。
  Future<bool> reauth({
    required ReAuthProvider provider,
  });

  /// Used to reset the password.
  ///
  /// Reset is performed by passing a class inheriting from [ResetAuthProvider] in [provider].
  ///
  /// パスワードをリセットする場合に利用します。
  ///
  /// [ResetAuthProvider]を継承したクラスを[provider]で渡すことにより、リセットを行ないます。
  Future<void> reset({
    required ResetAuthProvider provider,
  });

  /// Used to prove possession of the e-mail address.
  ///
  /// Normally, this is done to send an authentication email.
  ///
  /// Authentication is performed by passing a class inheriting from [VerifyAuthProvider] as [provider].
  ///
  /// Execute [onUserStateChanged] when a user's authentication state is changed.
  ///
  /// メールアドレスの所有を証明するために利用します。
  ///
  /// 通常はこれを実行することで認証用のメールを送信します。
  ///
  /// [VerifyAuthProvider]を継承したクラスを[provider]で渡すことにより、認証を行ないます。
  ///
  /// ユーザーの認証状態が変更されたときに[onUserStateChanged]を実行します。
  Future<void> verify({
    required VerifyAuthProvider provider,
    required VoidCallback onUserStateChanged,
  });

  /// Used to change the registered information.
  ///
  /// Change information by passing a class inheriting from [ChangeAuthProvider] with [provider].
  ///
  /// Execute [onUserStateChanged] when a user's authentication state is changed.
  ///
  /// 登録されている情報を変更する場合に利用します。
  ///
  /// [ChangeAuthProvider]を継承したクラスを[provider]で渡すことにより、情報の変更を行ないます。
  ///
  /// ユーザーの認証状態が変更されたときに[onUserStateChanged]を実行します。
  Future<void> change({
    required ChangeAuthProvider provider,
    required VoidCallback onUserStateChanged,
  });

  /// If you [change] with [ChangePhoneNumberAuthProvider], for example, you need to check the authentication code you received from an email or SMS.
  /// In that case, use this method to finalize the change.
  ///
  /// Confirm sign-in by passing a class inheriting from [ConfirmChangeAuthProvider] with [provider].
  ///
  /// Execute [onUserStateChanged] when a user's authentication state is changed.
  ///
  /// [ChangePhoneNumberAuthProvider]などで[change]した場合、メールやSMSから受け取った認証コードをチェックする必要があります。
  /// その場合、このメソッドを利用して変更を確定させてください。
  ///
  /// [ConfirmChangeAuthProvider]を継承したクラスを[provider]で渡すことにより、サインインを確定させます。
  ///
  /// ユーザーの認証状態が変更されたときに[onUserStateChanged]を実行します。
  Future<void> confirmChange({
    required ConfirmChangeAuthProvider provider,
    required VoidCallback onUserStateChanged,
  });

  /// Sign out if you are already signed in.
  ///
  /// Execute [onUserStateChanged] when a user's authentication state is changed.
  ///
  /// すでにサインインしている場合サインアウトします。
  ///
  /// ユーザーの認証状態が変更されたときに[onUserStateChanged]を実行します。
  Future<void> signOut({
    required VoidCallback onUserStateChanged,
  });

  /// Deletes already registered users.
  ///
  /// Users created by [AuthProvider] who are registered together with [signIn] even if [register] is not executed are also eligible.
  ///
  /// Execute [onUserStateChanged] when a user's authentication state is changed.
  ///
  /// すでに登録されているユーザーを削除します。
  ///
  /// [register]が実行されていない場合でも[signIn]で合わせて登録が行われる[AuthProvider]で作成されたユーザーも対象となります。
  ///
  /// ユーザーの認証状態が変更されたときに[onUserStateChanged]を実行します。
  Future<void> delete({
    required VoidCallback onUserStateChanged,
  });

  /// Discard the adapter.
  ///
  /// Destroy the authentication system used internally.
  ///
  /// アダプターを破棄します。
  ///
  /// 内部で使用されている認証システムを破棄してください。
  void dispose();
}

/// Returns the result of an access token.
///
/// Returns the actual token to [token].
///
/// Set the expiration time of the token to [expirationTime].
///
/// アクセストークンの結果を返します。
///
/// [token]に実際のトークンを設定します。
///
/// [expirationTime]にトークンの有効期限を設定します。
class AccessTokenValue {
  /// Returns the result of an access token.
  ///
  /// Returns the actual token to [token].
  ///
  /// Set the expiration time of the token to [expirationTime].
  ///
  /// アクセストークンの結果を返します。
  ///
  /// [token]に実際のトークンを設定します。
  ///
  /// [expirationTime]にトークンの有効期限を設定します。
  const AccessTokenValue({
    required this.token,
    this.expirationTime,
  });

  /// Actual token.
  ///
  /// 実際のトークン。
  final String token;

  /// Token expiration time.
  ///
  /// トークンの有効期限。
  final DateTime? expirationTime;

  bool get _forceRefresh {
    if (expirationTime == null) {
      return false;
    }
    return DateTime.now().isAfter(
      expirationTime!.subtract(const Duration(minutes: 5)),
    );
  }
}

/// Place it on top of [MaterialApp], etc., and set [AuthAdapter] for the entire app.
///
/// Pass [AuthAdapter] to [adapter].
///
/// Also, by using [AuthAdapterScope.of] in a descendant widget, you can retrieve the [AuthAdapter] set in the [AuthAdapterScope].
///
/// [MaterialApp]などの上に配置して、アプリ全体に[AuthAdapter]を設定します。
///
/// [adapter]に[AuthAdapter]を渡してください。
///
/// また[AuthAdapterScope.of]を子孫のウィジェット内で利用することにより[AuthAdapterScope]で設定された[AuthAdapter]を取得することができます。
///
/// ```dart
/// class MyApp extends StatelessWidget {
///   const MyApp({super.key});
///
///   @override
///   Widget build(BuildContext context) {
///     return AuthAdapterScope(
///       adapter: const RuntimeAuthAdapter(),
///       child: MaterialApp(
///         home: const AuthPage(),
///       ),
///     );
///   }
/// }
/// ```
class AuthAdapterScope extends StatefulWidget {
  /// Place it on top of [MaterialApp], etc., and set [AuthAdapter] for the entire app.
  ///
  /// Pass [AuthAdapter] to [adapter].
  ///
  /// Also, by using [AuthAdapterScope.of] in a descendant widget, you can retrieve the [AuthAdapter] set in the [AuthAdapterScope].
  ///
  /// [MaterialApp]などの上に配置して、アプリ全体に[AuthAdapter]を設定します。
  ///
  /// [adapter]に[AuthAdapter]を渡してください。
  ///
  /// また[AuthAdapterScope.of]を子孫のウィジェット内で利用することにより[AuthAdapterScope]で設定された[AuthAdapter]を取得することができます。
  ///
  /// ```dart
  /// class MyApp extends StatelessWidget {
  ///   const MyApp({super.key});
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return AuthAdapterScope(
  ///       adapter: const RuntimeAuthAdapter(),
  ///       child: MaterialApp(
  ///         home: const AuthPage(),
  ///       ),
  ///     );
  ///   }
  /// }
  /// ```
  const AuthAdapterScope({
    required this.child,
    required this.adapter,
    super.key,
  });

  /// Children's widget.
  ///
  /// 子供のウィジェット。
  final Widget child;

  /// [AuthAdapter] to be configured for the entire app.
  ///
  /// アプリ全体に設定する[AuthAdapter]。
  final AuthAdapter adapter;

  /// By passing [context], the [AuthAdapter] set in [AuthAdapterScope] can be obtained.
  ///
  /// If the ancestor does not have [AuthAdapterScope], an error will occur.
  ///
  /// [context]を渡すことにより[AuthAdapterScope]で設定された[AuthAdapter]を取得することができます。
  ///
  /// 祖先に[AuthAdapterScope]がない場合はエラーになります。
  static AuthAdapter? of(BuildContext context) {
    final scope =
        context.getElementForInheritedWidgetOfExactType<_AuthAdapterScope>();
    assert(
      scope != null,
      "AuthAdapterScope is not found. Place [AuthAdapterScope] widget closer to the root.",
    );
    return (scope?.widget as _AuthAdapterScope?)?.adapter;
  }

  @override
  State<StatefulWidget> createState() => _AuthAdapterScopeState();
}

class _AuthAdapterScopeState extends State<AuthAdapterScope> {
  @override
  void initState() {
    super.initState();
    AuthAdapter._primary ??= widget.adapter;
  }

  @override
  Widget build(BuildContext context) {
    return _AuthAdapterScope(
      adapter: widget.adapter,
      child: widget.child,
    );
  }
}

class _AuthAdapterScope extends InheritedWidget {
  const _AuthAdapterScope({
    required super.child,
    required this.adapter,
  });

  final AuthAdapter adapter;

  @override
  bool updateShouldNotify(covariant _AuthAdapterScope oldWidget) => false;
}

/// Test scope for [AuthAdapter].
///
/// [AuthAdapter]のテスト用スコープ。
class TestAuthAdapterScope {
  const TestAuthAdapterScope._();

  /// Set the [AuthAdapter] for testing.
  ///
  /// テスト用に[AuthAdapter]を設定します。
  static void setTestAdapter(AuthAdapter adapter) {
    AuthAdapter._test = adapter;
  }
}
