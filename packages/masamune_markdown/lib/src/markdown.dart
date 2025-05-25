part of '/masamune_markdown.dart';

/// Widget for displaying Markdown.
///
/// マークダウンを表示するウィジェット。
class Markdown extends StatelessWidget {
  /// Widget for displaying Markdown.
  ///
  /// マークダウンを表示するウィジェット。
  const Markdown(this.value, {super.key});

  final String value;

  @override
  Widget build(BuildContext context) {
    return MarkdownWidget(
      data: value,
      config: MarkdownConfig(configs: [
      ]),
    );
  }
}
