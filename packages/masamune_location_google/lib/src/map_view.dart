part of "/masamune_location_google.dart";

/// A widget that displays a map.
///
/// Pass [controller] for use.
///
/// Also, use [initialCameraPosition] to specify the display position of the first map.
///
/// マップを表示するウィジェット。
///
/// [controller]を渡して利用します。
///
/// また、[initialCameraPosition]を利用して最初のマップの表示位置を指定してください。
@immutable
class MapView extends StatefulWidget {
  /// A widget that displays a map.
  ///
  /// Pass [controller] for use.
  ///
  /// Also, use [initialCameraPosition] to specify the display position of the first map.
  ///
  /// マップを表示するウィジェット。
  ///
  /// [controller]を渡して利用します。
  ///
  /// また、[initialCameraPosition]を利用して最初のマップの表示位置を指定してください。
  const MapView({
    super.key,
    required this.controller,
    required this.initialCameraPosition,
    this.onMapCreated,
    this.gestureRecognizers = const <Factory<OneSequenceGestureRecognizer>>{},
    this.compassEnabled = false,
    this.mapToolbarEnabled = false,
    this.cameraTargetBounds = CameraTargetBounds.unbounded,
    this.mapType = MapType.normal,
    this.minMaxZoomPreference = MinMaxZoomPreference.unbounded,
    this.rotateGesturesEnabled = true,
    this.scrollGesturesEnabled = true,
    this.zoomControlsEnabled = false,
    this.zoomGesturesEnabled = true,
    this.liteModeEnabled = false,
    this.tiltGesturesEnabled = true,
    this.myLocationEnabled = true,
    this.myLocationButtonEnabled = false,
    this.padding = const EdgeInsets.all(0),
    this.indoorViewEnabled = false,
    this.trafficEnabled = false,
    this.buildingsEnabled = true,
    this.markers = const <Marker>{},
    this.polygons = const <Polygon>{},
    this.polylines = const <Polyline>{},
    this.circles = const <Circle>{},
    this.tileOverlays = const <TileOverlay>{},
    this.onCameraMoveStarted,
    this.onCameraMove,
    this.onCameraIdle,
    this.onTap,
    this.style,
    this.onLongPress,
    this.keepAlive = false,
  });

  /// Map style to be applied.
  ///
  /// 適用するマップスタイル。
  final MapStyle? style;

  /// Controller to pass to the map.
  ///
  /// This controller is used to change the position of the map, etc.
  ///
  /// マップに渡すコントローラー。
  ///
  /// このコントローラーからマップの位置の変更等を操作します。
  final MapController controller;

  /// Callback method for when the map is ready to be used.
  ///
  /// Used to receive a [GoogleMapController] for this [GoogleMap].
  ///
  /// マップが利用可能になったときに呼び出されるコールバックメソッド。
  ///
  /// この[GoogleMap]の[GoogleMapController]を受け取るために利用します。
  final MapCreatedCallback? onMapCreated;

  /// The initial position of the map's camera.
  ///
  /// マップのカメラの初期位置。
  final CameraPosition initialCameraPosition;

  /// Set to `true` to rotate the image by compass.
  ///
  /// コンパスによる画像の回転を行う場合は`true`に設定します。
  final bool compassEnabled;

  /// Set to `true` to display a toolbar for manipulating the map.
  ///
  /// Applicable for Android only.
  ///
  /// マップを操作するためのツールバーを表示する場合`true`にします。
  ///
  /// Androidのみ適用可能。
  final bool mapToolbarEnabled;

  /// Graphical bounding box settings for camera targets.
  ///
  /// カメラターゲットのグラフィカルバウンディングボックスの設定。
  final CameraTargetBounds cameraTargetBounds;

  /// Type of map tile to render.
  ///
  /// レンダリングするためのマップタイルのタイプ。
  final MapType mapType;

  /// Maximum and minimum zoom settings.
  ///
  /// The actual zoom level is determined by the map data and the device.
  ///
  /// ズームの最大最小値の設定。
  ///
  /// 実際のズームレベルはマップデータと端末によって決まります。
  final MinMaxZoomPreference minMaxZoomPreference;

  /// `True` if you want to enable the gesture to rotate the map.
  ///
  /// マップを回転させるジェスチャーを有効にしたい場合は`true`。
  final bool rotateGesturesEnabled;

  /// `True` if you want to enable the gesture to scroll the map.
  ///
  /// マップをスクロールさせるジェスチャーを有効にしたい場合は`true`。
  final bool scrollGesturesEnabled;

  /// `True` if you want to enable the gesture to zoom the map.
  ///
  /// マップをズームさせるジェスチャーを有効にしたい場合は`true`。
  final bool zoomGesturesEnabled;

  /// `True` if you want to enable the terminal tilt gesture.
  ///
  /// 端末を傾けるジェスチャーを有効にしたい場合は`true`。
  final bool tiltGesturesEnabled;

  /// `True` if you want to display control buttons for zooming in and out.
  ///
  /// Applicable for Android only.
  ///
  /// ズームインやズームアウトを行うためのコントロールボタンを表示したい場合は`true`。
  ///
  /// Androidのみ適用可能。
  final bool zoomControlsEnabled;

