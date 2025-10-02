part of "/masamune_painter.dart";

/// Display line properties [PainterTools].
///
/// 線のプロパティを表示する[PainterTools]。
@immutable
class LinePropertyPainterInlineTools extends PainterInlinePrimaryTools {
  /// Display line properties [PainterTools].
  ///
  /// 線のプロパティを表示する[PainterTools]。
  const LinePropertyPainterInlineTools({
    super.config = const PainterToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "線",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Line",
        ),
      ]),
      icon: FontAwesomeIcons.line,
    ),
    this.blockTools = const [
      Solid1pxLinePainterBlockTools(),
      Solid10pxLinePainterBlockTools(),
    ],
  });

  @override
  final List<PainterBlockTools> blockTools;

  @override
  String get id => "__painter_property_line__";

  @override
  bool shown(BuildContext context, PainterToolRef ref) {
    final inlineMode = ref.inlineMode;
    if (inlineMode == PainterInlineMode.select) {
      final values = ref.controller.currentValues;
      if (values.any((e) =>
          e.category == PaintingValueCategory.shape ||
          e.category == PaintingValueCategory.image)) {
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
    return ref.controller.currentTool is LinePropertyPainterInlineTools;
  }

  @override
  Widget icon(BuildContext context, PainterToolRef ref) {
    if (ref.controller.currentValues.isNotEmpty) {
      final theme = Theme.of(context);
      return ref.controller.property.currentValueLine?.icon(context, ref) ??
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
      return ref.controller.property.currentToolLine.icon(context, ref);
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
