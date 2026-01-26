// Dart imports:
import "dart:io";

// Package imports:
import "package:html/dom.dart";
import "package:html/parser.dart";
import "package:xml/xml.dart";

// Project imports:
import "package:katana_cli/config.dart";
import "package:katana_cli/katana_cli.dart";

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
    final deleteUser = authentication.getAsMap("delete_user");
    final apple = providers.getAsMap("apple");
    final facebook = providers.getAsMap("facebook");
    final google = providers.getAsMap("google");
    return projectId.isNotEmpty &&
        enableAuthentication &&
        (deleteUser.get("enable", false) ||
            apple.get("enable", false) ||
            facebook.get("enable", false) ||
            google.get("enable", false));
  }

  @override
  Future<void> exec(ExecContext context) async {
    final firebase = context.yaml.getAsMap("firebase");
    final projectId = firebase.get("project_id", "");
    final authentication = firebase.getAsMap("authentication");
    final providers = authentication.getAsMap("providers");
    final apple = providers.getAsMap("apple");
    final facebook = providers.getAsMap("facebook");
    final google = providers.getAsMap("google");
    final github = providers.getAsMap("github");
    final deleteUser = authentication.getAsMap("delete_user");
    final enableDeleteUser = deleteUser.get("enable", false);
    final functions = firebase.getAsMap("functions");
    final enableFunctions = functions.get("enable", false);
    final enableApple = apple.get("enable", false);
    final enableGoogle = google.get("enable", false);
    final enableFacebook = facebook.get("enable", false);
    final enableGithub = github.get("enable", false);
    final facebookAppId = facebook.get<int?>("app_id", null)?.toString() ??
        facebook.get("app_id", "") ??
        "";
    final facebookAppSecret =
        facebook.get<int?>("app_secret", null)?.toString() ??
            facebook.get("app_secret", "") ??
            "";
    final facebookClientToken = facebook.get("client_token", "");
    if (projectId.isEmpty) {
      error(
        "The item [firebase]->[project_id] is missing. Please provide the Firebase project ID for the configuration.",
      );
      return;
    }
    if (enableFacebook &&
        (facebookAppId.isEmpty ||
            facebookAppSecret.isEmpty ||
            facebookClientToken.isEmpty)) {
      error(
        "The item [facebook]->[app_id] or [facebook]->[app_secret], [facebook]->[client_token] is missing. Please provide the Facebook App ID and App Secret, Client Token for the configuration.",
      );
      return;
    }
    if (enableDeleteUser && !enableFunctions) {
      error(
        "The item [firebase]->[functions]->[enable] is missing. Please provide the Firebase functions configuration.",
      );
      return;
    }
    await addFlutterImport(
      [
        if (enableApple) ...[
          "masamune_auth_apple_firebase",
        ],
        if (enableFacebook) ...[
          "masamune_auth_facebook",
        ],
        if (enableGoogle) ...[
          "masamune_auth_google_firebase",
        ],
        if (enableDeleteUser) ...[
          "masamune_auth_firebase",
        ],
        if (enableGithub) ...[
          "masamune_auth_github_firebase",
        ],
      ],
    );
    if (enableGoogle || enableFacebook || enableGithub) {
      label("Load GoogleService-Info.plist.");
      String? reversedClientId;
      String? googleAppId;
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
      if (enableGoogle) {
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
        reversedClientId = reversedClientIdNode.nextElementSibling?.innerText;
        if (clientId.isEmpty || reversedClientId.isEmpty) {
          throw Exception(
            "Could not find `CLIENT_ID` or `REVERSED_CLIENT_ID` element in `ios/Runner/GoogleService-Info.plist`. File is corrupt.",
          );
        }
      }
      if (enableGithub) {
        final googleAppIdNode =
            googleServiceDict.children.firstWhereOrNull((p0) {
          return p0 is XmlElement &&
              p0.name.toString() == "key" &&
              p0.innerText == "GOOGLE_APP_ID";
        });
        if (googleAppIdNode == null) {
          throw Exception(
            "Could not find `GOOGLE_APP_ID` element in `ios/Runner/GoogleService-Info.plist`. File is corrupt.",
          );
        }
        googleAppId = googleAppIdNode.nextElementSibling?.innerText;
        if (googleAppId.isEmpty) {
          throw Exception(
            "Could not find `GOOGLE_APP_ID` element in `ios/Runner/GoogleService-Info.plist`. File is corrupt.",
          );
        }
        googleAppId = "app-${googleAppId?.replaceAll(":", "-")}";
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
                        if (googleAppId != null)
                          XmlElement(
                            XmlName("string"),
                            [],
                            [
                              XmlText(googleAppId),
                            ],
                          ),
                        if (reversedClientId != null)
                          XmlElement(
                            XmlName("string"),
                            [],
                            [
                              XmlText(reversedClientId),
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
        if (enableGoogle &&
            !urlSchemeArray.children.any(
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
        if (enableFacebook &&
            !urlSchemeArray.children.any(
              (p1) =>
                  p1 is XmlElement &&
                  p1.children.any((p2) =>
                      p2 is XmlElement &&
                      p2.name.toString() == "array" &&
                      p2.children.any((p3) =>
                          p3 is XmlElement &&
                          p3.name.toString() == "string" &&
                          p3.innerText == "fb$facebookAppId")),
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
                        XmlText("fb$facebookAppId"),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        }
        if (enableGithub &&
            !urlSchemeArray.children.any(
              (p1) =>
                  p1 is XmlElement &&
                  p1.children.any((p2) =>
                      p2 is XmlElement &&
                      p2.name.toString() == "array" &&
                      p2.children.any((p3) =>
                          p3 is XmlElement &&
                          p3.name.toString() == "string" &&
                          p3.innerText == googleAppId)),
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
                        XmlText(googleAppId!),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      }
      if (enableFacebook) {
        final lsApplicationQueriesSchemes =
            dict.children.firstWhereOrNull((p0) {
          return p0 is XmlElement &&
              p0.name.toString() == "key" &&
              p0.innerText == "LSApplicationQueriesSchemes";
        });
        if (lsApplicationQueriesSchemes == null) {
          dict.children.addAll(
            [
              XmlElement(
                XmlName("key"),
                [],
                [
                  XmlText("LSApplicationQueriesSchemes"),
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
                      XmlText("fbapi"),
                    ],
                  ),
                  XmlElement(
                    XmlName("string"),
                    [],
                    [
                      XmlText("fb-messenger-share-api"),
                    ],
                  ),
                ],
              ),
            ],
          );
        } else {
          final lsApplicationQueriesSchemesArray =
              lsApplicationQueriesSchemes.nextElementSibling;
          if (lsApplicationQueriesSchemesArray == null) {
            throw Exception(
              "Could not find `LSApplicationQueriesSchemes` value element in `ios/Runner/Info.plist`. File is corrupt.",
            );
          }
          if (enableFacebook &&
              !lsApplicationQueriesSchemesArray.children.any((p1) =>
                  p1 is XmlElement &&
                  p1.name.toString() == "string" &&
                  p1.innerText == "fbapi")) {
            lsApplicationQueriesSchemesArray.children.addAll(
              [
                XmlElement(
                  XmlName("string"),
                  [],
                  [
                    XmlText("fbapi"),
                  ],
                ),
                XmlElement(
                  XmlName("string"),
                  [],
                  [
                    XmlText("fb-messenger-share-api"),
                  ],
                ),
              ],
            );
          }
        }
        final facebookAppIdElement = dict.children.firstWhereOrNull((p0) {
          return p0 is XmlElement &&
              p0.name.toString() == "key" &&
              p0.innerText == "FacebookAppID";
        });
        if (facebookAppIdElement == null) {
          dict.children.addAll(
            [
              XmlElement(
                XmlName("key"),
                [],
                [
                  XmlText("FacebookAppID"),
                ],
              ),
              XmlElement(
                XmlName("string"),
                [],
                [
                  XmlText(facebookAppId),
                ],
              ),
            ],
          );
        } else {
          final facebookAppIdElementString =
              facebookAppIdElement.nextElementSibling;
          if (facebookAppIdElementString == null) {
            throw Exception(
              "Could not find `FacebookAppID` value element in `ios/Runner/Info.plist`. File is corrupt.",
            );
          }
          facebookAppIdElementString.innerText = facebookAppId;
        }
        final facebookClientTokenElement = dict.children.firstWhereOrNull((p0) {
          return p0 is XmlElement &&
              p0.name.toString() == "key" &&
              p0.innerText == "FacebookClientToken";
        });
        if (facebookClientTokenElement == null) {
          dict.children.addAll(
            [
              XmlElement(
                XmlName("key"),
                [],
                [
                  XmlText("FacebookClientToken"),
                ],
              ),
              XmlElement(
                XmlName("string"),
                [],
                [
                  XmlText(facebookClientToken),
                ],
              ),
            ],
          );
        } else {
          final facebookClientTokenElementString =
              facebookClientTokenElement.nextElementSibling;
          if (facebookClientTokenElementString == null) {
            throw Exception(
              "Could not find `FacebookClientToken` value element in `ios/Runner/Info.plist`. File is corrupt.",
            );
          }
          facebookClientTokenElementString.innerText = facebookClientToken;
        }

        final displayNameElement = dict.children.firstWhereOrNull((p0) {
          return p0 is XmlElement &&
              p0.name.toString() == "key" &&
              p0.innerText == "CFBundleDisplayName";
        });
        final displayNameElementString = displayNameElement?.nextElementSibling;
        if (displayNameElementString == null) {
          throw Exception(
            "Could not find `CFBundleDisplayName` value element in `ios/Runner/Info.plist`. File is corrupt.",
          );
        }
        final facebookDisplayNameElement = dict.children.firstWhereOrNull((p0) {
          return p0 is XmlElement &&
              p0.name.toString() == "key" &&
              p0.innerText == "FacebookDisplayName";
        });
        if (facebookDisplayNameElement == null) {
          dict.children.addAll(
            [
              XmlElement(
                XmlName("key"),
                [],
                [
                  XmlText("FacebookDisplayName"),
                ],
              ),
              XmlElement(
                XmlName("string"),
                [],
                [
                  XmlText(displayNameElementString.innerText),
                ],
              ),
            ],
          );
        } else {
          final facebookDisplayNameElementString =
              facebookDisplayNameElement.nextElementSibling;
          if (facebookDisplayNameElementString == null) {
            throw Exception(
              "Could not find `FacebookDisplayName` value element in `ios/Runner/Info.plist`. File is corrupt.",
            );
          }
          facebookDisplayNameElementString.innerText =
              displayNameElementString.innerText;
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
          "flutter.minSdkVersion=${Config.firebaseMinSdkVersion}",
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
            isKotlin: gradle.isKotlin,
          ),
        );
      }
      if (gradle.isKotlin) {
        gradle.android?.defaultConfig.minSdkVersion =
            "configProperties[\"flutter.minSdkVersion\"].toString().toInt()";
      } else {
        gradle.android?.defaultConfig.minSdkVersion =
            "configProperties[\"flutter.minSdkVersion\"].toInteger()";
      }
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
                "fb$facebookAppId",
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
    if (enableGoogle) {
      label("Load google-services.json");
      final googleServicesJson = File("android/app/google-services.json");
      if (!googleServicesJson.existsSync()) {
        throw Exception(
          "google-services.json does not exist in `android/app/google-services.json`. Do `katana create` to complete the initial setup of the project.",
        );
      }
      final googleServices = jsonDecodeAsMap(
        await googleServicesJson.readAsString(),
      );
      final oauthClient = googleServices
          .getAsList("client")
          .cast<DynamicMap>()
          .firstOrNull
          ?.getAsList("oauth_client")
          .cast<DynamicMap>()
          .firstWhereOrNull((item) => item.get("client_type", 0) == 3);
      final clientId = oauthClient.get("client_id", "");
      if (clientId.isEmpty) {
        throw Exception(
          "Could not find `client_id` in `android/app/google-services.json`. File is corrupt.",
        );
      }
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
          e0.localName == "meta" &&
          e0.attributes["name"] == "google-signin-client_id")) {
        head.append(
          Element.tag("meta")
            ..attributes["name"] = "google-signin-client_id"
            ..attributes["content"] = clientId,
        );
      }
      await indexHtmlFile.writeAsString(htmlDocument.outerHtml);
    }
    if (enableApple) {
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
            p0.innerText == "com.apple.developer.applesignin";
      });
      if (appleSignIn == null) {
        dict.children.add(
          XmlElement(
            XmlName("key"),
            [],
            [
              XmlText("com.apple.developer.applesignin"),
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
                  XmlText("Default"),
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
          if ((buildConfiguration.baseConfigurationReference
                      ?.contains("/* Release.xcconfig */") ??
                  false) ||
              (buildConfiguration.baseConfigurationReference
                      ?.contains("/* Debug.xcconfig */") ??
                  false)) {
            buildConfiguration.buildSettings.add(
              PBXBuildConfigurationSettings(
                  key: "CODE_SIGN_ENTITLEMENTS",
                  value: "Runner/Runner.entitlements"),
            );
          }
        }
      }
      await xcode.save();
    }
    if (enableDeleteUser) {
      label("Add firebase functions");
      final functions = Functions();
      await functions.load();
      if (!functions.imports
          .any((e) => e.contains("@mathrunet/masamune_auth"))) {
        functions.imports
            .add("import * as auth from \"@mathrunet/masamune_auth\";");
      }
      if (!functions.functions
          .any((e) => e.startsWith("auth.Functions.deleteUser"))) {
        functions.functions.add("auth.Functions.deleteUser()");
      }
      await functions.save();
    }
  }
}

/// Code base for `Runner.entitlements`.
///
/// `Runner.entitlements`のコードベース。
class RunnerEntitlementsCliCode extends CliCode {
  /// Code base for `Runner.entitlements`.
  ///
  /// `Runner.entitlements`のコードベース。
  const RunnerEntitlementsCliCode();

  @override
  String get name => "Runner";

  @override
  String get prefix => "Runner";

  @override
  String get directory => "ios/Runner";

  @override
  String get description =>
      "Define code for `Runner.entitlements`. `Runner.entitlements`用のコードを定義します。";

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
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
</dict>
</plist>
""";
  }
}
