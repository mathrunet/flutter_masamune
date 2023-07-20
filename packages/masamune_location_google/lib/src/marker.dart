part of masamune_location_google;

/// Marks a geographical location on the map.
///
/// [Marker.image] to place an image and [Marker.icon] to place an icon.
///
/// A marker icon is drawn oriented against the device's screen rather than
/// the map's surface; that is, it will not necessarily change orientation
/// due to map rotations, tilting, or zooming.
///
/// マップ上の地理的位置を示します。
///
/// [Marker.image]で画像を配置、[Marker.icon]でアイコンを配置します。
///
/// マーカーアイコンは、マップの表面ではなく、デバイスの画面に対して向きを変えて描画されます。
/// つまり、マップの回転、傾き、ズームによって必ずしも向きが変わるとは限りません。
class Marker extends map.Marker {
  /// Marks a geographical location on the map.
  ///
  /// [Marker.image] to place an image and [Marker.icon] to place an icon.
  ///
  /// A marker icon is drawn oriented against the device's screen rather than
  /// the map's surface; that is, it will not necessarily change orientation
  /// due to map rotations, tilting, or zooming.
  ///
  /// マップ上の地理的位置を示します。
  ///
  /// [Marker.image]で画像を配置、[Marker.icon]でアイコンを配置します。
  ///
  /// マーカーアイコンは、マップの表面ではなく、デバイスの画面に対して向きを変えて描画されます。
  /// つまり、マップの回転、傾き、ズームによって必ずしも向きが変わるとは限りません。
  Marker.image({
    required String markerId,
    super.alpha = 1.0,
    super.anchor = const Offset(0.5, 1.0),
    super.consumeTapEvents = false,
    super.draggable = false,
    super.flat = false,
    required this.image,
    this.size = 128,
    super.infoWindow = InfoWindow.noText,
    GeoValue position = const GeoValue(latitude: 0.0, longitude: 0.0),
    super.rotation = 0.0,
    super.visible = true,
    super.zIndex = 0.0,
    super.onTap,
    super.onDrag,
    super.onDragStart,
    super.onDragEnd,
  })  : _icon = null,
        color = null,
        super(markerId: MarkerId(markerId), position: position.toLatLng());

  /// Marks a geographical location on the map.
  ///
  /// [Marker.image] to place an image and [Marker.icon] to place an icon.
  ///
  /// A marker icon is drawn oriented against the device's screen rather than
  /// the map's surface; that is, it will not necessarily change orientation
  /// due to map rotations, tilting, or zooming.
  ///
  /// マップ上の地理的位置を示します。
  ///
  /// [Marker.image]で画像を配置、[Marker.icon]でアイコンを配置します。
  ///
  /// マーカーアイコンは、マップの表面ではなく、デバイスの画面に対して向きを変えて描画されます。
  /// つまり、マップの回転、傾き、ズームによって必ずしも向きが変わるとは限りません。
  Marker.icon({
    required String markerId,
    super.alpha = 1.0,
    super.anchor = const Offset(0.5, 1.0),
    super.consumeTapEvents = false,
    super.draggable = false,
    super.flat = false,
    required IconData icon,
    this.color,
    this.size = 24,
    super.infoWindow = InfoWindow.noText,
    GeoValue position = const GeoValue(latitude: 0.0, longitude: 0.0),
    super.rotation = 0.0,
    super.visible = true,
    super.zIndex = 0.0,
    super.onTap,
    super.onDrag,
    super.onDragStart,
    super.onDragEnd,
  })  : _icon = icon,
        image = null,
        super(markerId: MarkerId(markerId), position: position.toLatLng());

  /// Path of the icon image.
  ///
  /// Specify the relative path corresponding to the image to be acquired at [rootBundle].
  ///
  /// アイコンイメージのパス。
  ///
  /// [rootBundle]にてイメージを取得するのでそれに対応した相対パスを指定します。
  final Uri? image;

  /// Size of the icon image.
  ///
  /// アイコンイメージのサイズ。
  final double size;

  /// Data for the use of icons.
  ///
  /// アイコンを利用するためのデータ。
  final IconData? _icon;

  /// Icon Color.
  ///
  /// アイコンの色。
  final Color? color;

  Future<map.Marker?> _load() async {
    if (image != null) {
      final data = await rootBundle.load(image.toString());
      final codec = await instantiateImageCodec(
        data.buffer.asUint8List(),
        targetWidth: size.toInt(),
      );
      final fi = await codec.getNextFrame();
      final bytes = await fi.image.toByteData(format: ImageByteFormat.png);
      if (bytes == null) {
        return null;
      }
      return map.Marker(
        markerId: markerId,
        position: position,
        alpha: alpha,
        anchor: anchor,
        consumeTapEvents: consumeTapEvents,
        draggable: draggable,
        flat: flat,
        icon: BitmapDescriptor.fromBytes(bytes.buffer.asUint8List()),
        infoWindow: infoWindow,
        rotation: rotation,
        visible: visible,
        zIndex: zIndex,
        onTap: onTap,
        onDrag: onDrag,
        onDragStart: onDragStart,
        onDragEnd: onDragEnd,
      );
    } else if (_icon != null) {
      final pictureRecorder = PictureRecorder();
      final canvas = Canvas(pictureRecorder);
      final textPainter = TextPainter(textDirection: TextDirection.ltr);
      final iconStr = String.fromCharCode(_icon!.codePoint);
      textPainter.text = TextSpan(
          text: iconStr,
          style: TextStyle(
            letterSpacing: 0.0,
            fontSize: size.toDouble(),
            fontFamily: _icon!.fontFamily,
            color: color,
          ));
      textPainter.layout();
      textPainter.paint(canvas, const Offset(0.0, 0.0));
      final picture = pictureRecorder.endRecording();
      final image = await picture.toImage(
        size.toInt(),
        size.toInt(),
      );
      final bytes = await image.toByteData(format: ImageByteFormat.png);
      if (bytes == null) {
        return null;
      }
      return map.Marker(
        markerId: markerId,
        position: position,
        alpha: alpha,
        anchor: anchor,
        consumeTapEvents: consumeTapEvents,
        draggable: draggable,
        flat: flat,
        icon: BitmapDescriptor.fromBytes(bytes.buffer.asUint8List()),
        infoWindow: infoWindow,
        rotation: rotation,
        visible: visible,
        zIndex: zIndex,
        onTap: onTap,
        onDrag: onDrag,
        onDragStart: onDragStart,
        onDragEnd: onDragEnd,
      );
    }
    return null;
  }
}
