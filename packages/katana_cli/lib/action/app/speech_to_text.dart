// Dart imports:

// Project imports:
import 'package:katana_cli/katana_cli.dart';
import 'package:katana_cli/src/android_manifest.dart';

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
    final stt = context.yaml.getAsMap("app").getAsMap("speech_to_text");
    final permission = stt.getAsMap("permission");
    if (permission.isEmpty) {
      error(
        "The item [app]->[speech_to_text]->[permission] is missing. Please include the language code and the message when authorization is granted here.",
      );
      return;
    }
    await addFlutterImport(
      [
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
    await PodfilePermissionType.microphoneUsage.enablePermissionToPodfile();
    await PodfilePermissionType.speechRecognitionUsage
        .enablePermissionToPodfile();
    label("Edit AndroidManifest.xml.");
    await AndroidManifestPermissionType.recordAudio.enablePermission();
    await AndroidManifestPermissionType.bluetooth.enablePermission();
    await AndroidManifestPermissionType.bluetoothAdmin.enablePermission();
    await AndroidManifestPermissionType.bluetoothConnect.enablePermission();
    await AndroidManifestQueryType.speechToText.enableQuery();
  }
}
