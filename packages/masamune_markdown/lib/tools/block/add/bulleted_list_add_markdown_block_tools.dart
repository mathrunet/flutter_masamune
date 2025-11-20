part of "/masamune_markdown.dart";

/// Display the menu to add bulleted list blocks [MarkdownTools].
///
/// 箇条書きリストブロックを追加するメニューを表示する[MarkdownTools]。
@immutable
class BulletedListAddMarkdownBlockTools
    extends MarkdownBlockMultiLineVariableTools<
        MarkdownBulletedListBlockValue> {
  /// Display the menu to add bulleted list blocks [MarkdownTools].
  ///
  /// 箇条書きリストブロックを追加するメニューを表示する[MarkdownTools]。
  const BulletedListAddMarkdownBlockTools({
    super.config = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "箇条書きリスト",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Bulleted List",
        ),
      ]),
      icon: FontAwesomeIcons.listUl,
    ),
  });

  @override
  String get id => "__markdown_block_add_bulleted_list__";

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
    final newBlock = MarkdownBulletedListBlockValue.createEmpty(
      indent: currentBlock?.indent ?? 0,
    );

    // Insert the block
    ref.controller.insertBlock(newBlock);
    ref.deleteMode();
  }

  @override
  MarkdownBulletedListBlockValue? convertFromJson(DynamicMap json) {
    final type = json.get(MarkdownValue.typeKey, "");
    if (type != _kBulletedListType) {
      return null;
    }
    return MarkdownBulletedListBlockValue.fromJson(json);
  }

  @override
  ({MarkdownBulletedListBlockValue? value, int linesConsumed})?
      convertFromMarkdown(
    MarkdownParseContext context,
  ) {
    final line = context.currentLine.trim();
    if (RegExp(r"^[-*+]\s+").hasMatch(line)) {
      return (
        value: MarkdownBulletedListBlockValue.fromMarkdown(context.currentLine),
        linesConsumed: 1,
      );
    }
    return null;
  }

  @override
  MarkdownBulletedListBlockValue createBlockValue({
    String? initialText,
    List<MarkdownLineValue>? children,
  }) {
    return MarkdownBulletedListBlockValue.createEmpty(
      initialText: initialText,
      children: children,
    );
  }
}
