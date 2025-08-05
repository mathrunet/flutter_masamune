part of "/masamune_markdown.dart";

/// Display the menu to exchange headline 3 blocks [MarkdownTools].
///
/// 見出し3ブロックを変更するメニューを表示する[MarkdownTools]。
@immutable
class Headline3ExchangeMarkdownBlockTools extends MarkdownBlockTools {
  /// Display the menu to exchange headline 3 blocks [MarkdownTools].
  ///
  /// 見出し3ブロックを変更するメニューを表示する[MarkdownTools]。
  const Headline3ExchangeMarkdownBlockTools({
    super.config = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "見出し3",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Heading 3",
        ),
      ]),
      icon: FontAwesomeIcons.heading,
    ),
  });

  @override
    String get id => "__markdown_block_exchange_headline_3__";

  @override
  bool shown(BuildContext context, MarkdownToolRef ref) => true;

  @override
  bool enabled(BuildContext context, MarkdownToolRef ref) => true;

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
    ref.focusedController?.formatLine(Attribute.h3);
    ref.deleteMode();
  }
}
