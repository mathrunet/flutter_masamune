part of '/masamune_auth_google_firebase.dart';

const _kGoogleAuthProviderId = "google.com";

/// {@template google_auth}
/// An `AuthQuery` to authenticate with a Google account on Firebase.
///
/// [signIn] and [reauth] are available.
///
/// [signOut] logs you out of your Google account rather than providing Provider.
///
/// FirebaseにおけるGoogleアカウントでの認証を行うための`AuthQuery`。
///
/// [signIn]および[reauth]が利用可能です。
///
/// [signOut]はProviderを提供するのではなくGoogleアカウントからログアウトします。
/// {@endtemplate}
class FirebaseGoogleAuthQuery {
  const FirebaseGoogleAuthQuery._();

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
  static FirebaseGoogleSignInAuthProvider signIn() {
    return const FirebaseGoogleSignInAuthProvider();
  }

  /// [AuthProvider] for performing [Authentication.reauth].
  ///
  /// [Authentication.reauth]を実行するための[AuthProvider]。
  ///
  /// {@macro google_auth}
  static FirebaseGoogleReAuthProvider reauth() {
    return const FirebaseGoogleReAuthProvider();
  }
}

/// An `AuthQuery` for Google's OAuth authentication on Firebase.
///
/// FirebaseにおけるGoogleのOAuth認証を行うための`AuthQuery`。
class FirebaseGoogleSignInAuthProvider extends FirebaseSnsSignInAuthProvider {
  /// An `AuthQuery` for Google's OAuth authentication on Firebase.
  ///
  /// FirebaseにおけるGoogleのOAuth認証を行うための`AuthQuery`。
  const FirebaseGoogleSignInAuthProvider({super.allowMultiProvider = true});

  @override
  String get providerId => _kGoogleAuthProviderId;

  @override
  firebase_auth.AuthProvider authProvider() {
    return GoogleAuthProvider();
  }
}

/// An `AuthQuery` for Google's OAuth authentication on Firebase.
///
/// FirebaseにおけるGoogleのOAuth認証を行うための`AuthQuery`。
class FirebaseGoogleReAuthProvider extends FirebaseSnsReAuthProvider {
  /// An `AuthQuery` for Google's OAuth authentication on Firebase.
  ///
  /// FirebaseにおけるGoogleのOAuth認証を行うための`AuthQuery`。
  const FirebaseGoogleReAuthProvider();

  static const _signInProvider = FirebaseGoogleSignInAuthProvider();

  @override
  String get providerId => _signInProvider.providerId;

  @override
  firebase_auth.AuthProvider authProvider() {
    return GoogleAuthProvider();
  }
}
