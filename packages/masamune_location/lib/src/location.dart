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
class Location extends ChangeNotifier
    implements ValueListenable<LocationData?> {
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
  Location();

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
  Completer<void>? _completer;
  // ignore: cancel_subscriptions
  StreamSubscription<LocationData>? _locationEventSubscription;
  final location.Location _location = location.Location();

  /// Returns `true` if [listen] has already been executed.
  ///
  /// すでに[listen]が実行されている場合`true`を返します。
  bool get listening {
    if (!permitted) {
      return false;
    }
    if (_locationEventSubscription == null) {
      return false;
    }
    return true;
  }

  /// If permission is granted by executing [initialize], returns `true`.
  ///
  /// [initialize]を実行してパーミッションが許可されている場合は`true`を返します。
  bool get permitted => _permissionStatus == location.PermissionStatus.granted;
  location.PermissionStatus _permissionStatus =
      location.PermissionStatus.denied;

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
    if (_completer != null) {
      return _completer?.future;
    }
    _completer = Completer<void>();
    try {
      if (!await _location.serviceEnabled().timeout(timeout)) {
        if (!await _location.requestService().timeout(timeout)) {
          throw Exception(
            "Location service not available. The platform may not be supported or it may be disabled in the settings. please confirm.",
          );
        }
      }
      _permissionStatus = await _location.hasPermission().timeout(timeout);
      if (_permissionStatus == location.PermissionStatus.denied) {
        _permissionStatus =
            await _location.requestPermission().timeout(timeout);
      }
      if (_permissionStatus != location.PermissionStatus.granted) {
        throw Exception(
          "You are not authorized to use the location information service. Check the permission settings.",
        );
      }
      _initialized = true;
      notifyListeners();
      _completer?.complete();
      _completer = null;
    } catch (e) {
      _completer?.completeError(e);
      _completer = null;
      rethrow;
    } finally {
      _completer?.complete();
      _completer = null;
    }
  }

  /// Starts acquiring location information.
  ///
  /// The update interval can be specified by specifying [updateInterval].
  ///
  /// [LocationData] is stored in [value], so refer to it.
  ///
  /// 位置情報の取得を開始します。
  ///
  /// [updateInterval]を指定することで更新間隔を指定できます。
  ///
  /// [value]に[LocationData]が格納されるのでそこを参照してください。
  Future<void> listen({
    Duration updateInterval = const Duration(minutes: 1),
    Duration timeout = const Duration(seconds: 60),
  }) async {
    if (_completer != null) {
      return _completer?.future;
    }
    if (_updateInterval == updateInterval && listening) {
      return;
    }
    _completer = Completer<void>();
    _updateInterval = updateInterval;
    try {
      await initialize(timeout: timeout);
      _value = await _location.getLocation().timeout(timeout);
      _locationEventSubscription?.cancel();
      _locationEventSubscription = _location.onLocationChanged.listen(
        (locationData) {
          _updated = true;
          _value = locationData;
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
      _completer?.complete();
      _completer = null;
    } catch (e) {
      _completer?.completeError(e);
      _completer = null;
      rethrow;
    } finally {
      _completer?.complete();
      _completer = null;
    }
  }

  /// Cancel acquisition of [LocationData].
  ///
  /// [LocationData]の取得をキャンセルします。
  void unlisten() {
    _updated = false;
    _timer?.cancel();
    _timer = null;
    _locationEventSubscription?.cancel();
    _locationEventSubscription = null;
  }

  @override
  void dispose() {
    unlisten();
    super.dispose();
  }
}
