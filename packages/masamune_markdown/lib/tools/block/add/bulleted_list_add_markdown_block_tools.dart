part of "/masamune_markdown.dart";

/// Display the menu to add bulleted list blocks [MarkdownTools].
///
/// 箇条書きリストブロックを追加するメニューを表示する[MarkdownTools]。
@immutable
class BulletedListAddMarkdownBlockTools extends MarkdownBlockTools {
  /// Display the menu to add bulleted list blocks [MarkdownTools].
  ///
  /// 箇条書きリストブロックを追加するメニューを表示する[MarkdownTools]。
  const BulletedListAddMarkdownBlockTools({
    super.config = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "箇条書きリスト",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Bulleted List",
        ),
      ]),
      icon: FontAwesomeIcons.listUl,
    ),
  });

  @override
  String get id => "__markdown_block_add_bulleted_list__";

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
    ref.focusedController?.addFormattedLine(Attribute.ul);
    ref.deleteMode();
  }
}
