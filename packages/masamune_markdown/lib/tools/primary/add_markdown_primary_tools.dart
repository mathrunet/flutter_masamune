part of "/masamune_markdown.dart";

/// Display the menu to add blocks [MarkdownTools].
///
/// ブロックを追加するメニューを表示する[MarkdownTools]。
@immutable
class AddMarkdownPrimaryTools extends MarkdownPrimaryTools {
  /// Display the menu to add blocks [MarkdownTools].
  ///
  /// ブロックを追加するメニューを表示する[MarkdownTools]。
  const AddMarkdownPrimaryTools({
    super.config = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "ブロック追加",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Add Block",
        ),
      ]),
      icon: FontAwesomeIcons.plus,
    ),
    this.tools = const [
      TextAddMarkdownBlockTools(),
      Headline1AddMarkdownBlockTools(),
      Headline2AddMarkdownBlockTools(),
      Headline3AddMarkdownBlockTools(),
      BulletedListAddMarkdownBlockTools(),
      NumberListAddMarkdownBlockTools(),
      ToggleListAddMarkdownBlockTools(),
      CodeAddMarkdownBlockTools(),
      QuoteAddMarkdownBlockTools(),
    ],
  });

  /// Tools for adding blocks.
  ///
  /// ブロックを追加するツール。
  final List<MarkdownBlockTools> tools;

  @override
  String get id => "__markdown_block_add__";

  @override
  bool get hideKeyboardOnSelected => true;

  @override
  bool shown(BuildContext context, MarkdownToolRef ref) => true;

  @override
  bool enabled(BuildContext context, MarkdownToolRef ref) {
    return ref.selection != null;
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
  List<MarkdownBlockTools> get blockTools => tools;
}
