part of '/masamune_markdown.dart';

class MarkdownMention {
  const MarkdownMention({
    required this.id,
    required this.name,
    this.avatar,
  });

  factory MarkdownMention.fromJson(DynamicMap json) {
    return MarkdownMention(
      id: json["id"],
      name: json["name"],
      avatar: json["avatar"],
    );
  }

  static const String type = "mention";

  final ImageProvider? avatar;
  final String id;
  final String name;

  DynamicMap toJson() {
    return {
      "id": id,
      "name": name,
      "avatar": avatar,
    };
  }

  @override
  String toString() {
    return "MarkdownMention(id: $id, name: $name, avatar: $avatar)";
  }
}
