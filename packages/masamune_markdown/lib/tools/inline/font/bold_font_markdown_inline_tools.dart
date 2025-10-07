part of "/masamune_markdown.dart";

/// Display the menu to bold font [MarkdownTools].
///
/// フォントを太字にするメニューを表示する[MarkdownTools]。
@immutable
class BoldFontMarkdownInlineTools extends MarkdownInlineTools {
  /// Display the menu to bold font [MarkdownTools].
  ///
  /// フォントを太字にするメニューを表示する[MarkdownTools]。
  const BoldFontMarkdownInlineTools({
    super.config = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "フォントの太字",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Font Bold",
        ),
      ]),
      icon: Icons.format_bold,
    ),
  });

  @override
  String get id => "__markdown_inline_font_bold__";

  @override
  bool shown(BuildContext context, MarkdownToolRef ref) => true;

  @override
  bool enabled(BuildContext context, MarkdownToolRef ref) => true;

  @override
  bool actived(BuildContext context, MarkdownToolRef ref) {
    return ref.controller.hasInlineProperty(this);
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
    ref.controller.addInlineProperty(this);
  }

  @override
  Future<void> onDeactive(BuildContext context, MarkdownToolRef ref) async {
    ref.controller.removeInlineProperty(this);
  }
}
