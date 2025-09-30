part of "/masamune_painter.dart";

/// Display font size properties [PainterTools].
///
/// フォントサイズのプロパティを表示する[PainterTools]。
@immutable
class FontSizePropertyPainterInlineTools extends PainterInlinePrimaryTools {
  /// Display font size properties [PainterTools].
  ///
  /// フォントサイズのプロパティを表示する[PainterTools]。
  const FontSizePropertyPainterInlineTools({
    super.config = const PainterToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "フォントサイズ",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Font Size",
        ),
      ]),
      icon: FontAwesomeIcons.font,
    ),
    this.blockTools = const [
      Size10pxFontPainterBlockTools(),
      Size12pxFontPainterBlockTools(),
      Size14pxFontPainterBlockTools(),
      Size16pxFontPainterBlockTools(),
      Size18pxFontPainterBlockTools(),
      Size20pxFontPainterBlockTools(),
    ],
  });

  @override
  final List<PainterBlockTools> blockTools;

  @override
  String get id => "__painter_property_font_size__";

  @override
  bool shown(BuildContext context, PainterToolRef ref) {
    final inlineMode = ref.toolInlineMode;
    if (inlineMode == PainterToolInlineMode.select) {
      final values = ref.controller.currentValues;
      if (values.any((e) => e.category == PaintingValueCategory.text)) {
        return true;
      }
      return false;
    }
    return true;
  }

  @override
  bool enabled(BuildContext context, PainterToolRef ref) => true;

  @override
  bool actived(BuildContext context, PainterToolRef ref) {
    return ref.controller.currentTool is FontSizePropertyPainterInlineTools;
  }

  @override
  Widget icon(BuildContext context, PainterToolRef ref) {
    final theme = Theme.of(context);
    if (ref.controller.currentValues.isNotEmpty) {
      return ref.controller.property.currentValueFontSize?.icon(context, ref) ??
          Container(
            height: 26,
            width: 26,
            decoration: BoxDecoration(
              border: Border.all(
                  color: theme.colorTheme?.onBackground ?? Colors.transparent),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Stack(
              children: [
                Center(
                  child: Opacity(
                    opacity: 0.25,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("???",
                            style: theme.textTheme.labelSmall?.smallize(3)),
                        Container(
                          height: 1,
                          color: theme.colorTheme?.onBackground,
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Icon(
                    Icons.question_mark,
                    size: 18,
                    color: theme.colorTheme?.onBackground ?? Colors.transparent,
                  ),
                ),
              ],
            ),
          );
    } else {
      return ref.controller.property.currentToolFontSize?.icon(context, ref) ??
          Container(
            height: 26,
            width: 26,
            decoration: BoxDecoration(
              border: Border.all(
                  color: theme.colorTheme?.onBackground ?? Colors.transparent),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Stack(
              children: [
                Center(
                  child: Opacity(
                    opacity: 0.25,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("???",
                            style: theme.textTheme.labelSmall?.smallize(3)),
                        Container(
                          height: 1,
                          color: theme.colorTheme?.onBackground,
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Icon(
                    Icons.question_mark,
                    size: 18,
                    color: theme.colorTheme?.onBackground ?? Colors.transparent,
                  ),
                ),
              ],
            ),
          );
    }
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
    final prevTool = ref.controller.currentTool;
    ref.toggleMode(this);
    ref.controller._prevTool = prevTool;
  }

  @override
  Future<void> onDeactive(BuildContext context, PainterToolRef ref) async {
    final prevTool = ref.controller._prevTool;
    if (prevTool != null) {
      ref.toggleMode(prevTool);
    } else {
      ref.toggleMode(this);
    }
  }
}
