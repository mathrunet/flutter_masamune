part of masamune_location;

/// Google Maps.
@immutable
class UIGoogleMap extends StatefulWidget {
  /// Google Maps.
  const UIGoogleMap({
    Key? key,
    required this.controller,
    required this.initialCameraPosition,
    this.onMapCreated,
    this.gestureRecognizers = const <Factory<OneSequenceGestureRecognizer>>{},
    this.compassEnabled = true,
    this.mapToolbarEnabled = true,
    this.cameraTargetBounds = CameraTargetBounds.unbounded,
    this.mapType = MapType.normal,
    this.minMaxZoomPreference = MinMaxZoomPreference.unbounded,
    this.rotateGesturesEnabled = true,
    this.scrollGesturesEnabled = true,
    this.zoomControlsEnabled = true,
    this.zoomGesturesEnabled = true,
    this.liteModeEnabled = false,
    this.tiltGesturesEnabled = true,
    this.myLocationEnabled = false,
    this.myLocationButtonEnabled = true,

    /// If no padding is specified default padding will be 0.
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
    this.icons = const <String, UIGoogleMapIcon>{},
    this.onCameraMove,
    this.onCameraIdle,
    this.onTap,
    this.loader,
    this.style,
    this.onLongPress,
  }) : super(key: key);

  /// Icon image to load (in assets only).
  final Map<String, UIGoogleMapIcon> icons;

  /// Builder for loading data & icons.
  final void Function(
    BuildContext context,
    MapController controller,
    Map<String, UIGoogleMapIcon> icons,
  )? loader;

  /// Map Style.
  final MapStyle? style;

  /// Controller for maps.
  final MapController controller;

  /// Callback method for when the map is ready to be used.
  ///
  /// Used to receive a [GoogleMapController] for this [GoogleMap].
  final MapCreatedCallback? onMapCreated;

  /// The initial position of the map's camera.
  final CameraPosition initialCameraPosition;

  /// True if the map should show a compass when rotated.
  final bool compassEnabled;

  /// True if the map should show a toolbar when you interact with the map. Android only.
  final bool mapToolbarEnabled;

  /// Geographical bounding box for the camera target.
  final CameraTargetBounds cameraTargetBounds;

  /// Type of map tiles to be rendered.
  final MapType mapType;

  /// Preferred bounds for the camera zoom level.
  ///
  /// Actual bounds depend on map data and device.
  final MinMaxZoomPreference minMaxZoomPreference;

  /// True if the map view should respond to rotate gestures.
  final bool rotateGesturesEnabled;

  /// True if the map view should respond to scroll gestures.
  final bool scrollGesturesEnabled;

  /// True if the map view should show zoom controls. This includes two buttons
  /// to zoom in and zoom out. The default value is to show zoom controls.
  ///
  /// This is only supported on Android. And this field is silently ignored on iOS.
  final bool zoomControlsEnabled;

  /// True if the map view should respond to zoom gestures.
  final bool zoomGesturesEnabled;

  /// True if the map view should be in lite mode. Android only.
  ///
  /// See https://developers.google.com/maps/documentation/android-sdk/lite#overview_of_lite_mode for more details.
  final bool liteModeEnabled;

  /// True if the map view should respond to tilt gestures.
  final bool tiltGesturesEnabled;

  /// Padding to be set on map. See https://developers.google.com/maps/documentation/android-sdk/map#map_padding for more details.
  final EdgeInsets padding;

  /// Markers to be placed on the map.
  final Set<Marker> markers;

  /// Polygons to be placed on the map.
  final Set<Polygon> polygons;

  /// Polylines to be placed on the map.
  final Set<Polyline> polylines;

  /// Circles to be placed on the map.
  final Set<Circle> circles;

  /// Tile overlays to be placed on the map.
  final Set<TileOverlay> tileOverlays;

  /// Called when the camera starts moving.
  ///
  /// This can be initiated by the following:
  /// 1. Non-gesture animation initiated in response to user actions.
  ///    For example: zoom buttons, my location button, or marker clicks.
  /// 2. Programmatically initiated animation.
  /// 3. Camera motion initiated in response to user gestures on the map.
  ///    For example: pan, tilt, pinch to zoom, or rotate.
  final VoidCallback? onCameraMoveStarted;

  /// Called repeatedly as the camera continues to move after an
  /// onCameraMoveStarted call.
  ///
  /// This may be called as often as once every frame and should
  /// not perform expensive operations.
  final CameraPositionCallback? onCameraMove;

  /// Called when camera movement has ended, there are no pending
  /// animations and the user has stopped interacting with the map.
  final VoidCallback? onCameraIdle;

  /// Called every time a [GoogleMap] is tapped.
  final ArgumentCallback<LatLng>? onTap;

  /// Called every time a [GoogleMap] is long pressed.
  final ArgumentCallback<LatLng>? onLongPress;

