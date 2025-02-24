part of '/masamune_logger_firebase.dart';

/// Loggable for Firebase Analytics Register.
///
/// Firebase Analytics 登録用の Loggable。
class FirebaseAnalyticsRegisterLoggable extends Loggable {
  /// Loggable for Firebase Analytics Register.
  ///
  /// Firebase Analytics 登録用の Loggable。
  const FirebaseAnalyticsRegisterLoggable({
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
  String get name => AuthLoggerEvent.register.toString();

  @override
  Map<String, dynamic> toJson() {
    return {
      AuthLoggerEvent.userIdKey: userId,
      AuthLoggerEvent.providerKey: providerId,
    };
  }
}
