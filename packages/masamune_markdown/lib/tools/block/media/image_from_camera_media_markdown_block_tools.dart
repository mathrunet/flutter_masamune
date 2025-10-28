part of "/masamune_markdown.dart";

/// Display the menu to select image from camera [MarkdownTools].
///
/// カメラから画像を選択するメニューを表示する[MarkdownTools]。
@immutable
class ImageFromCameraMediaMarkdownBlockTools
    extends MarkdownBlockSingleChildVariableTools<Uri,
        MarkdownImageBlockValue> {
  /// Display the menu to select image from camera [MarkdownTools].
  ///
  /// カメラから画像を選択するメニューを表示する[MarkdownTools]。
  const ImageFromCameraMediaMarkdownBlockTools({
    required this.onPickImage,
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

  /// Pick image from camera.
  ///
  /// カメラから画像を選択します。
  final Future<Uri?> Function(BuildContext context, MarkdownToolRef ref)
      onPickImage;

  @override
  String get id => "__markdown_block_media_image_from_camera__";

  @override
  bool shown(BuildContext context, MarkdownToolRef ref) => true;

  @override
  bool enabled(BuildContext context, MarkdownToolRef ref) => true;

  @override
  bool actived(BuildContext context, MarkdownToolRef ref) => true;

  @override
  Widget icon(BuildContext context, MarkdownToolRef ref) {
    return Icon(config.icon);
  }

  @override
  Widget label(BuildContext context, MarkdownToolRef ref) {
    final locale = context.locale;
    return Text(config.title.value(locale) ?? "");
  }

  @override
  Future<void> onTap(BuildContext context, MarkdownToolRef ref) async {
    final uri = await onPickImage(context, ref);
    if (uri == null) {
      return;
    }
    ref.insertImage(uri);
    ref.deleteMode();
  }

  @override
  MarkdownBlockValue addBlock({MarkdownBlockValue? source}) {
    // TODO: implement addBlock
    throw UnimplementedError();
  }

  @override
  MarkdownBlockValue? exchangeBlock(MarkdownBlockValue target) {
    return null;
  }

  @override
  MarkdownImageBlockValue? convertFromJson(DynamicMap json) {
    // TODO: implement convertFromJson
    throw UnimplementedError();
  }

  @override
  MarkdownImageBlockValue? convertFromMarkdown(String markdown) {
    // TODO: implement convertFromMarkdown
    throw UnimplementedError();
  }

  @override
  DynamicMap? convertToJson(MarkdownImageBlockValue value) {
    // TODO: implement convertToJson
    throw UnimplementedError();
  }

  @override
  String? convertToMarkdown(MarkdownImageBlockValue value) {
    // TODO: implement convertToMarkdown
    throw UnimplementedError();
  }

  @override
  MarkdownImageBlockValue createBlockValue({String? initialText, Uri? child}) {
    // TODO: implement createBlockValue
    throw UnimplementedError();
  }
}
