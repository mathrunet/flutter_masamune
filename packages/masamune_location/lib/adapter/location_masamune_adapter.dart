part of '/masamune_location.dart';

/// Initial settings for handling location information [MasamuneAdapter].
///
/// 位置情報を取り扱うための初期設定を行う[MasamuneAdapter]。
class LocationMasamuneAdapter extends MasamuneAdapter {
  /// Initial settings for handling location information [MasamuneAdapter].
  ///
  /// 位置情報を取り扱うための初期設定を行う[MasamuneAdapter]。
  const LocationMasamuneAdapter({
    this.defaultAccuracy = LocationAccuracy.best,
    this.defaultDistanceFilterMeters = 10.0,
    this.location,
    this.listenOnBoot = false,
    this.enableBackgroundLocation = false,
  });

  /// Specifies the accuracy of location information.
  ///
  /// 位置情報の正確さを指定します。
  final LocationAccuracy defaultAccuracy;

  /// Minimum distance in meters for location updates.
  ///
  /// 位置情報を更新する際の最低距離（m）。
  final double defaultDistanceFilterMeters;

  /// Specify the object of [Location].
  ///
  /// After specifying this, execute [onMaybeBoot] to start initialization automatically.
  ///
  /// [Location]のオブジェクトを指定します。
  ///
  /// これを指定した上で[onMaybeBoot]を実行すると自動で初期化を開始します。
  final Location? location;

  /// `true` if [location] is set to `true` to start acquiring location information when [onMaybeBoot] is executed.
  ///
  /// [location]が設定されている場合、[onMaybeBoot]を実行した際合わせて位置情報の取得も開始する場合`true`。
  final bool listenOnBoot;

  /// `true` to enable background location acquisition.
  ///
  /// You must allow location information to be "always allowed".
  ///
  /// バックグラウンドでの位置情報取得を有効にする場合`true`。
  ///
  /// 位置情報の許可を"常に許可"にする必要があります。
  final bool enableBackgroundLocation;

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

  @override
  FutureOr<void> onMaybeBoot() async {
    await super.onMaybeBoot();
    if (listenOnBoot) {
      await location?.listen();
    } else {
      await location?.initialize();
    }
  }
}
