part of '/katana_auth.dart';

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

/// {@template sns_reauth}
/// An `AuthQuery` for OAuth re-authentication of SNS.
///
/// SNSのOAuth再認証を行うための`AuthQuery`。
/// {@endtemplate}
abstract class SnsReAuthProvider extends ReAuthProvider {
  /// {@template sns_reauth}
  /// An `AuthQuery` for OAuth re-authentication of SNS.
  ///
  /// SNSのOAuth再認証を行うための`AuthQuery`。
  /// {@endtemplate}
  const SnsReAuthProvider();

  /// Obtain credentials for SNS sign-in.
  ///
  /// Return with [Credential] to pass information to Firebase, etc.
  ///
  /// SNSサインインを行うための認証情報を取得します。
  ///
  /// [Credential]で返すことによりFirebaseなどに情報を渡します。
  Future<Credential> credential();
}
