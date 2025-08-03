part of "/masamune_markdown.dart";

/// Display the menu to mention [MarkdownTools].
///
/// メンションを表示するメニューを表示する[MarkdownTools]。
@immutable
class MentionMarkdownPrimaryTools extends MarkdownPrimaryTools {
  /// Display the menu to mention [MarkdownTools].
  ///
  /// メンションを表示するメニューを表示する[MarkdownTools]。
  const MentionMarkdownPrimaryTools({
    super.config = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "メンション",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Mention",
        ),
      ]),
      icon: FontAwesomeIcons.at,
    ),
  });

  @override
  String get id => "__markdown_mention__";

  @override
  bool get hideKeyboardOnSelected => true;

  @override
  bool shown(BuildContext context, MarkdownToolRef ref) {
    return ref.mentionBuilder != null;
  }

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
}
