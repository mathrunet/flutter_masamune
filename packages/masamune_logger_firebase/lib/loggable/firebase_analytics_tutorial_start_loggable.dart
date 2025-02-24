part of '/masamune_logger_firebase.dart';

/// Loggable for Firebase Analytics Tutorial Start.
///
/// Firebase Analytics チュートリアル開始用の Loggable。
class FirebaseAnalyticsTutorialStartLoggable extends Loggable {
  /// Loggable for Firebase Analytics Tutorial Start.
  ///
  /// Firebase Analytics チュートリアル開始用の Loggable。
  const FirebaseAnalyticsTutorialStartLoggable();

  @override
  String get name => FirebaseAnalyticsLoggerEvent.tutorialStart.toString();

  @override
  Map<String, dynamic> toJson() {
    return {};
  }
}
