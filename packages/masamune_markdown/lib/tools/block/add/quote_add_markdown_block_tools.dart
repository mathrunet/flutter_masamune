part of "/masamune_markdown.dart";

/// Display the menu to add quote blocks [MarkdownTools].
///
/// 引用ブロックを追加するメニューを表示する[MarkdownTools]。
@immutable
class QuoteAddMarkdownBlockTools extends MarkdownBlockTools {
  /// Display the menu to add quote blocks [MarkdownTools].
  ///
  /// 引用ブロックを追加するメニューを表示する[MarkdownTools]。
  const QuoteAddMarkdownBlockTools({
    super.config = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "引用",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Quote",
        ),
      ]),
      icon: FontAwesomeIcons.quoteLeft,
    ),
  });

  @override
  String get id => "__markdown_block_add_quote__";

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
    ref.focusedController?.addFormattedLine(Attribute.blockQuote);
    ref.deleteMode();
  }
}
