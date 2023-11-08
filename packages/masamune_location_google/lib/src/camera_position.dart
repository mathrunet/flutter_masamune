part of '/masamune_location_google.dart';

/// The position of the map "camera", the view point from which the world is shown in the map view.
///
/// Aggregates the camera's [target] geographical location, its [zoom] level,
/// [tilt] angle, and [bearing].
///
/// GoogleMapの「カメラ」の位置、地図ビューにおいて世界が表示される視点。
///
/// カメラの[target]の地理的位置、[zoom]レベル、[tilt]角度、[bearing]を集約します。
@immutable
class CameraPosition extends map.CameraPosition {
  /// The position of the map "camera", the view point from which the world is shown in the map view.
  ///
  /// Aggregates the camera's [target] geographical location, its [zoom] level,
  /// [tilt] angle, and [bearing].
  ///
  /// GoogleMapの「カメラ」の位置、地図ビューにおいて世界が表示される視点。
  ///
  /// カメラの[target]の地理的位置、[zoom]レベル、[tilt]角度、[bearing]を集約します。
  CameraPosition({
    super.bearing = 0.0,
    required GeoValue target,
    super.tilt = 0.0,
    super.zoom = 0.0,
  }) : super(target: target.toLatLng());
}
