part of "/masamune_markdown.dart";

/// Display the menu to add toggle list blocks [MarkdownTools].
///
/// チェックボックスリストブロックを追加するメニューを表示する[MarkdownTools]。
@immutable
class ToggleListAddMarkdownBlockTools extends MarkdownBlockTools {
  /// Display the menu to add toggle list blocks [MarkdownTools].
  ///
  /// チェックボックスリストブロックを追加するメニューを表示する[MarkdownTools]。
  const ToggleListAddMarkdownBlockTools({
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
  String get id => "__markdown_block_add_toggle_list__";

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
    ref.focusedController?.addFormattedLine(Attribute.checked);
    ref.deleteMode();
  }
}
