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
      icon: Icons.format_color_fill,
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
    final disabled = ref.currentForegroundColor == Colors.transparent;
    return Opacity(
      opacity: disabled ? 0.25 : 1,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorTheme?.onBackground ??
                Colors.transparent,
            width: 1,
          ),
          color: ref.currentForegroundColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(config.icon, size: 18),
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
    ref.setProperty(foregroundColor: ref.currentForegroundColor);
  }
}
