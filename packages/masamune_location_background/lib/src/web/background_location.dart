part of masamune_location_background.web;

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
  bool get initialized => false;

  @override
  LocationData? get value => _value;
  LocationData? _value;

  /// Get a list of all currently recorded location logs.
  ///
  /// 現在記録されているすべての位置情報ログの一覧を取得します。
  AsyncHistoryValue history() {
    return AsyncHistoryValue._(
      Future.value([]),
    );
  }

  /// Delete history.
  ///
  /// 履歴を削除します。
  Future<void> clear() => Future.value();

  /// Returns `true` if [listen] has already been executed.
  ///
  /// すでに[listen]が実行されている場合`true`を返します。
  bool get listening => false;

  /// If permission is granted by executing [initialize], returns `true`.
  ///
  /// [initialize]を実行してパーミッションが許可されている場合は`true`を返します。
  bool get permitted => false;

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
    throw UnsupportedError("This platform is not supported.");
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
    throw UnsupportedError("This platform is not supported.");
  }

  /// Cancel acquisition of [LocationData].
  ///
  /// [LocationData]の取得をキャンセルします。
  Future<void> unlisten() async {
    throw UnsupportedError("This platform is not supported.");
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
