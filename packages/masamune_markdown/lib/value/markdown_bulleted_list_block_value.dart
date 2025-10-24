part of "/masamune_markdown.dart";

/// A class for storing markdown bulleted list block value.
///
/// マークダウンの箇条書きリストブロックの値を格納するクラス。
@immutable
class MarkdownBulletedListBlockValue extends MarkdownMultiLineBlockValue {
  /// A class for storing markdown bulleted list block value.
  ///
  /// マークダウンの箇条書きリストブロックの値を格納するクラス。
  const MarkdownBulletedListBlockValue({
    required super.id,
    required super.children,
    super.indent = 0,
  });

  /// Create a [MarkdownBulletedListBlockValue] from a [DynamicMap].
  ///
  /// [DynamicMap]から[MarkdownBulletedListBlockValue]を作成します。
  factory MarkdownBulletedListBlockValue.fromJson(DynamicMap json) {
    return MarkdownBulletedListBlockValue(
      id: json.get(MarkdownValue.idKey, ""),
      indent: json.get(MarkdownValue.indentKey, 0),
      children: json
          .getAsList<DynamicMap>(MarkdownValue.childrenKey, [])
          .map(MarkdownLineValue.fromJson)
          .toList(),
    );
  }

  /// Create a [MarkdownBulletedListBlockValue] from a markdown string.
  ///
  /// [markdown]から[MarkdownBulletedListBlockValue]を作成します。
  factory MarkdownBulletedListBlockValue.fromMarkdown(String markdown) {
    // Remove leading "- " or "* " marker
    final cleanedMarkdown = markdown.replaceFirst(RegExp(r"^[-*]\s+"), "");
    return MarkdownBulletedListBlockValue(
      id: uuid(),
      children: [
        ...cleanedMarkdown.split("\n").map(MarkdownLineValue.fromMarkdown),
      ],
    );
  }

  /// Create a new [MarkdownBulletedListBlockValue] with an empty child.
  ///
  /// 新しい[MarkdownBulletedListBlockValue]を作成します。
  factory MarkdownBulletedListBlockValue.createEmpty([String? initialText]) {
    return MarkdownBulletedListBlockValue(
      id: uuid(),
      children: [
        MarkdownLineValue.createEmpty(initialText),
      ],
    );
  }

  @override
  String get type => "__markdown_block_bulleted_list__";

  @override
  bool get canIndent => true;

  @override
  bool get maintainIndent => true;

  @override
  DynamicMap toJson() {
    return {
      MarkdownValue.idKey: id,
      MarkdownValue.typeKey: type,
      MarkdownValue.indentKey: indent,
      MarkdownValue.childrenKey: children.map((e) => e.toJson()).toList(),
    };
  }

  @override
  EdgeInsetsGeometry padding(
    BuildContext context,
    MarkdownController controller,
  ) {
    return controller.style.list.padding ?? EdgeInsets.zero;
  }

  @override
  EdgeInsetsGeometry margin(
    BuildContext context,
    MarkdownController controller,
  ) {
    return controller.style.list.margin ?? EdgeInsets.zero;
  }

  @override
  TextStyle textStyle(
    BuildContext context,
    MarkdownController controller,
  ) {
    final theme = Theme.of(context);
    return (controller.style.list.textStyle ??
            theme.textTheme.bodyMedium ??
            const TextStyle())
        .copyWith(
      color: controller.style.list.foregroundColor,
    );
  }

  @override
  Color? backgroundColor(
    RenderContext context,
    MarkdownController controller,
  ) {
    return null;
  }

  @override
  String toMarkdown() {
    return children.map((e) => "- ${e.toMarkdown()}").join("\n");
  }

  @override
  MarkdownBulletedListBlockValue copyWith({
    String? id,
    int? indent,
    List<MarkdownLineValue>? children,
    bool? hasMarker,
  }) {
    return MarkdownBulletedListBlockValue(
      id: id ?? this.id,
      indent: indent ?? this.indent,
      children: children ?? this.children,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is MarkdownBulletedListBlockValue &&
        other.id == id &&
        other.type == type &&
        children.equalsTo(other.children) &&
        other.indent == indent;
  }

  @override
  int get hashCode {
    var hash = super.hashCode;
    for (final child in children) {
      hash = hash ^ child.hashCode;
    }
    return hash;
  }

  @override
  String toString() {
    return "MarkdownBulletedListBlockValue(children: $children, indent: $indent)";
  }
}
