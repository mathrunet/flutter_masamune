part of masamune_location_google;

/// [MasamuneAdapter] handles location information and performs initial settings for displaying GoogleMap.
///
/// 位置情報を取り扱い、GoogleMapを表示するための初期設定を行う[MasamuneAdapter]。
class GoogleLocationMasamuneAdapter extends LocationMasamuneAdapter {
  /// [MasamuneAdapter] handles location information and performs initial settings for displaying GoogleMap.
  ///
  /// 位置情報を取り扱い、GoogleMapを表示するための初期設定を行う[MasamuneAdapter]。
  const GoogleLocationMasamuneAdapter({this.defaultMapStyle});

  /// Default map style.
  ///
  /// デフォルトのマップスタイル。
  final MapStyle? defaultMapStyle;

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<GoogleLocationMasamuneAdapter>(
      adapter: this,
      child: app,
    );
  }
}
