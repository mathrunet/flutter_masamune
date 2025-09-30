part of "/masamune_painter.dart";

/// Display the menu to draw a normal font [PainterTools].
///
/// 標準フォントを描画するメニューを表示する[PainterTools]。
@immutable
class StyleNormalFontPainterBlockTools extends PainterFontStyleBlockTools {
  /// Display the menu to draw a normal font [PainterTools].
  ///
  /// 標準フォントを描画するメニューを表示する[PainterTools]。
  const StyleNormalFontPainterBlockTools({
    super.config = const PainterToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "標準",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Normal",
        ),
      ]),
      icon: Icons.line_weight,
    ),
  });

  @override
  String get id => "__painter_block_text_style_normal__";

  @override
  bool shown(BuildContext context, PainterToolRef ref) => true;

  @override
  bool enabled(BuildContext context, PainterToolRef ref) => true;

  @override
  bool actived(BuildContext context, PainterToolRef ref) {
    if (ref.controller.currentValues.isNotEmpty) {
      return ref.controller.property.currentValueFontStyle == this;
    } else {
      return ref.controller.property.currentToolFontStyle == this;
    }
  }

  @override
  Widget label(BuildContext context, PainterToolRef ref) {
    final locale = context.locale;
    return Text(config.title.value(locale) ?? "");
  }

  @override
  void onTap(BuildContext context, PainterToolRef ref) {
    if (ref.controller.currentValues.isNotEmpty) {
      ref.controller.property.setValues(fontStyle: this);
    } else {
      ref.controller.property.setTool(fontStyle: this);
    }
    final prevTool = ref.controller._prevTool;
    if (prevTool != null) {
      ref.toggleMode(prevTool);
    } else {
      ref.deleteMode();
    }
  }

  @override
  FontWeight get fontWeight => FontWeight.normal;

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
      child: Center(
        child: Text(
          "N",
          style: theme.textTheme.labelMedium,
        ),
      ),
    );
  }
}
