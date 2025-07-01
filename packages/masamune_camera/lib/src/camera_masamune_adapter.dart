part of "/masamune_camera.dart";

/// Base class for [MasamuneAdapter], which performs initial camera settings.
///
/// カメラの初期設定を行う[MasamuneAdapter]のベースクラス。
abstract class CameraMasamuneAdapter extends MasamuneAdapter {
  /// Base class for [MasamuneAdapter], which performs initial camera settings.
  ///
  /// カメラの初期設定を行う[MasamuneAdapter]のベースクラス。
  const CameraMasamuneAdapter({
    this.defaultResolutionPreset = ResolutionPreset.high,
    this.defaultImageFormat = MediaFormat.jpg,
    this.enableAudio = true,
  });

  /// Resolution preset.
  ///
  /// 解像度のプリセット。
  final ResolutionPreset defaultResolutionPreset;

  /// Image format.
  ///
  /// 画像フォーマット。
  final MediaFormat defaultImageFormat;

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

  /// Request camera authorization.
  ///
  /// Returns `false` if permission is not granted.
  ///
  /// カメラの権限をリクエストします。
  ///
  /// 権限が許可されていない場合は`false`を返します。
  Future<PermissionStatus> requestCameraPermission({
    Duration timeout = const Duration(seconds: 60),
  });

  /// Requests microphone privileges.
  ///
  /// Returns `false` if permission is not granted.
  ///
  /// マイクの権限をリクエストします。
  ///
  /// 権限が許可されていない場合は`false`を返します。
  Future<PermissionStatus> requestMicrophonePermission({
    Duration timeout = const Duration(seconds: 60),
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
    MediaFormat? format,
  });

  /// Start video recording.
  ///
  /// ビデオ撮影を開始します。
  Future<void> startVideoRecording({
    required camera.CameraController? controller,
  });

  /// Stop video recording.
  ///
  /// ビデオ撮影を停止します。
  Future<CameraValue?> stopVideoRecording({
    required camera.CameraController? controller,
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
