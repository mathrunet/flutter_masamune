part of "/masamune_markdown.dart";

/// Display the menu to exchange toggle list blocks [MarkdownTools].
///
/// チェックボックスリストブロックを変更するメニューを表示する[MarkdownTools]。
@immutable
class ToggleListExchangeMarkdownBlockTools extends MarkdownBlockTools {
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
  IconData icon(BuildContext context) {
    return config.icon;
  }

  @override
  String label(BuildContext context) {
    final locale = context.locale;
    return config.title.value(locale) ?? "";
  }

  @override
  void onTap(BuildContext context, MarkdownToolRef ref) {
    ref.focusedController?.formatLine(Attribute.checked);
    ref.deleteMode();
  }
}
