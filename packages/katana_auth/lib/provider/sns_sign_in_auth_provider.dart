part of katana_auth;

/// {@template sns_auth}
/// An `AuthQuery` for OAuth authentication for SNS.
///
/// SNSのOAuth認証を行うための`AuthQuery`。
/// {@endtemplate}
abstract class SnsSignInAuthProvider extends SignInAuthProvider {
  /// {@template sns_auth}
  /// An `AuthQuery` for OAuth authentication for SNS.
  ///
  /// SNSのOAuth認証を行うための`AuthQuery`。
  /// {@endtemplate}
  const SnsSignInAuthProvider();

  /// Obtain credentials for SNS sign-in.
  ///
  /// Return with [Credential] to pass information to Firebase, etc.
  ///
  /// SNSサインインを行うための認証情報を取得します。
  ///
  /// [Credential]で返すことによりFirebaseなどに情報を渡します。
  Future<Credential> credential();
}
