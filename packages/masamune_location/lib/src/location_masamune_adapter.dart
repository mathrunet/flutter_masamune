part of '/masamune_location.dart';

/// Initial settings for handling location information [MasamuneAdapter].
///
/// 位置情報を取り扱うための初期設定を行う[MasamuneAdapter]。
abstract class LocationMasamuneAdapter extends MasamuneAdapter {
  /// Initial settings for handling location information [MasamuneAdapter].
  ///
  /// 位置情報を取り扱うための初期設定を行う[MasamuneAdapter]。
  const LocationMasamuneAdapter({
    this.location,
    this.listenOnBoot = false,
    this.defaultLocationData,
    this.enableBackgroundLocation = false,
  });

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

  /// Specifies the initial position.
  ///
  /// 初期位置を指定します。
  final LocationData? defaultLocationData;

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

  /// Allow and obtain location permissions.
  ///
  /// 位置情報の権限の許可と取得を行います。
  Future<PermissionStatus> requestPermission({
    Duration timeout = const Duration(seconds: 60),
  }) async {
    var permissionStatus =
        await Permission.locationWhenInUse.status.timeout(timeout);
    if (permissionStatus != PermissionStatus.granted) {
      permissionStatus =
          await Permission.locationWhenInUse.request().timeout(timeout);
    }
    return permissionStatus;
  }

  /// Allow and retrieve background location permissions.
  ///
  /// バックグラウンドの位置情報の権限の許可と取得を行います。
  Future<PermissionStatus> requestBackgroundPermission({
    Duration timeout = const Duration(seconds: 60),
  }) async {
    var backgroundPermissionStatus =
        await Permission.locationAlways.status.timeout(timeout);
    if (backgroundPermissionStatus != PermissionStatus.granted) {
      backgroundPermissionStatus =
          await Permission.locationAlways.request().timeout(timeout);
    }
    return backgroundPermissionStatus;
  }

  /// Initialization.
  ///
  /// 初期化を行います。
  Future<void> initialize({
    bool checkPermission = true,
    Duration timeout = const Duration(seconds: 60),
  });

  /// Obtains location data once.
  ///
  /// 位置情報のデータを１回取得します。
  Future<LocationData> getLocation();

  /// Update location settings.
  ///
  /// 位置情報の設定を更新します。
  Future<void> changeSettings({
    LocationAccuracy? accuracy = LocationAccuracy.high,
    double? distanceFilterMeters = 0,
  });

  /// Enable background mode.
  ///
  /// バックグラウンドモードを有効にします。
  Future<void> enableBackgroundMode({required bool enable});

  /// Start location subscription.
  ///
  /// 位置情報の購読を開始します。
  StreamSubscription? listen(void Function(LocationData data) onData);

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
