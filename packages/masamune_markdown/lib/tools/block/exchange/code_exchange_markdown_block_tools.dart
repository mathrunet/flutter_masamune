part of "/masamune_markdown.dart";

/// Display the menu to exchange code blocks [MarkdownTools].
///
/// コードブロックを変更するメニューを表示する[MarkdownTools]。
@immutable
class CodeExchangeMarkdownBlockTools
    extends MarkdownBlockMultiLineVariableTools<MarkdownCodeBlockValue> {
  /// Display the menu to exchange code blocks [MarkdownTools].
  ///
  /// コードブロックを変更するメニューを表示する[MarkdownTools]。
  const CodeExchangeMarkdownBlockTools({
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
  String get id => "__markdown_block_exchange_code__";

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
    if (currentBlock is MarkdownCodeBlockValue) {
      return;
    }

    // Create new block preserving id, indent, and content
    final newBlock = MarkdownCodeBlockValue(
      id: currentBlock.id,
      indent: currentBlock.indent,
      children: currentBlock.extractLines() ?? [],
    );

    // Exchange the block
    ref.controller.exchangeBlock(newBlock);
    ref.deleteMode();
  }

  @override
  MarkdownCodeBlockValue? convertFromJson(DynamicMap json) {
    final type = json.get(MarkdownValue.typeKey, "");
    if (type != _kCodeBlockType) {
      return null;
    }
    return MarkdownCodeBlockValue.fromJson(json);
  }

  @override
  ({MarkdownCodeBlockValue? value, int linesConsumed})? convertFromMarkdown(
    MarkdownParseContext context,
  ) {
    return null;
  }

  @override
  MarkdownCodeBlockValue createBlockValue({
    String? initialText,
    List<MarkdownLineValue>? children,
  }) {
    return MarkdownCodeBlockValue.createEmpty(
      initialText: initialText,
      children: children,
    );
  }
}
