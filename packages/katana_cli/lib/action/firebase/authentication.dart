// Dart imports:
import 'dart:io';

// Package imports:
import 'package:xml/xml.dart';

// Project imports:
import 'package:katana_cli/katana_cli.dart';

/// FirebaseAuthentication deployment process.
///
/// FirebaseAuthenticationのデプロイ処理を行います。
class FirebaseAuthenticationCliAction extends CliCommand with CliActionMixin {
  /// FirebaseAuthentication deployment process.
  ///
  /// FirebaseAuthenticationのデプロイ処理を行います。
  const FirebaseAuthenticationCliAction();

  @override
  String get description =>
      "FirebaseAuthentication deployment process. Please create a Firebase project beforehand. Also, make `firebase` and `flutterfire` commands available. FirebaseAuthenticationのデプロイ処理を行います。予めFirebaseのプロジェクトを作成しておいてください。また、`firebase`と`flutterfire`のコマンドを利用可能にしてください。";

  @override
  bool checkEnabled(ExecContext context) {
    final firebase = context.yaml.getAsMap("firebase");
    final projectId = firebase.get("project_id", "");
    final authentication = firebase.getAsMap("authentication");
    final enableAuthentication = authentication.get("enable", false);
    final providers = authentication.getAsMap("providers");
    final apple = providers.getAsMap("apple");
    final facebook = providers.getAsMap("facebook");
    final google = providers.getAsMap("google");
    return projectId.isNotEmpty &&
        enableAuthentication &&
        (apple.get("enable", false) ||
            facebook.get("enable", false) ||
            google.get("enable", false));
  }

