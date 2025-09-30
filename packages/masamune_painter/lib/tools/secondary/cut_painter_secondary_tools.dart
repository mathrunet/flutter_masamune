part of "/masamune_painter.dart";

/// Display the menu to cut drawing data [PainterTools].
///
/// 描画データを切り取るメニューを表示する[PainterTools]。
@immutable
class CutPainterSecondaryTools extends PainterSecondaryTools {
  /// Display the menu to cut drawing data [PainterTools].
  ///
  /// 描画データを切り取るメニューを表示する[PainterTools]。
  const CutPainterSecondaryTools({
    super.config = const PainterToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "切り取り",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Cut",
        ),
      ]),
      icon: Icons.cut,
    ),
  });

  @override
  String get id => "__painter_cut__";

  @override
  bool shown(BuildContext context, PainterToolRef ref) {
    return ref.controller.currentValues.isNotEmpty;
  }

  @override
  bool enabled(BuildContext context, PainterToolRef ref) => true;

  @override
  bool actived(BuildContext context, PainterToolRef ref) => false;

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
    ref.cut();
  }
}
