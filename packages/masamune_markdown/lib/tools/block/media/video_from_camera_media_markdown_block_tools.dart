part of "/masamune_markdown.dart";

/// Display the menu to select video from camera [MarkdownTools].
///
/// カメラからビデオを選択するメニューを表示する[MarkdownTools]。
@immutable
class VideoFromCameraMediaMarkdownBlockTools extends MarkdownBlockTools {
  /// Display the menu to select video from camera [MarkdownTools].
  ///
  /// カメラからビデオを選択するメニューを表示する[MarkdownTools]。
  const VideoFromCameraMediaMarkdownBlockTools({
    super.config = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "カメラから\nビデオを選択",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Video\nfrom Camera",
        ),
      ]),
      icon: Icons.video_camera_back,
    ),
  });

  @override
  String get id => "__markdown_block_media_video_from_camera__";

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
