part of "/masamune_markdown.dart";

/// Display the menu to indent down [MarkdownTools].
///
/// インデントを下げるメニューを表示する[MarkdownTools]。
@immutable
class IndentDownMarkdownPrimaryTools extends MarkdownPrimaryTools {
  /// Display the menu to indent down [MarkdownTools].
  ///
  /// インデントを下げるメニューを表示する[MarkdownTools]。
  const IndentDownMarkdownPrimaryTools({
    super.config = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "インデント減少",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Indent Decrease",
        ),
      ]),
      icon: Icons.format_indent_decrease,
    ),
  });

  @override
  String get id => "__markdown_indent_down__";

  @override
  bool get hideKeyboardOnSelected => false;

  @override
  bool shown(BuildContext context, MarkdownToolRef ref) => true;

  @override
  bool enabled(BuildContext context, MarkdownToolRef ref) {
    return ref.focusedSelection != null;
  }

  @override
  bool actived(BuildContext context, MarkdownToolRef ref) {
    return ref.focusedController?.canDecreaseIndent() ?? false;
  }

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
    ref.focusedController?.indentSelection(false);
  }
}
