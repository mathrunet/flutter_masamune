part of "/masamune_markdown.dart";

/// Display the menu to exchange quote blocks [MarkdownTools].
///
/// 引用ブロックを変更するメニューを表示する[MarkdownTools]。
@immutable
class QuoteExchangeMarkdownBlockTools
    extends MarkdownBlockMultiLineVariableTools<MarkdownQuoteBlockValue> {
  /// Display the menu to exchange quote blocks [MarkdownTools].
  ///
  /// 引用ブロックを変更するメニューを表示する[MarkdownTools]。
  const QuoteExchangeMarkdownBlockTools({
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
  String get id => "__markdown_block_exchange_quote__";

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
    // Get current block
    final currentBlock = ref.controller.getCurrentBlock<MarkdownBlockValue>();

    if (currentBlock == null) {
      return;
    }

    // Don't exchange if already the correct type
    if (currentBlock is MarkdownQuoteBlockValue) {
      return;
    }

    // Create new block preserving id, indent, and content
    final newBlock = MarkdownQuoteBlockValue(
      id: currentBlock.id,
      indent: currentBlock.indent,
      children: currentBlock.extractLines() ?? [],
    );

    // Exchange the block
    ref.controller.exchangeBlock(newBlock);
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
    final line = context.currentLine.trim();

    // Check if this is a quote line (starts with >)
    if (!line.startsWith(">")) {
      return null;
    }

    // Collect consecutive quote lines
    final quoteLines = <String>[];
    var consumed = 0;

    while (context.currentIndex + consumed < context.lines.length) {
      final nextLine = context.lines[context.currentIndex + consumed].trim();

      // Stop if line doesn't start with >
      if (!nextLine.startsWith(">")) {
        break;
      }

      // Remove the > prefix and add the content
      quoteLines.add(nextLine.substring(1).trim());
      consumed++;
    }

    // Build the full markdown string for parsing
    final quoteContent = quoteLines.join("\n");
    final fullMarkdown = "> $quoteContent";

    return (
      value: MarkdownQuoteBlockValue.fromMarkdown(fullMarkdown),
      linesConsumed: consumed,
    );
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
