part of "/masamune_markdown.dart";

const _kHeadline2Type = "__markdown_block_headline_2__";

/// A class for storing markdown headline 2 block value.
///
/// マークダウンの見出し2ブロックの値を格納するクラス。
@immutable
class MarkdownHeadline2BlockValue extends MarkdownMultiLineBlockValue {
  /// A class for storing markdown headline 2 block value.
  ///
  /// マークダウンの見出し2ブロックの値を格納するクラス。
  const MarkdownHeadline2BlockValue({
    required super.id,
    required super.children,
    super.indent = 0,
  });

  /// Create a [MarkdownHeadline2BlockValue] from a [DynamicMap].
  ///
  /// [DynamicMap]から[MarkdownHeadline2BlockValue]を作成します。
  factory MarkdownHeadline2BlockValue.fromJson(DynamicMap json) {
    return MarkdownHeadline2BlockValue(
      id: json.get(MarkdownValue.idKey, ""),
      indent: json.get(MarkdownValue.indentKey, 0),
      children: json
          .getAsList<DynamicMap>(MarkdownValue.childrenKey, [])
          .map(MarkdownLineValue.fromJson)
          .toList(),
    );
  }

  /// Create a [MarkdownHeadline2BlockValue] from a markdown string.
  ///
  /// [markdown]から[MarkdownHeadline2BlockValue]を作成します。
  factory MarkdownHeadline2BlockValue.fromMarkdown(String markdown) {
    // 先頭の "## " マーカーを削除
    final cleanedMarkdown = markdown.replaceFirst(RegExp(r"^##\s+"), "");
    return MarkdownHeadline2BlockValue(
      id: uuid(),
      children: [
        ...cleanedMarkdown.split("\n").map(MarkdownLineValue.fromMarkdown),
      ],
    );
  }

  /// Create a new [MarkdownHeadline2BlockValue] with an empty child.
  ///
  /// 新しい[MarkdownHeadline2BlockValue]を作成します。
  factory MarkdownHeadline2BlockValue.createEmpty({
    String? initialText,
    List<MarkdownLineValue>? children,
    int indent = 0,
  }) {
    return MarkdownHeadline2BlockValue(
      id: uuid(),
      indent: indent,
      children: children ??
          [
            MarkdownLineValue.createEmpty(initialText: initialText),
          ],
    );
  }

  @override
  String get type => _kHeadline2Type;

  @override
  bool get canIndent => false;

  @override
  bool get maintainIndentOnNewLine => false;

  @override
  bool get maintainTypeOnNewLine => false;

  @override
  String toMarkdown() {
    return children.map((e) => "## ${e.toMarkdown()}").join("\n");
  }

  @override
  EdgeInsetsGeometry padding(
    BuildContext context,
    MarkdownController controller,
  ) {
    return controller.style.h2.padding ?? EdgeInsets.zero;
  }

  @override
  EdgeInsetsGeometry margin(
    BuildContext context,
    MarkdownController controller,
  ) {
    return controller.style.h2.margin ?? EdgeInsets.zero;
  }

  @override
  TextStyle textStyle(
    BuildContext context,
    MarkdownController controller,
  ) {
    final theme = Theme.of(context);
    return (controller.style.h2.textStyle ??
            theme.textTheme.headlineMedium ??
            const TextStyle())
        .copyWith(
      color: controller.style.h2.foregroundColor,
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
  BlockLayout? build(
    RenderContext context,
    MarkdownController controller,
    int textOffset,
  ) {
    // コントローラーからブロックスタイルを取得
    var padding =
        (controller.style.h2.padding ?? EdgeInsets.zero) as EdgeInsets;
    final margin =
        (controller.style.h2.margin ?? EdgeInsets.zero) as EdgeInsets;

    // インデントは適用しない（canIndent = false）

    // ベーステキストスタイルを構築
    final foregroundColor = controller.style.h2.foregroundColor ??
        context.theme.colorScheme.onSurface;
    final baseStyle = controller.style.h2.textStyle ??
        context.theme.textTheme.headlineMedium ??
        context.style;
    final baseTextStyle = baseStyle.copyWith(
      color: foregroundColor,
    );

    // 各スパンに個別のスタイルを持つTextSpanツリーを構築
    final textSpans = <TextSpan>[];
    final spanInfos = <_SpanInfo>[];
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
  MarkdownHeadline2BlockValue copyWith({
    String? id,
    int? indent,
    List<MarkdownLineValue>? children,
  }) {
    return MarkdownHeadline2BlockValue(
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
    return other is MarkdownHeadline2BlockValue &&
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
    return "MarkdownHeadline2BlockValue(children: $children, indent: $indent)";
  }
}
