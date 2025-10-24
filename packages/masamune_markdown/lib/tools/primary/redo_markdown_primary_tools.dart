part of "/masamune_markdown.dart";

/// Display the menu to redo [MarkdownTools].
///
/// やり直しメニューを表示する[MarkdownTools]。
@immutable
class RedoMarkdownPrimaryTools extends MarkdownPrimaryTools {
  /// Display the menu to redo [MarkdownTools].
  ///
  /// やり直しメニューを表示する[MarkdownTools]。
  const RedoMarkdownPrimaryTools({
    super.config = const MarkdownToolLabelConfig(
      title: LocalizedValue<String>([
        LocalizedLocaleValue<String>(
          Locale("ja", "JP"),
          "やり直し",
        ),
        LocalizedLocaleValue<String>(
          Locale("en", "US"),
          "Redo",
        ),
      ]),
      icon: Icons.redo,
    ),
  });

  @override
  String get id => "__markdown_redo__";

  @override
  bool get hideKeyboardOnSelected => false;

  @override
  bool shown(BuildContext context, MarkdownToolRef ref) => true;

  @override
  bool enabled(BuildContext context, MarkdownToolRef ref) {
    return ref.selection != null;
  }

  @override
  bool actived(BuildContext context, MarkdownToolRef ref) {
    return ref.controller.canRedo;
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
  void onTap(BuildContext context, MarkdownToolRef ref) {
    ref.controller.redo();
  }
}