  /// True if a "My Location" layer should be shown on the map.
  ///
  /// This layer includes a location indicator at the current device location,
  /// as well as a My Location button.
  /// * The indicator is a small blue dot if the device is stationary, or a
  /// chevron if the device is moving.
  /// * The My Location button animates to focus on the user's current location
  /// if the user's location is currently known.
  ///
  /// Enabling this feature requires adding location permissions to both native
  /// platforms of your app.
  /// * On Android add either
  /// `<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />`
  /// or `<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />`
  /// to your `AndroidManifest.xml` file. `ACCESS_COARSE_LOCATION` returns a
  /// location with an accuracy approximately equivalent to a city block, while
  /// `ACCESS_FINE_LOCATION` returns as precise a location as possible, although
  /// it consumes more battery power. You will also need to request these
  /// permissions during run-time. If they are not granted, the My Location
  /// feature will fail silently.
  /// * On iOS add a `NSLocationWhenInUseUsageDescription` key to your
  /// `Info.plist` file. This will automatically prompt the user for permissions
  /// when the map tries to turn on the My Location layer.
  final bool myLocationEnabled;

  /// Enables or disables the my-location button.
  ///
  /// The my-location button causes the camera to move such that the user's
  /// location is in the center of the map. If the button is enabled, it is
  /// only shown when the my-location layer is enabled.
  ///
  /// By default, the my-location button is enabled (and hence shown when the
  /// my-location layer is enabled).
  ///
  /// See also:
  ///   * [myLocationEnabled] parameter.
  final bool myLocationButtonEnabled;

  /// Enables or disables the indoor view from the map
  final bool indoorViewEnabled;

  /// Enables or disables the traffic layer of the map
  final bool trafficEnabled;

  /// Enables or disables showing 3D buildings where available
  final bool buildingsEnabled;

  /// Which gestures should be consumed by the map.
  ///
  /// It is possible for other gesture recognizers to be competing with the map on pointer
  /// events, e.g if the map is inside a [ListView] the [ListView] will want to handle
  /// vertical drags. The map will claim gestures that are recognized by any of the
  /// recognizers on this list.
  ///
  /// When this set is empty, the map will only handle pointer events for gestures that
  /// were not claimed by any other gesture recognizer.
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers;

  @override
  State<StatefulWidget> createState() => _UIGoogleMapState();
}

class _UIGoogleMapState extends State<UIGoogleMap> {
  Map<String, UIGoogleMapIcon>? _icons;

  @override
  void didUpdateWidget(covariant UIGoogleMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      widget.controller._initialize(oldWidget.controller.controller);
    }
    if (widget.icons != oldWidget.icons) {
      _icons = null;
      _getBytesFromAsset();
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.dispose();
  }

  /// Build.
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      key: widget.key,
      initialCameraPosition: widget.initialCameraPosition,
      onMapCreated: (controller) async {
        widget.controller._initialize(controller);
        if (widget.style != null) {
          controller.setMapStyle(widget.style!._style);
        }
        widget.onMapCreated?.call(controller);
        widget.controller._current = widget.initialCameraPosition.target;
        if (widget.loader == null) {
          return;
        }
        await _getBytesFromAsset();
        widget.loader?.call(context, widget.controller, _icons ?? {});
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
      markers: widget.markers,
      polygons: widget.polygons,
      polylines: widget.polylines,
      circles: widget.circles,
      onCameraMoveStarted: widget.onCameraMoveStarted,
      onCameraMove: (CameraPosition position) {
        widget.onCameraMove?.call(position);
        widget.controller._current = position.target;
      },
      onCameraIdle: () async {
        widget.onCameraIdle?.call();
        if (widget.loader == null) {
          return;
        }
        await _getBytesFromAsset();
        widget.loader?.call(context, widget.controller, _icons ?? {});
        setState(() {});
      },
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
    );
  }

  Future _getBytesFromAsset() async {
    if (_icons != null) {
      return;
    }
    _icons = {};
    if (widget.icons.isEmpty) {
      return;
    }
    for (final tmp in widget.icons.entries) {
      final data = await rootBundle.load(tmp.value.path);
      final codec = await instantiateImageCodec(
        data.buffer.asUint8List(),
        targetWidth: tmp.value.width,
      );
      final fi = await codec.getNextFrame();
      final bytes = await fi.image.toByteData(format: ImageByteFormat.png);
      if (bytes == null) {
        continue;
      }
      _icons![tmp.key] = tmp.value.copyWith(
        icon: BitmapDescriptor.fromBytes(
          bytes.buffer.asUint8List(),
        ),
      );
    }
  }
}

/// Define a Google Maps icon.
///
/// If you pass the data to [icons] of [UIGoogleMap],
/// the loaded data will be stored in [icon].
class UIGoogleMapIcon {
  /// Define a Google Maps icon.
  ///
  /// If you pass the data to [icons] of [UIGoogleMap],
  /// the loaded data will be stored in [icon].
  UIGoogleMapIcon(this.path, [this.width = 100]) : icon = null;

  UIGoogleMapIcon._({
    required this.path,
    this.width = 100,
    required this.icon,
  });

  /// Icon image path.
  final String path;

  /// Size of the icon image.
  final int width;

  /// Icon image.
  final BitmapDescriptor? icon;

  /// Copy for UIGoogleMapIcon.
  UIGoogleMapIcon copyWith({
    String? path,
    int? width,
    BitmapDescriptor? icon,
  }) {
    return UIGoogleMapIcon._(
      path: path ?? this.path,
      width: width ?? this.width,
      icon: icon ?? this.icon,
    );
  }
}
