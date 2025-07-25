part of "/masamune_camera.dart";

/// [MasamuneAdapter] for initial camera settings.
///
/// カメラの初期設定を行う[MasamuneAdapter]。
class MobileCameraMasamuneAdapter extends CameraMasamuneAdapter {
  /// [MasamuneAdapter] for initial camera settings.
  ///
  /// カメラの初期設定を行う[MasamuneAdapter]。
  const MobileCameraMasamuneAdapter({
    super.defaultResolutionPreset = ResolutionPreset.high,
    super.defaultImageFormat = MediaFormat.jpg,
    super.enableAudio = true,
  });

  static final List<camera.CameraDescription> _cameras = [];

  @override
  Widget preview({required camera.CameraController? controller}) {
    if (controller == null) {
      return const SizedBox();
    }
    return camera.CameraPreview(controller);
  }

  @override
  Future<camera.CameraController> initialize({
    ResolutionPreset? resolutionPreset,
  }) async {
    _cameras.clear();
    _cameras.addAll(await camera.availableCameras());
    final controller = camera.CameraController(
      _cameras.first,
      resolutionPreset?._toResolutionPreset() ??
          defaultResolutionPreset._toResolutionPreset(),
      enableAudio: enableAudio,
    );
    await controller.initialize();
    return controller;
  }

  @override
  Future<PermissionStatus> requestCameraPermission({
    Duration timeout = const Duration(seconds: 60),
  }) async {
    final status = await Permission.camera.status.timeout(timeout);
    if (status != PermissionStatus.granted) {
      return await Permission.camera.request().timeout(timeout);
    }
    return status;
  }

  @override
  Future<PermissionStatus> requestMicrophonePermission({
    Duration timeout = const Duration(seconds: 60),
  }) async {
    final status = await Permission.microphone.status.timeout(timeout);
    if (status != PermissionStatus.granted) {
      return await Permission.microphone.request().timeout(timeout);
    }
    return status;
  }

  @override
  Future<CameraValue?> takePicture({
    required camera.CameraController? controller,
    int? width,
    int? height,
    MediaFormat? format,
  }) async {
    final file = await controller?.takePicture();
    if (file == null) {
      return null;
    }
    return await CameraValue.fromXFile(
      file: file,
      format: format ?? defaultImageFormat,
      width: width,
      height: height,
      startTime: DateTime.now(),
    );
  }

  @override
  Future<void> startVideoRecording({
    required camera.CameraController? controller,
  }) async {
    return controller?.startVideoRecording();
  }

  @override
  Future<CameraValue?> stopVideoRecording({
    required camera.CameraController? controller,
    required DateTime startRecordingTime,
  }) async {
    final file = await controller?.stopVideoRecording();
    if (file == null) {
      return null;
    }
    return await CameraValue.fromXFile(
      file: file,
      format: MediaFormat.mp4,
      startTime: startRecordingTime,
      endTime: DateTime.now(),
    );
  }

  @override
  void dispose({
    required camera.CameraController? controller,
  }) {
    controller?.dispose();
  }
}
