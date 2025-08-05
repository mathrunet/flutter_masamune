part of "/masamune_markdown.dart";

/// Display the menu to indent up [MarkdownTools].
///
/// インデントを上げるメニューを表示する[MarkdownTools]。
@immutable
class IndentUpMarkdownPrimaryTools extends MarkdownPrimaryTools {
  /// Display the menu to indent up [MarkdownTools].
  ///
  /// インデントを上げるメニューを表示する[MarkdownTools]。
  const IndentUpMarkdownPrimaryTools({
    super.config = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "インデント増加",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Indent Increase",
        ),
      ]),
      icon: Icons.format_indent_increase,
    ),
  });

  @override
  String get id => "__markdown_indent_up__";

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
    return ref.focusedController?.canIncreaseIndent() ?? false;
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
    ref.focusedController?.indentSelection(true);
  }
}
