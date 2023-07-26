// Project imports:
import 'dart:io';

import 'package:katana_cli/katana_cli.dart';
import 'package:xml/xml.dart';

/// Add a module for using Speech-to-Text.
///
/// Speech-to-Textを利用するためのモジュールを追加します。
class AppSpeechToTextCliAction extends CliCommand with CliActionMixin {
  /// Add a module for using Speech-to-Text.
  ///
  /// Speech-to-Textを利用するためのモジュールを追加します。
  const AppSpeechToTextCliAction();

  @override
  String get description =>
      "Add a module for using Speech-to-Text. Speech-to-Textを利用するためのモジュールを追加します。";

  @override
  bool checkEnabled(ExecContext context) {
    final value = context.yaml.getAsMap("app").getAsMap("speech_to_text");
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
    final stt = context.yaml.getAsMap("app").getAsMap("speech_to_text");
    final permission = stt.getAsMap("permission");
    if (permission.isEmpty) {
      error(
        "The item [app]->[speech_to_text]->[permission] is missing. Please include the language code and the message when authorization is granted here.",
      );
      return;
    }
    await command(
      "Import packages.",
      [
        flutter,
        "pub",
        "add",
        "masamune_speech_to_text",
      ],
    );
    label("Addition of permission messages.");
    await XCodePermissionType.microphoneUsage.setMessageToXCode(
      permission
          .map((key, value) => MapEntry(key, value.toString()))
          .where((key, value) => value.isNotEmpty),
    );
    await XCodePermissionType.speechRecognitionUsage.setMessageToXCode(
      permission
          .map((key, value) => MapEntry(key, value.toString()))
          .where((key, value) => value.isNotEmpty),
    );
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
            p1.value == "android.permission.RECORD_AUDIO"))) {
      manifest.first.children.add(
        XmlElement(
          XmlName("uses-permission"),
          [
            XmlAttribute(
              XmlName("android:name"),
              "android.permission.RECORD_AUDIO",
            ),
          ],
          [],
        ),
      );
    }
    if (!manifest.first.children.any((p0) =>
        p0 is XmlElement &&
        p0.name.toString() == "uses-permission" &&
        p0.attributes.any((p1) =>
            p1.name.toString() == "android:name" &&
            p1.value == "android.permission.BLUETOOTH"))) {
      manifest.first.children.add(
        XmlElement(
          XmlName("uses-permission"),
          [
            XmlAttribute(
              XmlName("android:name"),
              "android.permission.BLUETOOTH",
            ),
          ],
          [],
        ),
      );
    }
    if (!manifest.first.children.any((p0) =>
        p0 is XmlElement &&
        p0.name.toString() == "uses-permission" &&
        p0.attributes.any((p1) =>
            p1.name.toString() == "android:name" &&
            p1.value == "android.permission.BLUETOOTH_ADMIN"))) {
      manifest.first.children.add(
        XmlElement(
          XmlName("uses-permission"),
          [
            XmlAttribute(
              XmlName("android:name"),
              "android.permission.BLUETOOTH_ADMIN",
            ),
          ],
          [],
        ),
      );
    }
    if (!manifest.first.children.any((p0) =>
        p0 is XmlElement &&
        p0.name.toString() == "uses-permission" &&
        p0.attributes.any((p1) =>
            p1.name.toString() == "android:name" &&
            p1.value == "android.permission.BLUETOOTH_CONNECT"))) {
      manifest.first.children.add(
        XmlElement(
          XmlName("uses-permission"),
          [
            XmlAttribute(
              XmlName("android:name"),
              "android.permission.BLUETOOTH_CONNECT",
            ),
          ],
          [],
        ),
      );
    }
    final queries = manifest.first.children.firstWhereOrNull(
            (p0) => p0 is XmlElement && p0.name.toString() == "queries") ??
        () {
          final q = XmlElement(XmlName("queries"), [], []);
          manifest.first.children.insertFirst(q);
          return q;
        }();
    if (!queries.children.any((p0) =>
        p0 is XmlElement &&
        p0.name.toString() == "intent" &&
        p0.children.any((p1) =>
            p1 is XmlElement &&
            p1.name.toString() == "action" &&
            p1.attributes.any((p2) =>
                p2.name.toString() == "android:name" &&
                p2.value == "android.speech.RecognitionService")))) {
      queries.children.add(
        XmlElement(
          XmlName("intent"),
          [],
          [
            XmlElement(
              XmlName("action"),
              [
                XmlAttribute(
                  XmlName("android:name"),
                  "android.speech.RecognitionService",
                ),
              ],
              [],
            ),
          ],
        ),
      );
    }
    await file.writeAsString(
      document.toXmlString(pretty: true, indent: "    ", newLine: "\n"),
    );
  }
}
