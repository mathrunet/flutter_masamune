// Project imports:
import "package:katana_cli/katana_cli.dart";
import "package:katana_cli/src/android_manifest.dart";

/// Add a module to use the camera.
///
/// カメラを利用するためのモジュールを追加します。
class AppCameraCliAction extends CliCommand with CliActionMixin {
  /// Add a module to use the camera.
  ///
  /// カメラを利用するためのモジュールを追加します。
  const AppCameraCliAction();

  @override
  String get description =>
      "Add a module to use the camera. カメラを利用するためのモジュールを追加します。";

  @override
  bool checkEnabled(ExecContext context) {
    final value = context.yaml.getAsMap("app").getAsMap("camera");
    final enabled = value.get("enable", false);
    if (!enabled) {
      return false;
    }
    return true;
  }

  @override
  Future<void> exec(ExecContext context) async {
    final camera = context.yaml.getAsMap("app").getAsMap("camera");
    final permission = camera.getAsMap("permission");
    final audioEnable = camera.getAsMap("audio").get("enable", false);
    final permissionCamera = permission.getAsMap("camera");
    final permissionMicrophone = permission.getAsMap("microphone");
    if (audioEnable && permissionMicrophone.isEmpty) {
      error(
        "The [camera]->[audio]->[enable] is enabled, but the [camera]->[permission]->[microphone] permission is not set.",
      );
      return;
    }
    label("Addition of permission messages.");
    await XCodePermissionType.cameraUsage.setMessageToXCode(
      permissionCamera
          .map((key, value) => MapEntry(key, value.toString()))
          .where((key, value) => value.isNotEmpty),
    );
    if (audioEnable) {
      await XCodePermissionType.microphoneUsage.setMessageToXCode(
        permissionMicrophone
            .map((key, value) => MapEntry(key, value.toString()))
            .where((key, value) => value.isNotEmpty),
      );
    }
    await PodfilePermissionType.cameraUsage.enablePermissionToPodfile();
    if (audioEnable) {
      await PodfilePermissionType.microphoneUsage.enablePermissionToPodfile();
    }
    if (audioEnable) {}
    label("Edit AndroidManifest.xml.");
    await AndroidManifestPermissionType.camera.enablePermission();
    await addFlutterImport(
      [
        "masamune_camera",
      ],
    );
  }
}
