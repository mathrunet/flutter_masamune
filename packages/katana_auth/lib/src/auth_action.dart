part of '/katana_auth.dart';

/// Base class that allows callbacks to be planted for sign-in and sign-out.
///
/// Use when implementing sign-in and sign-out processes for various social networking services.
///
/// サインインとサインアウトにコールバックを仕込むことができるベースクラス。
///
/// 各種SNSのサインインやサインアウトの処理を実装する際に使用してください。
abstract class AuthAction {
  /// Base class that allows callbacks to be planted for sign-in and sign-out.
  ///
  /// Use when implementing sign-in and sign-out processes for various social networking services.
  ///
  /// サインインとサインアウトにコールバックを仕込むことができるベースクラス。
  ///
  /// 各種SNSのサインインやサインアウトの処理を実装する際に使用してください。
  const AuthAction();

  /// Runs before sign-in.
  ///
  /// サインイン前に実行されます。
  Future<void> onSignIn() => Future.value();

  /// It is performed after successful sign-in.
  ///
  /// サインインが成功した後に実行されます。
  Future<void> onSignedIn() => Future.value();

  /// Runs before signing out.
  ///
  /// サインアウト前に実行されます。
  Future<void> onSignOut() => Future.value();

  /// It is performed after a successful sign-out.
  ///
  /// サインアウトが成功した後に実行されます。
  Future<void> onSignedOut() => Future.value();
}
