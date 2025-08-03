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

  @override
  String get id => "__markdown_block_media_video_from_library__";

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
