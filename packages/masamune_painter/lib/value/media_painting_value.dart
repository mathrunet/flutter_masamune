part of "/masamune_painter.dart";

/// A class for storing media drawing data.
///
/// メディア描画用のデータを格納するクラス。
@immutable
class MediaPaintingValue extends PaintingValue {
  /// A class for storing media drawing data.
  ///
  /// メディア描画用のデータを格納するクラス。
  const MediaPaintingValue({
    required super.id,
    required super.property,
    required super.start,
    required super.end,
    super.name,
    this.path,
  });

  /// The URI of the media.
  ///
  /// メディアのURI。
  final Uri? path;

  /// Create a [MediaPaintingValue] from a [DynamicMap].
  ///
  /// [DynamicMap]から[MediaPaintingValue]を作成します。
  factory MediaPaintingValue.fromJson(DynamicMap json) {
    final properties = PaintingProperty.fromJson(
      json.getAsMap(PaintingValue.propertyKey),
    );
    final path = json.get(PaintingValue.pathKey, "");
    return MediaPaintingValue(
      id: json.get(PaintingValue.idKey, ""),
      property: properties,
      name: json.get(PaintingValue.nameKey, nullOfString),
      start: Offset(
        json.get(PaintingValue.startXKey, 0.0),
        json.get(PaintingValue.startYKey, 0.0),
      ),
      end: Offset(
        json.get(PaintingValue.endXKey, 0.0),
        json.get(PaintingValue.endYKey, 0.0),
      ),
      path: path.isNotEmpty ? Uri.tryParse(path) : null,
    );
  }

  @override
  String get type => _kMediaPainterPrimaryToolsId;

  @override
  PaintingValueCategory get category => PaintingValueCategory.image;

  @override
  Rect get rect {
    return Rect.fromPoints(start, end);
  }

  @override
  double get minimumArea => 2500.0;

  @override
  Size get minimumSize => const Size(50, 50);

  @override
  DynamicMap toJson() {
    return {
      PaintingValue.typeKey: type,
      PaintingValue.idKey: id,
      PaintingValue.propertyKey: property.toJson(),
      PaintingValue.startXKey: start.dx,
      PaintingValue.startYKey: start.dy,
      PaintingValue.endXKey: end.dx,
      PaintingValue.endYKey: end.dy,
      PaintingValue.pathKey: path?.toString() ?? "",
      if (name != null) PaintingValue.nameKey: name,
    };
  }

  @override
  DynamicMap toDebug() {
    return {
      PaintingValue.typeKey: type,
      PaintingValue.propertyKey: property.toJson(),
      PaintingValue.startXKey: start.dx,
      PaintingValue.startYKey: start.dy,
      PaintingValue.endXKey: end.dx,
      PaintingValue.endYKey: end.dy,
      PaintingValue.pathKey: path?.toString() ?? "",
      if (name != null) PaintingValue.nameKey: name,
    };
  }

  @override
  MediaPaintingValue copyWith({
    Offset? offset,
    PaintingProperty? property,
    Offset? start,
    Offset? end,
    String? id,
    Uri? path,
    String? name,
  }) {
    return MediaPaintingValue(
      id: id ?? this.id,
      property: property ?? this.property,
      start: (start ?? this.start) + (offset ?? Offset.zero),
      end: (end ?? this.end) + (offset ?? Offset.zero),
      path: path ?? this.path,
      name: name ?? this.name,
    );
  }

  @override
  Rect? paint(Canvas canvas) {
    final path = this.path;
    final rect = Rect.fromPoints(start, end);

    if (rect.width.isNaN ||
        rect.height.isNaN ||
        rect.width.isInfinite ||
        rect.height.isInfinite) {
      return null;
    }

    // Draw media if uri is available
    if (path != null) {
      final database = PainterMasamuneAdapter.primary.mediaDatabase;
      final media = database.get(path.toString());
      if (media != null) {
        final paint = Paint()..filterQuality = FilterQuality.high;
        canvas.drawImageRect(
          media,
          Rect.fromLTWH(0, 0, media.width.toDouble(), media.height.toDouble()),
          rect,
          paint,
        );
      } else {
        // Draw placeholder
        _drawPlaceholder(canvas, rect);
      }
    } else {
      // Draw placeholder if no uri
      _drawPlaceholder(canvas, rect);
    }

    // Draw border if foreground color is set
    final foregroundColor = property.foregroundColor;
    final line = property.line;
    if (foregroundColor != null &&
        foregroundColor.a > 0.0 &&
        line != null &&
        line.strokeWidth > 0.0) {
      final paint = Paint()
        ..color = foregroundColor
        ..strokeWidth = line.strokeWidth
        ..style = PaintingStyle.stroke;

      canvas.drawRect(rect, paint);
    }
    return rect;
  }

  void _drawPlaceholder(Canvas canvas, Rect rect) {
    // 灰色の背景
    const backgroundColor = Color(0xFFBDBDBD);

    // Draw background
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawRect(rect, bgPaint);
  }

  @override
  MediaPaintingValue updateOnCreating({
    required Offset startPoint,
    required Offset currentPoint,
  }) {
    return MediaPaintingValue(
      id: id,
      property: property,
      start: startPoint,
      end: currentPoint,
      path: path,
      name: name,
    );
  }

  @override
  MediaPaintingValue updateOnMoving({required Offset delta}) {
    return MediaPaintingValue(
      id: id,
      property: property,
      start: start + delta,
      end: end + delta,
      path: path,
      name: name,
    );
  }

  @override
  MediaPaintingValue updateOnResizing({
    required Offset currentPoint,
    required PainterResizeDirection direction,
    required Offset startPoint,
    required Offset endPoint,
  }) {
    return MediaPaintingValue(
      id: id,
      property: property,
      start: startPoint,
      end: endPoint,
      path: path,
      name: name,
    );
  }

  @override
  Widget get icon => const Icon(FontAwesomeIcons.image);
}
