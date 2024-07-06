part of '/katana_auth.dart';

/// Class for implementing callbacks from [Authentication] or [AuthAdapter] during authentication.
///
/// [Authentication]や[AuthAdapter]から認証時のコールバックを実装するためのクラス。
class AuthActionQuery extends AuthAction {
  /// Class for implementing callbacks from [Authentication] or [AuthAdapter] during authentication.
  ///
  /// [Authentication]や[AuthAdapter]から認証時のコールバックを実装するためのクラス。
  AuthActionQuery({
    Future<void> Function()? onRestoredAuth,
    Future<void> Function()? onSignIn,
    Future<void> Function()? onSignedIn,
    Future<void> Function()? onSignOut,
    Future<void> Function()? onSignedOut,
  })  : _onRestoredAuth = onRestoredAuth,
        _onSignIn = onSignIn,
        _onSignedIn = onSignedIn,
        _onSignOut = onSignOut,
        _onSignedOut = onSignedOut;

  final Future<void> Function()? _onRestoredAuth;
  final Future<void> Function()? _onSignIn;
  final Future<void> Function()? _onSignedIn;
  final Future<void> Function()? _onSignOut;
  final Future<void> Function()? _onSignedOut;

  @override
  Future<void> onRestoredAuth() async {
    await _onRestoredAuth?.call();
  }

  @override
  Future<void> onSignIn() async {
    await _onSignIn?.call();
  }

  @override
  Future<void> onSignedIn() async {
    await _onSignedIn?.call();
  }

  @override
  Future<void> onSignOut() async {
    await _onSignOut?.call();
  }

  @override
  Future<void> onSignedOut() async {
    await _onSignedOut?.call();
  }
}

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

  /// Executed when authentication information is restored.
  ///
  /// 認証情報を復元したときに実行されます。
  Future<void> onRestoredAuth() => Future.value();

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
