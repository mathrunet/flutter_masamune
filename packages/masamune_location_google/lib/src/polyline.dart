part of "/masamune_location_google.dart";

/// Draws a line through geographical locations on the map.
///
/// 地図上の地理的位置を通る線を描画します。
class Polyline extends map.Polyline {
  /// Draws a line through geographical locations on the map.
  ///
  /// 地図上の地理的位置を通る線を描画します。
  Polyline({
    required String polylineId,
    super.consumeTapEvents = false,
    super.color = Colors.black,
    super.endCap = Cap.buttCap,
    super.geodesic = false,
    super.jointType = JointType.mitered,
    List<GeoValue> points = const <GeoValue>[],
    super.patterns = const <PatternItem>[],
    super.startCap = Cap.buttCap,
    super.visible = true,
    super.width = 10,
    super.zIndex = 0,
    super.onTap,
  }) : super(
          polylineId: PolylineId(polylineId),
          points: points.map((e) => e.toLatLng()).toList(),
        );
}
