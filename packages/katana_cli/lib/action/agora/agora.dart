// Dart imports:
import 'dart:io';

// Project imports:
import 'package:katana_cli/katana_cli.dart';

/// Add a module to use Agora.io.
///
/// Agora.ioを利用するためのモジュールを追加します。
class AgoraCliAction extends CliCommand with CliActionMixin {
  /// Add a module to use Agora.io.
  ///
  /// Agora.ioを利用するためのモジュールを追加します。
  const AgoraCliAction();

  @override
  String get description =>
      "Add a module to use Agora.io. Agora.ioを利用するためのモジュールを追加します。";

  @override
  bool checkEnabled(ExecContext context) {
    final value = context.yaml.getAsMap("agora");
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
    final firebaseCommand = bin.get("firebase", "firebase");
    final agora = context.yaml.getAsMap("agora");
    final appId = agora.get("app_id", "");
    final appCertificate = agora.get("app_certificate", "");
    final enableCloudRecording = agora.get("enable_cloud_recording", false);
    final firebase = context.yaml.getAsMap("firebase");
    final projectId = firebase.get("project_id", "");
    if (appId.isEmpty) {
      error("[agora]->[app_id] is empty.");
      return;
    }
    if (appCertificate.isEmpty) {
      error("[agora]->[app_certificate] is empty.");
    }
    if (projectId.isEmpty) {
      error(
        "The item [firebase]->[project_id] is missing. Please provide the Firebase project ID for the configuration.",
      );
      return;
    }
    final firebaseDir = Directory("firebase");
    if (!firebaseDir.existsSync()) {
      error(
        "The directory `firebase` does not exist. Initialize Firebase by executing Firebase init.",
      );
      return;
    }
    final functionsDir = Directory("firebase/functions");
    if (!functionsDir.existsSync()) {
      error(
        "The directory `firebase/functions` does not exist. Initialize Firebase by executing Firebase init.",
      );
      return;
    }
    await command(
      "Import packages.",
      [
        flutter,
        "pub",
        "add",
        "masamune_agora",
        "katana_functions_firebase",
      ],
    );
    label("Add firebase functions");
    final functions = Fuctions();
    await functions.load();
    if (!functions.functions.any((e) => e.startsWith("agoraToken"))) {
      functions.functions.add("agoraToken()");
    }
    if (enableCloudRecording &&
        !functions.functions.any((e) => e.startsWith("agoraCloudRecording"))) {
      functions.functions.add("agoraCloudRecording()");
    }
    await functions.save();
    await command(
      "Set firebase functions config.",
      [
        firebaseCommand,
        "functions:config:set",
        "agora.app_id=$appId",
        "agora.app_certificate=$appCertificate",
      ],
      workingDirectory: "firebase",
    );
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
