part of "/masamune_markdown.dart";

/// Display the menu to exchange headline 2 blocks [MarkdownTools].
///
/// 見出し2ブロックを変更するメニューを表示する[MarkdownTools]。
@immutable
class Headline2ExchangeMarkdownBlockTools
    extends MarkdownBlockMultiLineVariableTools<MarkdownHeadline2BlockValue> {
  /// Display the menu to exchange headline 2 blocks [MarkdownTools].
  ///
  /// 見出し2ブロックを変更するメニューを表示する[MarkdownTools]。
  const Headline2ExchangeMarkdownBlockTools({
    super.config = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "見出し2",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Heading 2",
        ),
      ]),
      icon: FontAwesomeIcons.heading,
    ),
  });

  @override
  String get id => "__markdown_block_exchange_headline_2__";

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
  MarkdownBlockValue addBlock({MarkdownBlockValue? source}) {
    return MarkdownHeadline2BlockValue.createEmpty(
      indent: source?.indent ?? 0,
    );
  }

  @override
  MarkdownBlockValue? exchangeBlock(MarkdownBlockValue target) {
    if (target is MarkdownHeadline2BlockValue) {
      return null;
    }
    return MarkdownHeadline2BlockValue(
      id: target.id,
      indent: target.indent,
      children: target.extractLines() ?? [],
    );
  }

  @override
  MarkdownHeadline2BlockValue? convertFromJson(DynamicMap json) {
    final type = json.get(MarkdownValue.typeKey, "");
    if (type != _kHeadline2Type) {
      return null;
    }
    return MarkdownHeadline2BlockValue.fromJson(json);
  }

  @override
  MarkdownHeadline2BlockValue? convertFromMarkdown(String markdown) {
    if (markdown.trim().startsWith("## ")) {
      return MarkdownHeadline2BlockValue.fromMarkdown(markdown);
    }
    return null;
  }

  @override
  MarkdownHeadline2BlockValue createBlockValue({
    String? initialText,
    List<MarkdownLineValue>? children,
  }) {
    return MarkdownHeadline2BlockValue.createEmpty(
      initialText: initialText,
      children: children,
    );
  }
}