  /// `True` to enable light mode.
  ///
  /// Applicable for Android only.
  ///
  /// See the link below for more information on light mode.
  ///
  /// ライトモードを有効にする場合は`true`。
  ///
  /// Androidのみ適用可能。
  ///
  /// ライトモードについては下記リンクを参照ください。
  ///
  /// https://developers.google.com/maps/documentation/android-sdk/lite#overview_of_lite_mode
  final bool liteModeEnabled;

  /// Sets the padding of the map.
  ///
  /// See below for map padding.
  ///
  /// マップのパディングを設定します。
  ///
  /// マップのパディングについては下記を参照。
  ///
  /// https://developers.google.com/maps/documentation/android-sdk/map#map_padding
  final EdgeInsets padding;

  /// Specify markers on the map.
  ///
  /// マップ上のマーカーを指定します。
  final Set<Marker> markers;

  /// Specifies polygons on the map.
  ///
  /// マップ上のポリゴンを指定します。
  final Set<Polygon> polygons;

  /// Specifies a polyline on the map.
  ///
  /// マップ上のポリラインを指定します。
  final Set<Polyline> polylines;

  /// Specifies a circle on the map.
  ///
  /// マップ上のサークルを指定します。
  final Set<Circle> circles;

  /// Specifies a tile overlay on the map.
  ///
  /// マップ上のタイルオーバーレイを指定します。
  final Set<TileOverlay> tileOverlays;

  /// Callback at the start of the camera move.
  ///
  /// This can be initiated by the following:
  /// 1. Non-gesture animation initiated in response to user actions.
  ///    For example: zoom buttons, my location button, or marker clicks.
  /// 2. Programmatically initiated animation.
  /// 3. Camera motion initiated in response to user gestures on the map.
  ///    For example: pan, tilt, pinch to zoom, or rotate.
  ///
  /// カメラの移動がスタートした時点でのコールバック。
  ///
  /// これは次の方法で開始できます。
  /// 1. ユーザーのアクションに応じて開始される非ジェスチャー アニメーション。
  ///    例: ズーム ボタン、現在地ボタン、マーカーのクリック。
  /// 2. プログラムでアニメーションを開始します。
  /// 3. マップ上のユーザーのジェスチャーに応じてカメラの動きが開始されます。
  ///    例: パン、チルト、ピンチでズーム、または回転します。
  final VoidCallback? onCameraMoveStarted;

  /// Called repeatedly as the camera continues to move after an [onCameraMoveStarted] call.
  ///
  /// This may be called as often as once every frame and should not perform expensive operations.
  ///
  /// [onCameraMoveStarted]呼び出し後、カメラが動き続けるときに繰り返し呼び出されます。
  ///
  /// これはフレームごとに 1 回程度呼び出すことができ、負荷の高い操作を実行すべきではありません。
  final void Function(CameraPosition position)? onCameraMove;

  /// Called when camera movement has ended, there are no pending animations and the user has stopped interacting with the map.
  ///
  /// カメラの動きが終了し、保留中のアニメーションがなく、ユーザーがマップとの対話を停止したときに呼び出されます。
  final VoidCallback? onCameraIdle;

  /// Called every time a [MapView] is tapped.
  ///
  /// [MapView]がタップされるたびに呼び出されます。
  final ArgumentCallback<LatLng>? onTap;

  /// Called every time a [MapView] is long pressed.
  ///
  /// [MapView]がロングタップされるたびに呼び出されます。
  final ArgumentCallback<LatLng>? onLongPress;

  /// `True` if a "My Location" layer should be shown on the map.
  ///
  /// This layer includes a location indicator at the current device location,
  /// as well as a My Location button.
  /// * The indicator is a small blue dot if the device is stationary, or a
  /// chevron if the device is moving.
  /// * The My Location button animates to focus on the user's current location
  /// if the user's location is currently known.
  ///
  /// 「現在地」レイヤーを地図上に表示する場合は`true`。
  ///
  /// このレイヤーには、現在のデバイスの位置の位置インジケーターが含まれます。
  /// [現在地] ボタンも同様です。
  /// * デバイスが静止している場合、インジケーターは小さな青い点になります。
  /// デバイスが移動している場合はシェブロン。
  /// * [現在地] ボタンは、ユーザーの現在位置に焦点を合わせてアニメーション化します。
  /// ユーザーの位置が現在わかっている場合。
  final bool myLocationEnabled;

  /// `True` if you want to display a button to move to the terminal position.
  ///
  /// If [myLocationEnabled] is not enabled, the button will be hidden.
  ///
  /// 端末の位置に移動するボタンを表示する場合は`true`。
  ///
  /// [myLocationEnabled]が有効でない場合はボタンは非表示になります。
  final bool myLocationButtonEnabled;

  /// `True` to enable indoor view.
  ///
  /// インドアビューを有効にする場合は`true`。
  final bool indoorViewEnabled;