  @override
  Future<void> exec(ExecContext context) async {
    final bin = context.yaml.getAsMap("bin");
    final flutter = bin.get("flutter", "flutter");
    final firebase = context.yaml.getAsMap("firebase");
    final projectId = firebase.get("project_id", "");
    final authentication = firebase.getAsMap("authentication");
    final providers = authentication.getAsMap("providers");
    final apple = providers.getAsMap("apple");
    final facebook = providers.getAsMap("facebook");
    final google = providers.getAsMap("google");
    final enableApple = apple.get("enable", false);
    final enableGoogle = google.get("enable", false);
    final enableFacebook = facebook.get("enable", false);
    final facebookAppId = facebook.get<int?>("app_id", null)?.toString() ??
        facebook.get("app_id", "") ??
        "";
    final facebookAppSecret =
        facebook.get<int?>("app_secret", null)?.toString() ??
            facebook.get("app_secret", "") ??
            "";
    if (projectId.isEmpty) {
      error(
        "The item [firebase]->[project_id] is missing. Please provide the Firebase project ID for the configuration.",
      );
      return;
    }
    if (enableFacebook &&
        (facebookAppId.isEmpty || facebookAppSecret.isEmpty)) {
      error(
        "The item [facebook]->[app_id] or [facebook]->[app_secret] is missing. Please provide the Facebook App ID and App Secret for the configuration.",
      );
      return;
    }
    await command(
      "Import packages.",
      [
        flutter,
        "pub",
        "add",
        if (enableApple) ...[
          "masamune_auth_apple",
        ],
        if (enableFacebook) ...[
          "masamune_auth_facebook",
        ],
        if (enableGoogle) ...[
          "masamune_auth_google",
        ],
      ],
    );
    if (enableGoogle || enableFacebook) {
      label("Load GoogleService-Info.plist.");
      final googleServicePlist = File("ios/Runner/GoogleService-Info.plist");
      final googleServiceDocument =
          XmlDocument.parse(await googleServicePlist.readAsString());
      final googleServiceDict =
          googleServiceDocument.findAllElements("dict").firstOrNull;
      if (googleServiceDict == null) {
        throw Exception(
          "Could not find `dict` element in `ios/Runner/GoogleService-Info.plist`. File is corrupt.",
        );
      }
      final clientIdNode = googleServiceDict.children.firstWhereOrNull((p0) {
        return p0 is XmlElement &&
            p0.name.toString() == "key" &&
            p0.innerText == "CLIENT_ID";
      });
      if (clientIdNode == null) {
        throw Exception(
          "Could not find `CLIENT_ID` element in `ios/Runner/GoogleService-Info.plist`. File is corrupt.",
        );
      }
      final clientId = clientIdNode.nextElementSibling?.innerText;
      final reversedClientIdNode =
          googleServiceDict.children.firstWhereOrNull((p0) {
        return p0 is XmlElement &&
            p0.name.toString() == "key" &&
            p0.innerText == "REVERSED_CLIENT_ID";
      });
      if (reversedClientIdNode == null) {
        throw Exception(
          "Could not find `REVERSED_CLIENT_ID` element in `ios/Runner/GoogleService-Info.plist`. File is corrupt.",
        );
      }
      final reversedClientId =
          reversedClientIdNode.nextElementSibling?.innerText;
      if (clientId.isEmpty || reversedClientId.isEmpty) {
        throw Exception(
          "Could not find `CLIENT_ID` or `REVERSED_CLIENT_ID` element in `ios/Runner/GoogleService-Info.plist`. File is corrupt.",
        );
      }
      label("Edit Info.plist.");
      final plist = File("ios/Runner/Info.plist");
      final iosDocument = XmlDocument.parse(await plist.readAsString());
      final dict = iosDocument.findAllElements("dict").firstOrNull;
      if (dict == null) {
        throw Exception(
          "Could not find `dict` element in `ios/Runner/Info.plist`. File is corrupt.",
        );
      }
      final bundleUrlTypes = dict.children.firstWhereOrNull((p0) {
        return p0 is XmlElement &&
            p0.name.toString() == "key" &&
            p0.innerText == "CFBundleURLTypes";
      });
      if (bundleUrlTypes == null) {
        dict.children.addAll(
          [
            XmlElement(
              XmlName("key"),
              [],
              [
                XmlText("CFBundleURLTypes"),
              ],
            ),
            XmlElement(
              XmlName("array"),
              [],
              [
                XmlElement(
                  XmlName("dict"),
                  [],
                  [
                    XmlElement(
                      XmlName("key"),
                      [],
                      [
                        XmlText("CFBundleTypeRole"),
                      ],
                    ),
                    XmlElement(
                      XmlName("string"),
                      [],
                      [
                        XmlText("Editor"),
                      ],
                    ),
                    XmlElement(
                      XmlName("key"),
                      [],
                      [
                        XmlText("CFBundleURLSchemes"),
                      ],
                    ),
                    XmlElement(
                      XmlName("array"),
                      [],
                      [
                        if (enableGoogle)
                          XmlElement(
                            XmlName("string"),
                            [],
                            [
                              XmlText(reversedClientId!),
                            ],
                          ),
                        if (enableFacebook)
                          XmlElement(
                            XmlName("string"),
                            [],
                            [
                              XmlText("fb$facebookAppId"),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      } else {
        final urlSchemeArray = bundleUrlTypes.nextElementSibling;
        if (urlSchemeArray == null) {
          throw Exception(
            "Could not find `CFBundleURLTypes` value element in `ios/Runner/Info.plist`. File is corrupt.",
          );
        }
        if (!urlSchemeArray.children.any(
          (p1) =>
              p1 is XmlElement &&
              p1.children.any((p2) =>
                  p2 is XmlElement &&
                  p2.name.toString() == "array" &&
                  p2.children.any((p3) =>
                      p3 is XmlElement &&
                      p3.name.toString() == "string" &&
                      p3.innerText == reversedClientId)),
        )) {
          urlSchemeArray.children.add(
            XmlElement(
              XmlName("dict"),
              [],
              [
                XmlElement(
                  XmlName("key"),
                  [],
                  [
                    XmlText("CFBundleTypeRole"),
                  ],
                ),
                XmlElement(
                  XmlName("string"),
                  [],
                  [
                    XmlText("Editor"),
                  ],
                ),
                XmlElement(
                  XmlName("key"),
                  [],
                  [
                    XmlText("CFBundleURLSchemes"),
                  ],
                ),
                XmlElement(
                  XmlName("array"),
                  [],
                  [
                    XmlElement(
                      XmlName("string"),
                      [],
                      [
                        XmlText(reversedClientId!),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      }
      await plist.writeAsString(
        iosDocument.toXmlString(pretty: true, indent: "\t", newLine: "\n"),
      );
    }
    if (enableFacebook) {
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
      label("Edit AndroidManifest.xml.");
      final file = File("android/app/src/main/AndroidManifest.xml");
      if (!file.existsSync()) {
        throw Exception(
          "AndroidManifest does not exist in `android/app/src/main/AndroidManifest.xml`. Do `katana create` to complete the initial setup of the project.",
        );
      }
      final document = XmlDocument.parse(await file.readAsString());
      final application = document.findAllElements("application");
      if (application.isEmpty) {
        throw Exception(
          "The structure of AndroidManifest.xml is broken. Do `katana create` to complete the initial setup of the project.",
        );
      }
      if (!application.first.children.any(
        (p0) =>
            p0 is XmlElement &&
            p0.name.toString() == "meta-data" &&
            p0.attributes.any(
              (p1) =>
                  p1.name.toString() == "android:name" &&
                  p1.value == "com.facebook.sdk.ApplicationId",
            ),
      )) {
        application.first.children.add(
          XmlElement(
            XmlName("meta-data"),
            [
              XmlAttribute(
                XmlName("android:name"),
                "com.facebook.sdk.ApplicationId",
              ),
              XmlAttribute(
                XmlName("android:value"),
                facebookAppId,
              ),
            ],
            [],
          ),
        );
      }
      if (!application.first.children.any(
        (p0) =>
            p0 is XmlElement &&
            p0.name.toString() == "meta-data" &&
            p0.attributes.any(
              (p1) =>
                  p1.name.toString() == "android:name" &&
                  p1.value == "com.facebook.sdk.ClientToken",
            ),
      )) {
        application.first.children.add(
          XmlElement(
            XmlName("meta-data"),
            [
              XmlAttribute(
                XmlName("android:name"),
                "com.facebook.sdk.ClientToken",
              ),
              XmlAttribute(
                XmlName("android:value"),
                facebookAppSecret,
              ),
            ],
            [],
          ),
        );
      }
      await file.writeAsString(
        document.toXmlString(pretty: true, indent: "    ", newLine: "\n"),
      );
    }
  }
}
