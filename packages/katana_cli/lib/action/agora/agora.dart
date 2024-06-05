// Dart imports:
import 'dart:io';

// Project imports:
import 'package:katana_cli/action/post/firebase_deploy_post_action.dart';
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
    final agora = context.yaml.getAsMap("agora");
    final appId = agora.get("app_id", "");
    final appCertificate = agora.get("app_certificate", "");
    final enableCloudRecording = agora.get("enable_cloud_recording", false);
    final enableFullscreenSharing =
        agora.get("enable_fullscreen_sharing", false);
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
    await addFlutterImport(
      [
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
    label("Edit XCode.");
    final xcode = XCode();
    await xcode.load();
    final buildConfigurations = xcode.pbxBuildConfiguration
        .where((element) => element.baseConfigurationReference.isNotEmpty);
    for (final buildConfiguration in buildConfigurations) {
      final buildSetting = buildConfiguration.buildSettings;
      if (!buildSetting.any((e) => e.key == "STRIP_STYLE")) {
        buildConfiguration.buildSettings.add(
          PBXBuildConfigurationSettings(
            key: "STRIP_STYLE",
            value: "\"non-global\"",
          ),
        );
      }
    }
    await xcode.save();
    label("Edit build.gradle.");
    final gradle = BuildGradle();
    await gradle.load();
    if (enableFullscreenSharing) {
      gradle.allProjects.configurations.removeWhere(
        (element) =>
            element.command ==
            "exclude group:\"io.agora.rtc\", module:\"full-screen-sharing\"",
      );
    } else {
      if (!gradle.allProjects.configurations.any((element) =>
          element.command ==
          "exclude group:\"io.agora.rtc\", module:\"full-screen-sharing\"")) {
        gradle.allProjects.configurations.add(
          GradleAllprojectsConfigurations(
            command:
                "exclude group:\"io.agora.rtc\", module:\"full-screen-sharing\"",
          ),
        );
      }
    }
    await gradle.save();
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
