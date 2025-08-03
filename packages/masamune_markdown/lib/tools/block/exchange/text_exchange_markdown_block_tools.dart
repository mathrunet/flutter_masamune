part of "/masamune_markdown.dart";

/// Display the menu to exchange text blocks [MarkdownTools].
///
/// テキストブロックを変更するメニューを表示する[MarkdownTools]。
@immutable
class TextExchangeMarkdownBlockTools extends MarkdownBlockTools {
  /// Display the menu to exchange text blocks [MarkdownTools].
  ///
  /// テキストブロックを変更するメニューを表示する[MarkdownTools]。
  const TextExchangeMarkdownBlockTools({
    super.config = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "テキスト",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Text",
        ),
      ]),
      icon: Icons.title,
    ),
  });

  @override
  String get id => "__markdown_block_exchange_text__";

  @override
  bool shown(BuildContext context, MarkdownToolRef ref) => true;

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
    ref.focusedController?.removeFormat();
    ref.deleteMode();
  }
}
