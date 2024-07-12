// Project imports:
import 'package:katana_cli/katana_cli.dart';

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
    await addFlutterImport(
      [
        "masamune_camera",
      ],
    );
  }
}
