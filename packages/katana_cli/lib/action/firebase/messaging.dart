// Dart imports:
import "dart:io";

// Package imports:
import "package:image/image.dart";
import "package:xml/xml.dart";

// Project imports:
import "package:katana_cli/action/post/firebase_deploy_post_action.dart";
import "package:katana_cli/katana_cli.dart";

/// Size list of notification icon.
///
/// 通知アイコンのサイズリスト。
final kSizeListNotificationIcon = {
  "android/app/src/main/res/mipmap-hdpi/ic_launcher_notification.png": 162,
  "android/app/src/main/res/mipmap-mdpi/ic_launcher_notification.png": 108,
  "android/app/src/main/res/mipmap-xhdpi/ic_launcher_notification.png": 216,
  "android/app/src/main/res/mipmap-xxhdpi/ic_launcher_notification.png": 324,
  "android/app/src/main/res/mipmap-xxxhdpi/ic_launcher_notification.png": 432,
};

/// Initialize FirebaseMessaging settings.
///
/// FirebaseMessagingの初期設定を行います。
class FirebaseMessagingCliAction extends CliCommand with CliActionMixin {
  /// Initialize FirebaseMessaging settings.
  ///
  /// FirebaseMessagingの初期設定を行います。
  const FirebaseMessagingCliAction();

  @override
  String get description =>
      "Initialize FirebaseMessaging based on the information in `katana.yaml`. Please create a Firebase project beforehand. Also, make `firebase` and `flutterfire` commands available. `katana.yaml`の情報を元にFirebaseMessagingの初期設定を行います。予めFirebaseのプロジェクトを作成しておいてください。また、`firebase`と`flutterfire`のコマンドを利用可能にしてください。";

  @override
  bool checkEnabled(ExecContext context) {
    final firebase = context.yaml.getAsMap("firebase");
    final projectId = firebase.get("project_id", "");
    final messaging = firebase.getAsMap("messaging").get("enable", false);
    return projectId.isNotEmpty && messaging;
  }

