part of "/masamune_markdown.dart";

/// Display the menu to add headline 3 blocks [MarkdownTools].
///
/// 見出し3ブロックを追加するメニューを表示する[MarkdownTools]。
@immutable
class Headline3AddMarkdownBlockTools extends MarkdownBlockTools {
  /// Display the menu to add headline 3 blocks [MarkdownTools].
  ///
  /// 見出し3ブロックを追加するメニューを表示する[MarkdownTools]。
  const Headline3AddMarkdownBlockTools({
    super.config = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "見出し3",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Heading 3",
        ),
      ]),
      icon: FontAwesomeIcons.heading,
    ),
  });

  @override
  String get id => "__markdown_block_add_headline_3__";

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
    ref.focusedController?.addFormattedLine(Attribute.h3);
    ref.deleteMode();
  }
}
