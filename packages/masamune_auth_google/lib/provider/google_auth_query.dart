part of "/masamune_auth_google.dart";

const _kGoogleAuthProviderId = "google.com";

/// {@template google_auth}
/// An `AuthQuery` to authenticate with a Google account.
///
/// [signIn] and [reauth] are available.
///
/// [signOut] logs you out of your Google account rather than providing Provider.
///
/// Googleアカウントでの認証を行うための`AuthQuery`。
///
/// [signIn]および[reauth]が利用可能です。
///
/// [signOut]はProviderを提供するのではなくGoogleアカウントからログアウトします。
/// {@endtemplate}
class GoogleAuthQuery {
  const GoogleAuthQuery._();

  /// ID that defines the provider's process.
  ///
  /// Basically, it is defined based on firebase's `PROVIDER_ID`.
  ///
  /// プロバイダーの処理を定義したID。
  ///
  /// 基本的にfirebaseの`PROVIDER_ID`をベースに定義されます。
  static const String providerId = _kGoogleAuthProviderId;

  /// [AuthProvider] for performing [Authentication.signIn].
  ///
  /// [Authentication.signIn]を実行するための[AuthProvider]。
  ///
  /// {@macro google_auth}
  static GoogleSignInAuthProvider signIn() {
    return const GoogleSignInAuthProvider();
  }

  /// [AuthProvider] for performing [Authentication.reauth].
  ///
  /// [Authentication.reauth]を実行するための[AuthProvider]。
  ///
  /// {@macro google_auth}
  static GoogleReAuthProvider reauth() {
    return const GoogleReAuthProvider();
  }

  /// Log out of your Google account.
  ///
  /// Googleアカウントからログアウトします。
  ///
  /// {@macro google_auth}
  static Future<void> signOut() async {
    await GoogleSignIn.instance.signOut();
  }
}

/// An `AuthQuery` for Google's OAuth authentication.
///
/// GoogleのOAuth認証を行うための`AuthQuery`。
class GoogleSignInAuthProvider extends SnsSignInAuthProvider {
  /// An `AuthQuery` for Google's OAuth authentication.
  ///
  /// GoogleのOAuth認証を行うための`AuthQuery`。
  const GoogleSignInAuthProvider({super.allowMultiProvider = true});

  @override
  String get providerId => _kGoogleAuthProviderId;

  @override
  Future<Credential> credential() async {
    // final adapter = GoogleAuthMasamuneAdapter.primary;
    final google = GoogleSignIn.instance;
    final currentUser = await google.authenticate();
    final credentials = currentUser.authentication;
    return Credential(
      providerId: providerId,
      idToken: credentials.idToken,
    );
  }
}

/// An `AuthQuery` for Google's OAuth authentication.
///
/// GoogleのOAuth認証を行うための`AuthQuery`。
class GoogleReAuthProvider extends SnsReAuthProvider {
  /// An `AuthQuery` for Google's OAuth authentication.
  ///
  /// GoogleのOAuth認証を行うための`AuthQuery`。
  const GoogleReAuthProvider();

  static const _signInProvider = GoogleSignInAuthProvider();

  @override
  String get providerId => _signInProvider.providerId;

  @override
  Future<Credential> credential() => _signInProvider.credential();
}
