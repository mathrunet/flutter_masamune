part of "/masamune_painter.dart";

/// Display the menu to draw a 14px font [PainterTools].
///
/// 14pxフォントを描画するメニューを表示する[PainterTools]。
@immutable
class Size14pxFontPainterBlockTools extends PainterFontSizeBlockTools {
  /// Display the menu to draw a 14px font [PainterTools].
  ///
  /// 14pxフォントを描画するメニューを表示する[PainterTools]。
  const Size14pxFontPainterBlockTools({
    super.config = const PainterToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "14px",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "14px",
        ),
      ]),
      icon: Icons.line_weight,
    ),
  });

  @override
  String get id => "__painter_block_text_size_14px__";

  @override
  bool shown(BuildContext context, PainterToolRef ref) => true;

  @override
  bool enabled(BuildContext context, PainterToolRef ref) => true;

  @override
  bool actived(BuildContext context, PainterToolRef ref) {
    if (ref.controller.currentValues.isNotEmpty) {
      return ref.controller.property.currentValueFontSize == this;
    } else {
      return ref.controller.property.currentToolFontSize == this;
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
      ref.controller.property.setValues(fontSize: this);
    } else {
      ref.controller.property.setTool(fontSize: this);
    }
    final prevTool = ref.controller._prevTool;
    if (prevTool != null) {
      ref.toggleMode(prevTool);
    } else {
      ref.deleteMode();
    }
  }

  @override
  double get fontSize => 14.0;

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
          "14px",
          style: theme.textTheme.labelSmall?.smallize(3),
        ),
      ),
    );
  }
}
