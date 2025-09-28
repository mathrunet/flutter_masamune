part of "/masamune_painter.dart";

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
  String get id => "__painter_shape_rectangle__";

  @override
  bool shown(BuildContext context, PainterToolRef ref) => true;

  @override
  bool enabled(BuildContext context, PainterToolRef ref) => true;

  @override
  bool actived(BuildContext context, PainterToolRef ref) {
    return ref.currentTool == null;
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
  RectanglePaintingValue create(
      {required Color color,
      required double width,
      required Offset point,
      String? uid}) {
    return RectanglePaintingValue(
      id: uid ?? uuid(),
      color: color,
      width: width,
      start: point,
      end: point,
    );
  }

  @override
  RectanglePaintingValue? convertFromJson(DynamicMap json) {
    final type = json.get(PaintingValue.typeKey, "");
    if (type == id) {
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
    required super.color,
    required super.width,
    required super.start,
    required super.end,
  }) : super(filled: false);

  /// Create a [RectanglePaintingValue] from a [DynamicMap].
  ///
  /// [DynamicMap]から[RectanglePaintingValue]を作成します。
  factory RectanglePaintingValue.fromJson(DynamicMap json) {
    return RectanglePaintingValue(
      id: json.get(PaintingValue.idKey, ""),
      color: Color(json.getAsInt(PaintingValue.colorKey)),
      width: json.get(PaintingValue.widthKey, 1.0),
      start: Offset(
        json.get(PaintingValue.startXKey, 0.0),
        json.get(PaintingValue.startYKey, 0.0),
      ),
      end: Offset(
        json.get(PaintingValue.endXKey, 0.0),
        json.get(PaintingValue.endYKey, 0.0),
      ),
    );
  }

  @override
  String get type => "__painter_shape_rectangle__";

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
      PaintingValue.colorKey: color.toInt(),
      PaintingValue.widthKey: width,
      PaintingValue.filledKey: false,
      PaintingValue.startXKey: start.dx,
      PaintingValue.startYKey: start.dy,
      PaintingValue.endXKey: end.dx,
      PaintingValue.endYKey: end.dy,
    };
  }

  @override
  RectanglePaintingValue copyWith({
    Offset? offset,
    Color? color,
    double? width,
    bool? filled,
    Offset? start,
    Offset? end,
    String? id,
  }) {
    return RectanglePaintingValue(
      id: id ?? this.id,
      color: color ?? this.color,
      width: width ?? this.width,
      start: (start ?? this.start) + (offset ?? Offset.zero),
      end: (end ?? this.end) + (offset ?? Offset.zero),
    );
  }

  @override
  Rect? paint(Canvas canvas) {
    final rect = Rect.fromPoints(start, end);

    // 四角形を描画
    final paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke;

    if (rect.width.isNaN ||
        rect.height.isNaN ||
        rect.width.isInfinite ||
        rect.height.isInfinite) {
      return null;
    }

    canvas.drawRect(rect, paint);
    return rect;
  }

  @override
  RectanglePaintingValue updateOnCreating({
    required Offset startPoint,
    required Offset currentPoint,
  }) {
    return RectanglePaintingValue(
      id: id,
      color: color,
      width: width,
      start: startPoint,
      end: currentPoint,
    );
  }

  @override
  PaintingValue updateOnMoving({required Offset delta}) {
    return RectanglePaintingValue(
      id: id,
      color: color,
      width: width,
      start: start + delta,
      end: end + delta,
    );
  }

  @override
  PaintingValue updateOnResizing({
    required Offset currentPoint,
    required PainterResizeDirection direction,
    required Offset startPoint,
    required Offset endPoint,
  }) {
    return RectanglePaintingValue(
      id: id,
      color: color,
      width: width,
      start: startPoint,
      end: endPoint,
    );
  }
}
