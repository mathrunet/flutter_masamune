part of "/masamune_markdown.dart";

/// Display the menu to change font style [MarkdownTools].
///
/// フォントスタイルを変更するメニューを表示する[MarkdownTools]。
@immutable
class FontMarkdownPrimaryTools extends MarkdownPrimaryTools {
  /// Display the menu to change font style [MarkdownTools].
  ///
  /// フォントスタイルを変更するメニューを表示する[MarkdownTools]。
  const FontMarkdownPrimaryTools({
    super.config = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "スタイル変更",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Style Change",
        ),
      ]),
      icon: FontAwesomeIcons.font,
    ),
    this.tools = const [
      BackFontMarkdownInlineTools(),
      BoldFontMarkdownInlineTools(),
      ItalicFontMarkdownInlineTools(),
      UnderlineFontMarkdownInlineTools(),
      StrikeFontMarkdownInlineTools(),
      LinkFontMarkdownInlineTools(),
      CodeFontMarkdownInlineTools(),
    ],
  });

  /// Tools for changing font style.
  ///
  /// フォントスタイルを変更するツール。
  final List<MarkdownInlineTools> tools;

  @override
  String get id => "__markdown_change_font__";

  @override
  bool get hideKeyboardOnSelected => false;

  @override
  bool shown(BuildContext context, MarkdownToolRef ref) => true;

  @override
  bool enabled(BuildContext context, MarkdownToolRef ref) {
    if (ref.focuedState?.selectInMentionLink ?? false) {
      return false;
    }
    return ref.focusedSelection != null;
  }

  @override
  bool actived(BuildContext context, MarkdownToolRef ref) => true;

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
    ref.toggleMode(this);
  }

  @override
  List<MarkdownInlineTools> get inlineTools => tools;
}
