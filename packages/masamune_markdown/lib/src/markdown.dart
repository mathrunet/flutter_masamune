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
  final void Function(String link)? onTapLink;

  @override
  Widget build(BuildContext context) {
    return FormMarkdownField(
      initialValue: value,
      style: style,
      expands: expands,
      scrollable: scrollable,
      onTapLink: onTapLink,
      readOnly: true,
    );
  }
}
