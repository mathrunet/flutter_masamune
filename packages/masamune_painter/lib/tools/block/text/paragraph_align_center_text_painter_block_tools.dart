part of "/masamune_painter.dart";

/// Display the menu to draw a center align [PainterTools].
///
/// 中央揃えを描画するメニューを表示する[PainterTools]。
@immutable
class ParagraphAlignCenterTextPainterBlockTools
    extends PainterParagraphAlignBlockTools {
  /// Display the menu to draw a center align [PainterTools].
  ///
  /// 中央揃えを描画するメニューを表示する[PainterTools]。
  const ParagraphAlignCenterTextPainterBlockTools({
    super.config = const PainterToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "中央揃え",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Center Align",
        ),
      ]),
      icon: Icons.line_weight,
    ),
  });

  @override
  String get id => "__painter_block_text_paragraph_align_center__";

  @override
  bool shown(BuildContext context, PainterToolRef ref) => true;

  @override
  bool enabled(BuildContext context, PainterToolRef ref) => true;

  @override
  bool actived(BuildContext context, PainterToolRef ref) {
    if (ref.controller.currentValues.isNotEmpty) {
      return ref.controller.property.currentValueParagraphAlign == this;
    } else {
      return ref.controller.property.currentToolParagraphAlign == this;
    }
  }

  @override
  Widget icon(BuildContext context, PainterToolRef ref) {
    final theme = Theme.of(context);
    return Container(
      height: 26,
      width: 26,
      decoration: BoxDecoration(
        border: Border.all(
            color: theme.colorTheme?.onBackground ?? Colors.transparent),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(
        Icons.format_align_center,
        size: 16,
        color: theme.colorTheme?.onBackground,
      ),
    );
  }

  @override
  Widget label(BuildContext context, PainterToolRef ref) {
    final locale = context.locale;
    return Text(config.title.value(locale) ?? "");
  }

  @override
  void onTap(BuildContext context, PainterToolRef ref) {
    if (ref.controller.currentValues.isNotEmpty) {
      ref.controller.property.setValues(paragraphAlign: this);
    } else {
      ref.controller.property.setTool(paragraphAlign: this);
    }
    final prevTool = ref.controller._prevTool;
    if (prevTool != null) {
      ref.toggleMode(prevTool);
    } else {
      ref.deleteMode();
    }
  }

  @override
  ui.TextAlign get paragraphAlign => ui.TextAlign.center;
}
