part of masamune_location;

/// Class for handling terminal location information.
///
/// The acquisition is initiated by doing [listen].
///
/// It monitors the data at each interval and calls [notifyListeners] if it has been updated.
///
/// [LocationData] is stored in [value], so refer to it.
///
/// Terminate acquisition with [unlisten].
///
/// 端末の位置情報を取り扱うクラス。
///
/// [listen]を行うことで取得を開始します。
///
/// インターバルごとにデータを監視し更新されていれば[notifyListeners]を呼び出します。
///
/// [value]に[LocationData]が格納されるのでそこを参照してください。
///
/// [unlisten]で取得を終了します。
class Location
    extends MasamuneControllerBase<LocationData?, LocationMasamuneAdapter> {
  /// Class for handling terminal location information.
  ///
  /// The acquisition is initiated by doing [listen].
  ///
  /// It monitors the data at each interval and calls [notifyListeners] if it has been updated.
  ///
  /// [LocationData] is stored in [value], so refer to it.
  ///
  /// Terminate acquisition with [unlisten].
  ///
  /// 端末の位置情報を取り扱うクラス。
  ///
  /// [listen]を行うことで取得を開始します。
  ///
  /// インターバルごとにデータを監視し更新されていれば[notifyListeners]を呼び出します。
  ///
  /// [value]に[LocationData]が格納されるのでそこを参照してください。
  ///
  /// [unlisten]で取得を終了します。
  Location({super.adapter});

  /// Query for Location.
  ///
  /// ```dart
  /// Location.query(parameters).read(appRef);     // Get from application scope.
  /// Location.query(parameters).watchOnApp(ref);  // Watch at application scope.
  /// Location.query(parameters).watchOnPage(ref); // Watch at page scope.
  /// ```
  static const query = _$LocationQuery();

  @override
  LocationMasamuneAdapter get primaryAdapter => LocationMasamuneAdapter.primary;

  /// Returns `true` if initialized by executing [initialize].
  ///
  /// [initialize]を実行して初期化されている場合は`true`を返します。
  bool get initialized => _initialized;
  bool _initialized = false;

  @override
  LocationData? get value => _value;
  LocationData? _value;

  Timer? _timer;
  Duration _updateInterval = const Duration(minutes: 1);
  bool _updated = false;
  Completer<void>? _listenCompleter;
  Completer<void>? _initializeCompleter;
  // ignore: cancel_subscriptions
  StreamSubscription<Position>? _positionStreamSubscription;

  /// Returns `true` if [listen] has already been executed.
  ///
  /// すでに[listen]が実行されている場合`true`を返します。
  bool get listening {
    if (!permitted) {
      return false;
    }
    if (_positionStreamSubscription == null) {
      return false;
    }
    return true;
  }

  /// If permission is granted by executing [initialize], returns `true`.
  ///
  /// [initialize]を実行してパーミッションが許可されている場合は`true`を返します。
  bool get permitted =>
      _permissionStatus == LocationPermission.always ||
      _permissionStatus == LocationPermission.whileInUse;
  LocationPermission _permissionStatus = LocationPermission.denied;

  /// Initialization.
  ///
  /// Location information is available or not and permissions are granted.
  ///
  /// 初期化を行います。
  ///
  /// 位置情報が利用可能かどうかとパーミッションの許可を行います。
  Future<void> initialize({
    Duration timeout = const Duration(seconds: 60),
  }) async {
    if (_initializeCompleter != null) {
      return _initializeCompleter?.future;
    }
    _initializeCompleter = Completer<void>();
    try {
      if (!await Geolocator.isLocationServiceEnabled().timeout(timeout)) {
        throw Exception(
          "Location service not available. The platform may not be supported or it may be disabled in the settings. please confirm.",
        );
      }
      _permissionStatus = await Geolocator.checkPermission().timeout(timeout);
      if (_permissionStatus == LocationPermission.denied) {
        _permissionStatus =
            await Geolocator.requestPermission().timeout(timeout);
      }
      if (_permissionStatus != LocationPermission.always &&
          _permissionStatus != LocationPermission.whileInUse) {
        throw Exception(
          "You are not authorized to use the location information service. Check the permission settings.",
        );
      }
      _initialized = true;
      notifyListeners();
      _initializeCompleter?.complete();
      _initializeCompleter = null;
    } catch (e) {
      _initializeCompleter?.completeError(e);
      _initializeCompleter = null;
      rethrow;
    } finally {
      _initializeCompleter?.complete();
      _initializeCompleter = null;
    }
  }

  /// Starts acquiring location information.
  ///
  /// The update interval can be specified by specifying [updateInterval].
  ///
  /// [LocationData] is stored in [value], so refer to it.
  ///
  /// You can also specify the accuracy with [accuracy] or [distanceFilterMeters].
  ///
  /// 位置情報の取得を開始します。
  ///
  /// [updateInterval]を指定することで更新間隔を指定できます。
  ///
  /// [value]に[LocationData]が格納されるのでそこを参照してください。
  ///
  /// [accuracy]や[distanceFilterMeters]で精度を指定することもできます。
  Future<void> listen({
    LocationAccuracy? accuracy,
    int? distanceFilterMeters,
    Duration updateInterval = const Duration(minutes: 1),
    Duration timeout = const Duration(seconds: 60),
  }) async {
    if (_listenCompleter != null) {
      return _listenCompleter?.future;
    }
    if (_updateInterval == updateInterval && listening) {
      return;
    }
    _listenCompleter = Completer<void>();
    _updateInterval = updateInterval;
    try {
      await initialize(timeout: timeout);
      _value = LocationData.fromPosition(
        await Geolocator.getCurrentPosition(
          desiredAccuracy:
              accuracy ?? LocationMasamuneAdapter.primary.defaultAccuracy,
        ),
      );
      _positionStreamSubscription?.cancel();
      _positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: LocationSettings(
          accuracy: accuracy ?? LocationMasamuneAdapter.primary.defaultAccuracy,
          distanceFilter: distanceFilterMeters ??
              LocationMasamuneAdapter.primary.defaultDistanceFilterMeters,
        ),
      ).listen((position) {
        _updated = true;
        _value = LocationData.fromPosition(position);
      });
      _updated = false;
      _timer?.cancel();
      _timer = Timer.periodic(_updateInterval, (timer) {
        if (!_updated) {
          return;
        }
        _updated = false;
        notifyListeners();
      });
      notifyListeners();
      _listenCompleter?.complete();
      _listenCompleter = null;
    } catch (e) {
      _listenCompleter?.completeError(e);
      _listenCompleter = null;
      rethrow;
    } finally {
      _listenCompleter?.complete();
      _listenCompleter = null;
    }
  }

  /// Cancel acquisition of [LocationData].
  ///
  /// [LocationData]の取得をキャンセルします。
  void unlisten() {
    _updated = false;
    _timer?.cancel();
    _timer = null;
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
  }

  @override
  void dispose() {
    unlisten();
    super.dispose();
  }
}

