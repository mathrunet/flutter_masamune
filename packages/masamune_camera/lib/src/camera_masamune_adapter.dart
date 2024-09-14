part of '/masamune_camera.dart';

/// Base class for [MasamuneAdapter], which performs initial camera settings.
///
/// カメラの初期設定を行う[MasamuneAdapter]のベースクラス。
abstract class CameraMasamuneAdapter extends MasamuneAdapter {
  /// Base class for [MasamuneAdapter], which performs initial camera settings.
  ///
  /// カメラの初期設定を行う[MasamuneAdapter]のベースクラス。
  const CameraMasamuneAdapter({
    this.defaultResolutionPreset = ResolutionPreset.high,
    this.defaultImageFormat = ImageFormat.jpg,
    this.enableAudio = true,
  });

  /// Resolution preset.
  ///
  /// 解像度のプリセット。
  final ResolutionPreset defaultResolutionPreset;

  /// Image format.
  ///
  /// 画像フォーマット。
  final ImageFormat defaultImageFormat;

  /// `true` to set audio.
  ///
  /// オーディオを設定する場合は`true`。
  final bool enableAudio;

  /// You can retrieve the [CameraMasamuneAdapter] first given by [MasamuneAdapterScope].
  ///
  /// 最初に[MasamuneAdapterScope]で与えた[CameraMasamuneAdapter]を取得することができます。
  static CameraMasamuneAdapter get primary {
    assert(
      _primary != null,
      "CameraMasamuneAdapter is not set. Place [MasamuneAdapterScope] widget closer to the root.",
    );
    return _primary!;
  }

  static CameraMasamuneAdapter? _primary;

  /// Output widget for camera preview.
  ///
  /// カメラのプレビュー用のウィジェットを出力します。
  Widget preview({
    required camera.CameraController? controller,
  });

  /// Initialize the camera.
  ///
  /// カメラを初期化します。
  Future<camera.CameraController?> initialize({
    ResolutionPreset? resolutionPreset,
  });

  /// Take a camera image.
  ///
  /// The value is returned as [CameraValue].
  ///
  /// カメラ画像を撮影します。
  ///
  /// [CameraValue]として値は返されます。
  Future<CameraValue?> takePicture({
    required camera.CameraController? controller,
    int? width,
    int? height,
    ImageFormat? format,
  });

  /// Dispose of the camera.
  ///
  /// カメラを破棄します。
  void dispose({
    required camera.CameraController? controller,
  });

  @override
  void onInitScope(MasamuneAdapter adapter) {
    super.onInitScope(adapter);
    if (adapter is! CameraMasamuneAdapter) {
      return;
    }
    _primary = adapter;
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<CameraMasamuneAdapter>(
      adapter: this,
      child: app,
    );
  }
}
