part of "/masamune_markdown.dart";

const _kCodeBlockType = "__markdown_block_code__";

/// A class for storing markdown code block value.
///
/// マークダウンのコードブロックの値を格納するクラス。
@immutable
class MarkdownCodeBlockValue extends MarkdownMultiLineBlockValue {
  /// A class for storing markdown code block value.
  ///
  /// マークダウンのコードブロックの値を格納するクラス。
  const MarkdownCodeBlockValue({
    required super.id,
    required super.children,
    this.language = "",
    super.indent = 0,
  });

  /// The programming language of the code block (e.g., "dart", "javascript").
  ///
  /// コードブロックのプログラミング言語（例: "dart", "javascript"）。
  final String language;

  /// Create a [MarkdownCodeBlockValue] from a [DynamicMap].
  ///
  /// [DynamicMap]から[MarkdownCodeBlockValue]を作成します。
  factory MarkdownCodeBlockValue.fromJson(DynamicMap json) {
    return MarkdownCodeBlockValue(
      id: json.get(MarkdownValue.idKey, ""),
      indent: json.get(MarkdownValue.indentKey, 0),
      language: json.get("language", ""),
      children: json
          .getAsList<DynamicMap>(MarkdownValue.childrenKey, [])
          .map(MarkdownLineValue.fromJson)
          .toList(),
    );
  }

  /// Create a [MarkdownCodeBlockValue] from a markdown string.
  ///
  /// [markdown]から[MarkdownCodeBlockValue]を作成します。
  factory MarkdownCodeBlockValue.fromMarkdown(String markdown) {
    // Extract language from opening ``` marker
    var language = "";
    var codeContent = markdown;

    // Remove opening ``` and optional language identifier
    if (markdown.startsWith("```")) {
      final firstLineEnd = markdown.indexOf("\n");
      if (firstLineEnd != -1) {
        language = markdown.substring(3, firstLineEnd).trim();
        codeContent = markdown.substring(firstLineEnd + 1);
      } else {
        language = markdown.substring(3).trim();
        codeContent = "";
      }
    }

    // Remove closing ```
    if (codeContent.endsWith("```")) {
      codeContent = codeContent.substring(0, codeContent.length - 3);
    }

    // Remove trailing newline before closing ```
    if (codeContent.endsWith("\n")) {
      codeContent = codeContent.substring(0, codeContent.length - 1);
    }

    return MarkdownCodeBlockValue(
      id: uuid(),
      language: language,
      children: [
        ...codeContent.split("\n").map(MarkdownLineValue.fromMarkdown),
      ],
    );
  }

  /// Create a new [MarkdownCodeBlockValue] with an empty child.
  ///
  /// 新しい[MarkdownCodeBlockValue]を作成します。
  factory MarkdownCodeBlockValue.createEmpty({
    String? initialText,
    List<MarkdownLineValue>? children,
    String? language,
    int indent = 0,
  }) {
    return MarkdownCodeBlockValue(
      id: uuid(),
      indent: indent,
      language: language ?? "",
      children: children ??
          [
            MarkdownLineValue.createEmpty(initialText: initialText),
          ],
    );
  }

  @override
  String get type => _kCodeBlockType;

  @override
  bool get canIndent => false;

  @override
  bool get insertBlockOnNewLine => false;

  @override
  bool get maintainIndentOnNewLine => false;

  @override
  bool get maintainTypeOnNewLine => false;

  @override
  String toMarkdown() {
    final codeLines = children.map((e) => e.toMarkdown()).join("\n");
    return "```$language\n$codeLines\n```";
  }

  @override
  EdgeInsetsGeometry padding(
    BuildContext context,
    MarkdownController controller,
  ) {
    return controller.style.code.padding ?? EdgeInsets.zero;
  }

  @override
  EdgeInsetsGeometry margin(
    BuildContext context,
    MarkdownController controller,
  ) {
    return controller.style.code.margin ?? EdgeInsets.zero;
  }

  @override
  TextStyle textStyle(
    BuildContext context,
    MarkdownController controller,
  ) {
    final theme = Theme.of(context);
    return (controller.style.code.textStyle ??
            theme.textTheme.bodyMedium?.copyWith(
              fontFamily: "monospace",
              fontFamilyFallback: ["Courier", "monospace"],
            ) ??
            const TextStyle(
              fontFamily: "monospace",
              fontFamilyFallback: ["Courier", "monospace"],
            ))
        .copyWith(
      color: controller.style.code.foregroundColor,
    );
  }

  @override
  Color? backgroundColor(
    RenderContext context,
    MarkdownController controller,
  ) {
    return controller.style.code.backgroundColor;
  }

  @override
  BlockLayout? build(
    RenderContext context,
    MarkdownController controller,
    int textOffset,
  ) {
    // Get block style from controller
    var padding =
        (controller.style.code.padding ?? EdgeInsets.zero) as EdgeInsets;
    final margin =
        (controller.style.code.margin ?? EdgeInsets.zero) as EdgeInsets;

    // No indentation applied (canIndent = false)

    // Build base text style
    final foregroundColor = controller.style.code.foregroundColor ??
        context.theme.colorScheme.onSurface;
    final baseStyle = controller.style.code.textStyle ??
        context.theme.textTheme.bodyMedium?.copyWith(
          fontFamily: "monospace",
          fontFamilyFallback: ["Courier", "monospace"],
        ) ??
        context.style.copyWith(
          fontFamily: "monospace",
          fontFamilyFallback: ["Courier", "monospace"],
        );
    final baseTextStyle = baseStyle.copyWith(
      color: foregroundColor,
    );

    // Build TextSpan tree with individual styles for each span
    final textSpans = <TextSpan>[];
    final spanInfos = <_SpanInfo>[];
    var totalLength = 0;

    for (var i = 0; i < children.length; i++) {
      final line = children[i];
      for (final span in line.children) {
        // Apply span-specific style
        final spanStyle = span.textStyle(context, controller, baseTextStyle);

        textSpans.add(TextSpan(
          text: span.value,
          style: spanStyle,
        ));

        // Save span info
        spanInfos.add(_SpanInfo(
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

    // Create text painter for this block
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
  DynamicMap toJson() {
    return {
      ...super.toJson(),
      "language": language,
    };
  }

  @override
  MarkdownCodeBlockValue copyWith({
    String? id,
    int? indent,
    List<MarkdownLineValue>? children,
    String? language,
  }) {
    return MarkdownCodeBlockValue(
      id: id ?? this.id,
      indent: indent ?? this.indent,
      children: children ?? this.children,
      language: language ?? this.language,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is MarkdownCodeBlockValue &&
        other.id == id &&
        other.type == type &&
        other.language == language &&
        children.equalsTo(other.children) &&
        other.indent == indent;
  }

  @override
  int get hashCode {
    var hash = super.hashCode ^ language.hashCode;
    for (final child in children) {
      hash = hash ^ child.hashCode;
    }
    return hash;
  }

  @override
  String toString() {
    return "MarkdownCodeBlockValue(language: $language, children: $children, indent: $indent)";
  }
}
