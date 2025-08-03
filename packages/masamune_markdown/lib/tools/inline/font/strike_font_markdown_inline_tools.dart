part of "/masamune_markdown.dart";

/// Display the menu to strike font [MarkdownTools].
///
/// フォントを取り消し線にするメニューを表示する[MarkdownTools]。
@immutable
class StrikeFontMarkdownInlineTools extends MarkdownInlineTools {
  /// Display the menu to strike font [MarkdownTools].
  ///
  /// フォントを取り消し線にするメニューを表示する[MarkdownTools]。
  const StrikeFontMarkdownInlineTools({
    super.config = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "フォントの取り消し線",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Font Strike",
        ),
      ]),
      icon: Icons.format_strikethrough,
    ),
  });

  @override
  String get id => "__markdown_inline_font_strike__";

  @override
  bool shown(BuildContext context, MarkdownToolRef ref) => true;

  @override
  bool enabled(BuildContext context, MarkdownToolRef ref) => true;

  @override
  bool actived(BuildContext context, MarkdownToolRef ref) {
    return ref.activeAttribute(Attribute.strikeThrough);
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
    ref.focusedController?.formatSelection(Attribute.strikeThrough);
  }

  @override
  Future<void> onDeactive(BuildContext context, MarkdownToolRef ref) async {
    ref.focusedController?.removeFormatSelection(Attribute.strikeThrough);
  }
}
