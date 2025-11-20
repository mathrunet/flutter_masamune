part of "/masamune_markdown.dart";

/// Display the menu to add headline 1 blocks [MarkdownTools].
///
/// 見出し1ブロックを追加するメニューを表示する[MarkdownTools]。
@immutable
class Headline1AddMarkdownBlockTools
    extends MarkdownBlockMultiLineVariableTools<MarkdownHeadline1BlockValue> {
  /// Display the menu to add headline 1 blocks [MarkdownTools].
  ///
  /// 見出し1ブロックを追加するメニューを表示する[MarkdownTools]。
  const Headline1AddMarkdownBlockTools({
    super.config = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "見出し1",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Heading 1",
        ),
      ]),
      icon: FontAwesomeIcons.heading,
    ),
  });

  @override
  String get id => "__markdown_block_add_headline_1__";

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
    final newBlock = MarkdownHeadline1BlockValue.createEmpty(
      indent: currentBlock?.indent ?? 0,
    );

    // Insert the block
    ref.controller.insertBlock(newBlock);
    ref.deleteMode();
  }

  @override
  MarkdownHeadline1BlockValue? convertFromJson(DynamicMap json) {
    final type = json.get(MarkdownValue.typeKey, "");
    if (type != _kHeadline1Type) {
      return null;
    }
    return MarkdownHeadline1BlockValue.fromJson(json);
  }

  @override
  ({MarkdownHeadline1BlockValue? value, int linesConsumed})?
      convertFromMarkdown(
    MarkdownParseContext context,
  ) {
    final line = context.currentLine.trim();
    if (line.startsWith("# ")) {
      return (
        value: MarkdownHeadline1BlockValue.fromMarkdown(context.currentLine),
        linesConsumed: 1,
      );
    }
    return null;
  }

  @override
  MarkdownHeadline1BlockValue createBlockValue({
    String? initialText,
    List<MarkdownLineValue>? children,
  }) {
    return MarkdownHeadline1BlockValue.createEmpty(
      initialText: initialText,
      children: children,
    );
  }
}
