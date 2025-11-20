part of "/masamune_markdown.dart";

/// Display the menu to add quote blocks [MarkdownTools].
///
/// 引用ブロックを追加するメニューを表示する[MarkdownTools]。
@immutable
class QuoteAddMarkdownBlockTools
    extends MarkdownBlockMultiLineVariableTools<MarkdownQuoteBlockValue> {
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
    // Get current block to preserve indent
    final currentBlock = ref.controller.getCurrentBlock();

    // Create new block with preserved indent
    final newBlock = MarkdownQuoteBlockValue.createEmpty(
      indent: currentBlock?.indent ?? 0,
    );

    // Insert the block
    ref.controller.insertBlock(newBlock);
    ref.deleteMode();
  }

  @override
  MarkdownQuoteBlockValue? convertFromJson(DynamicMap json) {
    final type = json.get(MarkdownValue.typeKey, "");
    if (type != _kQuoteType) {
      return null;
    }
    return MarkdownQuoteBlockValue.fromJson(json);
  }

  @override
  ({MarkdownQuoteBlockValue? value, int linesConsumed})? convertFromMarkdown(
    MarkdownParseContext context,
  ) {
    return null;
  }

  @override
  MarkdownQuoteBlockValue createBlockValue({
    String? initialText,
    List<MarkdownLineValue>? children,
  }) {
    return MarkdownQuoteBlockValue.createEmpty(
      initialText: initialText,
      children: children,
    );
  }
}
