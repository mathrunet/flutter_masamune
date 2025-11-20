part of "/masamune_markdown.dart";

/// Display the menu to exchange headline 3 blocks [MarkdownTools].
///
/// 見出し3ブロックを変更するメニューを表示する[MarkdownTools]。
@immutable
class Headline3ExchangeMarkdownBlockTools
    extends MarkdownBlockMultiLineVariableTools<MarkdownHeadline3BlockValue> {
  /// Display the menu to exchange headline 3 blocks [MarkdownTools].
  ///
  /// 見出し3ブロックを変更するメニューを表示する[MarkdownTools]。
  const Headline3ExchangeMarkdownBlockTools({
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
  String get id => "__markdown_block_exchange_headline_3__";

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
    if (currentBlock is MarkdownHeadline3BlockValue) {
      return;
    }

    // Create new block preserving id, indent, and content
    final newBlock = MarkdownHeadline3BlockValue(
      id: currentBlock.id,
      indent: currentBlock.indent,
      children: currentBlock.extractLines() ?? [],
    );

    // Exchange the block
    ref.controller.exchangeBlock(newBlock);
    ref.deleteMode();
  }

  @override
  MarkdownHeadline3BlockValue? convertFromJson(DynamicMap json) {
    final type = json.get(MarkdownValue.typeKey, "");
    if (type != _kHeadline3Type) {
      return null;
    }
    return MarkdownHeadline3BlockValue.fromJson(json);
  }

  @override
  ({MarkdownHeadline3BlockValue? value, int linesConsumed})?
      convertFromMarkdown(
    MarkdownParseContext context,
  ) {
    final line = context.currentLine.trim();
    if (line.startsWith("### ")) {
      return (
        value: MarkdownHeadline3BlockValue.fromMarkdown(context.currentLine),
        linesConsumed: 1,
      );
    }
    return null;
  }

  @override
  MarkdownHeadline3BlockValue createBlockValue({
    String? initialText,
    List<MarkdownLineValue>? children,
  }) {
    return MarkdownHeadline3BlockValue.createEmpty(
      initialText: initialText,
      children: children,
    );
  }
}
