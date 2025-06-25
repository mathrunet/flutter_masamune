part of "analytics.dart";

/// Configure settings related to AppStoreConnect.
///
/// AppStoreConnectに関連する設定を行います。
class AnalyitcsAppStoreCliCommand extends CliCommand {
  /// Configure settings related to AppStoreConnect.
  ///
  /// AppStoreConnectに関連する設定を行います。
  const AnalyitcsAppStoreCliCommand();

  @override
  String get description =>
      "Configure settings related to AppStoreConnect. AppStoreConnectに関連する設定を行います。";

  @override
  String? get example => "katana analytics appstore";

  @override
  Future<void> exec(ExecContext context) async {}
}
