part of "/masamune_painter.dart";

/// Display the menu to select image from camera [PainterTools].
///
/// カメラから画像を選択するメニューを表示する[PainterTools]。
@immutable
class ImageFromCameraMediaPainterBlockTools extends PainterBlockTools {
  /// Display the menu to select image from camera [PainterTools].
  ///
  /// カメラから画像を選択するメニューを表示する[PainterTools]。
  const ImageFromCameraMediaPainterBlockTools({
    required this.onPickImage,
    super.config = const PainterToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "カメラから\n画像を選択",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Image\nfrom Camera",
        ),
      ]),
      icon: Icons.photo_camera,
    ),
  });

  /// Pick image from camera.
  ///
  /// カメラから画像を選択します。
  final Future<Uri?> Function(BuildContext context, PainterToolRef ref)
      onPickImage;

  @override
  String get id => "__painter_block_image_from_camera__";

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
  Future<void> onTap(BuildContext context, PainterToolRef ref) async {
    final uri = await onPickImage(context, ref);
    if (uri == null) {
      return;
    }
    await ref.controller.insertImage(uri);
  }
}
