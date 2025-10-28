part of "/masamune_markdown.dart";

/// Display the menu to add quote blocks [MarkdownTools].
///
/// 引用ブロックを追加するメニューを表示する[MarkdownTools]。
@immutable
class QuoteAddMarkdownBlockTools
    extends MarkdownBlockMultiLineVariableTools<MarkdownQuoteBlockValue> {
  /// Display the menu to add quote blocks [MarkdownTools].
  ///
  /// 引用ブロックを追加するメニューを表示する[MarkdownTools]。
  const QuoteAddMarkdownBlockTools({
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
  String get id => "__markdown_block_add_quote__";

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
    return MarkdownQuoteBlockValue.createEmpty(
      indent: source?.indent ?? 0,
    );
  }

  @override
  MarkdownBlockValue? exchangeBlock(MarkdownBlockValue target) {
    if (target is MarkdownQuoteBlockValue) {
      return null;
    }
    return MarkdownQuoteBlockValue(
      id: target.id,
      indent: target.indent,
      children: target.extractLines() ?? [],
    );
  }

  @override
  MarkdownQuoteBlockValue? convertFromJson(DynamicMap json) {
    return MarkdownQuoteBlockValue.fromJson(json);
  }

  @override
  MarkdownQuoteBlockValue? convertFromMarkdown(String markdown) {
    return MarkdownQuoteBlockValue.fromMarkdown(markdown);
  }

  @override
  DynamicMap? convertToJson(MarkdownQuoteBlockValue value) {
    return value.toJson();
  }

  @override
  String? convertToMarkdown(MarkdownQuoteBlockValue value) {
    return value.toMarkdown();
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
