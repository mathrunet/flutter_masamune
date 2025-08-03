part of "/masamune_markdown.dart";

/// Display the menu to add media [MarkdownTools].
///
/// メディアを追加するメニューを表示する[MarkdownTools]。
@immutable
class MediaMarkdownPrimaryTools extends MarkdownPrimaryTools {
  /// Display the menu to add media [MarkdownTools].
  ///
  /// メディアを追加するメニューを表示する[MarkdownTools]。
  const MediaMarkdownPrimaryTools({
    super.config = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "メディア",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Media",
        ),
      ]),
      icon: Icons.image,
    ),
    this.tools = const [
      ImageFromCameraMediaMarkdownBlockTools(),
      ImageFromLibraryMediaMarkdownBlockTools(),
      VideoFromCameraMediaMarkdownBlockTools(),
      VideoFromLibraryMediaMarkdownBlockTools(),
    ],
  });

  /// Tools for adding media.
  ///
  /// メディアを追加するツール。
  final List<MarkdownBlockTools> tools;

  @override
  String get id => "__markdown_media_add__";

  @override
  bool get hideKeyboardOnSelected => true;

  @override
  bool shown(BuildContext context, MarkdownToolRef ref) => true;

  @override
  bool enabled(BuildContext context, MarkdownToolRef ref) {
    return ref.focusedSelection != null;
  }

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
    ref.toggleMode(this);
  }

  @override
  List<MarkdownBlockTools> get blockTools => tools;
}
