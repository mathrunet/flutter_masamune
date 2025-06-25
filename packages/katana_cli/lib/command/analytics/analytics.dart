library;

// Project imports:
import "package:katana_cli/katana_cli.dart";

part "firebase.dart";
part "googleplay.dart";
part "appstore.dart";

/// Configure settings related to marketing analytics tools.
///
/// マーケティング用の解析ツールに関連する設定を行います。
class AnalyticsCliCommand extends CliCommandGroup {
  /// Configure settings related to marketing analytics tools.
  ///
  /// マーケティング用の解析ツールに関連する設定を行います。
  const AnalyticsCliCommand();

  @override
  String get groupDescription =>
      "Configure settings related to marketing analytics tools. マーケティング用の解析ツールに関連する設定を行います。";

  @override
  Map<String, CliCommand> get commands => const {
        "firebase": AnalyitcsFirebaseCliCommand(),
        "googleplay": AnalyitcsGooglePlayCliCommand(),
        "appstore": AnalyitcsAppStoreCliCommand(),
      };
}
