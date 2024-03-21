// Dart imports:

// Package imports:

// Dart imports:
import 'dart:io';

// Package imports:
import 'package:xml/xml.dart';

// Project imports:
import 'package:katana_cli/katana_cli.dart';

/// Add a module for using ads.
///
/// 広告を利用するためのモジュールを追加します。
class AdsCliAction extends CliCommand with CliActionMixin {
  /// Add a module for using ads.
  ///
  /// 広告を利用するためのモジュールを追加します。
  const AdsCliAction();

  @override
  String get description =>
      "Add a module for using ads. 広告を利用するためのモジュールを追加します。";

  @override
  bool checkEnabled(ExecContext context) {
    final ads = context.yaml.getAsMap("ads");
    final enable = ads.get("enable", false);
    if (!enable) {
      return false;
    }
    return true;
  }

  @override
  Future<void> exec(ExecContext context) async {
    final ads = context.yaml.getAsMap("ads");
    final androidAppId = ads.get("android_app_id", "");
    final iosAppId = ads.get("ios_app_id", "");
    final permission = ads.getAsMap("permission");
    if (androidAppId.isEmpty && iosAppId.isEmpty) {
      throw Exception(
        "Specify the app ID for Android or iOS in [ads]->[android_app_id] or [ads]->[ios_app_id].",
      );
    }
    await addFlutterImport(
      [
        "masamune_ads_google",
      ],
    );
    if (androidAppId.isNotEmpty) {
      label("Edit AndroidManifest.xml.");
      final file = File("android/app/src/main/AndroidManifest.xml");
      if (!file.existsSync()) {
        throw Exception(
          "AndroidManifest does not exist in `android/app/src/main/AndroidManifest.xml`. Do `katana create` to complete the initial setup of the project.",
        );
      }
      final document = XmlDocument.parse(await file.readAsString());
      final manifest = document.findAllElements("manifest");
      if (manifest.isEmpty) {
        throw Exception(
          "The structure of AndroidManifest.xml is broken. Do `katana create` to complete the initial setup of the project.",
        );
      }
      final application = document.findAllElements("application");
      final applicationIdData = application.first.children.firstWhereOrNull(
        (p0) =>
            p0 is XmlElement &&
            p0.name.toString() == "meta-data" &&
            p0.attributes.any(
              (p1) =>
                  p1.name.toString() == "android:name" &&
                  p1.value == "com.google.android.gms.ads.APPLICATION_ID",
            ),
      );
      if (applicationIdData == null) {
        application.first.children.add(
          XmlElement(
            XmlName("meta-data"),
            [
              XmlAttribute(
                XmlName("android:name"),
                "com.google.android.gms.ads.APPLICATION_ID",
              ),
              XmlAttribute(
                XmlName("android:value"),
                androidAppId,
              ),
            ],
            [],
          ),
        );
      } else {
        applicationIdData.attributes
          ..clear()
          ..addAll([
            XmlAttribute(
              XmlName("android:name"),
              "com.google.android.gms.ads.APPLICATION_ID",
            ),
            XmlAttribute(
              XmlName("android:value"),
              androidAppId,
            ),
          ]);
      }
      await file.writeAsString(
        document.toXmlString(pretty: true, indent: "    ", newLine: "\n"),
      );
    }
    if (iosAppId.isNotEmpty) {
      label("Edit Info.plist.");
      final plist = File("ios/Runner/Info.plist");
      final document = XmlDocument.parse(await plist.readAsString());
      final dict = document.findAllElements("dict").firstOrNull;
      if (dict == null) {
        throw Exception(
          "Could not find `dict` element in `ios/Runner/Info.plist`. File is corrupt.",
        );
      }
      final applicationIdData = dict.children.firstWhereOrNull((p0) {
        return p0 is XmlElement &&
            p0.name.toString() == "key" &&
            p0.innerText == "GADApplicationIdentifier";
      });
      if (applicationIdData == null) {
        dict.children.addAll(
          [
            XmlElement(
              XmlName("key"),
              [],
              [XmlText("GADApplicationIdentifier")],
            ),
            XmlElement(XmlName("string"), [], [XmlText(iosAppId)]),
          ],
        );
      } else {
        applicationIdData.nextElementSibling!.innerText = iosAppId;
      }
      await plist.writeAsString(
        document.toXmlString(pretty: true, indent: "\t", newLine: "\n"),
      );
    }
    label("Addition of permission messages.");
    await XCodePermissionType.userTrackingUsage.setMessageToXCode(
      permission
          .map((key, value) => MapEntry(key, value.toString()))
          .where((key, value) => value.isNotEmpty),
    );
    await PodfilePermissionType.userTrackingUsage.enablePermissionToPodfile();
  }
}
