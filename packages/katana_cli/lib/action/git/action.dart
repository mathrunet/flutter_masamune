// Project imports:
import 'dart:io';

import 'package:katana_cli/katana_cli.dart';
import 'package:yaml/yaml.dart';
import 'platform/android.dart';
import 'platform/ios.dart';
import 'platform/web.dart';

/// Output yaml for Github Actions.
///
/// Github Actions用のyamlを出力します。
class GitActionCliAction extends CliCommand with CliActionMixin {
  /// Output yaml for Github Actions.
  ///
  /// Github Actions用のyamlを出力します。
  const GitActionCliAction();

  @override
  String get description =>
      "Output yaml for Github Actions. Available platforms are `android`, `ios`, `web`, `windows`, `macos`, and `linux`. Github Actions用のyamlを出力します。使用できるプラットフォームは`android`、`ios`、`web`、`windows`、`macos`、`linux`です。";

  @override
  bool checkEnabled(ExecContext context) {
    final value = context.yaml.getAsMap("github").getAsMap("action");
    final enabled = value.get("enable", false);
    if (!enabled) {
      return false;
    }
    return true;
  }

  @override
  Future<void> exec(ExecContext context) async {
    final github = context.yaml.getAsMap("github");
    final action = github.getAsMap("action");
    final platforms = action.get("platform", "").trimString(" ").split(" ");
    if (platforms.isEmpty) {
      error(
        "Platform is not specified. Please pass the platform you want to support as a parameter, like `katana github action android ios web`. Supported platforms are `android`, `ios`, `web`, `windows`, `macos`, and `linux`.",
      );
      return;
    }
    final pubspecFile = File("pubspec.yaml");
    final yaml = modifize(loadYaml(await pubspecFile.readAsString())) as Map;
    final bin = context.yaml.getAsMap("bin");
    final gh = bin.get("gh", "gh");
    final name = yaml.get("name", "");
    for (final platform in platforms) {
      label("Create build.yaml for $platform");
      switch (platform) {
        case "android":
          await buildAndroid(context, gh: gh, appName: name);
          break;
        case "ios":
          await buildIOS(context, gh: gh, appName: name);
          break;
        case "web":
          await buildWeb(context, gh: gh, appName: name);
          break;
      }
    }
  }
}
