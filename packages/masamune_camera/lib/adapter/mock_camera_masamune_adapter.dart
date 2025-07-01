part of "/masamune_camera.dart";

/// Initialize the camera for the mock [MasamuneAdapter].
///
/// モック用のカメラの初期設定を行う[MasamuneAdapter]。
class MockCameraMasamuneAdapter extends CameraMasamuneAdapter {
  /// Initialize the camera for the mock [MasamuneAdapter].
  ///
  /// モック用のカメラの初期設定を行う[MasamuneAdapter]。
  const MockCameraMasamuneAdapter({
    super.defaultResolutionPreset = ResolutionPreset.high,
    super.defaultImageFormat = MediaFormat.jpg,
    super.enableAudio = true,
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
  Future<PermissionStatus> requestCameraPermission({
    Duration timeout = const Duration(seconds: 60),
  }) async {
    return PermissionStatus.granted;
  }

  @override
  Future<PermissionStatus> requestMicrophonePermission({
    Duration timeout = const Duration(seconds: 60),
  }) async {
    return PermissionStatus.granted;
  }

  @override
  Future<CameraValue?> takePicture({
    required camera.CameraController? controller,
    int? width,
    int? height,
    MediaFormat? format,
  }) async {
    return await CameraValue.create(
      format: format ?? defaultImageFormat,
      width: width,
      height: height,
    );
  }

  @override
  Future<void> startVideoRecording({
    required camera.CameraController? controller,
  }) async {}

  @override
  Future<CameraValue?> stopVideoRecording(
      {required camera.CameraController? controller}) async {
    return null;
  }

  @override
  void dispose({
    required camera.CameraController? controller,
  }) {}
}
