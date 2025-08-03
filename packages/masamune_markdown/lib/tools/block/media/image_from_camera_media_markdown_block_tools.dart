part of "/masamune_markdown.dart";

/// Display the menu to select image from camera [MarkdownTools].
///
/// カメラから画像を選択するメニューを表示する[MarkdownTools]。
@immutable
class ImageFromCameraMediaMarkdownBlockTools extends MarkdownBlockTools {
  /// Display the menu to select image from camera [MarkdownTools].
  ///
  /// カメラから画像を選択するメニューを表示する[MarkdownTools]。
  const ImageFromCameraMediaMarkdownBlockTools({
    super.config = const MarkdownToolLabelConfig(
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

  @override
  String get id => "__markdown_block_media_image_from_camera__";

  @override
  bool shown(BuildContext context, MarkdownToolRef ref) => true;

  @override
  bool enabled(BuildContext context, MarkdownToolRef ref) => true;

  @override
  bool actived(BuildContext context, MarkdownToolRef ref) => true;

  @override
  IconData icon(BuildContext context) {
    return config.icon;
  }

  @override
  String label(BuildContext context) {
    final locale = context.locale;
    return config.title.value(locale) ?? "";
  }

  @override
  void onTap(BuildContext context, MarkdownToolRef ref) {
    
    ref.deleteMode();
  }
}
