part of '/masamune_location_google.dart';

/// [MasamuneAdapter] handles location information and performs initial settings for displaying GoogleMap.
///
/// 位置情報を取り扱い、GoogleMapを表示するための初期設定を行う[MasamuneAdapter]。
class GoogleLocationMasamuneAdapter extends LocationMasamuneAdapter {
  /// [MasamuneAdapter] handles location information and performs initial settings for displaying GoogleMap.
  ///
  /// 位置情報を取り扱い、GoogleMapを表示するための初期設定を行う[MasamuneAdapter]。
  const GoogleLocationMasamuneAdapter({
    this.defaultMapStyle,
    super.location,
    super.defaultAccuracy,
    super.defaultDistanceFilterMeters,
    super.listenOnBoot,
    super.enableBackgroundLocation,
    this.compass,
  });

  /// Compass management.
  ///
  /// コンパスの管理を行います。
  final Compass? compass;

  /// Default map style.
  ///
  /// デフォルトのマップスタイル。
  final MapStyle? defaultMapStyle;

  /// You can retrieve the [GoogleLocationMasamuneAdapter] first given by [MasamuneAdapterScope].
  ///
  /// 最初に[MasamuneAdapterScope]で与えた[GoogleLocationMasamuneAdapter]を取得することができます。
  static GoogleLocationMasamuneAdapter get primary {
    assert(
      _primary != null,
      "GoogleLocationMasamuneAdapter is not set. Place [MasamuneAdapterScope] widget closer to the root.",
    );
    return _primary!;
  }

  static GoogleLocationMasamuneAdapter? _primary;

  @override
  void onInitScope(MasamuneAdapter adapter) {
    super.onInitScope(adapter);
    if (adapter is! GoogleLocationMasamuneAdapter) {
      return;
    }
    _primary = adapter;
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<GoogleLocationMasamuneAdapter>(
      adapter: this,
      child: app,
    );
  }
}
