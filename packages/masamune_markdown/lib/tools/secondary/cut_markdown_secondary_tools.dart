part of "/masamune_markdown.dart";

/// Display the menu to cut text [MarkdownTools].
///
/// テキストを切り取るメニューを表示する[MarkdownTools]。
@immutable
class CutMarkdownSecondaryTools extends MarkdownSecondaryTools {
  /// Display the menu to cut text [MarkdownTools].
  ///
  /// テキストを切り取るメニューを表示する[MarkdownTools]。
  const CutMarkdownSecondaryTools({
    super.config = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "切り取り",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Cut",
        ),
      ]),
      icon: Icons.cut,
    ),
  });

  @override
  String get id => "__markdown_cut__";

  @override
  bool shown(BuildContext context, MarkdownToolRef ref) {
    return ref.isTextSelected;
  }

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
    ref.controller.cut();
    ref.controller.unselect();
  }
}
