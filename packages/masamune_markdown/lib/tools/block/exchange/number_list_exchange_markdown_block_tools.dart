part of "/masamune_markdown.dart";

/// Display the menu to exchange numbered list blocks [MarkdownTools].
///
/// 番号付きリストブロックを変更するメニューを表示する[MarkdownTools]。
@immutable
class NumberListExchangeMarkdownBlockTools
    extends MarkdownBlockMultiLineVariableTools<MarkdownNumberListBlockValue> {
  /// Display the menu to exchange numbered list blocks [MarkdownTools].
  ///
  /// 番号付きリストブロックを変更するメニューを表示する[MarkdownTools]。
  const NumberListExchangeMarkdownBlockTools({
    super.config = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "番号付きリスト",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Numbered List",
        ),
      ]),
      icon: FontAwesomeIcons.listOl,
    ),
  });

  @override
  String get id => "__markdown_block_exchange_number_list__";

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
    return MarkdownNumberListBlockValue.createEmpty(
      indent: source?.indent ?? 0,
      lineIndex: 0,
    );
  }

  @override
  MarkdownBlockValue? exchangeBlock(MarkdownBlockValue target) {
    if (target is MarkdownNumberListBlockValue) {
      return null;
    }
    return MarkdownNumberListBlockValue(
      id: target.id,
      indent: target.indent,
      children: target.extractLines() ?? [],
      lineIndex: 0,
    );
  }

  @override
  MarkdownNumberListBlockValue? convertFromJson(DynamicMap json) {
    final type = json.get(MarkdownValue.typeKey, "");
    if (type != _kNumberListType) {
      return null;
    }
    return MarkdownNumberListBlockValue.fromJson(json);
  }

  @override
  MarkdownNumberListBlockValue? convertFromMarkdown(String markdown) {
    if (RegExp(r"^\d+[.)]?\s+").hasMatch(markdown.trim())) {
      return MarkdownNumberListBlockValue.fromMarkdown(markdown);
    }
    return null;
  }

  @override
  MarkdownNumberListBlockValue createBlockValue({
    String? initialText,
    List<MarkdownLineValue>? children,
  }) {
    return MarkdownNumberListBlockValue.createEmpty(
      initialText: initialText,
      children: children,
    );
  }
}
