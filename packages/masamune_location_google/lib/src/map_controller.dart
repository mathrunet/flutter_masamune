part of '/masamune_location_google.dart';

/// Map controller to handle GoogleMap.
///
/// [MapController.query] allows you to retrieve objects from `ref.app.controller` and others while preserving their state.
///
/// [initialize] to initialize and set permissions.
///
/// The [location] and [compass] objects are contained within the [location] and [compass] objects, allowing control of the map while acquiring location and compass information.
///
/// You can use [position] and [zoom] to obtain the currently displayed position and zoom.
///
/// The map display position can be changed manually with [move] and automatically updated based on the information obtained from the location information with [track].
///
/// The zoom can be changed with [zoomIn], [zoomOut], and [zoomTo].
///
/// Markers, polygons, polylines, and circles can be set with [setMarker], [setCircle], [setPolygon], and [setPolyline].
///
/// GoogleMapを扱うためのマップコントローラー。
///
/// [MapController.query]で`ref.app.controller`などから状態を保持しながらオブジェクトの取得ができます。
///
/// [initialize]で初期化を行いパーミッションの設定を行います。
///
/// [location]や[compass]に[Location]や[Compass]のオブジェクトを内包しており位置情報やコンパスの情報を取得しながらマップのコントロールが可能です。
///
/// [position]や[zoom]で現在表示している位置やズームを取得できます。
///
/// [move]で手動でのマップの表示位置の変更、[track]で位置情報から取得した情報を元に自動でマップの表示位置を更新します。
///
/// [zoomIn]、[zoomOut]、[zoomTo]でズームを変更できます。
///
/// [setMarker]、[setCircle]、[setPolygon]、[setPolyline]でマーカーやポリゴン、ポリライン、サークルを設定できます。
class MapController
    extends MasamuneControllerBase<void, GoogleLocationMasamuneAdapter> {
  /// Map controller to handle GoogleMap.
  ///
  /// [MapController.query] allows you to retrieve objects from `ref.app.controller` and others while preserving their state.
  ///
  /// [initialize] to initialize and set permissions.
  ///
  /// The [location] and [compass] objects are contained within the [location] and [compass] objects, allowing control of the map while acquiring location and compass information.
  ///
  /// You can use [position] and [zoom] to obtain the currently displayed position and zoom.
  ///
  /// The map display position can be changed manually with [move] and automatically updated based on the information obtained from the location information with [track].
  ///
  /// The zoom can be changed with [zoomIn], [zoomOut], and [zoomTo].
  ///
  /// Markers, polygons, polylines, and circles can be set with [setMarker], [setCircle], [setPolygon], and [setPolyline].
  ///
  /// GoogleMapを扱うためのマップコントローラー。
  ///
  /// [MapController.query]で`ref.app.controller`などから状態を保持しながらオブジェクトの取得ができます。
  ///
  /// [initialize]で初期化を行いパーミッションの設定を行います。
  ///
  /// [location]や[compass]に[Location]や[Compass]のオブジェクトを内包しており位置情報やコンパスの情報を取得しながらマップのコントロールが可能です。
  ///
  /// [position]や[zoom]で現在表示している位置やズームを取得できます。
  ///
  /// [move]で手動でのマップの表示位置の変更、[track]で位置情報から取得した情報を元に自動でマップの表示位置を更新します。
  ///
  /// [zoomIn]、[zoomOut]、[zoomTo]でズームを変更できます。
  ///
  /// [setMarker]、[setCircle]、[setPolygon]、[setPolyline]でマーカーやポリゴン、ポリライン、サークルを設定できます。
  MapController({super.adapter, Location? location, Compass? compass})
      : _location = location,
        _compass = compass {
    this.location.addListener(notifyListeners);
    this.compass.addListener(notifyListeners);
  }

  /// Query for MapController.
  ///
  /// ```dart
  /// appRef.controller(MapController.query(parameters));     // Get from application scope.
  /// ref.app.controller(MapController.query(parameters));    // Watch at application scope.
  /// ref.page.controller(MapController.query(parameters));   // Watch at page scope.
  /// ```
  static const query = _$MapControllerQuery();

  @override
  GoogleLocationMasamuneAdapter get primaryAdapter =>
      GoogleLocationMasamuneAdapter.primary;

  Completer<void>? _completer;

  /// Manage location information.
  ///
  /// 位置情報の管理を行います。
  Location get location {
    if (_location != null) {
      return _location!;
    }
    return _location ??= Location();
  }

  Location? _location;

  /// Compass management.
  ///
  /// コンパスの管理を行います。
  Compass get compass {
    if (_compass != null) {
      return _compass!;
    }
    return _compass ??= Compass();
  }

  Compass? _compass;

  /// Obtains the current display position.
  ///
  /// 現在の表示位置を取得します。
  LatLng get position => _position;
  // ignore: prefer_final_fields
  LatLng _position = const LatLng(0, 0);

  /// Displays the current zoom level.
  ///
  /// 現在のズームレベルを表示します。
  double get zoom => _zoom;
  double _zoom = 0.0;

  /// Returns `true` if [initialize] is complete.
  ///
  /// [initialize]が完了している場合`true`を返します。
  bool get initialized => _initialized;
  bool _initialized = false;

  /// Returns `true` if tracking is currently started.
  ///
  /// 現在トラッキングを開始している場合`true`を返します。
  bool get tracking => _tracking;
  bool _tracking = false;

  /// List of markers set on the map.
  ///
  /// マップにセットされたマーカーの一覧。
  Set<Marker> get markers => _markers;
  Set<Marker> _markers = {};

  /// List of polygons set on the map.
  ///
  /// マップにセットされたポリゴンの一覧。
  Set<Polygon> get polygons => _polygons;
  Set<Polygon> _polygons = {};

  /// List of polylines set in the map.
  ///
  /// マップにセットされたポリラインの一覧。
  Set<Polyline> get polylines => _polylines;
  Set<Polyline> _polylines = {};

  /// List of circles set on the map.
  ///
  /// マップにセットされたサークルの一覧。
  Set<Circle> get circles => _circles;
  Set<Circle> _circles = {};

  /// List of tile overlays on the map.
  ///
  /// マップ上のタイルオーバーレイの一覧。
  Set<TileOverlay> get tileOverlays => _tileOverlays;
  Set<TileOverlay> _tileOverlays = {};

  /// GoogleMapController] set to this controller.
  ///
  /// [MapController] is automatically set by passing it to [MapView].
  ///
  /// このコントローラーにセットされた[GoogleMapController]。
  ///
  /// [MapView]に[MapController]をわたすことで自動でセットされます。
  GoogleMapController get controller => _controller!;
  GoogleMapController? _controller;

  /// Initialize [MapController].
  ///
  /// Processes to obtain the necessary permissions to acquire location information.
  ///
  /// [MapController]の初期化を行います。
  ///
  /// 位置情報取得に必要な許可を取得する処理を行います。
  Future<void> initialize() async {
    if (initialized) {
      return;
    }
    if (_completer != null) {
      return _completer?.future;
    }
    _completer = Completer<void>();
    try {
      await location.initialize();
      await compass.initialize();
      _initialized = true;
      notifyListeners();
      _completer?.complete();
      _completer = null;
    } catch (e) {
      _completer?.completeError(e);
      _completer = null;
    } finally {
      _completer?.complete();
      _completer = null;
    }
  }

  @override
  void dispose() {
    super.dispose();
    location.removeListener(notifyListeners);
    compass.removeListener(notifyListeners);
    controller.dispose();
  }

  void _setGoogleMapController(GoogleMapController controller) {
    _controller = controller;
  }

  /// The location information is acquired and the display position of the map is automatically updated.
  ///
  /// The update interval depends on how often [location] is updated.
  ///
  /// If you want to stop, execute [untrack].
  ///
  /// 位置情報を取得し自動でマップの表示位置を更新します。
  ///
  /// [location]のアップデートの頻度によって更新間隔が変わります。
  ///
  /// 停止したい場合は[untrack]を実行してください。
  Future<void> track() async {
    if (_tracking) {
      return;
    }
    _tracking = true;
    await initialize();
    location.addListener(_handledOnUpdate);
    location.listen();
    notifyListeners();
  }

  /// Stops acquiring location information that has been [track].
  ///
  /// [track]した位置情報の取得を停止します。
  void untrack() {
    if (!_tracking) {
      return;
    }
    _tracking = false;
    location.unlisten();
    location.removeListener(_handledOnUpdate);
    notifyListeners();
  }

  void _handledOnUpdate() {
    if (location.value?.latitude == null || location.value?.longitude == null) {
      return;
    }
    _move(
      latitude: location.value!.latitude,
      longitude: location.value!.longitude,
      animated: false,
    );
  }

  /// By passing [latitude] and [longitude], the display is manually updated to that position.
  ///
  /// ZOOM] can also be specified.
  ///
  /// If [animated] is set to `true`, it will animate when the position is moved.
  ///
  /// [latitude]と[longitude]を渡すことでその位置に手動で表示を更新します。
  ///
  /// 合わせて[zoom]も指定可能です。
  ///
  /// [animated]を`true`にすると位置の移動時にアニメーションします。
  Future<void> move({
    required double latitude,
    required double longitude,
    double? zoom,
    bool animated = true,
  }) async {
    untrack();
    _move(
      latitude: latitude,
      longitude: longitude,
      zoom: zoom,
      animated: animated,
    );
  }

  Future<void> _move({
    required double latitude,
    required double longitude,
    double? zoom,
    bool animated = true,
  }) async {
    await initialize();
    if (animated) {
      if (zoom != null) {
        await _controller?.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(latitude, longitude),
            zoom,
          ),
        );
      } else {
        await _controller?.animateCamera(
          CameraUpdate.newLatLng(LatLng(latitude, longitude)),
        );
      }
    } else {
      if (zoom != null) {
        await _controller?.moveCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(latitude, longitude),
            zoom,
          ),
        );
      } else {
        await _controller?.moveCamera(
          CameraUpdate.newLatLng(
            LatLng(latitude, longitude),
          ),
        );
      }
    }
    notifyListeners();
  }

  /// Zoom in on the current position.
  ///
  /// If [animated] is set to `true`, it will animate when moving.
  ///
  /// 現在の位置をズームインします。
  ///
  /// [animated]を`true`にすると移動時にアニメーションします。
  Future<void> zoomIn({
    bool animated = true,
  }) async {
    await initialize();
    if (animated) {
      await _controller?.animateCamera(
        CameraUpdate.zoomIn(),
      );
    } else {
      await _controller?.moveCamera(
        CameraUpdate.zoomIn(),
      );
    }
    if (_controller != null) {
      _zoom = await _controller!.getZoomLevel();
    }
    notifyListeners();
  }

  /// Zooms out to the current position.
  ///
  /// If [animated] is set to `true`, it will animate when moving.
  ///
  /// 現在の位置をズームアウトします。
  ///
  /// [animated]を`true`にすると移動時にアニメーションします。
  Future<void> zoomOut({
    bool animated = true,
  }) async {
    await initialize();
    if (animated) {
      await _controller?.animateCamera(
        CameraUpdate.zoomOut(),
      );
    } else {
      await _controller?.moveCamera(
        CameraUpdate.zoomOut(),
      );
    }
    if (_controller != null) {
      _zoom = await _controller!.getZoomLevel();
    }
    notifyListeners();
  }

  /// Sets the current zoom level to [zoom].
  ///
  /// If [animated] is set to `true`, it will animate when moving.
  ///
  /// 現在のズームレベルを[zoom]に設定します。
  ///
  /// [animated]を`true`にすると移動時にアニメーションします。
  Future<void> zoomTo({
    required double zoom,
    bool animated = true,
  }) async {
    await initialize();
    if (animated) {
      await _controller?.animateCamera(
        CameraUpdate.zoomTo(zoom),
      );
    } else {
      await _controller?.moveCamera(
        CameraUpdate.zoomTo(zoom),
      );
    }
    if (_controller != null) {
      _zoom = await _controller!.getZoomLevel();
    }
    notifyListeners();
  }

  /// Set a new [marker].
  ///
  /// If [Marker.markerId] is the same, it will be replaced.
  ///
  /// [marker]を新しくセットします。
  ///
  /// [Marker.markerId]が同じ場合は置き換えられます。
  void setMarker(Marker marker) {
    removeMarker(marker);
    _markers = {..._markers, marker};
    notifyListeners();
  }

  /// Deletes a marker with the same [Marker.markerId] as the given [marker].
  ///
  /// 与えられた[marker]と同じ[Marker.markerId]を持つマーカーを削除します。
  void removeMarker(Marker marker) {
    _markers = Set<Marker>.from(markers);
    _markers.removeWhere(
      (element) => element.markerId.value == marker.markerId.value,
    );
  }

  /// Set a new [polygon].
  ///
  /// If [Polygon.polygonId] is the same, it will be replaced.
  ///
  /// [polygon]を新しくセットします。
  ///
  /// [Polygon.polygonId]が同じ場合は置き換えられます。
  void setPolygon(Polygon polygon) {
    removePolygon(polygon);
    _polygons = {..._polygons, polygon};
    notifyListeners();
  }

  /// Deletes a polygon with the same [Polygon.polygonId] as the given [polygon].
  ///
  /// 与えられた[polygon]と同じ[Polygon.polygonId]を持つポリゴンを削除します。
  void removePolygon(Polygon polygon) {
    _polygons = Set<Polygon>.from(polygons);
    _polygons.removeWhere(
      (element) => element.polygonId.value == polygon.polygonId.value,
    );
  }

  /// Set a new [polyline].
  ///
  /// If [Polyline.polylineId] is the same, it will be replaced.
  ///
  /// [polyline]を新しくセットします。
  ///
  /// [Polyline.polylineId]が同じ場合は置き換えられます。
  void setPolyline(Polyline polyline) {
    removePolyline(polyline);
    _polylines = {..._polylines, polyline};
    notifyListeners();
  }

  /// Deletes a polyline with the same [Polyline.polylineId] as the given [polyline].
  ///
  /// 与えられた[polyline]と同じ[Polyline.polylineId]を持つポリラインを削除します。
  void removePolyline(Polyline polyline) {
    _polylines = Set<Polyline>.from(polylines);
    _polylines.removeWhere(
      (element) => element.polylineId.value == polyline.polylineId.value,
    );
  }

  /// Set a new [circle].
  ///
  /// If [Circle.circleId] is the same, it will be replaced.
  ///
  /// [circle]を新しくセットします。
  ///
  /// [Circle.circleId]が同じ場合は置き換えられます。
  void setCircle(Circle circle) {
    removeCircle(circle);
    _circles = {..._circles, circle};
    notifyListeners();
  }

  /// Deletes a circle with the same [Circle.circleId] as the given [circle].
  ///
  /// 与えられた[circle]と同じ[Circle.circleId]を持つサークルを削除します。
  void removeCircle(Circle circle) {
    _circles = Set<Circle>.from(circles);
    _circles.removeWhere(
      (element) => element.circleId.value == circle.circleId.value,
    );
  }

  /// Set a new [tileOverlay].
  ///
  /// If [TileOverlay.tileOverlayId] is the same, it will be replaced.
  ///
  /// [tileOverlay]を新しくセットします。
  ///
  /// [TileOverlay.tileOverlayId]が同じ場合は置き換えられます。
  void setTileOverlay(TileOverlay tileOverlay) {
    removeTileOverlay(tileOverlay);
    _tileOverlays = {..._tileOverlays, tileOverlay};
    notifyListeners();
  }

  /// Deletes a tile overlay with the same [TileOverlay.tileOverlayId] as the given [tileOverlay].
  ///
  /// 与えられた[tileOverlay]と同じ[TileOverlay.tileOverlayId]を持つタイルオーバーレイを削除します。
  void removeTileOverlay(TileOverlay tileOverlay) {
    _tileOverlays = Set<TileOverlay>.from(tileOverlays);
    _tileOverlays.removeWhere(
      (element) =>
          element.tileOverlayId.value == tileOverlay.tileOverlayId.value,
    );
  }

  /// Take a snapshot of the map.
  ///
  /// マップのスナップショットを取得します。
  Future<Uint8List?> takeSnapshot() async {
    await initialize();
    return await _controller?.takeSnapshot();
  }
}

@immutable
class _$MapControllerQuery {
  const _$MapControllerQuery();

  @useResult
  _$_MapControllerQuery call({
    GoogleLocationMasamuneAdapter? adapter,
    Location? location,
    Compass? compass,
  }) =>
      _$_MapControllerQuery(
        hashCode.toString(),
        adapter: adapter,
        location: location,
        compass: compass,
      );
}

@immutable
class _$_MapControllerQuery extends ControllerQueryBase<MapController> {
  const _$_MapControllerQuery(
    this._name, {
    this.adapter,
    this.location,
    this.compass,
  });

  final String _name;

  final GoogleLocationMasamuneAdapter? adapter;

  final Location? location;

  final Compass? compass;

  @override
  MapController Function() call(Ref ref) {
    return () => MapController(
          adapter: adapter,
          location: location,
          compass: compass,
        );
  }

  @override
  String get queryName => "$_name$location$compass";
  @override
  bool get autoDisposeWhenUnreferenced => false;
}
