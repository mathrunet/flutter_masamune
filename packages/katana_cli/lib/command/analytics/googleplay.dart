part of "analytics.dart";

/// Configure settings related to GooglePlayConsole.
///
/// GooglePlayConsoleに関連する設定を行います。
class AnalyitcsGooglePlayCliCommand extends CliCommand {
  /// Configure settings related to GooglePlayConsole.
  ///
  /// GooglePlayConsoleに関連する設定を行います。
  const AnalyitcsGooglePlayCliCommand();

  @override
  String get description =>
      "Configure settings related to GooglePlayConsole. GooglePlayConsoleに関連する設定を行います。";

  @override
  String? get example => "katana analytics googleplay";

  @override
  Future<void> exec(ExecContext context) async {}
}
