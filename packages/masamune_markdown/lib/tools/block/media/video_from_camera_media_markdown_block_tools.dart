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
    required this.onPickVideo,
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

  /// Pick video from camera.
  ///
  /// カメラからビデオを選択します。
  final Future<Uri?> Function(BuildContext context, MarkdownToolRef ref)
      onPickVideo;

  @override
  String get id => "__markdown_block_media_video_from_camera__";

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
}
