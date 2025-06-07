part of "others.dart";

/// Class that handles the compass of the terminal.
///
/// The acquisition is initiated by doing [listen].
///
/// It monitors the data at each interval and calls [notifyListeners] if it has been updated.
///
/// [CompassData] is stored in [value], so refer to it.
///
/// Terminate acquisition with [unlisten].
///
/// 端末のコンパスを取り扱うクラス。
///
/// [listen]を行うことで取得を開始します。
///
/// インターバルごとにデータを監視し更新されていれば[notifyListeners]を呼び出します。
///
/// [value]に[CompassData]が格納されるのでそこを参照してください。
///
/// [unlisten]で取得を終了します。
class Compass
    extends MasamuneControllerBase<CompassData?, LocationMasamuneAdapter> {
  /// Class that handles the compass of the terminal.
  ///
  /// The acquisition is initiated by doing [listen].
  ///
  /// It monitors the data at each interval and calls [notifyListeners] if it has been updated.
  ///
  /// [CompassData] is stored in [value], so refer to it.
  ///
  /// Terminate acquisition with [unlisten].
  ///
  /// 端末のコンパスを取り扱うクラス。
  ///
  /// [listen]を行うことで取得を開始します。
  ///
  /// インターバルごとにデータを監視し更新されていれば[notifyListeners]を呼び出します。
  ///
  /// [value]に[CompassData]が格納されるのでそこを参照してください。
  ///
  /// [unlisten]で取得を終了します。
  Compass({super.adapter});

  /// Query for Compass.
  ///
  /// ```dart
  /// appRef.controller(Compass.query(parameters));     // Get from application scope.
  /// ref.app.controller(Compass.query(parameters));    // Watch at application scope.
  /// ref.page.controller(Compass.query(parameters));   // Watch at page scope.
  /// ```
  static const query = _$CompassQuery();

  @override
  LocationMasamuneAdapter get primaryAdapter => LocationMasamuneAdapter.primary;

  /// Returns `true` if initialized by executing [initialize].
  ///
  /// [initialize]を実行して初期化されている場合は`true`を返します。
  bool get initialized => _initialized;
  bool _initialized = false;

  @override
  CompassData? get value => _value;
  CompassData? _value;

  Timer? _timer;
  Duration _updateInterval = const Duration(minutes: 1);
  bool _updated = false;
  Completer<void>? _completer;
  // ignore: cancel_subscriptions
  StreamSubscription<CompassEvent>? _compassEventSubscription;

  /// Returns `true` if [listen] has already been executed.
  ///
  /// すでに[listen]が実行されている場合`true`を返します。
  bool get listening {
    if (!permitted) {
      return false;
    }
    if (_compassEventSubscription == null) {
      return false;
    }
    return true;
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
    if (_completer != null) {
      return _completer?.future;
    }
    _completer = Completer<void>();
    try {
      if (!await location.Geolocator.isLocationServiceEnabled()
          .timeout(timeout)) {
        throw Exception(
          "Location service not available. The platform may not be supported or it may be disabled in the settings. please confirm.",
        );
      }
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

  /// Starts acquiring compass data.
  ///
  /// The update interval can be specified by specifying [updateInterval].
  ///
  /// [CompassData] is stored in [value], so refer to it.
  ///
  /// コンパスデータの取得を開始します。
  ///
  /// [updateInterval]を指定することで更新間隔を指定できます。
  ///
  /// [value]に[CompassData]が格納されるのでそこを参照してください。
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
      _compassEventSubscription = FlutterCompass.events?.listen((compass) {
        _updated = true;
        _value = CompassData(
          heading: compass.heading,
          headingForCameraMode: compass.headingForCameraMode,
          accuracy: compass.accuracy,
        );
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

  /// Cancel acquisition of [CompassData].
  ///
  /// [CompassData]の取得をキャンセルします。
  void unlisten() {
    if (!listening) {
      return;
    }
    _updated = false;
    _timer?.cancel();
    _timer = null;
    _compassEventSubscription?.cancel();
    _compassEventSubscription = null;
  }

  @override
  void dispose() {
    unlisten();
    super.dispose();
  }
}

@immutable
class _$CompassQuery {
  const _$CompassQuery();

  @useResult
  _$_CompassQuery call() => _$_CompassQuery(
        hashCode.toString(),
      );
}

@immutable
class _$_CompassQuery extends ControllerQueryBase<Compass> {
  const _$_CompassQuery(
    this._name,
  );

  final String _name;

  @override
  Compass Function() call(Ref ref) => Compass.new;

  @override
  String get queryName => _name;
  @override
  bool get autoDisposeWhenUnreferenced => false;
}
