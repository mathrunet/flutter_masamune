part of "/masamune_markdown.dart";

/// Display the menu to exchange toggle list blocks [MarkdownTools].
///
/// チェックボックスリストブロックを変更するメニューを表示する[MarkdownTools]。
@immutable
class ToggleListExchangeMarkdownBlockTools
    extends MarkdownBlockVariableTools<MarkdownToggleListBlockValue> {
  /// Display the menu to exchange toggle list blocks [MarkdownTools].
  ///
  /// チェックボックスリストブロックを変更するメニューを表示する[MarkdownTools]。
  const ToggleListExchangeMarkdownBlockTools({
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
  String get id => "__markdown_block_exchange_toggle_list__";

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
    return MarkdownToggleListBlockValue.fromJson(json);
  }

  @override
  MarkdownToggleListBlockValue? convertFromMarkdown(String markdown) {
    return MarkdownToggleListBlockValue.fromMarkdown(markdown);
  }

  @override
  DynamicMap? convertToJson(MarkdownToggleListBlockValue value) {
    return value.toJson();
  }

  @override
  String? convertToMarkdown(MarkdownToggleListBlockValue value) {
    return value.toMarkdown();
  }

  @override
  MarkdownToggleListBlockValue createBlockValue(
      {String? initialText, List<MarkdownLineValue>? children}) {
    return MarkdownToggleListBlockValue.createEmpty(
      initialText: initialText,
      children: children,
    );
  }
}
