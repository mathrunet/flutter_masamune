part of "/masamune_markdown.dart";

/// Display the menu to add code blocks [MarkdownTools].
///
/// コードブロックを追加するメニューを表示する[MarkdownTools]。
@immutable
class CodeAddMarkdownBlockTools
    extends MarkdownBlockVariableTools<MarkdownCodeBlockValue> {
  /// Display the menu to add code blocks [MarkdownTools].
  ///
  /// コードブロックを追加するメニューを表示する[MarkdownTools]。
  const CodeAddMarkdownBlockTools({
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
  String get id => "__markdown_block_add_code__";

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
    return MarkdownCodeBlockValue.createEmpty(
      indent: source?.indent ?? 0,
    );
  }

  @override
  MarkdownBlockValue? exchangeBlock(MarkdownBlockValue target) {
    if (target is MarkdownCodeBlockValue) {
      return null;
    }
    return MarkdownCodeBlockValue(
      id: target.id,
      indent: target.indent,
      children: target.extractLines() ?? [],
    );
  }

  @override
  MarkdownCodeBlockValue? convertFromJson(DynamicMap json) {
    return MarkdownCodeBlockValue.fromJson(json);
  }

  @override
  MarkdownCodeBlockValue? convertFromMarkdown(String markdown) {
    return MarkdownCodeBlockValue.fromMarkdown(markdown);
  }

  @override
  DynamicMap? convertToJson(MarkdownCodeBlockValue value) {
    return value.toJson();
  }

  @override
  String? convertToMarkdown(MarkdownCodeBlockValue value) {
    return value.toMarkdown();
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
