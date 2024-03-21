// Dart imports:
import 'dart:io';

// Package imports:
import 'package:xml/xml.dart';

// Project imports:
import 'package:katana_cli/action/firebase/authentication.dart';
import 'package:katana_cli/katana_cli.dart';

/// Add a module to use Firebase dynamic links.
///
/// Firebase dynamic linksを利用するためのモジュールを追加します。
class FirebaseDynamicLinksCliAction extends CliCommand with CliActionMixin {
  /// Add a module to use Firebase dynamic links.
  ///
  /// Firebase dynamic linksを利用するためのモジュールを追加します。
  const FirebaseDynamicLinksCliAction();

  @override
  String get description =>
      "Add a module to use Firebase dynamic links. Firebase dynamic linksを利用するためのモジュールを追加します。";

  @override
  bool checkEnabled(ExecContext context) {
    final firebase = context.yaml.getAsMap("firebase");
    final projectId = firebase.get("project_id", "");
    final dynamicLinks =
        firebase.getAsMap("dynamic_links").get("enable", false);
    return projectId.isNotEmpty && dynamicLinks;
  }

  @override
  Future<void> exec(ExecContext context) async {
    final firebase = context.yaml.getAsMap("firebase");
    final dynamicLinks = firebase.getAsMap("dynamic_links");
    final host = dynamicLinks.get("host", "");
    final uri = Uri.tryParse(host);
    if (host.isEmpty || uri == null) {
      error(
        "[firebase]->[dynamic_links]->[host] is not set. Please set the host name with URL scheme like `https://mathru.net`.",
      );
      return;
    }
    if (!uri.scheme.startsWith("http")) {
      error(
        "[firebase]->[dynamic_links]->[host] is not set. Please set the host name with URL scheme like `https://mathru.net`.",
      );
      return;
    }

    await addFlutterImport(
      [
        "masamune_deeplink_firebase",
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
