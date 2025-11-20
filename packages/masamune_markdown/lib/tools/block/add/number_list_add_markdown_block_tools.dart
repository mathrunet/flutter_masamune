part of "/masamune_markdown.dart";

/// Display the menu to add numbered list blocks [MarkdownTools].
///
/// 番号付きリストブロックを追加するメニューを表示する[MarkdownTools]。
@immutable
class NumberListAddMarkdownBlockTools
    extends MarkdownBlockMultiLineVariableTools<MarkdownNumberListBlockValue> {
  /// Display the menu to add numbered list blocks [MarkdownTools].
  ///
  /// 番号付きリストブロックを追加するメニューを表示する[MarkdownTools]。
  const NumberListAddMarkdownBlockTools({
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
  String get id => "__markdown_block_add_number_list__";

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
    // Get current block to preserve indent and calculate line index
    final currentBlock = ref.controller.getCurrentBlock();

    // Get line index based on previous number list blocks
    var lineIndex = 0;
    if (currentBlock is MarkdownNumberListBlockValue) {
      lineIndex = currentBlock.lineIndex + 1;
    }

    // Create new block with preserved indent and calculated line index
    final newBlock = MarkdownNumberListBlockValue.createEmpty(
      indent: currentBlock?.indent ?? 0,
      lineIndex: lineIndex,
    );

    // Insert the block
    ref.controller.insertBlock(newBlock);
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
