part of "/masamune_markdown.dart";

/// Display the menu to underline font [MarkdownTools].
///
/// フォントを下線にするメニューを表示する[MarkdownTools]。
@immutable
class UnderlineFontMarkdownInlineTools extends MarkdownInlineTools {
  /// Display the menu to underline font [MarkdownTools].
  ///
  /// フォントを下線にするメニューを表示する[MarkdownTools]。
  const UnderlineFontMarkdownInlineTools({
    super.config = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "フォントの下線",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Font Underline",
        ),
      ]),
      icon: Icons.format_underline,
    ),
  });

  @override
  String get id => "__markdown_inline_font_underline__";

  @override
  bool shown(BuildContext context, MarkdownToolRef ref) => true;

  @override
  bool enabled(BuildContext context, MarkdownToolRef ref) => true;

  @override
  bool actived(BuildContext context, MarkdownToolRef ref) {
    return ref.activeAttribute(Attribute.underline);
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
  void onTap(BuildContext context, MarkdownToolRef ref) {}

  @override
  Future<void> onActive(BuildContext context, MarkdownToolRef ref) async {
    ref.focusedController?.formatSelection(Attribute.underline);
  }

  @override
  Future<void> onDeactive(BuildContext context, MarkdownToolRef ref) async {
    ref.focusedController?.removeFormatSelection(Attribute.underline);
  }
}
