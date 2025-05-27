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
  "ads": PluginAdsMdCliAiCode(),
  "agora": PluginAgoraMdCliAiCode(),
  "animate": PluginAnimateMdCliAiCode(),
  "calendar": PluginCalendarMdCliAiCode(),
  "camera": PluginCameraMdCliAiCode(),
  "google_map": PluginGoogleMapMdCliAiCode(),
  "introduction": PluginIntroductionMdCliAiCode(),
  "local_notification": PluginLocalNotificationMdCliAiCode(),
  "location": PluginLocationMdCliAiCode(),
  "openai": PluginOpenAiMdCliAiCode(),
  "picker": PluginPickerMdCliAiCode(),
  "purchase": PluginPurchaseMdCliAiCode(),
  "sendgrid": PluginSendgridMdCliAiCode(),
  "speech_to_text": PluginSpeechToTextMdCliAiCode(),
  "stripe": PluginStripeMdCliAiCode(),
  "text_to_speech": PluginTextToSpeechMdCliAiCode(),
};

/// Contents of plugin_usage.md.
///
/// plugin_usage.mdの中身。
abstract class PluginUsageCliAiCode extends CliAiCode {
  /// Contents of katana_ui_usage.md.
  ///
  /// plugin_usage.mdの中身。
  const PluginUsageCliAiCode();

  /// Excerpt of the katana ui.
  ///
  /// KatanaUIの概要。
  String get excerpt;
}

/// Contents of plugin_usage.md.
///
/// plugin_usage.mdの中身。
class PluginUsageMdCliAiCode extends CliAiCode {
  /// Contents of plugin_usage.md.
  ///
  /// plugin_usage.mdの中身。
  const PluginUsageMdCliAiCode();

  @override
  String get name => "`Plugin`の一覧とその利用方法";

  @override
  String get description => "アプリ開発で利用可能な`Plugin`の一覧とその利用方法";

  @override
  String get globs => "*.dart";

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
          "| `${entry.key} | ${entry.value.name} | ${entry.value.excerpt} | Usage(`documents/rules/plugin/${entry.key.toSnakeCase()}.md`) |\n";
    }
    return header;
  }
}
