part of "/masamune_markdown.dart";

/// Display the menu to italic font [MarkdownTools].
///
/// フォントを斜体にするメニューを表示する[MarkdownTools]。
@immutable
class ItalicFontMarkdownInlineTools extends MarkdownInlineTools {
  /// Display the menu to italic font [MarkdownTools].
  ///
  /// フォントを斜体にするメニューを表示する[MarkdownTools]。
  const ItalicFontMarkdownInlineTools({
    super.config = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "フォントの斜体",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Font Italic",
        ),
      ]),
      icon: Icons.format_italic,
    ),
  });

  @override
  String get id => "__markdown_inline_font_italic__";

  @override
  bool shown(BuildContext context, MarkdownToolRef ref) => true;

  @override
  bool enabled(BuildContext context, MarkdownToolRef ref) => true;

  @override
  bool actived(BuildContext context, MarkdownToolRef ref) {
    return ref.activeAttribute(Attribute.italic);
  }

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
  void onTap(BuildContext context, MarkdownToolRef ref) {}

  @override
  Future<void> onActive(BuildContext context, MarkdownToolRef ref) async {
    ref.focusedController?.formatSelection(Attribute.italic);
  }

  @override
  Future<void> onDeactive(BuildContext context, MarkdownToolRef ref) async {
    ref.focusedController?.removeFormatSelection(Attribute.italic);
  }
}
