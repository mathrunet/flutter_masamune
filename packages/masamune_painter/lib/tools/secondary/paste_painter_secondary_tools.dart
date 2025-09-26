part of "/masamune_painter.dart";

/// Display the menu to paste drawing data [PainterTools].
///
/// 描画データを貼り付けるメニューを表示する[PainterTools]。
@immutable
class PastePainterSecondaryTools extends PainterSecondaryTools {
  /// Display the menu to paste drawing data [PainterTools].
  ///
  /// 描画データを貼り付けるメニューを表示する[PainterTools]。
  const PastePainterSecondaryTools({
    super.config = const PainterToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "貼り付け",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Paste",
        ),
      ]),
      icon: Icons.paste,
    ),
  });

  @override
  String get id => "__painter_paste__";

  @override
  bool shown(BuildContext context, PainterToolRef ref) {
    return ref.canPaste;
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
    ref.paste();
  }
}
