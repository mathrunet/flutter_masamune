part of "/masamune_painter.dart";

/// Display the menu to undo [PainterTools].
///
/// 元に戻すメニューを表示する[PainterTools]。
@immutable
class ForegroundColorPainterPrimaryTools extends PainterPrimaryTools {
  /// Display the menu to undo [PainterTools].
  ///
  /// 元に戻すメニューを表示する[PainterTools]。
  const ForegroundColorPainterPrimaryTools({
    super.config = const PainterToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "前景色",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Foreground Color",
        ),
      ]),
      icon: Icons.border_color,
    ),
  });

  @override
  String get id => "__painter_foreground_color__";

  @override
  bool shown(BuildContext context, PainterToolRef ref) {
    return true;
  }

  @override
  bool enabled(BuildContext context, PainterToolRef ref) => true;

  @override
  bool actived(BuildContext context, PainterToolRef ref) {
    return false;
  }

  @override
  Widget icon(BuildContext context, PainterToolRef ref) {
    final disabled = ref.currentForegroundColor.a <= 0.0;
    final theme = Theme.of(context);
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        border: Border.all(
          color:
              Theme.of(context).colorTheme?.onBackground ?? Colors.transparent,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Opacity(
          opacity: disabled ? 0.25 : 1,
          child: ColoredBox(
            color: ref.currentForegroundColor,
            child: Icon(
              config.icon,
              size: 18,
              color: ref.currentForegroundColor.a < 0.5
                  ? theme.colorTheme?.onBackground ?? Colors.transparent
                  : ref.currentForegroundColor.computeLuminance() > 0.5
                      ? kBlackColor
                      : kWhiteColor,
            ),
          ),
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
  void onTap(BuildContext context, PainterToolRef ref) async {
    // カラーピッカーダイアログを表示
    await Modal.show(
      context,
      modal: ColorPickerModal(ref: ref, activeTool: this),
    );
  }
}
