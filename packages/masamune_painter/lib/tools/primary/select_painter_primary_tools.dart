part of "/masamune_painter.dart";

/// Display the menu to select drawing data [PainterTools].
///
/// 描画データを選択するメニューを表示する[PainterTools]。
@immutable
class SelectPainterPrimaryTools extends PainterPrimaryTools {
  /// Display the menu to select drawing data [PainterTools].
  ///
  /// 描画データを選択するメニューを表示する[PainterTools]。
  const SelectPainterPrimaryTools({
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
    this.inlineTools = const [
      SelectPainterInlineTools(),
      BackgroundColorPainterInlineTools(),
      ForegroundColorPainterInlineTools(),
      LinePainterInlineTools(),
      GroupPainterInlineTools(),
      FilterPainterInlineTools(),
    ],
  });

  /// Inline tools for select painter.
  ///
  /// 選択ツールのインラインツール。
  @override
  final List<PainterInlineTools> inlineTools;

  @override
  String get id => "__painter_select__";

  @override
  bool shown(BuildContext context, PainterToolRef ref) {
    return true;
  }

  @override
  bool enabled(BuildContext context, PainterToolRef ref) => true;

  @override
  bool actived(BuildContext context, PainterToolRef ref) {
    return ref.currentValues.isNotEmpty ||
        ref.currentTool is SelectPainterPrimaryTools;
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
    if (ref.currentTool is SelectPainterPrimaryTools ||
        ref.controller._prevTool is SelectPainterPrimaryTools) {
      ref.controller.unselect();
      ref.deleteMode();
    } else {
      ref.toggleMode(this);
    }
  }

  @override
  bool get unselectOnDone => false;
}
