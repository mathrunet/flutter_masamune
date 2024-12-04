part of '/masamune_location.dart';

/// Initial settings for handling location information [MasamuneAdapter].
///
/// 位置情報を取り扱うための初期設定を行う[MasamuneAdapter]。
class MobileLocationMasamuneAdapter extends LocationMasamuneAdapter {
  /// Initial settings for handling location information [MasamuneAdapter].
  ///
  /// 位置情報を取り扱うための初期設定を行う[MasamuneAdapter]。
  const MobileLocationMasamuneAdapter({
    this.defaultAccuracy = LocationAccuracy.best,
    this.defaultDistanceFilterMeters = 10.0,
    this.getLocationTimeout = const Duration(seconds: 3),
    super.defaultLocationData,
    super.enableBackgroundLocation = false,
    super.location,
    super.listenOnBoot = false,
  });

  /// Timeout period when doing [getLocation].
  ///
  /// In the case of IOS, [getLocation] will not terminate until the location is moved, so set a timeout.
  ///
  /// [getLocation]を行うときのタイムアウト時間。
  ///
  /// IOSの場合位置を移動しないと[getLocation]が終了しないため、タイムアウトを設定します。
  final Duration getLocationTimeout;

  /// Specifies the accuracy of location information.
  ///
  /// 位置情報の正確さを指定します。
  final LocationAccuracy defaultAccuracy;

  /// Minimum distance in meters for location updates.
  ///
  /// 位置情報を更新する際の最低距離（m）。
  final double defaultDistanceFilterMeters;

  static location.LocationSettings _settings = location.LocationSettings();

  @override
  Future<void> initialize({
    bool checkPermission = true,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    _settings = location.LocationSettings(
      accuracy: defaultAccuracy.toGeoLocatorLocationAccuracy(),
      distanceFilter: defaultDistanceFilterMeters.toInt(),
    );
    if (!await location.Geolocator.isLocationServiceEnabled()
        .timeout(timeout)) {
      throw Exception(
        "Location service not available. The platform may not be supported or it may be disabled in the settings. please confirm.",
      );
    }
  }

  @override
  Future<LocationData> getLocation() async {
    final position = await location.Geolocator.getCurrentPosition(
      locationSettings: _settings,
    );
    return position.toLocationData();
  }

  @override
  Future<void> changeSettings({
    LocationAccuracy? accuracy = LocationAccuracy.high,
    double? distanceFilterMeters = 0,
  }) async {
    _settings = location.LocationSettings(
      accuracy: (accuracy ?? defaultAccuracy).toGeoLocatorLocationAccuracy(),
      distanceFilter:
          (distanceFilterMeters ?? defaultDistanceFilterMeters).toInt(),
    );
  }

  @override
  Future<void> enableBackgroundMode({required bool enable}) async {}

  @override
  StreamSubscription? listen(void Function(LocationData data) onData) {
    return location.Geolocator.getPositionStream(locationSettings: _settings)
        .listen(
      (event) {
        onData.call(event.toLocationData());
      },
    );
  }
}
