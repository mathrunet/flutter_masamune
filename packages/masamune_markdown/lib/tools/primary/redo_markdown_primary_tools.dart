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
    return ref.focusedSelection != null;
  }

  @override
  bool actived(BuildContext context, MarkdownToolRef ref) {
    return ref.focusedController?.document.hasRedo ?? false;
  }

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
    ref.focusedController?.redo();
  }
}
