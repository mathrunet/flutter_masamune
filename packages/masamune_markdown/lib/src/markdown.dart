part of "/masamune_markdown.dart";

/// Widget for displaying Markdown.
///
/// マークダウンを表示するウィジェット。
class Markdown extends StatefulWidget {
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
  State<Markdown> createState() => _MarkdownState();
}

class _MarkdownState extends State<Markdown> {
  List<MarkdownFieldValue>? _markdown;

  @override
  void initState() {
    super.initState();
    _markdown = [MarkdownFieldValue.fromMarkdown(widget.value)];
  }

  @override
  void didUpdateWidget(Markdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      setState(() {
        _markdown = [MarkdownFieldValue.fromMarkdown(widget.value)];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormMarkdownField(
      initialValue: _markdown,
      style: widget.style,
      expands: widget.expands,
      onTapLink: widget.onTapLink,
      onTapMention: widget.onTapMention,
      readOnly: true,
      scrollable: widget.scrollable,
    );
  }
}
