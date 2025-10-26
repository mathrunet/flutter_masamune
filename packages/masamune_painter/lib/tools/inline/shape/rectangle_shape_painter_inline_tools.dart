part of "/masamune_painter.dart";

const _kRectangleShapePainterInlineToolsId = "__painter_shape_rectangle__";

/// Display the menu to draw a rectangle [PainterTools].
///
/// 四角形を描画するメニューを表示する[PainterTools]。
@immutable
class RectangleShapePainterInlineTools
    extends PainterVariableInlineTools<RectanglePaintingValue> {
  /// Display the menu to draw a rectangle [PainterTools].
  ///
  /// 四角形を描画するメニューを表示する[PainterTools]。
  const RectangleShapePainterInlineTools({
    super.config = const PainterToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "四角形",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Rectangle",
        ),
      ]),
      icon: Icons.rectangle,
    ),
  });

  @override
  String get id => _kRectangleShapePainterInlineToolsId;

  @override
  bool shown(BuildContext context, PainterToolRef ref) => true;

  @override
  bool enabled(BuildContext context, PainterToolRef ref) => true;

  @override
  bool actived(BuildContext context, PainterToolRef ref) {
    return ref.controller.currentTool == null;
  }

  @override
  Widget icon(BuildContext context, PainterToolRef ref) {
    final theme = Theme.of(context);
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        border: Border.all(
          color: theme.dividerColor,
          width: 2,
        ),
      ),
    );
  }

  @override
  Widget label(BuildContext context, PainterToolRef ref) {
    final locale = context.locale;
    return Text(config.title.value(locale) ?? "");
  }

  @override
  void onTap(BuildContext context, PainterToolRef ref) {}

  @override
  Future<void> onActive(BuildContext context, PainterToolRef ref) async {
    ref.unselect();
    ref.toggleMode(this);
  }

  @override
  Future<void> onDeactive(BuildContext context, PainterToolRef ref) async {
    ref.deleteMode();
  }

  @override
  bool get canDraw => true;

  @override
  RectanglePaintingValue create({
    required Offset point,
    required PaintingProperty property,
    String? uid,
  }) {
    return RectanglePaintingValue(
      id: uid ?? uuid(),
      property: property,
      start: point,
      end: point,
    );
  }

  @override
  RectanglePaintingValue? convertFromJson(DynamicMap json) {
    final type = json.get(PaintingValue.typeKey, "");
    if (type == _kRectangleShapePainterInlineToolsId) {
      return RectanglePaintingValue.fromJson(json);
    }
    return null;
  }

  @override
  DynamicMap? convertToJson(PaintingValue value) {
    if (value is RectanglePaintingValue) {
      return value.toJson();
    }
    return null;
  }
}

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
