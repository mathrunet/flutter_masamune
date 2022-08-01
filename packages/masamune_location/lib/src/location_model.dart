part of masamune_location;

final locationProvider = ChangeNotifierProvider((_) => LocationModel());

/// This class manages and monitors location information.
///
/// Execute [listen()] to request location permission and monitor for changes.
class LocationModel extends ValueModel<LocationCompassData> {
  LocationModel()
      : super(
          const LocationCompassData(
            latitude: 0.0,
            longitude: 0.0,
            accuracy: 0.0,
            altitude: 0.0,
            speed: 0.0,
            speedAccuracy: 0.0,
            heading: 0.0,
            time: 0.0,
            headingForCameraMode: 0.0,
          ),
        );

  // ignore: cancel_subscriptions
  StreamSubscription<CompassEvent>? _compassEventSubscription;
  // ignore: cancel_subscriptions
  StreamSubscription<LocationData>? _locationEventSubscription;

  Timer? _timer;
  Duration? _updateInterval;
  bool _updated = false;

  /// Returns itself after the load/save finishes.
  Future<void>? get loading => _loadingCompleter?.future;
  Completer<void>? _loadingCompleter;

  /// If this value is `true`,
  /// the change will be notified when [value] itself is changed.
  @override
  bool get notifyOnChangeValue => _updateInterval == null;

  @protected
  final Location _location = Location();

  /// Check whether the location is currently being acquired.
  bool get isListened {
    if (!isPermitted) {
      return false;
    }
    if (_compassEventSubscription == null ||
        _locationEventSubscription == null) {
      return false;
    }
    return true;
  }

  /// Check the permission status of the current location.
  bool get isPermitted => _permissionStatus == PermissionStatus.granted;
  PermissionStatus _permissionStatus = PermissionStatus.denied;

  /// This class manages and monitors location information.
  ///
  /// Execute [listen()] to request location permission and monitor for changes.
  Future<void> listen({
    Duration? updateInterval,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    if (_updateInterval == updateInterval && isListened) {
      return;
    }
    _updateInterval = updateInterval;
    await _listenLocation(timeout);
  }

  /// Abandon location information acquisition.
  void unlisten() {
    dispose();
  }

  Future<void> _listenLocation(Duration timeout) async {
    if (_loadingCompleter != null) {
      return loading;
    }
    _loadingCompleter = Completer<void>();
    try {
      if (!await _location.serviceEnabled().timeout(timeout)) {
        if (!await _location.requestService().timeout(timeout)) {
          throw Exception(
            "Location service not available. The platform may not be supported or it may be disabled in the settings. please confirm."
                .localize(),
          );
        }
      }
      _permissionStatus = await _location.hasPermission().timeout(timeout);
      if (_permissionStatus == PermissionStatus.denied) {
        _permissionStatus =
            await _location.requestPermission().timeout(timeout);
      }
      if (_permissionStatus != PermissionStatus.granted) {
        throw Exception(
          "You are not authorized to use the location information service. Check the permission settings."
              .localize(),
        );
      }
      final locationData = await _location.getLocation().timeout(timeout);
      value = value.copyWith(
        latitude: locationData.latitude,
        longitude: locationData.longitude,
        verticalAccuracy: locationData.verticalAccuracy,
        altitude: locationData.altitude,
        speed: locationData.speed,
        speedAccuracy: locationData.speedAccuracy,
        time: locationData.time,
        headingAccuracy: locationData.headingAccuracy,
        elapsedRealtimeNanos: locationData.elapsedRealtimeNanos,
        elapsedRealtimeUncertaintyNanos:
            locationData.elapsedRealtimeUncertaintyNanos,
        satelliteNumber: locationData.satelliteNumber,
        provider: locationData.provider,
      );
      _compassEventSubscription?.cancel();
      _locationEventSubscription?.cancel();
      _compassEventSubscription = FlutterCompass.events?.listen((compass) {
        _updated = true;
        value = value.copyWith(
          heading: compass.heading,
          headingForCameraMode: compass.headingForCameraMode,
          accuracy: compass.accuracy,
        );
      });
      _locationEventSubscription =
          _location.onLocationChanged.listen((locationData) {
        _updated = true;
        value = value.copyWith(
          latitude: locationData.latitude,
          longitude: locationData.longitude,
          verticalAccuracy: locationData.verticalAccuracy,
          altitude: locationData.altitude,
          speed: locationData.speed,
          speedAccuracy: locationData.speedAccuracy,
          time: locationData.time,
          headingAccuracy: locationData.headingAccuracy,
          elapsedRealtimeNanos: locationData.elapsedRealtimeNanos,
          elapsedRealtimeUncertaintyNanos:
              locationData.elapsedRealtimeUncertaintyNanos,
          satelliteNumber: locationData.satelliteNumber,
          provider: locationData.provider,
        );
      });
      if (_updateInterval != null) {
        _updated = false;
        _timer?.cancel();
        _timer = Timer.periodic(_updateInterval!, (timer) {
          if (!_updated) {
            return;
          }
          notifyListeners();
        });
      }
      notifyListeners();
    } catch (e) {
      _loadingCompleter?.completeError(e);
      _loadingCompleter = null;
      rethrow;
    } finally {
      _loadingCompleter?.complete();
      _loadingCompleter = null;
    }
  }

  /// Destroys the object.
  ///
  /// Destroyed objects are not allowed.
  @override
  void dispose() {
    _updated = false;
    _updateInterval = null;
    _timer?.cancel();
    _timer = null;
    _loadingCompleter?.complete();
    _loadingCompleter = null;
    _compassEventSubscription?.cancel();
    _locationEventSubscription?.cancel();
    _compassEventSubscription = null;
    _locationEventSubscription = null;
    super.dispose();
  }
}

/// Class that stores compass data.
typedef CompassData = CompassEvent;
