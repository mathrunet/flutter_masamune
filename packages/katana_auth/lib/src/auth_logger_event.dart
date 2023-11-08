part of '/katana_auth.dart';

/// Authentication events for logging.
///
/// ロギング用の認証イベント。
enum AuthLoggerEvent {
  /// User Creation.
  ///
  /// ユーザー作成。
  create,

  /// Registration.
  ///
  /// 登録。
  register,

  /// Sign in.
  ///
  /// サインイン。
  signIn,

  /// Register or Sign in.
  ///
  /// 登録もしくはサインイン。
  registerOrSignIn,

  /// Sign out.
  ///
  /// サインアウト。
  signOut;

  /// User ID key.
  ///
  /// ユーザーIDのキー。
  static const userIdKey = "userId";

  /// Provider ID key.
  ///
  /// プロバイダーIDのキー。
  static const providerKey = "provider";
}
