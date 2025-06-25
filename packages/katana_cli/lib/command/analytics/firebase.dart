part of "analytics.dart";

/// Configure settings related to FirebaseAnalytics.
///
/// FirebaseAnalyticsに関連する設定を行います。
class AnalyitcsFirebaseCliCommand extends CliCommand {
  /// Configure settings related to FirebaseAnalytics.
  ///
  /// FirebaseAnalyticsに関連する設定を行います。
  const AnalyitcsFirebaseCliCommand();

  @override
  String get description =>
      "Configure settings related to FirebaseAnalytics. FirebaseAnalyticsに関連する設定を行います。";

  @override
  String? get example => "katana analytics firebase";

  @override
  Future<void> exec(ExecContext context) async {}
}
