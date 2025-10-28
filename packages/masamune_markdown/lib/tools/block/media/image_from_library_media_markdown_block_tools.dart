part of "/masamune_markdown.dart";

/// Display the menu to select image from library [MarkdownTools].
///
/// ライブラリから画像を選択するメニューを表示する[MarkdownTools]。
@immutable
class ImageFromLibraryMediaMarkdownBlockTools
    extends MarkdownBlockSingleChildVariableTools<Uri,
        MarkdownImageBlockValue> {
  /// Display the menu to select image from library [MarkdownTools].
  ///
  /// ライブラリから画像を選択するメニューを表示する[MarkdownTools]。
  const ImageFromLibraryMediaMarkdownBlockTools({
    required this.onPickImage,
    super.config = const MarkdownToolLabelConfig(
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

  /// Pick image from camera.
  ///
  /// カメラから画像を選択します。
  final Future<Uri?> Function(BuildContext context, MarkdownToolRef ref)
      onPickImage;

  @override
  String get id => "__markdown_block_media_image_from_library__";

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
    return createBlockValue();
  }

  @override
  MarkdownBlockValue? exchangeBlock(MarkdownBlockValue target) {
    return null;
  }

  @override
  MarkdownImageBlockValue? convertFromJson(DynamicMap json) {
    final type = json.get(MarkdownValue.typeKey, "");
    if (type != _kImageBlockType) {
      return null;
    }
    return MarkdownImageBlockValue.fromJson(json);
  }

  @override
  MarkdownImageBlockValue? convertFromMarkdown(String markdown) {
    return null;
  }

  @override
  MarkdownImageBlockValue createBlockValue({String? initialText, Uri? child}) {
    return MarkdownImageBlockValue.createEmpty(uri: child);
  }
}
