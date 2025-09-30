part of "/masamune_painter.dart";

/// Display the menu to select [PainterTools].
///
/// 選択メニューを表示する[PainterTools]。
@immutable
class SelectPainterInlineTools extends PainterInlineTools {
  /// Display the menu to select [PainterTools].
  ///
  /// 選択メニューを表示する[PainterTools]。
  const SelectPainterInlineTools({
    super.config = const PainterToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "選択",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Select",
        ),
      ]),
      icon: FontAwesomeIcons.arrowPointer,
    ),
  });

  @override
  String get id => "__painter_select_inline__";

  @override
  bool shown(BuildContext context, PainterToolRef ref) => true;

  @override
  bool enabled(BuildContext context, PainterToolRef ref) => true;

  @override
  bool actived(BuildContext context, PainterToolRef ref) {
    return ref.controller.currentValues.isNotEmpty ||
        ref.controller.currentTool is SelectPainterInlineTools ||
        ref.controller.currentTool is SelectPainterPrimaryTools ||
        ref.controller._prevTool is SelectPainterInlineTools ||
        ref.controller._prevTool is SelectPainterPrimaryTools;
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
    ref.deleteMode();
  }

  @override
  Future<void> onDeactive(BuildContext context, PainterToolRef ref) async {
    ref.controller.unselect();
    ref.deleteMode();
  }
}
