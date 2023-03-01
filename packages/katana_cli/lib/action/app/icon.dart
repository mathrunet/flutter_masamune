// ignore_for_file: implementation_imports

// Dart imports:
import 'dart:io';

// Package imports:
import 'package:image/image.dart';
import 'package:image/src/formats/ico_encoder.dart';

// Project imports:
import 'package:katana_cli/katana_cli.dart';

final _sizeList = {
  "document/store/icon.png": 512,
  "android/app/src/main/res/mipmap-hdpi/ic_launcher.png": 72,
  "android/app/src/main/res/mipmap-mdpi/ic_launcher.png": 48,
  "android/app/src/main/res/mipmap-xhdpi/ic_launcher.png": 96,
  "android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png": 144,
  "android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png": 192,
  "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@1x.png": 20,
  "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@2x.png": 40,
  "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@3x.png": 60,
  "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@1x.png": 29,
  "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@2x.png": 58,
  "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@3x.png": 87,
  "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@1x.png": 40,
  "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@2x.png": 80,
  "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@3x.png": 120,
  "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@2x.png": 120,
  "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@3x.png": 180,
  "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@1x.png": 76,
  "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@2x.png": 152,
  "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-83.5x83.5@2x.png":
      167,
  "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png":
      1024,
  "web/feature.png": 1024,
  "web/icons/Icon-192.png": 192,
  "web/icons/Icon-512.png": 512,
  "web/icons/Icon-maskable-192.png": 192,
  "web/icons/Icon-maskable-512.png": 512,
};

final _faviconSize = [
  16,
  32,
  192,
];

/// Automatically creates icon files for applications.
///
/// アプリ用のアイコンファイルを自動作成します。
class AppIconCliAction extends CliCommand with CliActionMixin {
  /// Automatically creates icon files for applications.
  ///
  /// アプリ用のアイコンファイルを自動作成します。
  const AppIconCliAction();

  @override
  String get description =>
      "Automatically creates icon files for applications. アプリ用のアイコンファイルを自動作成します。";

  @override
  bool checkEnabled(ExecContext context) {
    final value = context.yaml.getAsMap("app").getAsMap("icon");
    final enabled = value.get("enable", false);
    final path = value.get("path", "");
    if (!enabled || path.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  Future<void> exec(ExecContext context) async {
    final app = context.yaml.getAsMap("app");
    if (app.isEmpty) {
      error("The item [app] is missing. Please add an item.");
      return;
    }
    final icon = app.getAsMap("icon");
    if (icon.isEmpty) {
      error("The item [app]->[icon] is missing. Please add an item.");
      return;
    }
    final path = icon.get("path", "");
    if (path.isEmpty) {
      error(
        "The item [app]->[icon]->[path] is missing. Please provide the path to the original icon.",
      );
      return;
    }
    label("Load a file from $path");
    final iconFile = File(path);
    if (!iconFile.existsSync()) {
      error("Icon file not found in $path.");
      return;
    }
    final iconImage = decodeImage(iconFile.readAsBytesSync())!;
    if (iconImage.width != 1024 || iconImage.height != 1024) {
      error("Icon files should be 1024 x 1024.");
      return;
    }
    for (final tmp in _sizeList.entries) {
      label("Resize & Save to ${tmp.key}");
      final dir = Directory(tmp.key.parentPath());
      if (!dir.existsSync()) {
        await dir.create(recursive: true);
      }
      final file = File(tmp.key);
      if (file.existsSync()) {
        await file.delete();
      }
      final resized = copyResize(
        iconImage,
        height: tmp.value,
        width: tmp.value,
        interpolation: Interpolation.average,
      );
      await file.writeAsBytes(encodePng(resized, level: 9));
    }
    final icoFile = File("web/favicon.ico");
    if (icoFile.existsSync()) {
      await icoFile.delete();
    }
    final ico = IcoEncoder();
    await icoFile.writeAsBytes(
      ico.encodeImages(_faviconSize.map((e) {
        return copyResize(
          iconImage,
          height: e,
          width: e,
          interpolation: Interpolation.average,
        );
      }).toList()),
    );
  }
}
