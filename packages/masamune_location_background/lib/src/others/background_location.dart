part of masamune_location_background.others;

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
    return AsyncHistoryValue._(
      _BackgroundLocationRepository.loadAsLocations(),
    );
  }

  static const String _isolateName = "BackgroundLocationIsolate";

  Timer? _timer;
  ReceivePort port = ReceivePort();
  Duration _updateInterval = const Duration(minutes: 1);
  bool _updated = false;
  bool _running = false;
  Completer<void>? _listenCompleter;
  Completer<void>? _initializeCompleter;
  StreamSubscription? _subscription;

  /// Returns `true` if [listen] has already been executed.
  ///
  /// すでに[listen]が実行されている場合`true`を返します。
  bool get listening {
    if (!permitted) {
      return false;
    }
    if (_subscription == null) {
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
      if (IsolateNameServer.lookupPortByName(_isolateName) != null) {
        IsolateNameServer.removePortNameMapping(_isolateName);
      }
      IsolateNameServer.registerPortWithName(port.sendPort, _isolateName);
      _subscription ??= port.listen(
        _handledOnUpdate,
        onError: (e, stacktrace) {
          debugPrint(e.toString());
          debugPrint(stacktrace.toString());
          dispose();
        },
        cancelOnError: true,
      );
      await BackgroundLocator.initialize();
      _running = await BackgroundLocator.isServiceRunning();
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
    double? distanceFilterMeters,
    bool? stopOnTerminate,
    Duration updateInterval = const Duration(seconds: 60),
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
      _running = await BackgroundLocator.isServiceRunning();
      if (!_running) {
        await BackgroundLocator.registerLocationUpdate(
          BackgroundLocationCallbackHandler.callback,
          initCallback: BackgroundLocationCallbackHandler.init,
          disposeCallback: BackgroundLocationCallbackHandler.dispose,
          iosSettings: IOSSettings(
            accuracy: (accuracy ??
                    BackgroundLocationMasamuneAdapter.primary.defaultAccuracy)
                .toLocatorLocationAccuracy(),
            distanceFilter: distanceFilterMeters ??
                BackgroundLocationMasamuneAdapter
                    .primary.defaultDistanceFilterMeters,
            stopWithTerminate: stopOnTerminate ??
                BackgroundLocationMasamuneAdapter.primary.stopOnTerminate,
          ),
          androidSettings: AndroidSettings(
            accuracy: (accuracy ??
                    BackgroundLocationMasamuneAdapter.primary.defaultAccuracy)
                .toLocatorLocationAccuracy(),
            interval: updateInterval.inSeconds,
            distanceFilter: distanceFilterMeters ??
                BackgroundLocationMasamuneAdapter
                    .primary.defaultDistanceFilterMeters,
            client: LocationClient.google,
            androidNotificationSettings: BackgroundLocationMasamuneAdapter
                .primary.androidNotificationSettings
                .toAndroidNotificationSettings(
              onTap: BackgroundLocationCallbackHandler.notification,
            ),
          ),
        );
      }
      _value = await _BackgroundLocationRepository.loadAsLatestLocation();
      _updated = false;
      _timer?.cancel();
      _timer = Timer.periodic(_updateInterval, (timer) {
        if (!_updated) {
          return;
        }
        _updated = false;
        notifyListeners();
      });
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

  /// Cancel acquisition of [LocationData].
  ///
  /// [LocationData]の取得をキャンセルします。
  Future<void> unlisten() async {
    _updated = false;
    _running = false;
    _timer?.cancel();
    _timer = null;
    _subscription?.cancel();
    _subscription = null;
    await BackgroundLocator.unRegisterLocationUpdate();
    await _BackgroundLocationRepository.clear();
  }

  void _handledOnUpdate(dynamic data) async {
    try {
      final value = await _BackgroundLocationRepository.loadAsLatestLocation();
      if (_value != value) {
        _value = value;
        _updated = true;
      }
    } catch (e, stacktrace) {
      debugPrint(e.toString());
      debugPrint(stacktrace.toString());
    }
  }

  @override
  void dispose() {
    unlisten();
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
    future.then((value) {
      _value = value;
      notifyListeners();
    });
  }

  @override
  List<LocationData>? get value => _value;
  List<LocationData>? _value;
}
