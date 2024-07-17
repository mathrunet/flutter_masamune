part of '/masamune_camera.dart';

/// [MasamuneAdapter] for initial camera settings.
///
/// カメラの初期設定を行う[MasamuneAdapter]。
class MobileCameraMasamuneAdapter extends CameraMasamuneAdapter {
  /// [MasamuneAdapter] for initial camera settings.
  ///
  /// カメラの初期設定を行う[MasamuneAdapter]。
  const MobileCameraMasamuneAdapter({
    super.defaultResolutionPreset = ResolutionPreset.high,
    super.defaultImageFormat = ImageFormat.jpg,
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
    );
    await controller.initialize();
    return controller;
  }

  @override
  Future<CameraValue?> takePicture({
    required camera.CameraController? controller,
    int? width,
    int? height,
    ImageFormat? format,
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
    );
  }

  @override
  void dispose({
    required camera.CameraController? controller,
  }) {
    controller?.dispose();
  }
}
