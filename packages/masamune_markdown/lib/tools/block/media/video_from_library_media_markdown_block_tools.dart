part of "/masamune_markdown.dart";

/// Display the menu to select video from library [MarkdownTools].
///
/// ライブラリからビデオを選択するメニューを表示する[MarkdownTools]。
@immutable
class VideoFromLibraryMediaMarkdownBlockTools extends MarkdownBlockTools {
  /// Display the menu to select video from library [MarkdownTools].
  ///
  /// ライブラリからビデオを選択するメニューを表示する[MarkdownTools]。
  const VideoFromLibraryMediaMarkdownBlockTools({
    required this.onPickVideo,
    super.config = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "ライブラリから\nビデオを選択",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Video\nfrom Library",
        ),
      ]),
      icon: Icons.video_library,
    ),
  });

  /// Pick video from camera.
  ///
  /// カメラからビデオを選択します。
  final Future<Uri?> Function(BuildContext context, MarkdownToolRef ref)
      onPickVideo;

  @override
  String get id => "__markdown_block_media_video_from_library__";

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
    final uri = await onPickVideo(context, ref);
    if (uri == null) {
      return;
    }
    ref.insertVideo(uri);
    ref.deleteMode();
  }

  @override
  MarkdownBlockValue? exchangeBlock(MarkdownBlockValue target) {
    return null;
  }
}
