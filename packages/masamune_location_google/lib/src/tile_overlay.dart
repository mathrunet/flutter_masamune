part of masamune_location_google;

/// A set of images which are displayed on top of the base map tiles.
///
/// These tiles may be transparent, allowing you to add features to existing maps.
///
/// ## Tile Coordinates
///
/// Note that the world is projected using the Mercator projection
/// (see [Wikipedia](https://en.wikipedia.org/wiki/Mercator_projection)) with the left (west) side
/// of the map corresponding to -180 degrees of longitude and the right (east) side of the map
/// corresponding to 180 degrees of longitude. To make the map square, the top (north) side of the
/// map corresponds to 85.0511 degrees of latitude and the bottom (south) side of the map
/// corresponds to -85.0511 degrees of latitude. Areas outside this latitude range are not rendered.
///
/// At each zoom level, the map is divided into tiles and only the tiles that overlap the screen are
/// downloaded and rendered. Each tile is square and the map is divided into tiles as follows:
///
/// * At zoom level 0, one tile represents the entire world. The coordinates of that tile are
/// (x, y) = (0, 0).
/// * At zoom level 1, the world is divided into 4 tiles arranged in a 2 x 2 grid.
/// * ...
/// * At zoom level N, the world is divided into 4N tiles arranged in a 2N x 2N grid.
///
/// Note that the minimum zoom level that the camera supports (which can depend on various factors)
/// is GoogleMap.getMinZoomLevel and the maximum zoom level is GoogleMap.getMaxZoomLevel.
///
/// The coordinates of the tiles are measured from the top left (northwest) corner of the map.
/// At zoom level N, the x values of the tile coordinates range from 0 to 2N - 1 and increase from
/// west to east and the y values range from 0 to 2N - 1 and increase from north to south.
///
/// ベースマップタイルの上に表示される画像のセット。
///
/// これらのタイルは透明にすることができ、既存のマップに機能を追加することができます。
///
/// ## タイル座標
///
/// 世界はメルカトル投影法を用いて投影されていることに注意してください
/// （[Wikipedia](https://en.wikipedia.org/wiki/Mercator_projection)を参照）。
/// マップの左（西）側は経度-180度に対応し、マップの右（東）側は経度180度に対応します。
/// マップを正方形にするため、マップの上（北）側は緯度85.0511度に対応し、マップの下（南）側は緯度-85.0511度に対応します。
/// この緯度範囲外の領域はレンダリングされません。
///
/// 各ズームレベルでは、マップはタイルに分割され、画面と重なるタイルのみがダウンロードされ、レンダリングされます。
/// 各タイルは正方形で、マップは次のようにタイルに分割されます。
///
/// * ズームレベル0では、1つのタイルが世界全体を表します。そのタイルの座標は（x、y）=（0、0）です。
/// * ズームレベル1では、世界は2 x 2グリッドに配置された4つのタイルに分割されます。
/// * ...
/// * ズームレベルNでは、世界は2N x 2Nグリッドに配置された4N個のタイルに分割されます。
///
/// カメラがサポートする最小ズームレベル（さまざまな要因によって異なる場合があります）はGoogleMap.getMinZoomLevelであり、最大ズームレベルはGoogleMap.getMaxZoomLevelです。
///
/// タイルの座標は、マップの左上（北西）隅から測定されます。
/// ズームレベルNでは、タイル座標のx値は0から2N-1までの範囲で、西から東に向かって増加し、y値は0から2N-1までの範囲で、北から南に向かって増加します。
///
/// https://developers.google.com/android/reference/com/google/android/gms/maps/model/TileOverlay
class TileOverlay extends map.TileOverlay {
  /// A set of images which are displayed on top of the base map tiles.
  ///
  /// These tiles may be transparent, allowing you to add features to existing maps.
  ///
  /// ## Tile Coordinates
  ///
  /// Note that the world is projected using the Mercator projection
  /// (see [Wikipedia](https://en.wikipedia.org/wiki/Mercator_projection)) with the left (west) side
  /// of the map corresponding to -180 degrees of longitude and the right (east) side of the map
  /// corresponding to 180 degrees of longitude. To make the map square, the top (north) side of the
  /// map corresponds to 85.0511 degrees of latitude and the bottom (south) side of the map
  /// corresponds to -85.0511 degrees of latitude. Areas outside this latitude range are not rendered.
  ///
  /// At each zoom level, the map is divided into tiles and only the tiles that overlap the screen are
  /// downloaded and rendered. Each tile is square and the map is divided into tiles as follows:
  ///
  /// * At zoom level 0, one tile represents the entire world. The coordinates of that tile are
  /// (x, y) = (0, 0).
  /// * At zoom level 1, the world is divided into 4 tiles arranged in a 2 x 2 grid.
  /// * ...
  /// * At zoom level N, the world is divided into 4N tiles arranged in a 2N x 2N grid.
  ///
  /// Note that the minimum zoom level that the camera supports (which can depend on various factors)
  /// is GoogleMap.getMinZoomLevel and the maximum zoom level is GoogleMap.getMaxZoomLevel.
  ///
  /// The coordinates of the tiles are measured from the top left (northwest) corner of the map.
  /// At zoom level N, the x values of the tile coordinates range from 0 to 2N - 1 and increase from
  /// west to east and the y values range from 0 to 2N - 1 and increase from north to south.
  ///
  /// ベースマップタイルの上に表示される画像のセット。
  ///
  /// これらのタイルは透明にすることができ、既存のマップに機能を追加することができます。
  ///
  /// ## タイル座標
  ///
  /// 世界はメルカトル投影法を用いて投影されていることに注意してください
  /// （[Wikipedia](https://en.wikipedia.org/wiki/Mercator_projection)を参照）。
  /// マップの左（西）側は経度-180度に対応し、マップの右（東）側は経度180度に対応します。
  /// マップを正方形にするため、マップの上（北）側は緯度85.0511度に対応し、マップの下（南）側は緯度-85.0511度に対応します。
  /// この緯度範囲外の領域はレンダリングされません。
  ///
  /// 各ズームレベルでは、マップはタイルに分割され、画面と重なるタイルのみがダウンロードされ、レンダリングされます。
  /// 各タイルは正方形で、マップは次のようにタイルに分割されます。
  ///
  /// * ズームレベル0では、1つのタイルが世界全体を表します。そのタイルの座標は（x、y）=（0、0）です。
  /// * ズームレベル1では、世界は2 x 2グリッドに配置された4つのタイルに分割されます。
  /// * ...
  /// * ズームレベルNでは、世界は2N x 2Nグリッドに配置された4N個のタイルに分割されます。
  ///
  /// カメラがサポートする最小ズームレベル（さまざまな要因によって異なる場合があります）はGoogleMap.getMinZoomLevelであり、最大ズームレベルはGoogleMap.getMaxZoomLevelです。
  ///
  /// タイルの座標は、マップの左上（北西）隅から測定されます。
  /// ズームレベルNでは、タイル座標のx値は0から2N-1までの範囲で、西から東に向かって増加し、y値は0から2N-1までの範囲で、北から南に向かって増加します。
  ///
  /// https://developers.google.com/android/reference/com/google/android/gms/maps/model/TileOverlay
  TileOverlay({
    required String tileOverlayId,
    super.fadeIn = true,
    super.tileProvider,
    super.transparency = 0.0,
    super.zIndex = 0,
    super.visible = true,
    super.tileSize = 256,
  }) : super(
          tileOverlayId: TileOverlayId(tileOverlayId),
        );
}
