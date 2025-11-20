part of "/masamune_markdown.dart";

/// Display the menu to exchange text blocks [MarkdownTools].
///
/// テキストブロックを変更するメニューを表示する[MarkdownTools]。
@immutable
class TextExchangeMarkdownBlockTools
    extends MarkdownBlockMultiLineVariableTools<MarkdownParagraphBlockValue> {
  /// Display the menu to exchange text blocks [MarkdownTools].
  ///
  /// テキストブロックを変更するメニューを表示する[MarkdownTools]。
  const TextExchangeMarkdownBlockTools({
    super.config = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "テキスト",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Text",
        ),
      ]),
      icon: Icons.title,
    ),
  });

  @override
  String get id => "__markdown_block_exchange_text__";

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
    if (currentBlock is MarkdownParagraphBlockValue) {
      return;
    }

    // Create new block preserving id, indent, and content
    final newBlock = MarkdownParagraphBlockValue(
      id: currentBlock.id,
      indent: currentBlock.indent,
      children: currentBlock.extractLines() ?? [],
    );

    // Exchange the block
    ref.controller.exchangeBlock(newBlock);
    ref.deleteMode();
  }

  @override
  MarkdownParagraphBlockValue? convertFromJson(DynamicMap json) {
    final type = json.get(MarkdownValue.typeKey, "");
    if (type != _kParagraphType) {
      return null;
    }
    return MarkdownParagraphBlockValue.fromJson(json);
  }

  @override
  ({MarkdownParagraphBlockValue? value, int linesConsumed})?
      convertFromMarkdown(
    MarkdownParseContext context,
  ) {
    return null;
  }

  @override
  MarkdownParagraphBlockValue createBlockValue({
    String? initialText,
    List<MarkdownLineValue>? children,
  }) {
    return MarkdownParagraphBlockValue.createEmpty(
      initialText: initialText,
      children: children,
    );
  }
}
