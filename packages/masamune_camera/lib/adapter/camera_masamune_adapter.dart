part of '/masamune_camera.dart';

/// [MasamuneAdapter] for initial camera settings.
///
/// カメラの初期設定を行う[MasamuneAdapter]。
class CameraMasamuneAdapter extends MasamuneAdapter {
  /// [MasamuneAdapter] for initial camera settings.
  ///
  /// カメラの初期設定を行う[MasamuneAdapter]。
  const CameraMasamuneAdapter({
    this.defaultResolutionPreset = ResolutionPreset.high,
    this.defaultImageFormat = ImageFormat.jpg,
  });

  /// Resolution preset.
  ///
  /// 解像度のプリセット。
  final ResolutionPreset defaultResolutionPreset;

  /// Image format.
  ///
  /// 画像フォーマット。
  final ImageFormat defaultImageFormat;

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
