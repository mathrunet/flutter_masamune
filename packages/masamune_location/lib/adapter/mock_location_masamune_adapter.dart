part of '/masamune_location.dart';

/// [MasamuneAdapter] for creating location mocks.
///
/// 位置情報のモックを作成するための[MasamuneAdapter]。
class MockLocationMasamuneAdapter extends LocationMasamuneAdapter {
  /// [MasamuneAdapter] for creating location mocks.
  ///
  /// 位置情報のモックを作成するための[MasamuneAdapter]。
  const MockLocationMasamuneAdapter({
    required LocationData defaultLocationData,
    super.location,
    super.listenOnBoot = false,
  }) : super(defaultLocationData: defaultLocationData);

  @override
  Future<void> initialize({
    bool checkPermission = true,
    Duration timeout = const Duration(seconds: 60),
  }) async =>
      Future.value();

  @override
  Future<LocationData> getLocation() => Future.value(defaultLocationData);

  @override
  Future<void> changeSettings({
    LocationAccuracy? accuracy = LocationAccuracy.high,
    double? distanceFilterMeters = 0,
  }) =>
      Future.value();

  @override
  Future<void> enableBackgroundMode({required bool enable}) => Future.value();

  @override
  StreamSubscription? listen(void Function(LocationData data) onData) {
    onData.call(defaultLocationData!);
    return null;
  }
}
