// Dart imports:
import 'dart:io';

// Package imports:
import 'package:xml/xml.dart';

// Project imports:
import 'package:katana_cli/katana_cli.dart';

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
    final bin = context.yaml.getAsMap("bin");
    final flutter = bin.get("flutter", "flutter");
    final firebaseCommand = bin.get("firebase", "firebase");
    final firebase = context.yaml.getAsMap("firebase");
    final messaging = firebase.getAsMap("messaging");
    final channelId = messaging.get("channel_id", "");
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
        ),
      );
    }
    if (!(gradle.android?.defaultConfig.resValues.any(
          (e) => e.startsWith("'string', 'notification_channel_id'"),
        ) ??
        false)) {
      gradle.android?.defaultConfig.resValues.add(
        "'string', 'notification_channel_id', configProperties['notificationChannelId']",
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
    await command(
      "Import packages.",
      [
        flutter,
        "pub",
        "add",
        "masamune_notification_firebase:^2.0.0",
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
      if (!functions.functions.any((e) => e == "sendNotification()")) {
        functions.functions.add("sendNotification()");
      }
      await functions.save();
      await command(
        "Deploy firebase functions.",
        [
          firebaseCommand,
          "deploy",
          "--only",
          "functions",
        ],
        workingDirectory: "firebase",
      );
    }
  }
}
