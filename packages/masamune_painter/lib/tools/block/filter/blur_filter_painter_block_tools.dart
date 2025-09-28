part of "/masamune_painter.dart";

/// Display the menu to add bulleted list blocks [PainterTools].
///
/// ぼかしフィルターを適用するメニューを表示する[PainterTools]。
@immutable
class BlurFilterPainterBlockTools extends PainterBlockTools {
  /// Display the menu to add bulleted list blocks [PainterTools].
  ///
  /// ぼかしフィルターを適用するメニューを表示する[PainterTools]。
  const BlurFilterPainterBlockTools({
    super.config = const PainterToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "ぼかし",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Blur",
        ),
      ]),
      icon: Icons.blender,
    ),
  });

  @override
  String get id => "__painter_block_filter_blur__";

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
  void onTap(BuildContext context, PainterToolRef ref) {
    ref.deleteMode();
  }
}
