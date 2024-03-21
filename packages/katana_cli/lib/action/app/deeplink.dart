// Dart imports:
import 'dart:io';

// Package imports:
import 'package:xml/xml.dart';

// Project imports:
import 'package:katana_cli/action/firebase/authentication.dart';
import 'package:katana_cli/katana_cli.dart';

/// Add a module to use Deeplink.
///
/// Deeplinkを利用するためのモジュールを追加します。
class AppDeeplinkCliAction extends CliCommand with CliActionMixin {
  /// Add a module to use Deeplink.
  ///
  /// Deeplinkを利用するためのモジュールを追加します。
  const AppDeeplinkCliAction();

  @override
  String get description =>
      "Add a module to use Deeplink. Deeplinkを利用するためのモジュールを追加します。";

  @override
  bool checkEnabled(ExecContext context) {
    final value = context.yaml.getAsMap("app").getAsMap("deeplink");
    final enabled = value.get("enable", false);
    if (!enabled) {
      return false;
    }
    return true;
  }

  @override
  Future<void> exec(ExecContext context) async {
    final deeplink = context.yaml.getAsMap("app").getAsMap("deeplink");
    final host = deeplink.get("host", "");
    final server = deeplink.getAsMap("server");
    final enableServer = server.get("enable", false);
    final iosTeamId = server.get("ios_team_id", "");
    final androidSHA256 = server.get("android_sha_256", "");
    final uri = Uri.tryParse(host);
    if (host.isEmpty || uri == null) {
      error(
        "[app]->[deeplink]->[host] is not set. Please set the host name with URL scheme like `https://mathru.net`.",
      );
      return;
    }
    if (enableServer) {
      if (iosTeamId.isEmpty) {
        error(
          "[app]->[deeplink]->[server]->[ios_team_id] is not set. Please set the iOS Team ID.",
        );
        return;
      }
      if (androidSHA256.isEmpty) {
        error(
          "[app]->[deeplink]->[server]->[android_sha_256] is not set. Please set the Android SHA-256.",
        );
        return;
      }
    }

    await addFlutterImport(
      [
        "masamune_deeplink",
      ],
    );
    label("Edit AndroidManifest.xml.");
    final file = File("android/app/src/main/AndroidManifest.xml");
    if (!file.existsSync()) {
      throw Exception(
        "AndroidManifest does not exist in `android/app/src/main/AndroidManifest.xml`. Do `katana create` to complete the initial setup of the project.",
      );
    }
    final androidDocument = XmlDocument.parse(await file.readAsString());
    final activity = androidDocument.findAllElements("activity");
    if (activity.isEmpty) {
      throw Exception(
        "The structure of AndroidManifest.xml is broken. Do `katana create` to complete the initial setup of the project.",
      );
    }
    if (!activity.first.children.any((p0) =>
        p0 is XmlElement &&
        p0.name.toString() == "intent-filter" &&
        (p0.findElements("action").firstOrNull?.attributes.any((item) =>
                item.name.toString() == "android:name" &&
                item.value == "android.intent.action.VIEW") ??
            false) &&
        (p0.findElements("data").firstOrNull?.attributes.any((item) =>
                item.name.toString() == "android:scheme" &&
                item.value == uri.scheme) ??
            false) &&
        (p0.findElements("data").firstOrNull?.attributes.any((item) =>
                item.name.toString() == "android:host" &&
                item.value == uri.host) ??
            false))) {
      activity.first.children.add(
        XmlElement(
          XmlName("intent-filter"),
          [
            XmlAttribute(
              XmlName("android:autoVerify"),
              "true",
            ),
          ],
          [
            XmlElement(
              XmlName("action"),
              [
                XmlAttribute(
                  XmlName("android:name"),
                  "android.intent.action.VIEW",
                ),
              ],
              [],
            ),
            XmlElement(
              XmlName("category"),
              [
                XmlAttribute(
                  XmlName("android:name"),
                  "android.intent.category.DEFAULT",
                ),
              ],
              [],
            ),
            XmlElement(
              XmlName("category"),
              [
                XmlAttribute(
                  XmlName("android:name"),
                  "android.intent.category.BROWSABLE",
                ),
              ],
              [],
            ),
            XmlElement(
              XmlName("data"),
              [
                XmlAttribute(
                  XmlName("android:scheme"),
                  uri.scheme,
                ),
                XmlAttribute(
                  XmlName("android:host"),
                  uri.host,
                ),
              ],
              [],
            ),
          ],
        ),
      );
    }
    await file.writeAsString(
      androidDocument.toXmlString(pretty: true, indent: "    ", newLine: "\n"),
    );
    if (uri.scheme == "http" || uri.scheme == "https") {
      label("Edit Runner.entitlements.");
      final runnerEntitlements = File("ios/Runner/Runner.entitlements");
      if (!runnerEntitlements.existsSync()) {
        await const RunnerEntitlementsCliCode()
            .generateFile("Runner.entitlements");
      }
      final runnerDocument =
          XmlDocument.parse(await runnerEntitlements.readAsString());
      final dict = runnerDocument.findAllElements("dict").firstOrNull;
      if (dict == null) {
        throw Exception(
          "Could not find `dict` element in `ios/Runner/Info.plist`. File is corrupt.",
        );
      }
      final appleSignIn = dict.children.firstWhereOrNull((p0) {
        return p0 is XmlElement &&
            p0.name.toString() == "key" &&
            p0.innerText == "com.apple.developer.associated-domains";
      });
      if (appleSignIn == null) {
        dict.children.add(
          XmlElement(
            XmlName("key"),
            [],
            [
              XmlText("com.apple.developer.associated-domains"),
            ],
          ),
        );
        dict.children.add(
          XmlElement(
            XmlName("array"),
            [],
            [
              XmlElement(
                XmlName("string"),
                [],
                [
                  XmlText("applinks:${uri.host}"),
                ],
              ),
            ],
          ),
        );
        await runnerEntitlements.writeAsString(
          runnerDocument.toXmlString(
              pretty: true, indent: "    ", newLine: "\n"),
        );
      }
      label("Edit project.pbxproj");
      final xcode = XCode();
      await xcode.load();
      final bundleId = xcode.pbxBuildConfiguration
          .map(
            (e) => e.buildSettings
                .firstWhereOrNull((e) => e.key == "PRODUCT_BUNDLE_IDENTIFIER")
                ?.value,
          )
          .firstWhereOrNull((e) => e != null)
          ?.replaceAll('"', "")
          .replaceAll("'", "");
      if (bundleId.isEmpty) {
        throw Exception(
          "Bundle ID is not set in your XCode project. Please open `ios/Runner.xcodeproj` and check the settings.",
        );
      }
      final fileId = XCode.generateId();
      if (!xcode.pbxFileReference.any((e) => e.path == "Runner.entitlements")) {
        xcode.pbxFileReference.add(
          PBXFileReference(
            id: fileId,
            comment: "Runner.entitlements",
            lastKnownFileType: "text.plist.entitlements",
            path: "Runner.entitlements",
            sourceTree: "\"<group>\"",
          ),
        );
        final runner =
            xcode.pbxGroup.firstWhereOrNull((item) => item.comment == "Runner");
        if (runner == null) {
          throw Exception(
            "Could not find `Runner` group in `ios/Runner.xcodeproj/project.pbxproj`. File is corrupt.",
          );
        }
        runner.children
            .add(PBXGroupChild(comment: "Runner.entitlements", id: fileId));
        for (final buildConfiguration in xcode.pbxBuildConfiguration) {
          if (buildConfiguration.buildSettings
              .any((e) => e.key == "CODE_SIGN_ENTITLEMENTS")) {
            continue;
          }
          if (buildConfiguration.baseConfigurationReference
                      ?.contains("/* Release.xcconfig */") ==
                  true ||
              buildConfiguration.baseConfigurationReference
                      ?.contains("/* Debug.xcconfig */") ==
                  true) {
            buildConfiguration.buildSettings.add(
              PBXBuildConfigurationSettings(
                  key: "CODE_SIGN_ENTITLEMENTS",
                  value: "Runner/Runner.entitlements"),
            );
          }
        }
      }
      await xcode.save();
      label("Create apple-app-site-association");
      final dir = Directory("web/.well-known");
      if (!dir.existsSync()) {
        await dir.create(recursive: true);
      }
      await AppleAppSiteAssociationCliCode(
        teamId: iosTeamId,
        bundleId: bundleId!,
      ).generateFile("apple-app-site-association");
      await AppleAppSiteAssociationCliCode(
        teamId: iosTeamId,
        bundleId: bundleId,
      ).generateFile(".well-known/apple-app-site-association");
      label("Create assetlinks.json");
      await AndroidAssetLinksCliCode(
        packageName: bundleId,
        sha256: androidSHA256,
      ).generateFile("assetlinks.json");
    } else {
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
                        XmlElement(
                          XmlName("string"),
                          [],
                          [
                            XmlText(uri.scheme),
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
                      p3.innerText == uri.scheme)),
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
                        XmlText(uri.scheme),
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
  }
}

/// Code base for `apple-app-site-association`.
///
/// `apple-app-site-association`のコードベース。
class AppleAppSiteAssociationCliCode extends CliCode {
  /// Code base for `apple-app-site-association`.
  ///
  /// `apple-app-site-association`のコードベース。
  const AppleAppSiteAssociationCliCode({
    required this.bundleId,
    required this.teamId,
  });

