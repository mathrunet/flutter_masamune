part of "/masamune_painter.dart";

const _kEllipseShapePainterInlineToolsId = "__painter_shape_ellipse__";

/// Display the menu to draw an ellipse [PainterTools].
///
/// 楕円を描画するメニューを表示する[PainterTools]。
@immutable
class EllipseShapePainterInlineTools
    extends PainterVariableInlineTools<EllipsePaintingValue> {
  /// Display the menu to draw an ellipse [PainterTools].
  ///
  /// 楕円を描画するメニューを表示する[PainterTools]。
  const EllipseShapePainterInlineTools({
    super.config = const PainterToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "円",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Circle",
        ),
      ]),
      icon: Icons.circle,
    ),
  });

  @override
  String get id => _kEllipseShapePainterInlineToolsId;

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
        shape: BoxShape.circle,
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
  EllipsePaintingValue create({
    required Offset point,
    required PaintingProperty property,
    String? uid,
  }) {
    return EllipsePaintingValue(
      id: uid ?? uuid(),
      property: property,
      start: point,
      end: point,
    );
  }

  @override
  EllipsePaintingValue? convertFromJson(DynamicMap json) {
    final type = json.get(PaintingValue.typeKey, "");
    if (type == _kEllipseShapePainterInlineToolsId) {
      return EllipsePaintingValue.fromJson(json);
    }
    return null;
  }

  @override
  DynamicMap? convertToJson(PaintingValue value) {
    if (value is EllipsePaintingValue) {
      return value.toJson();
    }
    return null;
  }
}

/// A class for storing ellipse drawing data.
///
/// 楕円描画用のデータを格納するクラス。
@immutable
class EllipsePaintingValue extends PaintingValue {
  /// A class for storing ellipse drawing data.
  ///
  /// 楕円描画用のデータを格納するクラス。
  const EllipsePaintingValue({
    required super.id,
    required super.property,
    required super.start,
    required super.end,
    super.name,
  });

  /// Create a [EllipsePaintingValue] from a [DynamicMap].
  ///
  /// [DynamicMap]から[EllipsePaintingValue]を作成します。
  factory EllipsePaintingValue.fromJson(DynamicMap json) {
    final properties = PaintingProperty.fromJson(
      json.getAsMap(PaintingValue.propertyKey),
    );
    return EllipsePaintingValue(
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
  String get type => _kEllipseShapePainterInlineToolsId;

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
  EllipsePaintingValue copyWith({
    Offset? offset,
    PaintingProperty? property,
    Offset? start,
    Offset? end,
    String? id,
    String? name,
  }) {
    return EllipsePaintingValue(
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

    // 塗りつぶしの楕円を描画
    if (backgroundColor != null && backgroundColor.a > 0.0) {
      final paint = Paint()
        ..color = backgroundColor
        ..strokeWidth = line?.strokeWidth ?? 0.0
        ..style = PaintingStyle.fill;
      canvas.drawOval(rect, paint);
    }

    // 線の楕円を描画
    if (foregroundColor != null &&
        foregroundColor.a > 0.0 &&
        line != null &&
        line.strokeWidth > 0.0) {
      final paint = Paint()
        ..color = foregroundColor
        ..strokeWidth = line.strokeWidth
        ..style = PaintingStyle.stroke;

      canvas.drawOval(rect, paint);
    }
    return rect;
  }

  @override
  EllipsePaintingValue updateOnCreating({
    required Offset startPoint,
    required Offset currentPoint,
  }) {
    return EllipsePaintingValue(
      id: id,
      property: property,
      start: startPoint,
      end: currentPoint,
      name: name,
    );
  }

  @override
  EllipsePaintingValue updateOnMoving({required Offset delta}) {
    return EllipsePaintingValue(
      id: id,
      property: property,
      start: start + delta,
      end: end + delta,
      name: name,
    );
  }

  @override
  EllipsePaintingValue updateOnResizing({
    required Offset currentPoint,
    required PainterResizeDirection direction,
    required Offset startPoint,
    required Offset endPoint,
  }) {
    return EllipsePaintingValue(
      id: id,
      property: property,
      start: startPoint,
      end: endPoint,
      name: name,
    );
  }

  @override
  Widget get icon => const Icon(Icons.circle);
}
