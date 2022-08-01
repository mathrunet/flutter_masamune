part of masamune_location;

extension WidgetRefMapControllerExtensions on WidgetRef {
  MapController useMapController() {
    return valueBuilder<MapController, _MapControllerValue>(
      key: "mapController",
      builder: () {
        return _MapControllerValue(() {
          final location = readProvider(locationProvider);
          location.listen().then((value) => rebuild());
        });
      },
    );
  }
}

@immutable
class _MapControllerValue extends ScopedValue<MapController> {
  const _MapControllerValue(this.onInit);

  final VoidCallback onInit;

  @override
  ScopedValueState<MapController<Object>, ScopedValue<MapController<Object>>>
      createState() => _MapControllerValueState();
}

class _MapControllerValueState
    extends ScopedValueState<MapController, _MapControllerValue> {
  final MapController _controller = MapController._();

  @override
  void initValue() {
    super.initValue();
    value.onInit.call();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  MapController<Object> build() => _controller;
}

/// Map controller.
class MapController<T extends Object> {
  MapController._();

  /// Current GPS Location.
  LatLng get location {
    final data = LocationCore.location;
    return LatLng(
      data.latitude ?? 0.0,
      data.longitude ?? 0.0,
    );
  }

  /// Current Location.
  LatLng get current => _current;
  // ignore: prefer_final_fields
  LatLng _current = const LatLng(0, 0);

  /// Target Location.
  LatLng get target => _target;
  LatLng _target = const LatLng(0, 0);

  /// Marker set.
  final Set<Marker> markers = {};

  /// Polygon set.
  final Set<Polygon> polygons = {};

  /// Polyline set.
  final Set<Polyline> polylines = {};

  /// Circle set.
  final Set<Circle> circles = {};

  /// Google map controller.
  late final GoogleMapController controller;

  /// Dispose controller.
  void dispose() {
    controller.dispose();
  }

  void _initialize(GoogleMapController controller) {
    this.controller = controller;
  }

  /// Set the target location.
  ///
  /// [latitude]: Latitude.
  /// [longitude]: Longitude.
  void setTarget(double latitude, double longitude) {
    _target = LatLng(latitude, longitude);
  }

  /// Set the marker.
  ///
  /// The already set marker is replaced.
  ///
  /// [marker]: Marker.
  void setMarker(Marker marker) {
    markers.removeWhere(
      (element) => element.markerId.value == marker.markerId.value,
    );
    markers.add(marker);
  }

  /// Set the polygon.
  ///
  /// The already set polygon is replaced.
  ///
  /// [polygon]: Polygon.
  void setPolygon(Polygon polygon) {
    polygons.removeWhere(
      (element) => element.polygonId.value == polygon.polygonId.value,
    );
    polygons.add(polygon);
  }

  /// Set the polyline.
  ///
  /// The already set polyline is replaced.
  ///
  /// [polyline]: Polyline.
  void setPolyline(Polyline polyline) {
    polylines.removeWhere(
      (element) => element.polylineId.value == polyline.polylineId.value,
    );
    polylines.add(polyline);
  }

  /// Set the circle.
  ///
  /// The already set circle is replaced.
  ///
  /// [circle]: Circle.
  void setCircle(Circle circle) {
    circles.removeWhere(
      (element) => element.circleId.value == circle.circleId.value,
    );
    circles.add(circle);
  }
}