  /// IOS Team ID.
  ///
  /// IOSのチームID。
  final String teamId;

  /// IOS Bundle ID.
  ///
  /// IOSのバンドルID。
  final String bundleId;

  @override
  String get name => "apple-app-site-association";

  @override
  String get prefix => "apple-app-site-association";

  @override
  String get directory => "web";

  @override
  String get description =>
      "Define code for `apple-app-site-association`. `apple-app-site-association`用のコードを定義します。";

  @override
  String import(String path, String baseName, String className) {
    return """
""";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
{
  "applinks": {
       "apps": [],
        "details": [
           {
               "appID":"$teamId.$bundleId",
               "paths":[ "*" ]
           }
         ]
    }
}
""";
  }
}

/// Code base for `assetsLinks.json`.
///
/// `assetsLinks.json`のコードベース。
class AndroidAssetLinksCliCode extends CliCode {
  /// Code base for `assetsLinks.json`.
  ///
  /// `assetsLinks.json`のコードベース。
  const AndroidAssetLinksCliCode({
    required this.packageName,
    required this.sha256,
  });

  /// Android SHA256 fingerprinting.
  ///
  /// AndroidのSHA256のフィンガープリント。
  final String sha256;

  /// Android package name.
  ///
  /// Androidのパッケージ名。
  final String packageName;

  @override
  String get name => "assetsLinks.json";

  @override
  String get prefix => "assetsLinks.json";

  @override
  String get directory => "web/.well-known";

  @override
  String get description =>
      "Define code for `assetsLinks.json`. `assetsLinks.json`用のコードを定義します。";

  @override
  String import(String path, String baseName, String className) {
    return """
""";
  }

  @override
  String header(String path, String baseName, String className) {
    return "";
  }

  @override
  String body(String path, String baseName, String className) {
    return """
[{
      "relation": ["delegate_permission/common.handle_all_urls"],
      "target": {
        "namespace": "android_app",
        "package_name": "$packageName",
        "sha256_cert_fingerprints": ["$sha256"]
      }
 }]
""";
  }
}
