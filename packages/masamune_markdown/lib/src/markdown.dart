part of "/masamune_markdown.dart";

/// Widget for displaying Markdown.
///
/// マークダウンを表示するウィジェット。
class Markdown extends StatelessWidget {
  /// Widget for displaying Markdown.
  ///
  /// マークダウンを表示するウィジェット。
  const Markdown(
    this.value, {
    super.key,
    this.style,
    this.expands = false,
    this.scrollable = true,
    this.onTapLink,
    this.onTapMention,
  });

  /// Value of the markdown.
  ///
  /// マークダウンの値。
  final String value;

  /// Style of the markdown.
  ///
  /// マークダウンのスタイル。
  final FormStyle? style;

  /// Expands the markdown.
  ///
  /// マークダウンを展開します。
  final bool expands;

  /// Scrollable of the markdown.
  ///
  /// マークダウンをスクロール可能にします。
  final bool scrollable;

  /// Callback when the link is tapped.
  ///
  /// リンクがタップされた時のコールバック。
  final void Function(Uri link)? onTapLink;

  /// Callback when the mention is tapped.
  ///
  /// メンションがタップされた時のコールバック。
  final void Function(MarkdownMention mention)? onTapMention;

  @override
  Widget build(BuildContext context) {
    return FormMarkdownField(
      initialValue: value,
      style: style,
      expands: expands,
      onTapLink: onTapLink,
      onTapMention: onTapMention,
      readOnly: true,
      scrollable: scrollable,
    );
  }
}