/// Location data class.
///
/// 位置情報のデータクラス。
@immutable
class LocationData {
  const LocationData._({
    required this.longitude,
    required this.latitude,
    required this.timestamp,
    required this.accuracy,
    required this.altitude,
    required this.heading,
    required this.speed,
    required this.speedAccuracy,
  });

  factory LocationData.fromPosition(Position position) {
    return LocationData._(
      longitude: position.longitude,
      latitude: position.latitude,
      timestamp: position.timestamp,
      accuracy: position.accuracy,
      altitude: position.altitude,
      heading: position.heading,
      speed: position.speed,
      speedAccuracy: position.speedAccuracy,
    );
  }

  /// The latitude of this position in degrees normalized to the interval -90.0
  /// to +90.0 (both inclusive).
  ///
  /// 正規化された度単位でのこの位置の緯度。-90.0から+90.0（両方とも含む）の間。
  final double latitude;

  /// The longitude of the position in degrees normalized to the interval -180
  /// (exclusive) to +180 (inclusive).
  ///
  /// 度単位でのこの位置の経度。-180（排他）から+180（含む）の間。
  final double longitude;

  /// The time at which this position was determined.
  ///
  /// この位置が決定された時刻。
  final DateTime? timestamp;

  /// The altitude of the device in meters.
  ///
  /// The altitude is not available on all devices. In these cases the returned
  /// value is 0.0.
  ///
  /// デバイスの高度（メートル単位）。
  ///
  /// 高度はすべてのデバイスで利用できるわけではありません。この場合、返される値は0.0です。
  final double altitude;

  /// The estimated horizontal accuracy of the position in meters.
  ///
  /// The accuracy is not available on all devices. In these cases the value is
  /// 0.0.
  ///
  /// 位置の推定水平精度（メートル単位）。
  ///
  /// 精度はすべてのデバイスで利用できるわけではありません。この場合、値は0.0です。
  final double accuracy;

  /// The heading in which the device is traveling in degrees.
  ///
  /// The heading is not available on all devices. In these cases the value is
  /// 0.0.
  ///
  /// デバイスが進行している方向の度数。
  ///
  /// ヘッディングはすべてのデバイスで利用できるわけではありません。この場合、値は0.0です。
  final double heading;

  /// The speed at which the devices is traveling in meters per second over
  /// ground.
  ///
  /// The speed is not available on all devices. In these cases the value is
  /// 0.0.
  ///
  /// 地上の秒速メートルでデバイスが移動している速度。
  ///
  /// 速度はすべてのデバイスで利用できるわけではありません。この場合、値は0.0です。
  final double speed;

  /// The estimated speed accuracy of this position, in meters per second.
  ///
  /// The speedAccuracy is not available on all devices. In these cases the
  /// value is 0.0.
  ///
  /// この位置の推定速度精度（秒速メートル単位）。
  ///
  /// speedAccuracyはすべてのデバイスで利用できるわけではありません。この場合、値は0.0です。
  final double speedAccuracy;

  /// Converts from internal location information to [GeoValue].
  ///
  /// 内部の位置情報から[GeoValue]に変換します。
  GeoValue toGeoValue({
    double radiusKm = 1.0,
  }) {
    return GeoValue(latitude: latitude, longitude: longitude);
  }

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode =>
      accuracy.hashCode ^
      altitude.hashCode ^
      heading.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      speed.hashCode ^
      speedAccuracy.hashCode ^
      timestamp.hashCode;

  @override
  String toString() {
    return "Latitude: $latitude, Longitude: $longitude";
  }
}

@immutable
class _$LocationQuery {
  const _$LocationQuery();

  @useResult
  _$_LocationQuery call() => _$_LocationQuery(
        hashCode.toString(),
      );
}

@immutable
class _$_LocationQuery extends ControllerQueryBase<Location> {
  const _$_LocationQuery(
    this._name,
  );

  final String _name;

  @override
  Location Function() call(Ref ref) {
    return () => Location();
  }

  @override
  String get queryName => _name;
  @override
  bool get autoDisposeWhenUnreferenced => false;
}
