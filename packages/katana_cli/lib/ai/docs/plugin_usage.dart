// Project imports:
import 'package:katana_cli/ai/docs/plugins/ads.dart';
import 'package:katana_cli/ai/docs/plugins/agora.dart';
import 'package:katana_cli/ai/docs/plugins/animate.dart';
import 'package:katana_cli/ai/docs/plugins/calendar.dart';
import 'package:katana_cli/ai/docs/plugins/camera.dart';
import 'package:katana_cli/ai/docs/plugins/google_map.dart';
import 'package:katana_cli/ai/docs/plugins/introduction.dart';
import 'package:katana_cli/ai/docs/plugins/local_notification.dart';
import 'package:katana_cli/ai/docs/plugins/location.dart';
import 'package:katana_cli/ai/docs/plugins/openai.dart';
import 'package:katana_cli/ai/docs/plugins/picker.dart';
import 'package:katana_cli/ai/docs/plugins/purchase.dart';
import 'package:katana_cli/ai/docs/plugins/sendgrid.dart';
import 'package:katana_cli/ai/docs/plugins/speech_to_text.dart';
import 'package:katana_cli/ai/docs/plugins/stripe.dart';
import 'package:katana_cli/ai/docs/plugins/text_to_speech.dart';
import 'package:katana_cli/katana_cli.dart';

/// List of Plugin types.
///
/// Pluginタイプのリスト。
const kPluginList = {
  "ads": PluginAdsMdcCliAiCode(),
  "agora": PluginAgoraMdcCliAiCode(),
  "animate": PluginAnimateMdcCliAiCode(),
  "calendar": PluginCalendarMdcCliAiCode(),
  "camera": PluginCameraMdcCliAiCode(),
  "google_map": PluginGoogleMapMdcCliAiCode(),
  "introduction": PluginIntroductionMdcCliAiCode(),
  "local_notification": PluginLocalNotificationMdcCliAiCode(),
  "location": PluginLocationMdcCliAiCode(),
  "openai": PluginOpenAiMdcCliAiCode(),
  "picker": PluginPickerMdcCliAiCode(),
  "purchase": PluginPurchaseMdcCliAiCode(),
  "sendgrid": PluginSendgridMdcCliAiCode(),
  "speech_to_text": PluginSpeechToTextMdcCliAiCode(),
  "stripe": PluginStripeMdcCliAiCode(),
  "text_to_speech": PluginTextToSpeechMdcCliAiCode(),
};

/// Contents of plugin_usage.mdc.
///
/// plugin_usage.mdcの中身。
abstract class PluginUsageCliAiCode extends CliAiCode {
  /// Contents of katana_ui_usage.mdc.
  ///
  /// plugin_usage.mdcの中身。
  const PluginUsageCliAiCode();

  /// Excerpt of the katana ui.
  ///
  /// KatanaUIの概要。
  String get excerpt;
}

/// Contents of plugin_usage.mdc.
///
/// plugin_usage.mdcの中身。
class PluginUsageMdcCliAiCode extends CliAiCode {
  /// Contents of plugin_usage.mdc.
  ///
  /// plugin_usage.mdcの中身。
  const PluginUsageMdcCliAiCode();

  @override
  String get name => "`Plugin`の一覧とその利用方法";

  @override
  String get description => "アプリ開発で利用可能な`Plugin`の一覧とその利用方法";

  @override
  String get globs => "lib/**/*.dart, test/**/*.dart";

  @override
  String get directory => "docs";

  @override
  String body(String baseName, String className) {
    var header = r"""
アプリ開発で利用可能な`Plugin`の一覧とその利用方法を下記に記載する。

## `Plugin`の一覧

| PluginID | PluginName | Summary | Usage |
| --- | --- | --- | --- |
""";
    for (final entry in kPluginList.entries) {
      header +=
          "| `${entry.key} | ${entry.value.name} | ${entry.value.excerpt} | [Usage](mdc:.cursor/rules/plugin/${entry.key.toSnakeCase()}.mdc) |\n";
    }
    return header;
  }
}
