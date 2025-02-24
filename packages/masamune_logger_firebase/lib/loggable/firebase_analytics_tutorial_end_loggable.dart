part of '/masamune_logger_firebase.dart';

/// Loggable for Firebase Analytics Tutorial End.
///
/// Firebase Analytics チュートリアル終了用の Loggable。
class FirebaseAnalyticsTutorialEndLoggable extends Loggable {
  /// Loggable for Firebase Analytics Tutorial End.
  ///
  /// Firebase Analytics チュートリアル終了用の Loggable。
  const FirebaseAnalyticsTutorialEndLoggable();

  @override
  String get name => FirebaseAnalyticsLoggerEvent.tutorialEnd.toString();

  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}
