part of "/masamune_painter.dart";

/// Display paragraph align properties [PainterTools].
///
/// 段落揃えのプロパティを表示する[PainterTools]。
@immutable
class ParagraphAlignPropertyPainterInlineTools
    extends PainterInlinePrimaryTools {
  /// Display paragraph align properties [PainterTools].
  ///
  /// 段落揃えのプロパティを表示する[PainterTools]。
  const ParagraphAlignPropertyPainterInlineTools({
    super.config = const PainterToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "段落揃え",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Paragraph Align",
        ),
      ]),
      icon: FontAwesomeIcons.paragraph,
    ),
    this.blockTools = const [
      ParagraphAlignLeftTextPainterBlockTools(),
      ParagraphAlignCenterTextPainterBlockTools(),
      ParagraphAlignRightTextPainterBlockTools(),
      ParagraphAlignJustifyTextPainterBlockTools(),
    ],
  });

  @override
  final List<PainterBlockTools> blockTools;

  @override
  String get id => "__painter_property_paragraph_align__";

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
    return ref.controller.currentTool
        is ParagraphAlignPropertyPainterInlineTools;
  }

  @override
  Widget icon(BuildContext context, PainterToolRef ref) {
    final theme = Theme.of(context);
    if (ref.controller.currentValues.isNotEmpty) {
      return ref.controller.property.currentValueParagraphAlign
              ?.icon(context, ref) ??
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
      return ref.controller.property.currentToolParagraphAlign
              ?.icon(context, ref) ??
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
    // 他のPainterInlinePrimaryToolsから切り替える場合は_prevToolを保持
    final currentTool = ref.controller.currentTool;
    final shouldPreservePrevTool =
        currentTool is PainterInlinePrimaryTools && currentTool != this;
    final prevToolToPreserve =
        shouldPreservePrevTool ? ref.controller._prevTool : currentTool;
    ref.toggleMode(this);
    ref.controller._prevTool = prevToolToPreserve;
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
