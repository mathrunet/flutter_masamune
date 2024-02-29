// Dart imports:
import 'dart:io';

// Project imports:
import 'package:katana_cli/katana_cli.dart';
import 'package:katana_cli/src/android_manifest.dart';

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
    final permission = agora.getAsMap("permission");
    final permissionCamera = permission.getAsMap("camera");
    final permissionMicrophone = permission.getAsMap("microphone");
    final firebase = context.yaml.getAsMap("firebase");
    final projectId = firebase.get("project_id", "");
    if (appId.isEmpty) {
      error("[agora]->[app_id] is empty.");
      return;
    }
    if (appCertificate.isEmpty) {
      error("[agora]->[app_certificate] is empty.");
      return;
    }
    if (permissionCamera.isEmpty) {
      error("[agora]->[permission]->[camera] is empty.");
      return;
    }
    if (permissionMicrophone.isEmpty) {
      error("[agora]->[permission]->[microphone] is empty.");
      return;
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
    label("Edit AndroidManifest.xml.");
    await AndroidManifestPermissionType.readPhoneState.enablePermission();
    await AndroidManifestPermissionType.internet.enablePermission();
    await AndroidManifestPermissionType.recordAudio.enablePermission();
    await AndroidManifestPermissionType.camera.enablePermission();
    await AndroidManifestPermissionType.modifyAudioSettings.enablePermission();
    await AndroidManifestPermissionType.accessNetworkState.enablePermission();
    await AndroidManifestPermissionType.bluetooth.enablePermission();
    await AndroidManifestPermissionType.accessWifiState.enablePermission();
    await AndroidManifestPermissionType.readExternalStorage.enablePermission();
    await AndroidManifestPermissionType.wakeLock.enablePermission();
    await AndroidManifestPermissionType.readPrivilegedPhoneState
        .enablePermission();
    label("Addition of permission messages.");
    await XCodePermissionType.cameraUsage.setMessageToXCode(
      permissionCamera
          .map((key, value) => MapEntry(key, value.toString()))
          .where((key, value) => value.isNotEmpty),
    );
    await XCodePermissionType.microphoneUsage.setMessageToXCode(
      permissionMicrophone
          .map((key, value) => MapEntry(key, value.toString()))
          .where((key, value) => value.isNotEmpty),
    );
    await PodfilePermissionType.cameraUsage.enablePermissionToPodfile();
    await PodfilePermissionType.microphoneUsage.enablePermissionToPodfile();
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
    label("Set firebase functions config.");
    final env = FunctionsEnv();
    await env.load();
    env["AGORA_APP_ID"] = appId;
    env["AGORA_APP_CERTIFICATE"] = appCertificate;
    await env.save();
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
