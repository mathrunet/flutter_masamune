part of "/masamune_markdown.dart";

/// Display the menu to add code blocks [MarkdownTools].
///
/// コードブロックを追加するメニューを表示する[MarkdownTools]。
@immutable
class CodeAddMarkdownBlockTools extends MarkdownBlockTools {
  /// Display the menu to add code blocks [MarkdownTools].
  ///
  /// コードブロックを追加するメニューを表示する[MarkdownTools]。
  const CodeAddMarkdownBlockTools({
    super.config = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "コード",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Code",
        ),
      ]),
      icon: FontAwesomeIcons.code,
    ),
  });

  @override
  String get id => "__markdown_block_add_code__";

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
  void onTap(BuildContext context, MarkdownToolRef ref) {
    ref.controller.insertBlock(this);
    ref.deleteMode();
  }
}
