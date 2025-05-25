part of '/masamune_markdown.dart';

class MarkdownMention {
  MarkdownMention({
    required this.id,
    required this.name,
    this.avatar,
  });

  final ImageProvider? avatar;
  final String id;
  final String name;
}
