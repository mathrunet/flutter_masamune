part of "others.dart";

const _kRunningKey = "gps://runnning";

/// Class for handling terminal location information.
///
/// It also works in the background.
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
/// バックグラウンド時も動作します。
///
/// [listen]を行うことで取得を開始します。
///
/// インターバルごとにデータを監視し更新されていれば[notifyListeners]を呼び出します。
///
/// [value]に[LocationData]が格納されるのでそこを参照してください。
///
/// [unlisten]で取得を終了します。
class BackgroundLocation extends MasamuneControllerBase<LocationData?,
    BackgroundLocationMasamuneAdapter> {
  /// Class for handling terminal location information.
  ///
  /// It also works in the background.
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
  /// バックグラウンド時も動作します。
  ///
  /// [listen]を行うことで取得を開始します。
  ///
  /// インターバルごとにデータを監視し更新されていれば[notifyListeners]を呼び出します。
  ///
  /// [value]に[LocationData]が格納されるのでそこを参照してください。
  ///
  /// [unlisten]で取得を終了します。
  BackgroundLocation({super.adapter});

  /// Query for Location.
  ///
  /// ```dart
  /// appRef.controller(Location.query(parameters));     // Get from application scope.
  /// ref.app.controller(Location.query(parameters));    // Watch at application scope.
  /// ref.page.controller(Location.query(parameters));   // Watch at page scope.
  /// ```
  static const query = _$BackgroundLocationQuery();

  @override
  BackgroundLocationMasamuneAdapter get primaryAdapter =>
      BackgroundLocationMasamuneAdapter.primary;

  /// Returns `true` if initialized by executing [initialize].
  ///
  /// [initialize]を実行して初期化されている場合は`true`を返します。
  bool get initialized => _initialized;
  bool _initialized = false;

  @override
  LocationData? get value => _value;
  LocationData? _value;

  /// Get a list of all currently recorded location logs.
  ///
  /// 現在記録されているすべての位置情報ログの一覧を取得します。
  AsyncHistoryValue history() {
    if (UniversalPlatform.isAndroid) {
      return AsyncHistoryValue._(
        _AndroidBackgroundLocationRepository.loadAsLocations(),
      );
    } else {
      return AsyncHistoryValue._(
        _IOSBackgroundLocationRepository.loadAsLocations(),
      );
    }
  }

  /// Delete history.
  ///
  /// 履歴を削除します。
  Future<void> clear() {
    if (UniversalPlatform.isAndroid) {
      return _AndroidBackgroundLocationRepository.clear();
    } else {
      return _IOSBackgroundLocationRepository.clear();
    }
  }

  Timer? _timer;
  bool _running = false;
  Completer<void>? _listenCompleter;
  Completer<void>? _initializeCompleter;
  _BackgroundLocationWidgetsBindingObserver? _observer;
  FutureOr<void> Function(BackgroundLocation location)? _onUpdate;
  FutureOr<void> Function(BackgroundLocation location)? _onResume;

  /// Returns `true` if [listen] has already been executed.
  ///
  /// すでに[listen]が実行されている場合`true`を返します。
  bool get listening {
    if (!permitted) {
      return false;
    }
    return _running;
  }

  /// If permission is granted by executing [initialize], returns `true`.
  ///
  /// [initialize]を実行してパーミッションが許可されている場合は`true`を返します。
  bool get permitted => _permissionStatus == PermissionStatus.granted;
  PermissionStatus _permissionStatus = PermissionStatus.denied;

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
    if (initialized) {
      return;
    }
    if (_initializeCompleter != null) {
      return _initializeCompleter?.future;
    }
    _initializeCompleter = Completer<void>();
    try {
      _permissionStatus =
          await Permission.locationWhenInUse.status.timeout(timeout);
      if (_permissionStatus != PermissionStatus.granted) {
        _permissionStatus =
            await Permission.locationWhenInUse.request().timeout(timeout);
      }
      if (_permissionStatus != PermissionStatus.granted) {
        throw Exception(
          "You are not authorized to use the location information service. Check the permission settings.",
        );
      }
      _permissionStatus =
          await Permission.locationAlways.status.timeout(timeout);
      if (_permissionStatus != PermissionStatus.granted) {
        _permissionStatus =
            await Permission.locationAlways.request().timeout(timeout);
      }
      if (_permissionStatus != PermissionStatus.granted) {
        throw Exception(
          "You are not authorized to use the location information service. Check the permission settings.",
        );
      }
      _permissionStatus = await Permission.location.status.timeout(timeout);
      if (_permissionStatus != PermissionStatus.granted) {
        _permissionStatus =
            await Permission.location.request().timeout(timeout);
      }
      if (_permissionStatus != PermissionStatus.granted) {
        throw Exception(
          "You are not authorized to use the location information service. Check the permission settings.",
        );
      }
      await BackgroundLocator.initialize();
      _running = await BackgroundLocator.isServiceRunning();
      final sharedPreferences = await SharedPreferences.getInstance();
      _running = sharedPreferences.getBool(_kRunningKey.toSHA1()) ?? _running;
      if (_running) {
        if (UniversalPlatform.isAndroid) {
          _value =
              await _AndroidBackgroundLocationRepository.loadAsLatestLocation();
        } else {
          _value =
              await _IOSBackgroundLocationRepository.loadAsLatestLocation();
        }
      }
      _observer ??= _BackgroundLocationWidgetsBindingObserver(this);
      WidgetsBinding.instance.addObserver(_observer!);
      _timer?.cancel();
      _timer = Timer.periodic(
        adapter.defaultUpdateInterval,
        _handledOnUpdate,
      );
      _initialized = true;
      notifyListeners();
      if (_running) {
        await listen();
      }
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
    double? distanceFilterMeters,
    bool? stopOnTerminate,
    Duration timeout = const Duration(seconds: 60),
    FutureOr<void> Function(BackgroundLocation location)? onUpdate,
    FutureOr<void> Function(BackgroundLocation location)? onResume,
  }) async {
    if (_listenCompleter != null) {
      return _listenCompleter?.future;
    }
    _onUpdate = onUpdate;
    _onResume = onResume;
    _listenCompleter = Completer<void>();
    try {
      await initialize(timeout: timeout);
      _running = await BackgroundLocator.isServiceRunning();
      if (_running) {
        await BackgroundLocator.unRegisterLocationUpdate();
      }
      if (UniversalPlatform.isAndroid) {
        await BackgroundLocator.registerLocationUpdate(
          AndroidBackgroundLocationCallbackHandler.callback,
          initCallback: AndroidBackgroundLocationCallbackHandler.init,
          disposeCallback: AndroidBackgroundLocationCallbackHandler.dispose,
          androidSettings: AndroidSettings(
            accuracy: (accuracy ?? adapter.defaultAccuracy)
                .toLocatorLocationAccuracy(),
            interval: adapter.defaultUpdateInterval.inSeconds,
            distanceFilter:
                distanceFilterMeters ?? adapter.defaultDistanceFilterMeters,
            client: LocationClient.google,
            androidNotificationSettings: adapter.androidNotificationSettings
                .toAndroidNotificationSettings(
              onTap: AndroidBackgroundLocationCallbackHandler.notification,
            ),
          ),
        );
        _value =
            await _AndroidBackgroundLocationRepository.loadAsLatestLocation();
      } else {
        await BackgroundLocator.registerLocationUpdate(
          IOSBackgroundLocationCallbackHandler.callback,
          initCallback: IOSBackgroundLocationCallbackHandler.init,
          disposeCallback: IOSBackgroundLocationCallbackHandler.dispose,
          iosSettings: IOSSettings(
            accuracy: (accuracy ?? adapter.defaultAccuracy)
                .toLocatorLocationAccuracy(),
            distanceFilter:
                distanceFilterMeters ?? adapter.defaultDistanceFilterMeters,
            stopWithTerminate: stopOnTerminate ?? adapter.stopOnTerminate,
          ),
          androidSettings: AndroidSettings(
            accuracy: (accuracy ?? adapter.defaultAccuracy)
                .toLocatorLocationAccuracy(),
            interval: adapter.defaultUpdateInterval.inSeconds,
            distanceFilter:
                distanceFilterMeters ?? adapter.defaultDistanceFilterMeters,
            client: LocationClient.google,
            androidNotificationSettings: adapter.androidNotificationSettings
                .toAndroidNotificationSettings(
              onTap: IOSBackgroundLocationCallbackHandler.notification,
            ),
          ),
        );
        _value = await _IOSBackgroundLocationRepository.loadAsLatestLocation();
      }
      final sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setBool(_kRunningKey.toSHA1(), true);
      _running = await BackgroundLocator.isServiceRunning();
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

  Future<void> _handledOnUpdate(Timer timer) async {
    if (!_running) {
      return;
    }
    final value = UniversalPlatform.isAndroid
        ? await _AndroidBackgroundLocationRepository.loadAsLatestLocation()
        : await _IOSBackgroundLocationRepository.loadAsLatestLocation();
    if (value != _value) {
      _value = value;
      await wait([
        adapter.onUpdate?.call(this),
        _onUpdate?.call(this),
      ]);
      notifyListeners();
    }
  }

  /// Cancel acquisition of [LocationData].
  ///
  /// [LocationData]の取得をキャンセルします。
  Future<void> unlisten() async {
    await BackgroundLocator.unRegisterLocationUpdate();
    await clear();
    _running = await BackgroundLocator.isServiceRunning();
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool(_kRunningKey.toSHA1(), false);
    notifyListeners();
  }

  @override
  void dispose() {
    unlisten();
    _timer?.cancel();
    _timer = null;
    WidgetsBinding.instance.removeObserver(_observer!);
    super.dispose();
  }
}

@immutable
class _$BackgroundLocationQuery {
  const _$BackgroundLocationQuery();

  @useResult
  _$_BackgroundLocationQuery call() => _$_BackgroundLocationQuery(
        hashCode.toString(),
      );
}

@immutable
class _$_BackgroundLocationQuery
    extends ControllerQueryBase<BackgroundLocation> {
  const _$_BackgroundLocationQuery(
    this._name,
  );

  final String _name;

  @override
  BackgroundLocation Function() call(Ref ref) {
    return () => BackgroundLocation();
  }

  @override
  String get queryName => _name;
  @override
  bool get autoDisposeWhenUnreferenced => false;
}

extension on LocationDto {
  LocationData toLocationData([DateTime? time]) {
    return LocationData(
      latitude: latitude,
      longitude: longitude,
      accuracy: accuracy,
      altitude: altitude,
      speed: speed,
      speedAccuracy: speedAccuracy,
      heading: heading,
      timestamp: time ?? DateTime.now(),
    );
  }
}

extension on BackgroundLocationAndroidNotificationSettings {
  AndroidNotificationSettings toAndroidNotificationSettings(
      {VoidCallback? onTap}) {
    return AndroidNotificationSettings(
      notificationChannelName: channelName,
      notificationTitle: title,
      notificationMsg: message,
      notificationBigMsg: longMessage,
      notificationIcon: icon,
      notificationIconColor: iconColor,
      notificationTapCallback: onTap,
    );
  }
}

extension on LocationAccuracy {
  locator_settings.LocationAccuracy toLocatorLocationAccuracy() {
    switch (this) {
      case LocationAccuracy.lowest:
        return locator_settings.LocationAccuracy.POWERSAVE;
      case LocationAccuracy.low:
        return locator_settings.LocationAccuracy.LOW;
      case LocationAccuracy.medium:
        return locator_settings.LocationAccuracy.BALANCED;
      case LocationAccuracy.high:
        return locator_settings.LocationAccuracy.HIGH;
      case LocationAccuracy.best:
        return locator_settings.LocationAccuracy.NAVIGATION;
      case LocationAccuracy.navigation:
        return locator_settings.LocationAccuracy.NAVIGATION;
      default:
        return locator_settings.LocationAccuracy.POWERSAVE;
    }
  }
}

/// Class for asynchronously retrieving values returned from [BackgroundLocation.history].
///
/// Location history can be obtained from [value].
///
/// [BackgroundLocation.history]から返される値を非同期で取得するためのクラスです。
///
/// [value]から位置情報の履歴を取得できます。
class AsyncHistoryValue extends ChangeNotifier
    implements ValueListenable<List<LocationData>?> {
  AsyncHistoryValue._(Future<List<LocationData>?> future) {
    _completer = Completer<void>();
    future.then((value) {
      _value = value;
      notifyListeners();
      _completer?.complete();
      _completer = null;
    });
  }

  Future<void>? get future => _completer?.future;
  Completer<void>? _completer;

  @override
  List<LocationData>? get value => _value;
  List<LocationData>? _value;
}

class _BackgroundLocationWidgetsBindingObserver extends WidgetsBindingObserver {
  _BackgroundLocationWidgetsBindingObserver(this.backgroundLocation);

  final BackgroundLocation backgroundLocation;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        backgroundLocation.adapter.onResume?.call(backgroundLocation);
        backgroundLocation._onResume?.call(backgroundLocation);
        break;
      default:
        break;
    }
  }
}
