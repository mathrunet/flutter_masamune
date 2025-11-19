part of "/masamune_markdown.dart";

const _kParagraphType = "__markdown_block_paragraph__";

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

  /// Create a new [MarkdownParagraphBlockValue] with an empty child.
  ///
  /// 新しい[MarkdownParagraphBlockValue]を作成します。
  factory MarkdownParagraphBlockValue.createEmpty({
    String? initialText,
    List<MarkdownLineValue>? children,
    int indent = 0,
  }) {
    return MarkdownParagraphBlockValue(
      id: uuid(),
      indent: indent,
      children: children ??
          [
            MarkdownLineValue.createEmpty(initialText: initialText),
          ],
    );
  }

  @override
  String get type => _kParagraphType;

  @override
  bool get canIndent => true;

  @override
  bool get maintainIndentOnNewLine => true;

  @override
  bool get maintainTypeOnNewLine => true;

  @override
  String toMarkdown() {
    return children.map((e) => e.toMarkdown()).join("\n");
  }

  @override
  BlockStyle style(
    RenderContext context,
    MarkdownController controller,
  ) {
    final theme = context.theme;
    return BlockStyle(
      padding: controller.style.paragraph.padding ?? EdgeInsets.zero,
      margin: controller.style.paragraph.margin ?? EdgeInsets.zero,
      textStyle: (controller.style.paragraph.textStyle ??
              theme.textTheme.bodyMedium ??
              const TextStyle())
          .copyWith(
        color: controller.style.paragraph.foregroundColor,
      ),
    );
  }

  @override
  BlockLayout? build(
    RenderContext context,
    MarkdownController controller,
    int textOffset,
  ) {
    // コントローラーからブロックスタイルを取得
    var padding =
        (controller.style.paragraph.padding ?? EdgeInsets.zero) as EdgeInsets;
    final margin =
        (controller.style.paragraph.margin ?? EdgeInsets.zero) as EdgeInsets;

    // インデントを適用
    final indentWidth = indent * controller.style.indentWidth;
    padding = padding.copyWith(left: padding.left + indentWidth);

    // ベーステキストスタイルを構築
    final baseStyle = controller.style.paragraph.textStyle ?? context.style;
    final baseTextStyle = baseStyle.copyWith(
      color: controller.style.paragraph.foregroundColor ?? baseStyle.color,
    );

    // 各スパンに個別のスタイルを持つTextSpanツリーを構築
    final textSpans = <TextSpan>[];
    final spanInfos = <SpanInfo>[];
    var totalLength = 0;

    for (var i = 0; i < children.length; i++) {
      final line = children[i];
      for (final span in line.children) {
        // スパン固有のスタイルを適用
        final spanStyle = span.textStyle(context, controller, baseTextStyle);

        textSpans.add(TextSpan(
          text: span.value,
          style: spanStyle,
        ));

        // スパン情報を保存
        spanInfos.add(SpanInfo(
          span: span,
          localOffset: totalLength,
          length: span.value.length,
        ));

        totalLength += span.value.length;
      }
      if (i < children.length - 1) {
        textSpans.add(TextSpan(text: "\n", style: baseTextStyle));
        totalLength += 1;
      }
    }

    // このブロック用のテキストペインターを作成
    final painter = TextPainter(
      text: TextSpan(children: textSpans, style: baseTextStyle),
      textAlign: context.textAlign,
      textDirection: context.textDirection,
      textWidthBasis: context.textWidthBasis,
      textHeightBehavior: context.textHeightBehavior,
      strutStyle: context.strutStyle,
    );

    return BlockLayout(
      block: this,
      painter: painter,
      textOffset: textOffset,
      textLength: totalLength,
      padding: padding,
      margin: margin,
      spans: spanInfos,
    );
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
