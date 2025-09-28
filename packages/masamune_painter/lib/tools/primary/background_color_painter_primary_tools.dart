part of "/masamune_painter.dart";

/// Display the menu to undo [PainterTools].
///
/// 元に戻すメニューを表示する[PainterTools]。
@immutable
class BackgroundColorPainterPrimaryTools extends PainterPrimaryTools {
  /// Display the menu to undo [PainterTools].
  ///
  /// 元に戻すメニューを表示する[PainterTools]。
  const BackgroundColorPainterPrimaryTools({
    super.config = const PainterToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "背景色",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Background Color",
        ),
      ]),
      icon: Icons.border_color,
    ),
  });

  @override
  String get id => "__painter_background_color__";

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
    final disabled = ref.currentBackgroundColor == Colors.transparent;
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
          color: ref.currentBackgroundColor,
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
    ref.setProperty(backgroundColor: ref.currentBackgroundColor);
  }
}
