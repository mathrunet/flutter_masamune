part of "/masamune_location_google.dart";

/// [MasamuneAdapter] handles location information and performs initial settings for displaying GoogleMap.
///
/// 位置情報を取り扱い、GoogleMapを表示するための初期設定を行う[MasamuneAdapter]。
abstract class GoogleLocationMasamuneAdapter extends LocationMasamuneAdapter {
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

  /// Default map style.
  ///
  /// デフォルトのマップスタイル。
  MapStyle? get defaultMapStyle;
}