  @override
  Future<void> exec(ExecContext context) async {
    final firebase = context.yaml.getAsMap("firebase");
    final messaging = firebase.getAsMap("messaging");
    final channelId = messaging.get("channel_id", "");
    final notificationIcon = messaging.get("android_notification_icon", "");
    if (channelId.isEmpty) {
      error(
        "Channel ID is not specified in [firebase]->[messaging]->[channel_id]. Please specify any ID.",
      );
      return;
    }
    label("Add processing to the Gradle file.");
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
      if (!(gradle.android?.defaultConfig.resValues.any(
            (e) => e.startsWith('("string", "notification_channel_id"'),
          ) ??
          false)) {
        gradle.android?.defaultConfig.resValues.add(
          '("string", "notification_channel_id", configProperties["notificationChannelId"].toString())',
        );
      }
    } else {
      if (!(gradle.android?.defaultConfig.resValues.any(
            (e) => e.startsWith(" 'string', 'notification_channel_id'"),
          ) ??
          false)) {
        gradle.android?.defaultConfig.resValues.add(
          " 'string', 'notification_channel_id', configProperties['notificationChannelId']",
        );
      }
    }
    final compileOptions = GradleAndroidCompileOptions(
      sourceCompatibility: "JavaVersion.VERSION_11",
      targetCompatibility: "JavaVersion.VERSION_11",
      coreLibraryDesugaringEnabled: true,
    );
    gradle.android?.compileOptions = compileOptions;
    final defaultConfig = gradle.android?.defaultConfig;
    if (defaultConfig == null) {
      throw Exception("defaultConfig is not found. Please check build.gradle.");
    }
    defaultConfig.multiDexEnabled = "true";
    if (!gradle.dependencies.any((e) =>
        e.group == "coreLibraryDesugaring" &&
        e.packageName == "com.android.tools:desugar_jdk_libs:2.1.4")) {
      gradle.dependencies.add(
        GradleDependencies(
          group: "coreLibraryDesugaring",
          packageName: "com.android.tools:desugar_jdk_libs:2.1.4",
          isKotlin: gradle.isKotlin,
        ),
      );
    }
    await gradle.save();
    label("Edit config.properties.");
    final properties = File("android/config.properties");
    if (properties.existsSync()) {
      final contents = await properties.readAsLines();
      if (!contents.any((e) => e.startsWith("notificationChannelId"))) {
        contents.add("notificationChannelId=$channelId");
      }
      await properties.writeAsString(contents.join("\n"));
    } else {
      await properties.writeAsString(
        "notificationChannelId=$channelId",
      );
    }
    if (notificationIcon.isNotEmpty) {
      label("Create notification icon.");
      final iconFile = File(notificationIcon);
      if (!iconFile.existsSync()) {
        error("Icon file not found in $notificationIcon.");
        return;
      }
      final iconImage = decodeImage(iconFile.readAsBytesSync())!;
      if (iconImage.width != 1024 || iconImage.height != 1024) {
        error("Icon files should be 1024 x 1024.");
        return;
      }
      for (final tmp in kSizeListNotificationIcon.entries) {
        label("Resize & Save to ${tmp.key}");
        final dir = Directory(tmp.key.parentPath());
        if (!dir.existsSync()) {
          await dir.create(recursive: true);
        }
        final file = File(tmp.key);
        if (file.existsSync()) {
          await file.delete();
        }
        final resized = adjustColor(
          copyResize(
            iconImage,
            height: tmp.value,
            width: tmp.value,
            interpolation: Interpolation.average,
          ),
          mids: ColorUint8.rgb(255, 255, 255),
          blacks: ColorUint8.rgb(255, 255, 255),
          whites: ColorUint8.rgb(255, 255, 255),
        );
        await file.writeAsBytes(encodePng(resized, level: 9));
      }
    }
    label("Edit AndroidManifest.xml.");
    final file = File("android/app/src/main/AndroidManifest.xml");
    if (!file.existsSync()) {
      throw Exception(
        "AndroidManifest does not exist in `android/app/src/main/AndroidManifest.xml`. Do `katana create` to complete the initial setup of the project.",
      );
    }
    final document = XmlDocument.parse(await file.readAsString());
    final application = document.findAllElements("application");
    final activity = document.findAllElements("activity");
    if (application.isEmpty) {
      throw Exception(
        "The structure of AndroidManifest.xml is broken. Do `katana create` to complete the initial setup of the project.",
      );
    }
    if (notificationIcon.isNotEmpty &&
        !application.first.children.any((p0) =>
            p0 is XmlElement &&
            p0.name.toString() == "meta-data" &&
            (p0.attributes.any((item) =>
                item.name.toString() == "android:name" &&
                item.value ==
                    "com.google.firebase.messaging.default_notification_icon")))) {
      application.first.children.add(
        XmlElement(
          XmlName("meta-data"),
          [
            XmlAttribute(
              XmlName("android:name"),
              "com.google.firebase.messaging.default_notification_icon",
            ),
            XmlAttribute(
              XmlName("android:resource"),
              "@mipmap/ic_launcher_notification",
            ),
          ],
          [],
        ),
      );
    }
    if (!activity.first.children.any((p0) =>
        p0 is XmlElement &&
        p0.name.toString() == "intent-filter" &&
        (p0.findElements("action").firstOrNull?.attributes.any((item) =>
                item.name.toString() == "android:name" &&
                item.value == "FLUTTER_NOTIFICATION_CLICK") ??
            false))) {
      activity.first.children.add(
        XmlElement(
          XmlName("intent-filter"),
          [],
          [
            XmlElement(
              XmlName("action"),
              [
                XmlAttribute(
                  XmlName("android:name"),
                  "FLUTTER_NOTIFICATION_CLICK",
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
          ],
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
                p1.value ==
                    "com.google.firebase.messaging.default_notification_channel_id",
          ),
    )) {
      application.first.children.add(
        XmlElement(
          XmlName("meta-data"),
          [
            XmlAttribute(
              XmlName("android:name"),
              "com.google.firebase.messaging.default_notification_channel_id",
            ),
            XmlAttribute(
              XmlName("android:value"),
              "@string/notification_channel_id",
            ),
          ],
          [],
        ),
      );
    }
    final scheduledNotificationReceiver =
        application.first.children.firstWhereOrNull(
      (p0) =>
          p0 is XmlElement &&
          p0.name.toString() == "receiver" &&
          p0.attributes.any(
            (p1) =>
                p1.name.toString() == "android:name" &&
                p1.value ==
                    "com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver",
          ),
    );
    if (scheduledNotificationReceiver == null) {
      application.first.children.add(
        XmlElement(
          XmlName("receiver"),
          [
            XmlAttribute(
              XmlName("android:name"),
              "com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver",
            ),
            XmlAttribute(
              XmlName("android:exported"),
              "false",
            ),
          ],
          [],
        ),
      );
    }
    final scheduledNotificationBootReceiver =
        application.first.children.firstWhereOrNull(
      (p0) =>
          p0 is XmlElement &&
          p0.name.toString() == "receiver" &&
          p0.attributes.any(
            (p1) =>
                p1.name.toString() == "android:name" &&
                p1.value ==
                    "com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver",
          ),
    );
    if (scheduledNotificationBootReceiver == null) {
      application.first.children.add(
        XmlElement(
          XmlName("receiver"),
          [
            XmlAttribute(
              XmlName("android:name"),
              "com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver",
            ),
            XmlAttribute(
              XmlName("android:exported"),
              "false",
            ),
          ],
          [
            XmlElement(
              XmlName("intent-filter"),
              [],
              [
                XmlElement(
                  XmlName("action"),
                  [
                    XmlAttribute(
                      XmlName("android:name"),
                      "android.intent.action.BOOT_COMPLETED",
                    ),
                  ],
                  [],
                ),
                XmlElement(
                  XmlName("action"),
                  [
                    XmlAttribute(
                      XmlName("android:name"),
                      "android.intent.action.MY_PACKAGE_REPLACED",
                    ),
                  ],
                  [],
                ),
                XmlElement(
                  XmlName("category"),
                  [
                    XmlAttribute(
                      XmlName("android:name"),
                      "android.intent.action.QUICKBOOT_POWERON",
                    ),
                  ],
                  [],
                ),
                XmlElement(
                  XmlName("category"),
                  [
                    XmlAttribute(
                      XmlName("android:name"),
                      "com.htc.intent.action.QUICKBOOT_POWERON",
                    ),
                  ],
                  [],
                ),
              ],
            ),
          ],
        ),
      );
    }
    await file.writeAsString(
      document.toXmlString(pretty: true, indent: "    ", newLine: "\n"),
    );
    label("Edit Runner.entitlements.");
    await XCode.createRunnerEntitlements();
    final entitlements = File("ios/Runner/Runner.entitlements");
    if (entitlements.existsSync()) {
      final document = XmlDocument.parse(await entitlements.readAsString());
      final dict = document.findAllElements("dict").firstOrNull;
      if (dict == null) {
        throw Exception(
          "Could not find `dict` element in `ios/Runner/Runner.entitlements`. File is corrupt.",
        );
      }
      final node = dict.children.firstWhereOrNull((p0) {
        return p0 is XmlElement &&
            p0.name.toString() == "key" &&
            p0.innerText == "aps-environment";
      });
      if (node == null) {
        dict.children.addAll(
          [
            XmlElement(
              XmlName("key"),
              [],
              [XmlText("aps-environment")],
            ),
            XmlElement(
              XmlName("string"),
              [],
              [XmlText("development")],
            ),
          ],
        );
      }
      await entitlements.writeAsString(
        document.toXmlString(pretty: true, indent: "\t", newLine: "\n"),
      );
    }
    label("Edit AppDelegate.swift.");
    final appDelegateFile = File("ios/Runner/AppDelegate.swift");
    if (!appDelegateFile.existsSync()) {
      throw Exception(
        "AppDelegate.swift does not exist in `ios/Runner/AppDelegate.swift`. Do `katana create` to complete the initial setup of the project.",
      );
    }
    var swift = await appDelegateFile.readAsString();
    if (!RegExp(r"UNUserNotificationCenter.current\(\).delegate")
        .hasMatch(swift)) {
      swift = swift.replaceFirst(
        "    GeneratedPluginRegistrant.register",
        "    if #available(iOS 10.0, *) {\n      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate\n    }\n    GeneratedPluginRegistrant.register",
      );
    }
    await appDelegateFile.writeAsString(swift);
    await addFlutterImport(
      [
        "masamune_notification_firebase",
      ],
    );
    label("Add firebase-messaging-sw.js");
    final swFile = File("web/firebase-messaging-sw.js");
    if (!swFile.existsSync()) {
      await swFile.writeAsString("console.log('Empty');");
    }
    if (Directory("firebase/functions").existsSync()) {
      label("Add firebase functions");
      final functions = Fuctions();
      await functions.load();
      if (!functions.functions.any((e) => e.startsWith("sendNotification"))) {
        functions.functions.add("sendNotification()");
      }
      await functions.save();
      context.requestFirebaseDeploy(FirebaseDeployPostActionType.functions);
      // await command(
      //   "Deploy firebase functions.",
      //   [
      //     firebaseCommand,
      //     "deploy",
      //     "--only",
      //     "functions",
      //   ],
      //   workingDirectory: "firebase",
      // );
    }
  }
}
