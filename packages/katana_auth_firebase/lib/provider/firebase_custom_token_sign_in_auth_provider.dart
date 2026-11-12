part of "/katana_auth_firebase.dart";

/// {@template firebase_custom_token_sign_in_auth}
/// An `AuthQuery` for signing in to Firebase Authentication with a custom token.
///
/// Pass the custom token issued by your own server (e.g. created with the Firebase Admin SDK) to [token].
///
/// The token is only kept in memory and passed to [FirebaseAuth.signInWithCustomToken] inside [FirebaseAuthAdapter]. It is never persisted by this package.
///
/// A custom token cannot be linked to an existing user. If a user is already signed in, an exception is thrown, so sign out before signing in with a custom token.
///
/// An empty [token] is rejected with a [FirebaseAuthException] whose code is `invalid-custom-token` without calling Firebase.
///
/// Firebaseのカスタムトークンでサインインを行うための`AuthQuery`。
///
/// 自前のサーバー（Firebase Admin SDKなど）で発行したカスタムトークンを[token]に渡します。
///
/// トークンはメモリ上でのみ保持され、[FirebaseAuthAdapter]内で[FirebaseAuth.signInWithCustomToken]に渡されます。このパッケージで永続化されることはありません。
///
/// カスタムトークンは既存ユーザーにリンクできません。すでにサインインしている場合は例外が発生するため、先にサインアウトしてください。
///
/// 空の[token]はFirebaseを呼び出さずにコード`invalid-custom-token`の[FirebaseAuthException]で拒否されます。
/// {@endtemplate}
class FirebaseCustomTokenSignInAuthProvider extends SignInAuthProvider {
  /// {@macro firebase_custom_token_sign_in_auth}
  const FirebaseCustomTokenSignInAuthProvider(this.token)
    : super(allowMultiProvider: false);

  /// Custom token issued by your own server.
  ///
  /// 自前のサーバーで発行したカスタムトークン。
  final String token;

  @override
  String get providerId => "custom";

  @override
  String toString() =>
      "FirebaseCustomTokenSignInAuthProvider(token: <redacted>)";
}
