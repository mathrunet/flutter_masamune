part of "/masamune_auth_github_firebase.dart";

const _kGitHubAuthProviderId = "github.com";

/// {@template github_auth}
/// An `AuthQuery` to authenticate with a GitHub account on Firebase.
///
/// [signIn] and [reauth] are available.
///
/// FirebaseにおけるGitHubアカウントでの認証を行うための`AuthQuery`。
///
/// [signIn]および[reauth]が利用可能です。
/// {@endtemplate}
class FirebaseGithubAuthQuery {
  const FirebaseGithubAuthQuery._();

  /// ID that defines the provider's process.
  ///
  /// Basically, it is defined based on firebase's `PROVIDER_ID`.
  ///
  /// プロバイダーの処理を定義したID。
  ///
  /// 基本的にfirebaseの`PROVIDER_ID`をベースに定義されます。
  static const String providerId = _kGitHubAuthProviderId;

  /// [firebase_auth.AuthProvider] for performing [Authentication.signIn].
  ///
  /// [Authentication.signIn]を実行するための[firebase_auth.AuthProvider]。
  ///
  /// {@macro github_auth}
  static FirebaseGitHubSignInAuthProvider signIn() {
    return const FirebaseGitHubSignInAuthProvider();
  }

  /// [firebase_auth.AuthProvider] for performing [Authentication.reauth].
  ///
  /// [Authentication.reauth]を実行するための[firebase_auth.AuthProvider]。
  ///
  /// {@macro github_auth}
  static FirebaseGitHubReAuthProvider reauth() {
    return const FirebaseGitHubReAuthProvider();
  }
}

/// An `AuthQuery` for GitHub's OAuth authentication on Firebase.
///
/// FirebaseにおけるGitHubのOAuth認証を行うための`AuthQuery`。
class FirebaseGitHubSignInAuthProvider extends FirebaseSnsSignInAuthProvider {
  /// An `AuthQuery` for GitHub's OAuth authentication on Firebase.
  ///
  /// FirebaseにおけるGitHubのOAuth認証を行うための`AuthQuery`。
  const FirebaseGitHubSignInAuthProvider({super.allowMultiProvider = true});

  @override
  String get providerId => _kGitHubAuthProviderId;

  @override
  firebase_auth.AuthProvider authProvider() {
    final provider = GithubAuthProvider();
    return provider;
  }
}

/// An `AuthQuery` for GitHub's OAuth authentication on Firebase.
///
/// FirebaseにおけるGitHubのOAuth認証を行うための`AuthQuery`。
class FirebaseGitHubReAuthProvider extends FirebaseSnsReAuthProvider {
  /// An `AuthQuery` for GitHub's OAuth authentication on Firebase.
  ///
  /// FirebaseにおけるGitHubのOAuth認証を行うための`AuthQuery`。
  const FirebaseGitHubReAuthProvider();

  static const _signInProvider = FirebaseGitHubSignInAuthProvider();

  @override
  String get providerId => _signInProvider.providerId;

  @override
  firebase_auth.AuthProvider authProvider() {
    final provider = GithubAuthProvider();
    return provider;
  }
}
