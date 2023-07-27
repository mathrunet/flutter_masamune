library katana_cli.store;

// Dart imports:
import 'dart:io';

// Package imports:
import 'package:image/image.dart';

// Project imports:
import 'package:katana_cli/katana_cli.dart';

part 'screenshot.dart';
part 'android_token.dart';
part 'build.dart';

class StoreCliCommand extends CliCommandGroup {
  const StoreCliCommand();

  @override
  String get groupDescription =>
      "Configure settings for the store, including creating screenshots. スクリーンショットの作成など、ストア用の設定を行います。";

  @override
  Map<String, CliCommand> get commands => const {
        "screenshot": StoreScreenshotCliCommand(),
        "android_token": StoreAndroidTokenCliCommand(),
        "build": StoreAndroidBuildCliCommand(),
      };
}
