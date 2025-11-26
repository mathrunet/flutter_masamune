part of "/masamune_markdown.dart";

const _kBulletedListType = "__markdown_block_bulleted_list__";

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
    // 先頭の "- " または "* " マーカーを削除
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
  factory MarkdownBulletedListBlockValue.createEmpty({
    String? initialText,
    List<MarkdownLineValue>? children,
    int indent = 0,
  }) {
    return MarkdownBulletedListBlockValue(
      id: uuid(),
      indent: indent,
      children: children ??
          [
            MarkdownLineValue.createEmpty(initialText: initialText),
          ],
    );
  }

  @override
  String get type => _kBulletedListType;

  @override
  bool get canIndent => true;

  @override
  bool get maintainIndentOnNewLine => true;

  @override
  bool get maintainTypeOnNewLine => true;

  @override
  String toMarkdown() {
    return children.map((e) => "- ${e.toMarkdown()}").join("\n");
  }

  @override
  BlockStyle style(
    RenderContext context,
    MarkdownController controller,
  ) {
    final theme = context.theme;
    return BlockStyle(
      padding: controller.style.list.padding ?? EdgeInsets.zero,
      margin: controller.style.list.margin ?? EdgeInsets.zero,
      textStyle: (controller.style.list.textStyle ??
              theme.textTheme.bodyMedium ??
              const TextStyle())
          .copyWith(
        color: controller.style.list.foregroundColor,
      ),
      borderRadius: controller.style.list.borderRadius,
      border: controller.style.list.border,
      backgroundColor: controller.style.list.backgroundColor,
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
        (controller.style.list.padding ?? EdgeInsets.zero) as EdgeInsets;
    final margin =
        (controller.style.list.margin ?? EdgeInsets.zero) as EdgeInsets;

    // インデントを適用
    final indentWidth = indent * controller.style.indentWidth;
    padding = padding.copyWith(
        left: padding.left + indentWidth + controller.style.indentWidth);

    // ベーステキストスタイルを構築
    final foregroundColor = controller.style.list.foregroundColor ??
        context.theme.colorScheme.onSurface;
    final baseStyle = controller.style.list.textStyle ?? context.style;
    final baseTextStyle = baseStyle.copyWith(
      color: foregroundColor,
    );

    // 各スパンに個別のスタイルを持つTextSpanツリーを構築
    // 注意: マーカーはテキストコンテンツに含まれない
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

    // このブロック用のテキストペインターを作成（マーカーなし）
    final painter = TextPainter(
      text: TextSpan(children: textSpans, style: baseTextStyle),
      textAlign: context.textAlign,
      textDirection: context.textDirection,
      textWidthBasis: context.textWidthBasis,
      textHeightBehavior: context.textHeightBehavior,
      strutStyle: context.strutStyle,
    );

    // インデントベースのシンボルでマーカー情報を作成
    void Function(Canvas canvas, Offset offset)? markerSymbol;
    final markerIndent = indent % 3;
    switch (markerIndent) {
      case 0:
        markerSymbol = (canvas, offset) {
          canvas.drawCircle(offset, 4, Paint()..color = foregroundColor);
        };
        break;
      case 1:
        markerSymbol = (canvas, offset) {
          canvas.drawCircle(
              offset,
              4,
              Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 2
                ..color = foregroundColor);
        };
        break;
      default:
        markerSymbol = (canvas, offset) {
          canvas.drawRect(
            Rect.fromCenter(
              center: offset,
              width: 8,
              height: 8,
            ),
            Paint()..color = foregroundColor,
          );
        };
        break;
    }
    final markerInfo = MarkerInfo(
      markerBuilder: markerSymbol,
      width: controller.style.indentWidth,
    );

    return BlockLayout(
      block: this,
      painter: painter,
      textOffset: textOffset,
      textLength: totalLength,
      padding: padding,
      margin: margin,
      spans: spanInfos,
      marker: markerInfo,
    );
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
