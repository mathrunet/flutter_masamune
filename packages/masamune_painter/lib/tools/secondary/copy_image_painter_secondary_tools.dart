part of "/masamune_painter.dart";

/// Display the menu to copy drawing data as image [PainterTools].
///
/// 描画データを画像としてコピーするメニューを表示する[PainterTools]。
@immutable
class CopyImagePainterSecondaryTools extends PainterSecondaryTools {
  /// Display the menu to copy drawing data as image [PainterTools].
  ///
  /// 描画データを画像としてコピーするメニューを表示する[PainterTools]。
  const CopyImagePainterSecondaryTools({
    super.config = const PainterToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "画像としてコピー",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Copy as Image",
        ),
      ]),
      icon: Icons.image,
    ),
  });

  @override
  String get id => "__painter_copy_image__";

  @override
  bool shown(BuildContext context, PainterToolRef ref) {
    return ref.currentValues.isNotEmpty;
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
    ref.copyAsImage();
  }
}
