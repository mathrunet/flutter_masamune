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
    ref.controller.exchangeBlock(this);
    ref.deleteMode();
  }

  @override
  MarkdownBlockValue? exchangeBlock(MarkdownBlockValue target) {
    if (target is MarkdownParagraphBlockValue) {
      return null;
    }
    return MarkdownParagraphBlockValue(
      id: target.id,
      children: target.extractLines() ?? [],
      indent: target.indent,
    );
  }

  @override
  MarkdownParagraphBlockValue? convertFromJson(DynamicMap json) {
    // TODO: implement convertFromJson
    throw UnimplementedError();
  }

  @override
  MarkdownParagraphBlockValue? convertFromMarkdown(String markdown) {
    // TODO: implement convertFromMarkdown
    throw UnimplementedError();
  }

  @override
  DynamicMap? convertToJson(MarkdownParagraphBlockValue value) {
    // TODO: implement convertToJson
    throw UnimplementedError();
  }

  @override
  String? convertToMarkdown(MarkdownParagraphBlockValue value) {
    // TODO: implement convertToMarkdown
    throw UnimplementedError();
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
