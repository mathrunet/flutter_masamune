part of '/masamune_location_google.dart';

extension on GeoValue {
  LatLng toLatLng() => LatLng(latitude, longitude);
}

extension on map.CameraPosition {
  CameraPosition toCameraPosition() {
    return CameraPosition(
      target: GeoValue(latitude: target.latitude, longitude: target.longitude),
      bearing: bearing,
      tilt: tilt,
      zoom: zoom,
    );
  }
}
