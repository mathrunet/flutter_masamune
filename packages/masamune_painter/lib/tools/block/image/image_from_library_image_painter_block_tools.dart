part of "/masamune_painter.dart";

/// Display the menu to select image from library [PainterTools].
///
/// ライブラリから画像を選択するメニューを表示する[PainterTools]。
@immutable
class ImageFromLibraryImagePainterBlockTools extends PainterBlockTools {
  /// Display the menu to select image from library [PainterTools].
  ///
  /// ライブラリから画像を選択するメニューを表示する[PainterTools]。
  const ImageFromLibraryImagePainterBlockTools({
    required this.onPickImage,
    super.config = const PainterToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "ライブラリから\n画像を選択",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Image\nfrom Library",
        ),
      ]),
      icon: Icons.photo_library,
    ),
  });

  /// Pick image from library.
  ///
  /// ライブラリから画像を選択します。
  final Future<Uri?> Function(BuildContext context, PainterToolRef ref)
      onPickImage;

  @override
  String get id => "__painter_block_image_from_library__";

  @override
  bool shown(BuildContext context, PainterToolRef ref) => true;

  @override
  bool enabled(BuildContext context, PainterToolRef ref) => true;

  @override
  bool actived(BuildContext context, PainterToolRef ref) => true;

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
  Future<void> onTap(BuildContext context, PainterToolRef ref) async {
    final uri = await onPickImage(context, ref);
    if (uri == null) {
      return;
    }
    await ref.controller.insertImage(uri);
    ref.deleteMode();
  }
}
