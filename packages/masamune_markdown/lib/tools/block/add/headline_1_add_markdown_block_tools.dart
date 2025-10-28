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
    ref.controller.insertBlock(this);
    ref.deleteMode();
  }

  @override
  MarkdownBlockValue addBlock({MarkdownBlockValue? source}) {
    return MarkdownHeadline1BlockValue.createEmpty(
      indent: source?.indent ?? 0,
    );
  }

  @override
  MarkdownBlockValue? exchangeBlock(MarkdownBlockValue target) {
    if (target is MarkdownHeadline1BlockValue) {
      return null;
    }
    return MarkdownHeadline1BlockValue(
      id: target.id,
      indent: target.indent,
      children: target.extractLines() ?? [],
    );
  }

  @override
  MarkdownHeadline1BlockValue? convertFromJson(DynamicMap json) {
    return MarkdownHeadline1BlockValue.fromJson(json);
  }

  @override
  MarkdownHeadline1BlockValue? convertFromMarkdown(String markdown) {
    return MarkdownHeadline1BlockValue.fromMarkdown(markdown);
  }

  @override
  DynamicMap? convertToJson(MarkdownHeadline1BlockValue value) {
    return value.toJson();
  }

  @override
  String? convertToMarkdown(MarkdownHeadline1BlockValue value) {
    return value.toMarkdown();
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
