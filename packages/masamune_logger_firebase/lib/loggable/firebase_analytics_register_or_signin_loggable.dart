part of '/masamune_logger_firebase.dart';

/// Loggable for Firebase Analytics Register or Sign In.
///
/// Firebase Analytics 登録もしくはサインイン用の Loggable。
class FirebaseAnalyticsRegisterOrSignInLoggable extends Loggable {
  /// Loggable for Firebase Analytics Register or Sign In.
  ///
  /// Firebase Analytics 登録もしくはサインイン用の Loggable。
  const FirebaseAnalyticsRegisterOrSignInLoggable({
    required this.userId,
    required this.providerId,
  });

  /// User ID.
  ///
  /// ユーザーID。
  final String userId;

  /// Provider ID.
  ///
  /// プロバイダーID。
  final String providerId;

  @override
  String get name => AuthLoggerEvent.registerOrSignIn.toString();

  @override
  Map<String, dynamic> toJson() {
    return {
      AuthLoggerEvent.userIdKey: userId,
      AuthLoggerEvent.providerKey: providerId,
    };
  }
}
