part of '/masamune_location_google.dart';

/// Draws a polygon through geographical locations on the map.
///
/// 地図上の地理的位置を通る多角形を描画します。
class Polygon extends map.Polygon {
  /// Draws a polygon through geographical locations on the map.
  ///
  /// 地図上の地理的位置を通る多角形を描画します。
  Polygon({
    required String polygonId,
    super.consumeTapEvents = false,
    super.fillColor = Colors.black,
    super.geodesic = false,
    List<GeoValue> points = const <GeoValue>[],
    List<List<GeoValue>> holes = const <List<GeoValue>>[],
    super.strokeColor = Colors.black,
    super.strokeWidth = 10,
    super.visible = true,
    super.zIndex = 0,
    super.onTap,
  }) : super(
          polygonId: PolygonId(polygonId),
          points: points.map((e) => e.toLatLng()).toList(),
          holes: holes.map((e) => e.map((e) => e.toLatLng()).toList()).toList(),
        );
}
