part of '/masamune_logger_firebase.dart';

/// Loggable for Firebase Analytics Sign In.
///
/// Firebase Analytics サインイン用の Loggable。
class FirebaseAnalyticsSignInLoggable extends Loggable {
  /// Loggable for Firebase Analytics Sign In.
  ///
  /// Firebase Analytics サインイン用の Loggable。
  const FirebaseAnalyticsSignInLoggable({
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
  String get name => AuthLoggerEvent.signIn.toString();

  @override
  Map<String, dynamic> toJson() {
    return {
      AuthLoggerEvent.userIdKey: userId,
      AuthLoggerEvent.providerKey: providerId,
    };
  }
}
