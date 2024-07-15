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
    super.defaultLocationData,
    super.enableBackgroundLocation = false,
    super.location,
    super.listenOnBoot = false,
  });

  /// Specifies the accuracy of location information.
  ///
  /// 位置情報の正確さを指定します。
  final LocationAccuracy defaultAccuracy;

  /// Minimum distance in meters for location updates.
  ///
  /// 位置情報を更新する際の最低距離（m）。
  final double defaultDistanceFilterMeters;


  static final l.Location _location = l.Location();

  @override
  Future<void> initialize({
    bool checkPermission = true,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    if (!await _location.serviceEnabled().timeout(timeout)) {
      throw Exception(
        "Location service not available. The platform may not be supported or it may be disabled in the settings. please confirm.",
      );
    }
  }

  @override
  Future<LocationData> getLocation() async {
    return (await _location.getLocation()).toLocationData();
  }

  @override
  Future<void> changeSettings({
    LocationAccuracy? accuracy = LocationAccuracy.high,
    double? distanceFilterMeters = 0,
  }) async {
    await _location.changeSettings(
      accuracy: (accuracy ?? defaultAccuracy).toGeoLocatorLocationAccuracy(),
      distanceFilter: distanceFilterMeters ?? defaultDistanceFilterMeters,
    );
  }

  @override
  Future<void> enableBackgroundMode({required bool enable}) async {
    await _location.enableBackgroundMode(enable: enable);
  }

  @override
  StreamSubscription? listen(void Function(LocationData data) onData) {
    return _location.onLocationChanged.listen(
      (event) {
        onData.call(event.toLocationData());
      },
    );
  }
}
