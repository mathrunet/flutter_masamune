part of "/masamune_markdown.dart";

/// Display the menu to close the keyboard [MarkdownTools].
///
/// キーボードを閉じるメニューを表示する[MarkdownTools]。
@immutable
class CloseMarkdownSecondaryTools extends MarkdownSecondaryTools {
  /// Display the menu to close the keyboard [MarkdownTools].
  ///
  /// キーボードを閉じるメニューを表示する[MarkdownTools]。
  const CloseMarkdownSecondaryTools({
    super.config = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "キーボードを閉じる",
        ),
      ]),
      icon: Icons.keyboard_hide,
    ),
  });

  @override
  String get id => "__markdown_close_keyboard__";

  @override
  bool shown(BuildContext context, MarkdownToolRef ref) => true;

  @override
  bool enabled(BuildContext context, MarkdownToolRef ref) {
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
    ref.closeKeyboard();
  }
}
