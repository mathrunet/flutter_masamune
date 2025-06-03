part of "/masamune_markdown.dart";

/// Data class for Markdown mentions.
///
/// マークダウンのメンション用のデータクラス。
class MarkdownMention {
  /// Data class for Markdown mentions.
  ///
  /// マークダウンのメンション用のデータクラス。
  const MarkdownMention({
    required this.id,
    required this.name,
    this.avatar,
  });

  /// Create a MarkdownMention from a JSON object.
  ///
  /// マークダウンのメンション用のデータクラスを作成します。
  factory MarkdownMention.fromJson(DynamicMap json) {
    return MarkdownMention(
      id: json["id"],
      name: json["name"],
      avatar: json["avatar"],
    );
  }

  /// Type of MarkdownMention.
  ///
  /// マークダウンのメンションのタイプ。
  static const String type = "mention";

  /// Avatar of the mention.
  ///
  /// メンションのアバター。
  final ImageProvider? avatar;

  /// ID of the mention.
  ///
  /// メンションのID。
  final String id;

  /// Name of the mention.
  ///
  /// メンションの名前。
  final String name;

  /// Convert to a JSON object.
  ///
  /// マークダウンのメンション用のデータクラスをJSONオブジェクトに変換します。
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
