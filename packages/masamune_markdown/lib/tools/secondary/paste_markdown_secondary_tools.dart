part of "/masamune_markdown.dart";

/// Display the menu to paste text [MarkdownTools].
///
/// テキストを貼り付けるメニューを表示する[MarkdownTools]。
@immutable
class PasteMarkdownSecondaryTools extends MarkdownSecondaryTools {
  /// Display the menu to paste text [MarkdownTools].
  ///
  /// テキストを貼り付けるメニューを表示する[MarkdownTools]。
  const PasteMarkdownSecondaryTools({
    super.config = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "貼り付け",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Paste",
        ),
      ]),
      icon: Icons.paste,
    ),
  });

  @override
  String get id => "__markdown_paste__";

  @override
  bool shown(BuildContext context, MarkdownToolRef ref) {
    return ref.isKeyboardShowing && ref.canPaste;
  }

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
    ref.focusedController?.clipboardPaste();
  }
}
