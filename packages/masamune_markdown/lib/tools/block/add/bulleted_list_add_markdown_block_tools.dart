part of "/masamune_markdown.dart";

/// Display the menu to add bulleted list blocks [MarkdownTools].
///
/// 箇条書きリストブロックを追加するメニューを表示する[MarkdownTools]。
@immutable
class BulletedListAddMarkdownBlockTools
    extends MarkdownBlockVariableTools<MarkdownBulletedListBlockValue> {
  /// Display the menu to add bulleted list blocks [MarkdownTools].
  ///
  /// 箇条書きリストブロックを追加するメニューを表示する[MarkdownTools]。
  const BulletedListAddMarkdownBlockTools({
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
  String get id => "__markdown_block_add_bulleted_list__";

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
  MarkdownBlockValue addBlock() {
    return MarkdownBulletedListBlockValue.createEmpty();
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
    // TODO: implement convertFromJson
    throw UnimplementedError();
  }

  @override
  MarkdownBulletedListBlockValue? convertFromMarkdown(String markdown) {
    // TODO: implement convertFromMarkdown
    throw UnimplementedError();
  }

  @override
  DynamicMap? convertToJson(MarkdownBulletedListBlockValue value) {
    // TODO: implement convertToJson
    throw UnimplementedError();
  }

  @override
  String? convertToMarkdown(MarkdownBulletedListBlockValue value) {
    // TODO: implement convertToMarkdown
    throw UnimplementedError();
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
