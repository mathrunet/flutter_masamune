part of masamune_location_google;

/// The shape of the marker icon.
///
/// マーカーアイコンの形。
enum MarkerIconShape {
  /// Rectrangle.
  ///
  /// 四角形。
  rect,

  /// Circle.
  ///
  /// 円形。
  circle,
}

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
        borderColor = null,
        borderWidth = 1.0,
        padding = 0.0,
        borderRadius = 8.0,
        backgroundColor = null,
        shape = MarkerIconShape.circle,
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
    this.padding = 0.0,
    this.borderColor,
    this.borderWidth = 1.0,
    this.backgroundColor,
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
    this.shape = MarkerIconShape.circle,
    super.onDragEnd,
    this.borderRadius = 8.0,
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

  /// The color of the border around the icon.
  ///
  /// アイコンの周りのボーダーの色。
  final Color? borderColor;

  /// Width of the border around the icon.
  ///
  /// アイコンの周りのボーダーの幅。
  final double borderWidth;

  /// Background color around the icon.
  ///
  /// アイコンの周りの背景色。
  final Color? backgroundColor;

  /// Padding around icons.
  ///
  /// アイコン周りのパディング。
  final double padding;

  /// Radius of rounded corners for [MarkerIconShape.rect].
  ///
  /// [MarkerIconShape.rect]の場合の角丸の半径。
  final double borderRadius;

  /// Shape of marker.
  ///
  /// マーカーの形状。
  final MarkerIconShape shape;

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
      final generator = _MarkerGenerator(
        markerSize: size,
        padding: padding,
        strokeWidth: borderWidth,
        borderRadius: borderRadius,
      );
      final icon = await generator.createBitmapDescriptorFromIconData(
        iconData: _icon!,
        shape: shape,
        iconColor: color ?? Colors.grey,
        borderColor: borderColor,
        backgroundColor: backgroundColor,
      );
      if (icon == null) {
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
        icon: icon,
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

class _MarkerGenerator {
  _MarkerGenerator({
    required this.markerSize,
    this.strokeWidth = 1.0,
    this.padding = 0.0,
    this.borderRadius = 8.0,
  }) {
    _offset = markerSize / 2;
    _outlineWidth = _offset - (strokeWidth / 2) + padding;
    _fillWidth = markerSize / 2 + padding;
    final outlineCircleInnerWidth = markerSize - (2 * strokeWidth);
    _iconSize = sqrt(pow(outlineCircleInnerWidth, 2) / 2);
    final rectDiagonal = sqrt(2 * pow(markerSize, 2));
    final circleDistanceToCorners =
        (rectDiagonal - outlineCircleInnerWidth) / 2;
    _iconOffset = sqrt(pow(circleDistanceToCorners, 2) / 2);
  }

  final double markerSize;
  final double padding;
  final double strokeWidth;
  late final double _offset;
  late final double _outlineWidth;
  late final double _fillWidth;
  late final double _iconSize;
  late final double _iconOffset;
  final double borderRadius;

  Future<BitmapDescriptor?> createBitmapDescriptorFromIconData({
    required IconData iconData,
    required Color iconColor,
    required MarkerIconShape shape,
    Color? borderColor,
    Color? backgroundColor,
  }) async {
    final pictureRecorder = PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    if (shape == MarkerIconShape.rect) {
      if (backgroundColor != null) {
        _paintRRectFill(canvas, backgroundColor);
      }
      if (borderColor != null) {
        _paintRRectStroke(canvas, borderColor);
      }
    } else {
      if (backgroundColor != null) {
        _paintCircleFill(canvas, backgroundColor);
      }
      if (borderColor != null) {
        _paintCircleStroke(canvas, borderColor);
      }
    }
    _paintIcon(canvas, iconColor, iconData);

    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(markerSize.round(), markerSize.round());
    final bytes = await image.toByteData(format: ImageByteFormat.png);
    if (bytes == null) {
      return null;
    }
    return BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
  }

  void _paintCircleFill(Canvas canvas, Color color) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;
    canvas.drawCircle(Offset(_offset, _offset), _fillWidth, paint);
  }

  void _paintCircleStroke(Canvas canvas, Color color) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = color
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(Offset(_offset, _offset), _outlineWidth, paint);
  }

  void _paintRRectFill(Canvas canvas, Color color) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: Offset(_offset, _offset),
            width: _fillWidth,
            height: _fillWidth),
        Radius.circular(borderRadius),
      ),
      paint,
    );
  }

  void _paintRRectStroke(Canvas canvas, Color color) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..color = color
      ..strokeWidth = strokeWidth;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: Offset(_offset, _offset),
            width: _outlineWidth,
            height: _outlineWidth),
        Radius.circular(borderRadius),
      ),
      paint,
    );
  }

  void _paintIcon(Canvas canvas, Color color, IconData iconData) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
        text: String.fromCharCode(iconData.codePoint),
        style: TextStyle(
          letterSpacing: 0.0,
          fontSize: _iconSize,
          fontFamily: iconData.fontFamily,
          package: iconData.fontPackage,
          color: color,
        ));
    textPainter.layout();
    textPainter.paint(canvas, Offset(_iconOffset, _iconOffset));
  }
}
