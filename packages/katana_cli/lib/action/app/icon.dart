// ignore_for_file: implementation_imports

// Dart imports:
import "dart:io";

// Package imports:
import "package:image/image.dart";
import "package:image/src/formats/ico_encoder.dart";

// Project imports:
import "package:katana_cli/katana_cli.dart";

final _sizeList = {
  "documents/store/icon.png": 512,
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

final _sizeListAdaptiveBackground = {
  "android/app/src/main/res/mipmap-hdpi/ic_launcher_background.png": 162,
  "android/app/src/main/res/mipmap-mdpi/ic_launcher_background.png": 108,
  "android/app/src/main/res/mipmap-xhdpi/ic_launcher_background.png": 216,
  "android/app/src/main/res/mipmap-xxhdpi/ic_launcher_background.png": 324,
  "android/app/src/main/res/mipmap-xxxhdpi/ic_launcher_background.png": 432,
};
final _sizeListAdaptiveForeground = {
  "android/app/src/main/res/mipmap-hdpi/ic_launcher_foreground.png": 162,
  "android/app/src/main/res/mipmap-mdpi/ic_launcher_foreground.png": 108,
  "android/app/src/main/res/mipmap-xhdpi/ic_launcher_foreground.png": 216,
  "android/app/src/main/res/mipmap-xxhdpi/ic_launcher_foreground.png": 324,
  "android/app/src/main/res/mipmap-xxxhdpi/ic_launcher_foreground.png": 432,
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
    final adaptive = icon.getAsMap("adaptive_icon");
    final adaptiveBackground = adaptive.get("background", "");
    final adaptiveForeground = adaptive.get("foreground", "");
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
    if (adaptiveBackground.isNotEmpty && adaptiveForeground.isNotEmpty) {
      label("Load a file from $adaptiveBackground");
      final backgroundIconFile = File(adaptiveBackground);
      final backgroundIsColor = !backgroundIconFile.existsSync();
      label("Load a file from $adaptiveForeground");
      final foregroundIconFile = File(adaptiveForeground);
      if (!foregroundIconFile.existsSync()) {
        error("Icon file not found in $adaptiveForeground.");
        return;
      }
      final backgroundIconImage = backgroundIsColor
          ? null
          : decodeImage(backgroundIconFile.readAsBytesSync())!;
      if (backgroundIconImage != null) {
        if (backgroundIconImage.width != 1024 ||
            backgroundIconImage.height != 1024) {
          error("Icon files should be 1024 x 1024.");
          return;
        }
        for (final tmp in _sizeListAdaptiveBackground.entries) {
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
            backgroundIconImage,
            height: tmp.value,
            width: tmp.value,
            interpolation: Interpolation.average,
          );
          await file.writeAsBytes(encodePng(resized, level: 9));
        }
      }
      final foregroundIconImage =
          decodeImage(foregroundIconFile.readAsBytesSync())!;
      if (foregroundIconImage.width != 1024 ||
          foregroundIconImage.height != 1024) {
        error("Icon files should be 1024 x 1024.");
        return;
      }
      for (final tmp in _sizeListAdaptiveForeground.entries) {
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
          foregroundIconImage,
          height: tmp.value,
          width: tmp.value,
          interpolation: Interpolation.average,
        );
        await file.writeAsBytes(encodePng(resized, level: 9));
      }
      label("Create a ic_launcher.xml");
      await IcLauncherCliCode(
        backgroundIsColor: backgroundIsColor,
      ).generateFile("ic_launcher.xml");
      if (backgroundIsColor) {
        await ColorValueCliCode(
          backgroundColorCode: adaptiveBackground.trimString("#"),
        ).generateFile("colors.xml");
      }
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

/// Contents of ic_launcher.xml.
///
/// ic_launcher.xmlの中身。
class IcLauncherCliCode extends CliCode {
  /// Contents of launch.json.
  ///
  /// launch.jsonの中身。
  const IcLauncherCliCode({this.backgroundIsColor = false});

  /// `true` if background is color.
  ///
  /// 背景が色の場合`true`。
  final bool backgroundIsColor;

  @override
  String get name => "ic_launcher";

  @override
  String get prefix => "ic_launcher";

  @override
  String get directory => "android/app/src/main/res/mipmap-anydpi-v26";

  @override
  String get description =>
      "Create ic_launcher.xml for adaptive icons. アダプティブアイコン用のic_launcher.xmlを作成します。";

  @override
  String import(String path, String baseName, String className) {
    return "";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="${backgroundIsColor ? "@color/ic_launcher_background" : "@mipmap/ic_launcher_background"}"/>
    <foreground android:drawable="@mipmap/ic_launcher_foreground"/>
</adaptive-icon>
""";
  }
}

/// Contents of values/colors.xml.
///
/// values/colors.xmlの中身。
class ColorValueCliCode extends CliCode {
  /// Contents of values/colors.xml.
  ///
  /// values/colors.xmlの中身。
  const ColorValueCliCode({required this.backgroundColorCode});

  /// Background color.
  ///
  /// 背景の色。
  final String backgroundColorCode;

  @override
  String get name => "colors";

  @override
  String get prefix => "colors";

  @override
  String get directory => "android/app/src/main/res/values";

  @override
  String get description =>
      "Create values/colors.xml for adaptive icons. アダプティブアイコン用のvalues/colors.xmlを作成します。";

  @override
  String import(String path, String baseName, String className) {
    return "";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="ic_launcher_background">#$backgroundColorCode</color>
</resources>
""";
  }
}
