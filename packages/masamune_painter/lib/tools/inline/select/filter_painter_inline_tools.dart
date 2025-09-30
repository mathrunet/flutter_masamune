part of "/masamune_painter.dart";

/// Display the menu to undo [PainterTools].
///
/// 元に戻すメニューを表示する[PainterTools]。
@immutable
class FilterPainterInlineTools extends PainterInlinePrimaryTools {
  /// Display the menu to undo [PainterTools].
  ///
  /// 元に戻すメニューを表示する[PainterTools]。
  const FilterPainterInlineTools({
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
  });

  @override
  List<PainterBlockTools> get blockTools => [
        const BlurFilterPainterBlockTools(),
      ];

  @override
  String get id => "__painter_filter__";

  @override
  bool shown(BuildContext context, PainterToolRef ref) {
    return true;
  }

  @override
  bool enabled(BuildContext context, PainterToolRef ref) => true;

  @override
  bool actived(BuildContext context, PainterToolRef ref) {
    return ref.currentTool is FilterPainterInlineTools;
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
    ref.toggleMode(this);
    ref.controller._prevTool = ref.currentTool;
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
