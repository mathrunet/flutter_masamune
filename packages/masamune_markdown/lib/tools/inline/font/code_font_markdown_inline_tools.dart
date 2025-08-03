part of "/masamune_markdown.dart";

/// Display the menu to code font [MarkdownTools].
///
/// フォントをコードにするメニューを表示する[MarkdownTools]。
@immutable
class CodeFontMarkdownInlineTools extends MarkdownInlineTools {
  /// Display the menu to code font [MarkdownTools].
  ///
  /// フォントをコードにするメニューを表示する[MarkdownTools]。
  const CodeFontMarkdownInlineTools({
    super.config = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "フォントのインラインコード",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Font Inline Code",
        ),
      ]),
      icon: Icons.code,
    ),
  });

  @override
  String get id => "__markdown_inline_font_code__";

  @override
  bool shown(BuildContext context, MarkdownToolRef ref) => true;

  @override
  bool enabled(BuildContext context, MarkdownToolRef ref) => true;

  @override
  bool actived(BuildContext context, MarkdownToolRef ref) {
    return ref.activeAttribute(Attribute.inlineCode);
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
    ref.focusedController?.formatSelection(Attribute.inlineCode);
  }

  @override
  Future<void> onDeactive(BuildContext context, MarkdownToolRef ref) async {
    ref.focusedController?.removeFormatSelection(Attribute.inlineCode);
  }
}
