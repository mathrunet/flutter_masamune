part of "/masamune_markdown.dart";

/// Display the menu to add toggle list blocks [MarkdownTools].
///
/// チェックボックスリストブロックを追加するメニューを表示する[MarkdownTools]。
@immutable
class ToggleListAddMarkdownBlockTools
    extends MarkdownBlockMultiLineVariableTools<MarkdownToggleListBlockValue> {
  /// Display the menu to add toggle list blocks [MarkdownTools].
  ///
  /// チェックボックスリストブロックを追加するメニューを表示する[MarkdownTools]。
  const ToggleListAddMarkdownBlockTools({
    super.config = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "チェックリスト",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Toggle List",
        ),
      ]),
      icon: FontAwesomeIcons.listCheck,
    ),
  });

  @override
  String get id => "__markdown_block_add_toggle_list__";

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
    ref.controller.insertBlock(this);
    ref.deleteMode();
  }

  @override
  MarkdownBlockValue addBlock({MarkdownBlockValue? source}) {
    return MarkdownToggleListBlockValue.createEmpty(
      indent: source?.indent ?? 0,
    );
  }

  @override
  MarkdownBlockValue? exchangeBlock(MarkdownBlockValue target) {
    if (target is MarkdownToggleListBlockValue) {
      return null;
    }
    return MarkdownToggleListBlockValue(
      id: target.id,
      indent: target.indent,
      children: target.extractLines() ?? [],
    );
  }

  @override
  MarkdownToggleListBlockValue? convertFromJson(DynamicMap json) {
    final type = json.get(MarkdownValue.typeKey, "");
    if (type != _kToggleListType) {
      return null;
    }
    return MarkdownToggleListBlockValue.fromJson(json);
  }

  @override
  ({MarkdownToggleListBlockValue? value, int linesConsumed})? convertFromMarkdown(
    MarkdownParseContext context,
  ) {
    final line = context.currentLine.trim();
    if (RegExp(r"^\[[ x]\]\s+").hasMatch(line)) {
      return (
        value: MarkdownToggleListBlockValue.fromMarkdown(context.currentLine),
        linesConsumed: 1,
      );
    }
    return null;
  }

  @override
  MarkdownToggleListBlockValue createBlockValue({
    String? initialText,
    List<MarkdownLineValue>? children,
  }) {
    return MarkdownToggleListBlockValue.createEmpty(
      initialText: initialText,
      children: children,
    );
  }
}
