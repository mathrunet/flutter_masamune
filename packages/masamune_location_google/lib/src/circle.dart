part of '/masamune_location_google.dart';

/// Draws a circle on the map.
///
/// マップ上に円を描画します。
class Circle extends map.Circle {
  /// Draws a circle on the map.
  ///
  /// マップ上に円を描画します。
  Circle({
    required String circleId,
    super.consumeTapEvents = false,
    super.fillColor = Colors.transparent,
    GeoValue center = const GeoValue(latitude: 0.0, longitude: 0.0),
    super.radius = 0,
    super.strokeColor = Colors.black,
    super.strokeWidth = 10,
    super.visible = true,
    super.zIndex = 0,
    super.onTap,
  }) : super(
          circleId: CircleId(circleId),
          center: center.toLatLng(),
        );
}
