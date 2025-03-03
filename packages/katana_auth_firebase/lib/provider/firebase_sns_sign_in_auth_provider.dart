part of '/katana_auth_firebase.dart';

/// {@template firebase_sns_auth}
/// An `AuthQuery` for OAuth authentication for SNS on Firebase.
///
/// FirebaseにおけるSNSのOAuth認証を行うための`AuthQuery`。
/// {@endtemplate}
abstract class FirebaseSnsSignInAuthProvider extends SignInAuthProvider {
  /// {@template firebase_sns_auth}
  /// An `AuthQuery` for OAuth authentication for SNS on Firebase.
  ///
  /// FirebaseにおけるSNSのOAuth認証を行うための`AuthQuery`。
  /// {@endtemplate}
  const FirebaseSnsSignInAuthProvider({super.allowMultiProvider = true});

  /// Obtain an authentication provider for SNS sign-in in Firebase.
  ///
  /// FirebaseにおけるSNSサインインを行うための認証プロバイダーを取得します。
  firebase_auth.AuthProvider authProvider();
}

/// {@template firebase_sns_reauth}
/// An `AuthQuery` for OAuth re-authentication of SNS on Firebase.
///
/// FirebaseにおけるSNSのOAuth再認証を行うための`AuthQuery`。
/// {@endtemplate}
abstract class FirebaseSnsReAuthProvider extends ReAuthProvider {
  /// {@template firebase_sns_reauth}
  /// An `AuthQuery` for OAuth re-authentication of SNS on Firebase.
  ///
  /// FirebaseにおけるSNSのOAuth再認証を行うための`AuthQuery`。
  /// {@endtemplate}
  const FirebaseSnsReAuthProvider();

  /// Obtain an authentication provider for SNS re-authentication in Firebase.
  ///
  /// FirebaseにおけるSNS再認証を行うための認証プロバイダーを取得します。
  firebase_auth.AuthProvider authProvider();
}
