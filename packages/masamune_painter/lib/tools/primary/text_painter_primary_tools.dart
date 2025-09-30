part of "/masamune_painter.dart";

/// Display the menu to select text [PainterTools].
///
/// テキストを選択するメニューを表示する[PainterTools]。
@immutable
class TextPainterPrimaryTools
    extends PainterVariablePrimaryTools<TextPaintingValue> {
  /// Display the menu to select text [PainterTools].
  ///
  /// テキストを選択するメニューを表示する[PainterTools]。
  const TextPainterPrimaryTools({
    super.config = const PainterToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "テキスト",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Text",
        ),
      ]),
      icon: FontAwesomeIcons.font,
    ),
  });

  @override
  String get id => "__painter_text__";

  @override
  bool shown(BuildContext context, PainterToolRef ref) => true;

  @override
  bool enabled(BuildContext context, PainterToolRef ref) => true;

  @override
  bool actived(BuildContext context, PainterToolRef ref) {
    return ref.currentTool is TextPainterInlineTools ||
        ref.currentTool is TextPainterPrimaryTools;
  }

  @override
  Widget icon(BuildContext context, PainterToolRef ref) {
    return Icon(config.icon);
  }

  @override
  Widget label(BuildContext context, PainterToolRef ref) {
    final locale = context.locale;
    return Text(config.title.value(locale) ?? "");
  }

  @override
  void onTap(BuildContext context, PainterToolRef ref) {
    ref.toggleMode(this);
  }

  @override
  TextPaintingValue create(
      {required Offset point,
      Color? backgroundColor,
      Color? foregroundColor,
      PainterLineBlockTools? tool,
      String? uid}) {
    return TextPaintingValue(
      id: uid ?? uuid(),
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      tool: tool,
      start: point,
      end: point,
    );
  }

  @override
  TextPaintingValue? convertFromJson(DynamicMap json) {
    final type = json.get(PaintingValue.typeKey, "");
    if (type == id) {
      return TextPaintingValue.fromJson(json);
    }
    return null;
  }

  @override
  DynamicMap? convertToJson(PaintingValue value) {
    if (value is TextPaintingValue) {
      return value.toJson();
    }
    return null;
  }
}

/// A class for storing text drawing data.
///
/// テキスト描画用のデータを格納するクラス。
@immutable
class TextPaintingValue extends PaintingValue {
  /// A class for storing text drawing data.
  ///
  /// テキスト描画用のデータを格納するクラス。
  const TextPaintingValue({
    required super.id,
    required super.backgroundColor,
    required super.foregroundColor,
    required super.tool,
    required super.start,
    required super.end,
  });

  /// Create a [TextPaintingValue] from a [DynamicMap].
  ///
  /// [DynamicMap]から[TextPaintingValue]を作成します。
  factory TextPaintingValue.fromJson(DynamicMap json) {
    final backgroundColor =
        json.get(PaintingValue.backgroundColorKey, nullOfNum)?.toInt();
    final foregroundColor =
        json.get(PaintingValue.foregroundColorKey, nullOfNum)?.toInt();
    final toolId = json.get(PaintingValue.toolKey, "");
    final lineTool =
        PainterMasamuneAdapter.primary.defaultPrimaryTools.firstWhereOrNull(
      (e) => e is LinePropertyPainterInlineTools,
    );
    final lineTools = lineTool?.blockTools?.whereType<PainterLineBlockTools>();
    final tool = lineTools?.firstWhereOrNull((e) => e.id == toolId);
    return TextPaintingValue(
      id: json.get(PaintingValue.idKey, ""),
      backgroundColor: backgroundColor != null ? Color(backgroundColor) : null,
      foregroundColor: foregroundColor != null ? Color(foregroundColor) : null,
      tool: tool,
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
  String get type => "__painter_shape_text__";

  @override
  PaintingValueCategory get category => PaintingValueCategory.text;

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
    final backgroundColor = this.backgroundColor?.toInt();
    final foregroundColor = this.foregroundColor?.toInt();
    return {
      PaintingValue.typeKey: type,
      PaintingValue.idKey: id,
      if (backgroundColor != null)
        PaintingValue.backgroundColorKey: backgroundColor,
      if (foregroundColor != null)
        PaintingValue.foregroundColorKey: foregroundColor,
      PaintingValue.toolKey: tool?.id,
      PaintingValue.filledKey: false,
      PaintingValue.startXKey: start.dx,
      PaintingValue.startYKey: start.dy,
      PaintingValue.endXKey: end.dx,
      PaintingValue.endYKey: end.dy,
    };
  }

  @override
  TextPaintingValue copyWith({
    Offset? offset,
    Color? backgroundColor,
    Color? foregroundColor,
    PainterLineBlockTools? tool,
    Offset? start,
    Offset? end,
    String? id,
  }) {
    return TextPaintingValue(
      id: id ?? this.id,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      tool: tool ?? this.tool,
      start: (start ?? this.start) + (offset ?? Offset.zero),
      end: (end ?? this.end) + (offset ?? Offset.zero),
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

    final backgroundColor = this.backgroundColor;
    final foregroundColor = this.foregroundColor;
    if ((backgroundColor == null || backgroundColor.a <= 0.0) &&
        (foregroundColor == null || foregroundColor.a <= 0.0 || tool == null)) {
      return rect;
    }

    // 塗りつぶしの四角を描画
    if (backgroundColor != null && backgroundColor.a > 0.0) {
      final paint = Paint()
        ..color = backgroundColor
        ..strokeWidth = tool?.strokeWidth ?? 1.0
        ..style = PaintingStyle.fill;
      canvas.drawRect(rect, paint);
    }

    // 線の四角を描画
    if (foregroundColor != null && foregroundColor.a > 0.0 && tool != null) {
      final paint = Paint()
        ..color = foregroundColor
        ..strokeWidth = tool?.strokeWidth ?? 1.0
        ..style = PaintingStyle.stroke;

      canvas.drawRect(rect, paint);
    }
    return rect;
  }

  @override
  TextPaintingValue updateOnCreating({
    required Offset startPoint,
    required Offset currentPoint,
  }) {
    return TextPaintingValue(
      id: id,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      tool: tool,
      start: startPoint,
      end: currentPoint,
    );
  }

  @override
  TextPaintingValue updateOnMoving({required Offset delta}) {
    return TextPaintingValue(
      id: id,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      tool: tool,
      start: start + delta,
      end: end + delta,
    );
  }

  @override
  TextPaintingValue updateOnResizing({
    required Offset currentPoint,
    required PainterResizeDirection direction,
    required Offset startPoint,
    required Offset endPoint,
  }) {
    return TextPaintingValue(
      id: id,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      tool: tool,
      start: startPoint,
      end: endPoint,
    );
  }
}
