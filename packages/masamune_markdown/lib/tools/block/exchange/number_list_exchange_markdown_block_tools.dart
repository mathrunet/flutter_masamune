part of "/masamune_markdown.dart";

/// Display the menu to exchange numbered list blocks [MarkdownTools].
///
/// 番号付きリストブロックを変更するメニューを表示する[MarkdownTools]。
@immutable
class NumberListExchangeMarkdownBlockTools
    extends MarkdownBlockMultiLineVariableTools<MarkdownNumberListBlockValue> {
  /// Display the menu to exchange numbered list blocks [MarkdownTools].
  ///
  /// 番号付きリストブロックを変更するメニューを表示する[MarkdownTools]。
  const NumberListExchangeMarkdownBlockTools({
    super.config = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "番号付きリスト",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Numbered List",
        ),
      ]),
      icon: FontAwesomeIcons.listOl,
    ),
  });

  @override
  String get id => "__markdown_block_exchange_number_list__";

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
    if (currentBlock is MarkdownNumberListBlockValue) {
      return;
    }

    // Create new block preserving id, indent, and content
    // lineIndex is reset to 0 when exchanging to number list
    final newBlock = MarkdownNumberListBlockValue(
      id: currentBlock.id,
      indent: currentBlock.indent,
      children: currentBlock.extractLines() ?? [],
      lineIndex: 0,
    );

    // Exchange the block
    ref.controller.exchangeBlock(newBlock);
    ref.deleteMode();
  }

  @override
  MarkdownNumberListBlockValue? convertFromJson(DynamicMap json) {
    final type = json.get(MarkdownValue.typeKey, "");
    if (type != _kNumberListType) {
      return null;
    }
    return MarkdownNumberListBlockValue.fromJson(json);
  }

  @override
  ({MarkdownNumberListBlockValue? value, int linesConsumed})?
      convertFromMarkdown(
    MarkdownParseContext context,
  ) {
    final line = context.currentLine.trim();
    if (RegExp(r"^\d+[.)]?\s+").hasMatch(line)) {
      return (
        value: MarkdownNumberListBlockValue.fromMarkdown(context.currentLine),
        linesConsumed: 1,
      );
    }
    return null;
  }

  @override
  MarkdownNumberListBlockValue createBlockValue({
    String? initialText,
    List<MarkdownLineValue>? children,
  }) {
    return MarkdownNumberListBlockValue.createEmpty(
      initialText: initialText,
      children: children,
    );
  }
}
