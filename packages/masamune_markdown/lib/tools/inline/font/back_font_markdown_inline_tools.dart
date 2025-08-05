part of "/masamune_markdown.dart";

/// Display the menu to back font [MarkdownTools].
///
/// フォントメニューから戻るメニューを表示する[MarkdownTools]。
@immutable
class BackFontMarkdownInlineTools extends MarkdownInlineTools {
  /// Display the menu to back font [MarkdownTools].
  ///
  /// フォントメニューから戻るメニューを表示する[MarkdownTools]。
  const BackFontMarkdownInlineTools({
    super.config = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "戻る",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Back",
        ),
      ]),
      icon: Icons.arrow_back_ios,
    ),
  });

  @override
  String get id => "__markdown_inline_font_back__";

  @override
  bool shown(BuildContext context, MarkdownToolRef ref) => true;

  @override
  bool enabled(BuildContext context, MarkdownToolRef ref) => true;

  @override
  bool actived(BuildContext context, MarkdownToolRef ref) => false;

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
    ref.focusedController?.unselect();
    ref.deleteMode();
  }

  @override
  Future<void> onDeactive(BuildContext context, MarkdownToolRef ref) async {
    ref.focusedController?.unselect();
    ref.deleteMode();
  }
}
