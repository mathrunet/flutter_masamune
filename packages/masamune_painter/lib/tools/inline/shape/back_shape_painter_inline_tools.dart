part of "/masamune_painter.dart";

/// Display the menu to back shape [PainterTools].
///
/// 図形メニューから戻るメニューを表示する[PainterTools]。
@immutable
class BackShapePainterInlineTools extends PainterInlineTools {
  /// Display the menu to back shape [PainterTools].
  ///
  /// 図形メニューから戻るメニューを表示する[PainterTools]。
  const BackShapePainterInlineTools({
    super.config = const PainterToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "戻る",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Back",
        ),
      ]),
      icon: Icons.arrow_back_ios,
    ),
  });


  @override
  String get id => "__painter_shape_back__";

  @override
  bool shown(BuildContext context, PainterToolRef ref) => true;

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
  void onTap(BuildContext context, PainterToolRef ref) {}

  @override
  Future<void> onActive(BuildContext context, PainterToolRef ref) async {
    ref.deleteMode();
  }

  @override
  Future<void> onDeactive(BuildContext context, PainterToolRef ref) async {
    ref.deleteMode();
  }
}
