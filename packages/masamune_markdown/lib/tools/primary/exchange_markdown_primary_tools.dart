part of "/masamune_markdown.dart";

/// Display the menu to exchange blocks [MarkdownTools].
///
/// ブロックを交換するメニューを表示する[MarkdownTools]。
@immutable
class ExchangeMarkdownPrimaryTools extends MarkdownPrimaryTools {
  /// Display the menu to exchange blocks [MarkdownTools].
  ///
  /// ブロックを交換するメニューを表示する[MarkdownTools]。
  const ExchangeMarkdownPrimaryTools({
    super.config = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "ブロックスタイル変更",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Block Style Change",
        ),
      ]),
      icon: Icons.repeat,
    ),
    this.tools = const [
      TextExchangeMarkdownBlockTools(),
      Headline1ExchangeMarkdownBlockTools(),
      Headline2ExchangeMarkdownBlockTools(),
      Headline3ExchangeMarkdownBlockTools(),
      BulletedListExchangeMarkdownBlockTools(),
      NumberListExchangeMarkdownBlockTools(),
      ToggleListExchangeMarkdownBlockTools(),
      CodeExchangeMarkdownBlockTools(),
      QuoteExchangeMarkdownBlockTools(),
    ],
  });

  /// Tools for adding blocks.
  ///
  /// ブロックを追加するツール。
  final List<MarkdownBlockTools> tools;

  @override
  String get id => "__markdown_block_exchange__";

  @override
  bool get hideKeyboardOnSelected => true;

  @override
  bool shown(BuildContext context, MarkdownToolRef ref) => true;

  @override
  bool enabled(BuildContext context, MarkdownToolRef ref) {
    return ref.focusedSelection != null;
  }

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
    ref.toggleMode(this);
  }

  @override
  List<MarkdownBlockTools> get blockTools => tools;
}
