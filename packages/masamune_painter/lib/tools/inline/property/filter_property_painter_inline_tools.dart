part of "/masamune_painter.dart";

/// Display filter properties [PainterTools].
///
/// フィルターのプロパティを表示する[PainterTools]。
@immutable
class FilterPropertyPainterInlineTools extends PainterInlinePrimaryTools {
  /// Display filter properties [PainterTools].
  ///
  /// フィルターのプロパティを表示する[PainterTools]。
  const FilterPropertyPainterInlineTools({
    super.config = const PainterToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "フィルター",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Filter",
        ),
      ]),
      icon: Icons.filter_list,
    ),
    this.blockTools = const [
      BlurFilterPainterBlockTools(),
    ],
  });

  @override
  final List<PainterBlockTools> blockTools;

  @override
  String get id => "__painter_property_filter__";

  @override
  bool shown(BuildContext context, PainterToolRef ref) {
    final inlineMode = ref.toolInlineMode;
    if (inlineMode == PainterToolInlineMode.select) {
      final values = ref.controller.currentValues;
      if (values.any((e) => e.category == PaintingValueCategory.shape)) {
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
    return ref.controller.currentTool is FilterPropertyPainterInlineTools;
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
