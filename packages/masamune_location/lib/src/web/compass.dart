part of masamune_location.web;

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
  /// appRef.conroller(Compass.query(parameters));   // Get from application scope.
  /// ref.app.conroller(Compass.query(parameters));  // Watch at application scope.
  /// ref.page.conroller(Compass.query(parameters)); // Watch at page scope.
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
  Completer<void>? _completer;

  /// Returns `true` if [listen] has already been executed.
  ///
  /// すでに[listen]が実行されている場合`true`を返します。
  bool get listening => false;

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
    if (initialized) {
      return;
    }
    if (_completer != null) {
      return _completer?.future;
    }
    _completer = Completer<void>();
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
      debugPrint("Compass data is not retrieved on the web.");
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
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    unlisten();
    super.dispose();
  }
}

/// Data obtained from the terminal's compass.
///
/// 端末のコンパスから取得されたデータ。
@immutable
class CompassData {
  /// Data obtained from the terminal's compass.
  ///
  /// 端末のコンパスから取得されたデータ。
  const CompassData({
    required this.heading,
    required this.headingForCameraMode,
    required this.accuracy,
  });

  /// The heading, in degrees, of the device around its Z axis, or where the top of the device is pointing.
  ///
  /// Z軸を中心としたデバイスの進行方向 (度単位)、またはデバイスの上部が指している方向。
  final double? heading;

  /// The heading, in degrees, of the device around its X axis, or where the back of the device is pointing.
  ///
  /// X 軸を中心としたデバイスの進行方向 (度単位)、またはデバイスの背面が指している方向。
  final double? headingForCameraMode;

  /// The deviation error, in degrees, plus or minus from the heading.
  /// NOTE: for iOS this is computed by the platform and is reliable. For Android several values are hard-coded, and the true error could be more . or less than the value here.
  ///
  /// 機首方位からの偏差誤差 (度単位)。
  ///
  /// 注: iOS の場合、これはプラットフォームによって計算され、信頼性があります。 Android の場合、いくつかの値はハードコーディングされており、実際のエラーはさらに多くの値になる可能性があります。ここの値以下です。
  final double? accuracy;

  @override
  String toString() {
    return 'heading: $heading\nheadingForCameraMode: $headingForCameraMode\naccuracy: $accuracy';
  }

  @override
  int get hashCode =>
      heading.hashCode ^ headingForCameraMode.hashCode ^ accuracy.hashCode;

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;
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
  Compass Function() call(Ref ref) {
    return () => Compass();
  }

  @override
  String get name => _name;
  @override
  bool get autoDisposeWhenUnreferenced => false;
}