  /// `True` if you want to enable the traffic view.
  ///
  /// 交通量のビューを有効にする場合は`true`。
  final bool trafficEnabled;

  /// `True` to enable 3D building view.
  ///
  /// 3Dのビルのビューを有効にする場合は`true`。
  final bool buildingsEnabled;

  /// If you wish to specify other gestures on the map, add them here.
  ///
  /// マップ上のその他のジェスチャーを指定したい場合こちらに追加します。
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers;

  /// If placed in a list, whether or not it should not be discarded on scrolling.
  ///
  /// If `true`, it is not destroyed but retained.
  ///
  /// リストに配置された場合、スクロール時に破棄されないようにするかどうか。
  ///
  /// `true`の場合、破棄されず保持され続けます。
  final bool keepAlive;

  @override
  State<StatefulWidget> createState() => _MapVewState();
}

class _MapVewState extends State<MapView> with AutomaticKeepAliveClientMixin {
  final Set<map.Marker> _marker = {};

  @override
  void didUpdateWidget(covariant MapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      widget.controller
          ._setGoogleMapController(oldWidget.controller.controller);
    }
    if (!widget.markers.equalsTo(oldWidget.markers) ||
        !widget.controller.markers.equalsTo(oldWidget.controller.markers)) {
      _marker.clear();
      _getBytesFromAsset();
    }
    if (!widget.polygons.equalsTo(oldWidget.polygons) ||
        !widget.polylines.equalsTo(oldWidget.polylines) ||
        !widget.circles.equalsTo(oldWidget.circles) ||
        !widget.tileOverlays.equalsTo(oldWidget.tileOverlays) ||
        !widget.controller.polygons.equalsTo(oldWidget.controller.polygons) ||
        !widget.controller.polylines.equalsTo(oldWidget.controller.polylines) ||
        !widget.controller.circles.equalsTo(oldWidget.controller.circles) ||
        !widget.controller.tileOverlays
            .equalsTo(oldWidget.controller.tileOverlays)) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final adapter =
        MasamuneAdapterScope.of<GoogleLocationMasamuneAdapter>(context);
    final mapStyle = widget.style ?? adapter?.defaultMapStyle;

    return GoogleMap(
      key: widget.key,
      initialCameraPosition: widget.initialCameraPosition,
      style: mapStyle?._style,
      onMapCreated: (controller) async {
        widget.controller._setGoogleMapController(controller);
        widget.onMapCreated?.call(controller);
        widget.controller._position = widget.initialCameraPosition.target;
        widget.controller._zoom = await controller.getZoomLevel();
        await _getBytesFromAsset();
        await Future.delayed(const Duration(milliseconds: 250));
        setState(() {});
      },
      gestureRecognizers: widget.gestureRecognizers,
      compassEnabled: widget.compassEnabled,
      mapToolbarEnabled: widget.mapToolbarEnabled,
      cameraTargetBounds: widget.cameraTargetBounds,
      mapType: widget.mapType,
      minMaxZoomPreference: widget.minMaxZoomPreference,
      rotateGesturesEnabled: widget.rotateGesturesEnabled,
      scrollGesturesEnabled: widget.scrollGesturesEnabled,
      zoomControlsEnabled: widget.zoomControlsEnabled,
      zoomGesturesEnabled: widget.zoomGesturesEnabled,
      liteModeEnabled: widget.liteModeEnabled,
      tiltGesturesEnabled: widget.tiltGesturesEnabled,
      myLocationEnabled: widget.myLocationEnabled,
      myLocationButtonEnabled: widget.myLocationButtonEnabled,
      padding: widget.padding,
      indoorViewEnabled: widget.indoorViewEnabled,
      trafficEnabled: widget.trafficEnabled,
      buildingsEnabled: widget.buildingsEnabled,
      markers: {
        ..._marker,
      },
      polygons: {
        ...widget.polygons,
        ...widget.controller.polygons,
      },
      polylines: {
        ...widget.polylines,
        ...widget.controller.polylines,
      },
      circles: {
        ...widget.circles,
        ...widget.controller.circles,
      },
      tileOverlays: {
        ...widget.tileOverlays,
        ...widget.controller.tileOverlays,
      },
      onCameraMoveStarted: widget.onCameraMoveStarted,
      onCameraMove: (map.CameraPosition position) async {
        widget.onCameraMove?.call(position.toCameraPosition());
        widget.controller._position = position.target;
        if (widget.controller._controller != null) {
          widget.controller._zoom =
              await widget.controller._controller!.getZoomLevel();
        }
      },
      onCameraIdle: widget.onCameraIdle,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
    );
  }

  Future<void> _getBytesFromAsset() async {
    for (final marker in widget.markers) {
      if (_marker.contains(marker)) {
        continue;
      }
      final loaded = await marker._load();
      if (loaded == null) {
        continue;
      }
      _marker.add(loaded);
    }
    for (final marker in widget.controller.markers) {
      if (_marker.contains(marker)) {
        continue;
      }
      final loaded = await marker._load();
      if (loaded == null) {
        continue;
      }
      _marker.add(loaded);
    }
    setState(() {});
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;
}
