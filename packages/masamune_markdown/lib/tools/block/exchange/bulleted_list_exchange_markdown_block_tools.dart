part of "/masamune_markdown.dart";

/// Display the menu to exchange bulleted list blocks [MarkdownTools].
///
/// 箇条書きリストブロックを変更するメニューを表示する[MarkdownTools]。
@immutable
class BulletedListExchangeMarkdownBlockTools
    extends MarkdownBlockMultiLineVariableTools<
        MarkdownBulletedListBlockValue> {
  /// Display the menu to exchange bulleted list blocks [MarkdownTools].
  ///
  /// 箇条書きリストブロックを変更するメニューを表示する[MarkdownTools]。
  const BulletedListExchangeMarkdownBlockTools({
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
  String get id => "__markdown_block_exchange_bulleted_list__";

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
    return MarkdownBulletedListBlockValue.createEmpty(
      indent: source?.indent ?? 0,
    );
  }

  @override
  MarkdownBlockValue? exchangeBlock(MarkdownBlockValue target) {
    if (target is MarkdownBulletedListBlockValue) {
      return null;
    }
    return MarkdownBulletedListBlockValue(
      id: target.id,
      indent: target.indent,
      children: target.extractLines() ?? [],
    );
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
