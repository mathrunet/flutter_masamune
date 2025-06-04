part of "/masamune_location_google.dart";

/// [MasamuneAdapter] for the mock-up that handles location information and performs the initial setup for displaying GoogleMap.
///
/// 位置情報を取り扱い、GoogleMapを表示するための初期設定を行うモック用の[MasamuneAdapter]。
class GoogleMockLocationMasamuneAdapter extends MockLocationMasamuneAdapter
    implements GoogleLocationMasamuneAdapter {
  /// [MasamuneAdapter] for the mock-up that handles location information and performs the initial setup for displaying GoogleMap.
  ///
  /// 位置情報を取り扱い、GoogleMapを表示するための初期設定を行うモック用の[MasamuneAdapter]。
  const GoogleMockLocationMasamuneAdapter({
    required super.defaultLocationData,
    this.defaultMapStyle,
    super.location,
    super.listenOnBoot = false,
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
