part of "/masamune_painter.dart";

/// A class for storing rectangle drawing data.
///
/// 四角形描画用のデータを格納するクラス。
@immutable
class RectanglePaintingValue extends PaintingValue {
  /// A class for storing rectangle drawing data.
  ///
  /// 四角形描画用のデータを格納するクラス。
  const RectanglePaintingValue({
    required super.id,
    required super.property,
    required super.start,
    required super.end,
    super.name,
  });

  /// Create a [RectanglePaintingValue] from a [DynamicMap].
  ///
  /// [DynamicMap]から[RectanglePaintingValue]を作成します。
  factory RectanglePaintingValue.fromJson(DynamicMap json) {
    final properties = PaintingProperty.fromJson(
      json.getAsMap(PaintingValue.propertyKey),
    );
    return RectanglePaintingValue(
      id: json.get(PaintingValue.idKey, ""),
      property: properties,
      start: Offset(
        json.get(PaintingValue.startXKey, 0.0),
        json.get(PaintingValue.startYKey, 0.0),
      ),
      end: Offset(
        json.get(PaintingValue.endXKey, 0.0),
        json.get(PaintingValue.endYKey, 0.0),
      ),
      name: json.get(PaintingValue.nameKey, nullOfString),
    );
  }

  @override
  String get type => _kRectangleShapePainterInlineToolsId;

  @override
  PaintingValueCategory get category => PaintingValueCategory.shape;

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
      if (name != null) PaintingValue.nameKey: name,
    };
  }

  @override
  RectanglePaintingValue copyWith({
    Offset? offset,
    PaintingProperty? property,
    Offset? start,
    Offset? end,
    String? id,
    String? name,
  }) {
    return RectanglePaintingValue(
      id: id ?? this.id,
      property: property ?? this.property,
      start: (start ?? this.start) + (offset ?? Offset.zero),
      end: (end ?? this.end) + (offset ?? Offset.zero),
      name: name ?? this.name,
    );
  }

  @override
  Rect? paint(Canvas canvas) {
    final rect = Rect.fromPoints(start, end);

    if (rect.width.isNaN ||
        rect.height.isNaN ||
        rect.width.isInfinite ||
        rect.height.isInfinite) {
      return null;
    }

    final backgroundColor = property.backgroundColor;
    final foregroundColor = property.foregroundColor;
    final line = property.line;
    if ((backgroundColor == null || backgroundColor.a <= 0.0) &&
        (foregroundColor == null || foregroundColor.a <= 0.0 || line == null)) {
      return rect;
    }

    // 塗りつぶしの四角を描画
    if (backgroundColor != null && backgroundColor.a > 0.0) {
      final paint = Paint()
        ..color = backgroundColor
        ..strokeWidth = line?.strokeWidth ?? 0.0
        ..style = PaintingStyle.fill;
      canvas.drawRect(rect, paint);
    }

    // 線の四角を描画
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

  @override
  RectanglePaintingValue updateOnCreating({
    required Offset startPoint,
    required Offset currentPoint,
  }) {
    return RectanglePaintingValue(
      id: id,
      property: property,
      start: startPoint,
      end: currentPoint,
      name: name,
    );
  }

  @override
  RectanglePaintingValue updateOnMoving({required Offset delta}) {
    return RectanglePaintingValue(
      id: id,
      property: property,
      start: start + delta,
      end: end + delta,
      name: name,
    );
  }

  @override
  RectanglePaintingValue updateOnResizing({
    required Offset currentPoint,
    required PainterResizeDirection direction,
    required Offset startPoint,
    required Offset endPoint,
  }) {
    return RectanglePaintingValue(
      id: id,
      property: property,
      start: startPoint,
      end: endPoint,
      name: name,
    );
  }

  @override
  Widget get icon => const Icon(Icons.rectangle);
}
