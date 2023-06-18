part of masamune_location;

/// Initial settings for handling location information [MasamuneAdapter].
///
/// 位置情報を取り扱うための初期設定を行う[MasamuneAdapter]。
class LocationMasamuneAdapter extends MasamuneAdapter {
  /// Initial settings for handling location information [MasamuneAdapter].
  ///
  /// 位置情報を取り扱うための初期設定を行う[MasamuneAdapter]。
  const LocationMasamuneAdapter({
    this.defaultAccuracy = LocationAccuracy.best,
    this.defaultDistanceFilterMeters = 10,
  });

  /// Specifies the accuracy of location information.
  ///
  /// 位置情報の正確さを指定します。
  final LocationAccuracy defaultAccuracy;

  /// Minimum distance in meters for location updates.
  ///
  /// 位置情報を更新する際の最低距離（m）。
  final int defaultDistanceFilterMeters;

  /// You can retrieve the [LocationMasamuneAdapter] first given by [MasamuneAdapterScope].
  ///
  /// 最初に[MasamuneAdapterScope]で与えた[LocationMasamuneAdapter]を取得することができます。
  static LocationMasamuneAdapter get primary {
    assert(
      _primary != null,
      "LocationMasamuneAdapter is not set. Place [MasamuneAdapterScope] widget closer to the root.",
    );
    return _primary!;
  }

  static LocationMasamuneAdapter? _primary;

  @override
  void onInitScope(MasamuneAdapter adapter) {
    super.onInitScope(adapter);
    if (adapter is! LocationMasamuneAdapter) {
      return;
    }
    _primary = adapter;
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<LocationMasamuneAdapter>(
      adapter: this,
      child: app,
    );
  }
}
