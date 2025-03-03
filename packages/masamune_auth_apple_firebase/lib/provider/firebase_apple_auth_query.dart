part of '/masamune_auth_apple_firebase.dart';

const _kAppleAuthProviderId = "apple.com";

/// {@template apple_auth}
/// An `AuthQuery` to authenticate with your Apple account on Firebase.
///
/// [signIn] and [reauth] are available.
///
/// FirebaseにおけるAppleアカウントでの認証を行うための`AuthQuery`。
///
/// [signIn]および[reauth]が利用可能です。
/// {@endtemplate}
class FirebaseAppleAuthQuery {
  const FirebaseAppleAuthQuery._();

  /// ID that defines the provider's process.
  ///
  /// Basically, it is defined based on firebase's `PROVIDER_ID`.
  ///
  /// プロバイダーの処理を定義したID。
  ///
  /// 基本的にfirebaseの`PROVIDER_ID`をベースに定義されます。
  static const String providerId = _kAppleAuthProviderId;

  /// [AuthProvider] for performing [Authentication.signIn].
  ///
  /// [Authentication.signIn]を実行するための[AuthProvider]。
  ///
  /// {@macro apple_auth}
  static FirebaseAppleSignInAuthProvider signIn() {
    return const FirebaseAppleSignInAuthProvider();
  }

  /// [AuthProvider] for performing [Authentication.reauth].
  ///
  /// [Authentication.reauth]を実行するための[AuthProvider]。
  ///
  /// {@macro apple_auth}
  static FirebaseAppleReAuthProvider reauth() {
    return const FirebaseAppleReAuthProvider();
  }
}

/// An `AuthQuery` for Apple's OAuth authentication on Firebase.
///
/// FirebaseにおけるAppleのOAuth認証を行うための`AuthQuery`。
class FirebaseAppleSignInAuthProvider extends FirebaseSnsSignInAuthProvider {
  /// An `AuthQuery` for Apple's OAuth authentication on Firebase.
  ///
  /// FirebaseにおけるAppleのOAuth認証を行うための`AuthQuery`。
  const FirebaseAppleSignInAuthProvider({super.allowMultiProvider = true});

  @override
  String get providerId => _kAppleAuthProviderId;

  @override
  firebase_auth.AuthProvider authProvider() {
    return AppleAuthProvider();
  }
}

/// An `AuthQuery` for Apple's OAuth re-authentication on Firebase.
///
/// FirebaseにおけるAppleのOAuth再認証を行うための`AuthQuery`。
class FirebaseAppleReAuthProvider extends FirebaseSnsReAuthProvider {
  /// An `AuthQuery` for Apple's OAuth re-authentication on Firebase.
  ///
  /// FirebaseにおけるAppleのOAuth再認証を行うための`AuthQuery`。
  const FirebaseAppleReAuthProvider();

  static const _signInProvider = FirebaseAppleSignInAuthProvider();

  @override
  String get providerId => _signInProvider.providerId;

  @override
  firebase_auth.AuthProvider authProvider() => _signInProvider.authProvider();
}
