part of '/masamune_camera.dart';

/// Initialize the camera for the mock [MasamuneAdapter].
///
/// モック用のカメラの初期設定を行う[MasamuneAdapter]。
class MockCameraMasamuneAdapter extends CameraMasamuneAdapter {
  /// Initialize the camera for the mock [MasamuneAdapter].
  ///
  /// モック用のカメラの初期設定を行う[MasamuneAdapter]。
  const MockCameraMasamuneAdapter({
    super.defaultResolutionPreset = ResolutionPreset.high,
    super.defaultImageFormat = ImageFormat.jpg,
  });

  @override
  Widget preview({required camera.CameraController? controller}) {
    return const ColoredBox(color: Colors.black);
  }

  @override
  Future<camera.CameraController?> initialize({
    ResolutionPreset? resolutionPreset,
  }) async {
    return null;
  }

  @override
  Future<CameraValue?> takePicture({
    required camera.CameraController? controller,
    int? width,
    int? height,
    ImageFormat? format,
  }) async {
    return await CameraValue.create(
      format: format ?? defaultImageFormat,
      width: width,
      height: height,
    );
  }

  @override
  void dispose({
    required camera.CameraController? controller,
  }) {}
}
