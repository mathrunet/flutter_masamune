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
  bool get canDraw => true;

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
