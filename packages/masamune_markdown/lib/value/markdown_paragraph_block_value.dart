part of "/masamune_markdown.dart";

/// A class for storing markdown paragraph block value.
///
/// マークダウンの段落ブロックの値を格納するクラス。
@immutable
class MarkdownParagraphBlockValue extends MarkdownMultiLineBlockValue {
  /// A class for storing markdown paragraph block value.
  ///
  /// マークダウンの段落ブロックの値を格納するクラス。
  const MarkdownParagraphBlockValue({
    required super.id,
    required super.children,
    super.indent = 0,
  });

  /// Create a [MarkdownParagraphBlockValue] from a [DynamicMap].
  ///
  /// [DynamicMap]から[MarkdownParagraphBlockValue]を作成します。
  factory MarkdownParagraphBlockValue.fromJson(DynamicMap json) {
    return MarkdownParagraphBlockValue(
      id: json.get(MarkdownValue.idKey, ""),
      indent: json.get(MarkdownValue.indentKey, 0),
      children: json
          .getAsList<DynamicMap>(MarkdownValue.childrenKey, [])
          .map(MarkdownLineValue.fromJson)
          .toList(),
    );
  }

  /// Create a [MarkdownParagraphBlockValue] from a markdown string.
  ///
  /// [markdown]から[MarkdownParagraphBlockValue]を作成します。
  factory MarkdownParagraphBlockValue.fromMarkdown(String markdown) {
    return MarkdownParagraphBlockValue(
      id: uuid(),
      children: [
        ...markdown.split("\n").map(MarkdownLineValue.fromMarkdown),
      ],
    );
  }

  @override
  String get type => "__text_block_paragraph__";

  @override
  bool get canIndent => true;

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
    return controller.style.paragraph.padding ?? EdgeInsets.zero;
  }

  @override
  EdgeInsetsGeometry margin(
    BuildContext context,
    MarkdownController controller,
  ) {
    return controller.style.paragraph.margin ?? EdgeInsets.zero;
  }

  @override
  TextStyle textStyle(
    BuildContext context,
    MarkdownController controller,
  ) {
    final theme = Theme.of(context);
    return (controller.style.paragraph.textStyle ??
            theme.textTheme.bodyMedium ??
            const TextStyle())
        .copyWith(
      color: controller.style.paragraph.foregroundColor,
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
    return children.map((e) => e.toMarkdown()).join("\n");
  }

  @override
  MarkdownParagraphBlockValue copyWith({
    String? id,
    int? indent,
    List<MarkdownLineValue>? children,
  }) {
    return MarkdownParagraphBlockValue(
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
    return other is MarkdownParagraphBlockValue &&
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
    return "MarkdownParagraphBlockValue(children: $children, indent: $indent)";
  }
}
