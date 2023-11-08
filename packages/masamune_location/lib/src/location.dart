part of '/masamune_location.dart';

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
  /// appRef.controller(Location.query(parameters));     // Get from application scope.
  /// ref.app.controller(Location.query(parameters));    // Watch at application scope.
  /// ref.page.controller(Location.query(parameters));   // Watch at page scope.
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
      _value = (await Geolocator.getCurrentPosition(
        desiredAccuracy:
            (accuracy ?? LocationMasamuneAdapter.primary.defaultAccuracy)
                .toGeoLocatorLocationAccuracy(),
      ))
          .toLocationData();
      _positionStreamSubscription?.cancel();
      _positionStreamSubscription = Geolocator.getPositionStream(
        locationSettings: LocationSettings(
          accuracy:
              (accuracy ?? LocationMasamuneAdapter.primary.defaultAccuracy)
                  .toGeoLocatorLocationAccuracy(),
          distanceFilter: distanceFilterMeters ??
              LocationMasamuneAdapter.primary.defaultDistanceFilterMeters,
        ),
      ).listen((position) {
        _updated = true;
        _value = position.toLocationData();
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
  Future<void> unlisten() async {
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

extension on LocationAccuracy {
  geolocator.LocationAccuracy toGeoLocatorLocationAccuracy() {
    switch (this) {
      case LocationAccuracy.lowest:
        return geolocator.LocationAccuracy.lowest;
      case LocationAccuracy.low:
        return geolocator.LocationAccuracy.low;
      case LocationAccuracy.medium:
        return geolocator.LocationAccuracy.medium;
      case LocationAccuracy.high:
        return geolocator.LocationAccuracy.high;
      case LocationAccuracy.best:
        return geolocator.LocationAccuracy.best;
      case LocationAccuracy.navigation:
        return geolocator.LocationAccuracy.bestForNavigation;
      default:
        return geolocator.LocationAccuracy.low;
    }
  }
}

extension on Position {
  LocationData toLocationData() {
    return LocationData(
      latitude: latitude,
      longitude: longitude,
      altitude: altitude,
      accuracy: accuracy,
      heading: heading,
      speed: speed,
      speedAccuracy: speedAccuracy,
      timestamp: timestamp,
    );
  }
}
