part of "/masamune_painter.dart";

const _kTextPainterPrimaryToolsId = "__painter_text__";

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
    this.inlineTools = const [
      TextPainterInlineTools(),
      ForegroundPropertyColorPainterInlineTools(),
      FontSizePropertyPainterInlineTools(),
      FontStylePropertyPainterInlineTools(),
      ParagraphAlignPropertyPainterInlineTools(),
    ],
  });

  @override
  final List<PainterInlineTools> inlineTools;

  @override
  String get id => _kTextPainterPrimaryToolsId;

  @override
  bool shown(BuildContext context, PainterToolRef ref) => true;

  @override
  bool enabled(BuildContext context, PainterToolRef ref) => true;

  @override
  bool actived(BuildContext context, PainterToolRef ref) {
    return ref.controller.currentTool is TextPainterInlineTools ||
        ref.controller.currentTool is TextPainterPrimaryTools;
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
  TextPaintingValue create({
    required Offset point,
    required PaintingProperty property,
    String? uid,
  }) {
    return TextPaintingValue(
      id: uid ?? uuid(),
      property: property,
      start: point,
      end: point,
    );
  }

  @override
  TextPaintingValue? convertFromJson(DynamicMap json) {
    final type = json.get(PaintingValue.typeKey, "");
    if (type == _kTextPainterPrimaryToolsId) {
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
    required super.property,
    required super.start,
    required super.end,
    this.text = "",
  });

  /// The text content.
  ///
  /// テキストコンテンツ。
  final String text;

  /// Create a [TextPaintingValue] from a [DynamicMap].
  ///
  /// [DynamicMap]から[TextPaintingValue]を作成します。
  factory TextPaintingValue.fromJson(DynamicMap json) {
    final properties = PaintingProperty.fromJson(
      json.getAsMap(PaintingValue.propertyKey),
    );
    return TextPaintingValue(
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
      text: json.get(textKey, ""),
    );
  }

  /// The key for the text.
  ///
  /// テキストのキー。
  static const String textKey = "text";

  @override
  String get type => _kTextPainterPrimaryToolsId;

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
    return {
      PaintingValue.typeKey: type,
      PaintingValue.idKey: id,
      PaintingValue.propertyKey: property.toJson(),
      PaintingValue.startXKey: start.dx,
      PaintingValue.startYKey: start.dy,
      PaintingValue.endXKey: end.dx,
      PaintingValue.endYKey: end.dy,
      textKey: text,
    };
  }

  @override
  TextPaintingValue copyWith({
    Offset? offset,
    PaintingProperty? property,
    Offset? start,
    Offset? end,
    String? id,
    String? text,
  }) {
    return TextPaintingValue(
      id: id ?? this.id,
      property: property ?? this.property,
      start: (start ?? this.start) + (offset ?? Offset.zero),
      end: (end ?? this.end) + (offset ?? Offset.zero),
      text: text ?? this.text,
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

    final foregroundColor = property.foregroundColor;

    // テキストを描画
    if (text.isNotEmpty && foregroundColor != null && foregroundColor.a > 0.0) {
      final fontSize = property.fontSize?.fontSize ?? 16.0;
      final fontStyle = property.fontStyle;
      final paragraphAlign = property.paragraphAlign;

      // TextStyleを作成
      final textStyle = TextStyle(
        color: foregroundColor,
        fontSize: fontSize,
        fontWeight: fontStyle?.fontWeight ?? FontWeight.normal,
      );

      // TextAlignを設定
      final textAlign = paragraphAlign?.paragraphAlign ?? TextAlign.left;

      // TextSpanを作成
      final textSpan = TextSpan(
        text: text,
        style: textStyle,
      );

      // TextPainterを作成
      final textPainter = TextPainter(
        text: textSpan,
        textAlign: textAlign,
        textDirection: TextDirection.ltr,
      );

      // レイアウトを実行（横幅を制約）
      textPainter.layout(
        minWidth: 0,
        maxWidth: rect.width,
      );

      // テキストを描画
      textPainter.paint(canvas, Offset(rect.left, rect.top));
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
      property: property,
      start: startPoint,
      end: currentPoint,
      text: text,
    );
  }

  @override
  TextPaintingValue updateOnMoving({required Offset delta}) {
    return TextPaintingValue(
      id: id,
      property: property,
      start: start + delta,
      end: end + delta,
      text: text,
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
      property: property,
      start: startPoint,
      end: endPoint,
      text: text,
    );
  }
}
