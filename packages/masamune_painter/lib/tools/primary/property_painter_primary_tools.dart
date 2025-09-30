part of "/masamune_painter.dart";

/// Display the menu to select drawing property [PainterTools].
///
/// 描画プロパティを選択するメニューを表示する[PainterTools]。
@immutable
class PropertyPainterPrimaryTools extends PainterPrimaryTools {
  /// Display the menu to select drawing property [PainterTools].
  ///
  /// 描画プロパティを選択するメニューを表示する[PainterTools]。
  const PropertyPainterPrimaryTools({
    super.config = const PainterToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "プロパティ",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Property",
        ),
      ]),
      icon: Icons.settings,
    ),
    this.inlineTools = const [
      BackPainterInlineTools(),
      BackgroundColorPainterInlineTools(),
      ForegroundColorPainterInlineTools(),
      LinePainterInlineTools(),
    ],
  });

  /// Inline tools for select painter.
  ///
  /// 選択ツールのインラインツール。
  @override
  final List<PainterInlineTools> inlineTools;

  @override
  String get id => "__painter_property__";

  @override
  bool shown(BuildContext context, PainterToolRef ref) {
    return true;
  }

  @override
  bool enabled(BuildContext context, PainterToolRef ref) => true;

  @override
  bool actived(BuildContext context, PainterToolRef ref) {
    return ref.currentTool is SelectPainterPrimaryTools;
  }

  @override
  Widget icon(BuildContext context, PainterToolRef ref) {
    final theme = Theme.of(context);
    final foregroundColor = ref.currentToolForegroundColor;
    final backgroundColor = ref.currentToolBackgroundColor;
    final line = ref.currentToolLine;
    return Container(
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorTheme?.onBackground.withValues(alpha: 0.5) ??
              Colors.transparent,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: backgroundColor,
          border: Border.all(
            color: foregroundColor,
            width: 3,
          ),
        ),
        child: line.strokeIcon(
          context,
          ref,
          color: backgroundColor.a < 0.5
              ? theme.colorTheme?.onBackground ?? Colors.transparent
              : backgroundColor.computeLuminance() > 0.5
                  ? kBlackColor
                  : kWhiteColor,
        ),
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
    ref.toggleMode(this);
  }

  @override
  bool get canSelect => true;
}
