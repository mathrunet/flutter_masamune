part of '/masamune_location_google.dart';

/// [MasamuneAdapter] handles location information and performs initial settings for displaying GoogleMap.
///
/// 位置情報を取り扱い、GoogleMapを表示するための初期設定を行う[MasamuneAdapter]。
class GoogleMobileLocationMasamuneAdapter extends MobileLocationMasamuneAdapter
    implements GoogleLocationMasamuneAdapter {
  /// [MasamuneAdapter] handles location information and performs initial settings for displaying GoogleMap.
  ///
  /// 位置情報を取り扱い、GoogleMapを表示するための初期設定を行う[MasamuneAdapter]。
  const GoogleMobileLocationMasamuneAdapter({
    this.defaultMapStyle,
    super.location,
    super.defaultAccuracy,
    super.defaultDistanceFilterMeters,
    super.listenOnBoot = false,
    super.enableBackgroundLocation,
    super.defaultLocationData,
  });

  /// Default map style.
  ///
  /// デフォルトのマップスタイル。
  @override
  final MapStyle? defaultMapStyle;

  @override
  void onInitScope(MasamuneAdapter adapter) {
    super.onInitScope(adapter);
    if (adapter is! GoogleLocationMasamuneAdapter) {
      return;
    }
    GoogleLocationMasamuneAdapter._primary = adapter;
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<GoogleLocationMasamuneAdapter>(
      adapter: this,
      child: app,
    );
  }
}
