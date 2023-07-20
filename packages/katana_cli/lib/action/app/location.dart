// Dart imports:
import 'dart:io';

// Package imports:
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:xml/xml.dart';

// Project imports:
import 'package:katana_cli/katana_cli.dart';

/// Add a module to use location information and GoogleMap.
///
/// 位置情報およびGoogleMapを利用するためのモジュールを追加します。
class AppLocationCliAction extends CliCommand with CliActionMixin {
  /// Add a module to use location information and GoogleMap.
  ///
  /// 位置情報およびGoogleMapを利用するためのモジュールを追加します。
  const AppLocationCliAction();

  @override
  String get description =>
      "Add a module to use location information and GoogleMap. 位置情報およびGoogleMapを利用するためのモジュールを追加します。";

  @override
  bool checkEnabled(ExecContext context) {
    final value = context.yaml.getAsMap("location");
    final enabled = value.get("enable", false);
    if (!enabled) {
      return false;
    }
    return true;
  }

  @override
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final flutter = bin.get("flutter", "flutter");
    final location = context.yaml.getAsMap("location");
    final enableBackground = location.get("enable_background", false);
    final googleMap = location.getAsMap("google_map");
    final enableGoogleMap = googleMap.get("enable", false);
    final googleMapApiKeys = googleMap.getAsMap("api_key");
    final googleMapApiKeyForAndroid = googleMapApiKeys.get("android", "");
    final googleMapApiKeyForIOS = googleMapApiKeys.get("ios", "");
    final googleMapApiKeyForWeb = googleMapApiKeys.get("web", "");
    final permission = location.getAsMap("permission");
    if (enableGoogleMap &&
        googleMapApiKeyForAndroid.isEmpty &&
        googleMapApiKeyForIOS.isEmpty &&
        googleMapApiKeyForWeb.isEmpty) {
      error(
        "[google_map]->[api_key] is missing. Please add the API key issued by Google.",
      );
      return;
    }
    if (permission.isEmpty) {
      error(
        "The item [app]->[picker]->[permission] is missing. Please include the language code and the message when authorization is granted here.",
      );
      return;
    }
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
    if (!manifest.first.children.any((p0) =>
        p0 is XmlElement &&
        p0.name.toString() == "uses-permission" &&
        p0.attributes.any((p1) =>
            p1.name.toString() == "android:name" &&
            p1.value == "android.permission.ACCESS_FINE_LOCATION"))) {
      manifest.first.children.add(
        XmlElement(
          XmlName("uses-permission"),
          [
            XmlAttribute(
              XmlName("android:name"),
              "android.permission.ACCESS_FINE_LOCATION",
            ),
          ],
          [],
        ),
      );
    }
    if (enableBackground) {
      if (!manifest.first.children.any((p0) =>
          p0 is XmlElement &&
          p0.name.toString() == "uses-permission" &&
          p0.attributes.any((p1) =>
              p1.name.toString() == "android:name" &&
              p1.value == "android.permission.ACCESS_BACKGROUND_LOCATION"))) {
        manifest.first.children.add(
          XmlElement(
            XmlName("uses-permission"),
            [
              XmlAttribute(
                XmlName("android:name"),
                "android.permission.ACCESS_BACKGROUND_LOCATION",
              ),
            ],
            [],
          ),
        );
      }
    }
    if (enableGoogleMap) {
      final application = document.findAllElements("application");
      if (!application.first.children.any(
        (p0) =>
            p0 is XmlElement &&
            p0.name.toString() == "meta-data" &&
            p0.attributes.any(
              (p1) =>
                  p1.name.toString() == "android:name" &&
                  p1.value == "com.google.android.geo.API_KEY",
            ),
      )) {
        application.first.children.add(
          XmlElement(
            XmlName("meta-data"),
            [
              XmlAttribute(
                XmlName("android:name"),
                "com.google.android.geo.API_KEY",
              ),
              XmlAttribute(
                XmlName("android:value"),
                googleMapApiKeyForAndroid.isNotEmpty
                    ? googleMapApiKeyForAndroid
                    : (googleMapApiKeyForIOS.isNotEmpty
                        ? googleMapApiKeyForIOS
                        : googleMapApiKeyForWeb),
              ),
            ],
            [],
          ),
        );
      }
    }
    await file.writeAsString(
      document.toXmlString(pretty: true, indent: "    ", newLine: "\n"),
    );
    if (enableGoogleMap) {
      label("Edit config.properties");
      final configPropertiesFile = File("android/config.properties");
      if (!configPropertiesFile.existsSync()) {
        await configPropertiesFile.writeAsString("");
      }
      final configProperties = await configPropertiesFile.readAsLines();
      if (!configProperties
          .any((element) => element.startsWith("flutter.minSdkVersion"))) {
        await configPropertiesFile.writeAsString([
          ...configProperties,
          "flutter.minSdkVersion=23",
        ].join("\n"));
      }
      label("Edit build.gradle");
      final gradle = AppGradle();
      await gradle.load();
      if (!gradle.loadProperties.any((e) => e.name == "configProperties")) {
        gradle.loadProperties.add(
          GradleLoadProperties(
            path: "config.properties",
            name: "configProperties",
            file: "configPropertiesFile",
          ),
        );
      }
      gradle.android?.defaultConfig.minSdkVersion =
          "configProperties[\"flutter.minSdkVersion\"]";
      await gradle.save();
      label("Edit AppDelegate.swift.");
      final file = File("ios/Runner/AppDelegate.swift");
      if (!file.existsSync()) {
        throw Exception(
          "AppDelegate.swift does not exist in `ios/Runner/AppDelegate.swift`. Do `katana create` to complete the initial setup of the project.",
        );
      }
      var swift = await file.readAsString();
      if (!RegExp("import GoogleMaps").hasMatch(swift)) {
        swift = swift.replaceFirst(
          "import Flutter",
          "import Flutter\nimport GoogleMaps",
        );
      }
      if (!RegExp(r"GMSServices.provideAPIKey").hasMatch(swift)) {
        swift = swift.replaceFirst(
          "    GeneratedPluginRegistrant.register",
          "    GMSServices.provideAPIKey(\"${googleMapApiKeyForIOS.isNotEmpty ? googleMapApiKeyForIOS : (googleMapApiKeyForAndroid.isNotEmpty ? googleMapApiKeyForAndroid : googleMapApiKeyForWeb)}\")\n    GeneratedPluginRegistrant.register",
        );
      }
      await file.writeAsString(swift);
      label("Edit index.html");
      final indexHtmlFile = File("web/index.html");
      if (!indexHtmlFile.existsSync()) {
        throw Exception(
          "index.html does not exist in `web/index.html`. Do `katana create` to complete the initial setup of the project.",
        );
      }
      final htmlDocument = parse(await indexHtmlFile.readAsString());
      final head = htmlDocument.head;
      if (head == null) {
        throw Exception(
          "The structure of index.html is broken. Do `katana create` to complete the initial setup of the project.",
        );
      }
      if (!head.children.any((e0) =>
          e0.localName == "script" &&
          e0.attributes["src"] != null &&
          e0.attributes["src"]!
              .startsWith("https://maps.googleapis.com/maps/api/js"))) {
        head.children.add(
          Element.tag("script")
            ..attributes["src"] =
                "https://maps.googleapis.com/maps/api/js?key=${googleMapApiKeyForWeb.isNotEmpty ? googleMapApiKeyForWeb : (googleMapApiKeyForAndroid.isNotEmpty ? googleMapApiKeyForAndroid : googleMapApiKeyForIOS)}",
        );
      }
      await indexHtmlFile.writeAsString(htmlDocument.outerHtml);
    }
    if (enableBackground) {
      label("Edit Info.plist.");
      final plist = File("ios/Runner/Info.plist");
      final document = XmlDocument.parse(await plist.readAsString());
      final dict = document.findAllElements("dict").firstOrNull;
      if (dict == null) {
        throw Exception(
          "Could not find `dict` element in `ios/Runner/Info.plist`. File is corrupt.",
        );
      }
      final node = dict.children.firstWhereOrNull((p0) {
        return p0 is XmlElement &&
            p0.name.toString() == "key" &&
            p0.innerText == "UIBackgroundModes";
      });
      if (node == null) {
        dict.children.addAll(
          [
            XmlElement(
              XmlName("key"),
              [],
              [XmlText("UIBackgroundModes")],
            ),
            XmlElement(
              XmlName("array"),
              [],
              [
                XmlElement(
                  XmlName("string"),
                  [],
                  [XmlText("location")],
                )
              ],
            ),
          ],
        );
      } else {
        final next = node.nextElementSibling;
        if (next is XmlElement && next.name.toString() == "array") {
          if (!next.children.any(
            (p1) =>
                p1 is XmlElement &&
                p1.name.toString() == "string" &&
                p1.innerText == "location",
          )) {
            next.children.add(
              XmlElement(
                XmlName("string"),
                [],
                [XmlText("location")],
              ),
            );
          }
        } else {
          throw Exception(
            "The `ios/Runner/Info.plist` configuration is broken.",
          );
        }
      }
      await plist.writeAsString(
        document.toXmlString(pretty: true, indent: "\t", newLine: "\n"),
      );
    }
    label("Addition of permission messages.");
    await XCodePermissionType.locationWhenInUseUsage.setMessageToXCode(
      permission
          .map((key, value) => MapEntry(key, value.toString()))
          .where((key, value) => value.isNotEmpty),
    );
    await XCodePermissionType.locationAlwaysUsage.setMessageToXCode(
      permission
          .map((key, value) => MapEntry(key, value.toString()))
          .where((key, value) => value.isNotEmpty),
    );
    await XCodePermissionType.locationAlwaysAndWhenInUseUsage.setMessageToXCode(
      permission
          .map((key, value) => MapEntry(key, value.toString()))
          .where((key, value) => value.isNotEmpty),
    );
    await command(
      "Import packages.",
      [
        flutter,
        "pub",
        "add",
        if (enableGoogleMap)
          "masamune_location_google"
        else
          "masamune_location",
      ],
    );
  }
}
