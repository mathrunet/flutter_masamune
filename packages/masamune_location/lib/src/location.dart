part of "/masamune_location.dart";

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
  Duration _updateInterval = const Duration(seconds: 1);
  bool _updated = false;
  Completer<void>? _listenCompleter;
  Completer<void>? _loadCompleter;
  Completer<void>? _saveCompleter;
  Completer<void>? _initializeCompleter;
  // ignore: cancel_subscriptions
  StreamSubscription? _locationChangeStreamSubscription;

  /// Returns `true` if [listen] has already been executed.
  ///
  /// すでに[listen]が実行されている場合`true`を返します。
  bool get listening {
    if (!permitted) {
      return false;
    }
    if (_locationChangeStreamSubscription == null) {
      return false;
    }
    return true;
  }

  /// If permission is granted by executing [initialize], returns `true`.
  ///
  /// [initialize]を実行してパーミッションが許可されている場合は`true`を返します。
  bool get permitted => _permissionStatus == PermissionStatus.granted;
  PermissionStatus _permissionStatus = PermissionStatus.denied;

  /// Returns `true` if [initialize] is executed and permissions for background are allowed.
  ///
  /// [initialize]を実行してバックグラウンド向けのパーミッションが許可されている場合は`true`を返します。
  bool get permittedBackground =>
      _backgroundPermissionStatus == PermissionStatus.granted;
  PermissionStatus _backgroundPermissionStatus = PermissionStatus.denied;

  /// Allow location permissions.
  ///
  /// Returns `false` if rejected.
  ///
  /// 位置情報の権限の許可を行います。
  ///
  /// 拒否されている場合は`false`を返します。
  Future<bool> requestPermission({
    Duration timeout = const Duration(seconds: 60),
  }) async {
    if (kIsWeb) {
      return true;
    }
    try {
      _permissionStatus = await adapter.requestPermission(timeout: timeout);
      if (_permissionStatus != PermissionStatus.granted) {
        return false;
      }
      if (adapter.enableBackgroundLocation) {
        _backgroundPermissionStatus =
            await adapter.requestBackgroundPermission(timeout: timeout);
      }
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  /// Initialization.
  ///
  /// Location information is available or not and permissions are granted.
  ///
  /// If [checkPermission] is `true`, permission check is performed.
  ///
  /// 初期化を行います。
  ///
  /// 位置情報が利用可能かどうかとパーミッションの許可を行います。
  ///
  /// [checkPermission]が`true`の場合、パーミッションチェックを行います。
  Future<void> initialize({
    bool checkPermission = true,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    if (_initializeCompleter != null) {
      return _initializeCompleter?.future;
    }
    if (initialized) {
      return;
    }
    _initializeCompleter = Completer<void>();
    try {
      await adapter.initialize(
          checkPermission: checkPermission, timeout: timeout);
      if (checkPermission) {
        if (!await requestPermission(timeout: timeout)) {
          debugPrint(
            "You are not authorized to use the location information service. Check the permission settings.",
          );
        }
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

  /// If location information has not been acquired, location information is acquired only once.
  ///
  /// If [checkPermission] is `true`, permission check is performed.
  ///
  /// When permissions are not allowed, [defaultLocationData] is used.
  ///
  /// 位置情報が取得されていない場合１度だけ位置情報を取得します。
  ///
  /// [checkPermission]が`true`の場合、パーミッションチェックを行います。
  ///
  /// パーミッションが許可されていない時は[defaultLocationData]が使用されます。
  Future<void> load({
    bool checkPermission = true,
    LocationAccuracy? accuracy,
    double? distanceFilterMeters,
    LocationData? defaultLocationData,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    if (_loadCompleter != null) {
      return _loadCompleter?.future;
    }
    if (_listenCompleter != null) {
      return _listenCompleter?.future;
    }
    if (_value != null) {
      return;
    }
    _loadCompleter = Completer<void>();
    try {
      await initialize(
        timeout: timeout,
        checkPermission: checkPermission,
      );
      if (!permitted) {
        _value = defaultLocationData ?? adapter.defaultLocationData ?? _value;
      } else {
        _value = await adapter.getLocation();
      }
      notifyListeners();
      _loadCompleter?.complete();
      _loadCompleter = null;
    } catch (e) {
      _loadCompleter?.completeError(e);
      _loadCompleter = null;
      rethrow;
    } finally {
      _loadCompleter?.complete();
      _loadCompleter = null;
    }
  }

  /// Update location information.
  ///
  /// If [checkPermission] is `true`, permission check is performed.
  ///
  /// When permissions are not allowed, [defaultLocationData] is used.
  ///
  /// 位置情報を更新します。
  ///
  /// [checkPermission]が`true`の場合、パーミッションチェックを行います。
  ///
  /// パーミッションが許可されていない時は[defaultLocationData]が使用されます。
  Future<void> reload({
    Duration timeout = const Duration(seconds: 60),
    LocationAccuracy? accuracy,
    double? distanceFilterMeters,
    bool checkPermission = true,
    LocationData? defaultLocationData,
  }) async {
    _value = null;
    await load(
      timeout: timeout,
      checkPermission: checkPermission,
      defaultLocationData: defaultLocationData,
      accuracy: accuracy,
      distanceFilterMeters: distanceFilterMeters,
    );
  }

  /// Update the location manually by passing [location].
  ///
  /// [location]を渡すことで手動で位置情報を更新します。
  Future<void> save({
    required LocationData location,
  }) async {
    if (_saveCompleter != null) {
      return _saveCompleter?.future;
    }
    _saveCompleter = Completer<void>();
    try {
      await initialize(checkPermission: false);
      _value = location;
      notifyListeners();
      _saveCompleter?.complete();
      _saveCompleter = null;
    } catch (e) {
      _saveCompleter?.completeError(e);
      _saveCompleter = null;
      rethrow;
    } finally {
      _saveCompleter?.complete();
      _saveCompleter = null;
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
    double? distanceFilterMeters,
    Duration updateInterval = const Duration(seconds: 1),
    Duration timeout = const Duration(seconds: 15),
  }) async {
    if (_listenCompleter != null) {
      return _listenCompleter?.future;
    }
    if (_loadCompleter != null) {
      await _loadCompleter?.future;
    }
    if (_updateInterval == updateInterval && listening) {
      return;
    }
    _listenCompleter = Completer<void>();
    _updateInterval = updateInterval;
    try {
      await initialize(timeout: timeout);
      await adapter.changeSettings(
        accuracy: accuracy,
        distanceFilterMeters: distanceFilterMeters,
      );
      if (adapter.enableBackgroundLocation && permittedBackground) {
        await adapter.enableBackgroundMode(enable: true);
      }
      _value = await adapter.getLocation().timeout(timeout);
      _locationChangeStreamSubscription?.cancel();
      _locationChangeStreamSubscription = adapter.listen(
        (value) {
          _updated = true;
          _value = value;
        },
      );
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
    _locationChangeStreamSubscription?.cancel();
    _locationChangeStreamSubscription = null;
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
  location.LocationAccuracy toGeoLocatorLocationAccuracy() {
    switch (this) {
      case LocationAccuracy.lowest:
        return location.LocationAccuracy.lowest;
      case LocationAccuracy.low:
        return location.LocationAccuracy.low;
      case LocationAccuracy.medium:
        return location.LocationAccuracy.medium;
      case LocationAccuracy.high:
        return location.LocationAccuracy.high;
      case LocationAccuracy.best:
        return location.LocationAccuracy.high;
      case LocationAccuracy.navigation:
        return location.LocationAccuracy.bestForNavigation;
      default:
        return location.LocationAccuracy.reduced;
    }
  }
}

extension on location.Position {
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
