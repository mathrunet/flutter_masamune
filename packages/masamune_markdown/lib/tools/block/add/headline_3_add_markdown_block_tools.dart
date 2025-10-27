part of "/masamune_markdown.dart";

/// Display the menu to add headline 3 blocks [MarkdownTools].
///
/// 見出し3ブロックを追加するメニューを表示する[MarkdownTools]。
@immutable
class Headline3AddMarkdownBlockTools
    extends MarkdownBlockVariableTools<MarkdownHeadline3BlockValue> {
  /// Display the menu to add headline 3 blocks [MarkdownTools].
  ///
  /// 見出し3ブロックを追加するメニューを表示する[MarkdownTools]。
  const Headline3AddMarkdownBlockTools({
    super.config = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "見出し3",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Heading 3",
        ),
      ]),
      icon: FontAwesomeIcons.heading,
    ),
  });

  @override
  String get id => "__markdown_block_add_headline_3__";

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
    return MarkdownHeadline3BlockValue.createEmpty(
      indent: source?.indent ?? 0,
    );
  }

  @override
  MarkdownBlockValue? exchangeBlock(MarkdownBlockValue target) {
    if (target is MarkdownHeadline3BlockValue) {
      return null;
    }
    return MarkdownHeadline3BlockValue(
      id: target.id,
      indent: target.indent,
      children: target.extractLines() ?? [],
    );
  }

  @override
  MarkdownHeadline3BlockValue? convertFromJson(DynamicMap json) {
    return MarkdownHeadline3BlockValue.fromJson(json);
  }

  @override
  MarkdownHeadline3BlockValue? convertFromMarkdown(String markdown) {
    return MarkdownHeadline3BlockValue.fromMarkdown(markdown);
  }

  @override
  DynamicMap? convertToJson(MarkdownHeadline3BlockValue value) {
    return value.toJson();
  }

  @override
  String? convertToMarkdown(MarkdownHeadline3BlockValue value) {
    return value.toMarkdown();
  }

  @override
  MarkdownHeadline3BlockValue createBlockValue({
    String? initialText,
    List<MarkdownLineValue>? children,
  }) {
    return MarkdownHeadline3BlockValue.createEmpty(
      initialText: initialText,
      children: children,
    );
  }
}
