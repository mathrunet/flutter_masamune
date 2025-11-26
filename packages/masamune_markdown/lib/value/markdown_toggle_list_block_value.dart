part of "/masamune_markdown.dart";

const _kToggleListType = "__markdown_block_toggle_list__";

/// A class for storing markdown toggle list block value.
///
/// マークダウンのチェックボックスリストブロックの値を格納するクラス。
@immutable
class MarkdownToggleListBlockValue extends MarkdownMultiLineBlockValue {
  /// A class for storing markdown toggle list block value.
  ///
  /// マークダウンのチェックボックスリストブロックの値を格納するクラス。
  const MarkdownToggleListBlockValue({
    required super.id,
    required super.children,
    super.indent = 0,
    this.checked = false,
  });

  /// Create a [MarkdownToggleListBlockValue] from a [DynamicMap].
  ///
  /// [DynamicMap]から[MarkdownToggleListBlockValue]を作成します。
  factory MarkdownToggleListBlockValue.fromJson(DynamicMap json) {
    return MarkdownToggleListBlockValue(
      id: json.get(MarkdownValue.idKey, ""),
      indent: json.get(MarkdownValue.indentKey, 0),
      checked: json.get(MarkdownValue.checkedKey, false),
      children: json
          .getAsList<DynamicMap>(MarkdownValue.childrenKey, [])
          .map(MarkdownLineValue.fromJson)
          .toList(),
    );
  }

  /// Create a [MarkdownToggleListBlockValue] from a markdown string.
  ///
  /// [markdown]から[MarkdownToggleListBlockValue]を作成します。
  factory MarkdownToggleListBlockValue.fromMarkdown(String markdown) {
    // 先頭の "[x] " または "[ ] " マーカーを削除
    final checked = markdown.trim().startsWith("[x]");
    final cleanedMarkdown = markdown.trim().replaceFirst(
          RegExp(r"^\[[ x]\]\s+"),
          "",
        );
    return MarkdownToggleListBlockValue(
      id: uuid(),
      checked: checked,
      children: [
        ...cleanedMarkdown.split("\n").map(MarkdownLineValue.fromMarkdown),
      ],
    );
  }

  /// Create a new [MarkdownToggleListBlockValue] with an empty child.
  ///
  /// 新しい[MarkdownToggleListBlockValue]を作成します。
  factory MarkdownToggleListBlockValue.createEmpty({
    String? initialText,
    List<MarkdownLineValue>? children,
    int indent = 0,
    bool checked = false,
  }) {
    return MarkdownToggleListBlockValue(
      id: uuid(),
      indent: indent,
      checked: checked,
      children: children ??
          [
            MarkdownLineValue.createEmpty(initialText: initialText),
          ],
    );
  }

  @override
  String get type => _kToggleListType;

  /// The checked state of the toggle list block.
  ///
  /// チェックボックスリストブロックのチェック状態。
  final bool checked;

  @override
  bool get canIndent => true;

  @override
  bool get maintainIndentOnNewLine => true;

  @override
  bool get maintainTypeOnNewLine => true;

  @override
  String toMarkdown() {
    return children
        .map((e) => "[${checked ? "x" : " "}] ${e.toMarkdown()}")
        .join("\n");
  }

  @override
  DynamicMap toJson() {
    return {
      ...super.toJson(),
      MarkdownValue.checkedKey: checked,
    };
  }

  @override
  BlockStyle style(
    RenderContext context,
    MarkdownController controller,
  ) {
    final theme = context.theme;
    return BlockStyle(
      padding: controller.style.toggleList.padding ?? EdgeInsets.zero,
      margin: controller.style.toggleList.margin ?? EdgeInsets.zero,
      textStyle: (controller.style.toggleList.textStyle ??
              theme.textTheme.bodyMedium ??
              const TextStyle())
          .copyWith(
        color: controller.style.toggleList.foregroundColor,
      ),
      borderRadius: controller.style.toggleList.borderRadius,
      border: controller.style.toggleList.border,
      backgroundColor: controller.style.toggleList.backgroundColor,
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
        (controller.style.toggleList.padding ?? EdgeInsets.zero) as EdgeInsets;
    final margin =
        (controller.style.toggleList.margin ?? EdgeInsets.zero) as EdgeInsets;

    // インデントを適用
    final indentWidth = indent * controller.style.indentWidth;
    padding = padding.copyWith(
        left: padding.left + indentWidth + controller.style.indentWidth);

    // ベーステキストスタイルを構築
    final foregroundColor = controller.style.toggleList.foregroundColor ??
        context.theme.colorScheme.onSurface;
    final baseStyle = controller.style.toggleList.textStyle ?? context.style;
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

    // チェックボックスマーカー情報を作成
    void Function(Canvas canvas, Offset offset)? markerSymbol;
    markerSymbol = (canvas, offset) {
      const boxSize = 16.0;
      final rect = Rect.fromCenter(
        center: offset,
        width: boxSize,
        height: boxSize,
      );

      // チェックボックスの枠を描画
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(3)),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = foregroundColor,
      );

      // チェックされている場合はチェックマークを描画
      if (checked) {
        final checkPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = foregroundColor
          ..strokeCap = StrokeCap.round;

        final checkPath = Path();
        checkPath.moveTo(offset.dx - 4, offset.dy);
        checkPath.lineTo(offset.dx - 1, offset.dy + 3);
        checkPath.lineTo(offset.dx + 4, offset.dy - 4);

        canvas.drawPath(checkPath, checkPaint);
      }
    };

    final markerInfo = MarkerInfo(
      markerBuilder: markerSymbol,
      width: controller.style.indentWidth,
      onTapMarker: () {
        controller.toggleBlock(this);
      },
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
  MarkdownToggleListBlockValue copyWith({
    String? id,
    int? indent,
    List<MarkdownLineValue>? children,
    bool? checked,
  }) {
    return MarkdownToggleListBlockValue(
      id: id ?? this.id,
      indent: indent ?? this.indent,
      children: children ?? this.children,
      checked: checked ?? this.checked,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is MarkdownToggleListBlockValue &&
        other.id == id &&
        other.type == type &&
        children.equalsTo(other.children) &&
        other.indent == indent &&
        other.checked == checked;
  }

  @override
  int get hashCode {
    var hash = super.hashCode;
    for (final child in children) {
      hash = hash ^ child.hashCode;
    }
    hash = hash ^ checked.hashCode;
    return hash;
  }

  @override
  String toString() {
    return "MarkdownToggleListBlockValue(children: $children, indent: $indent, checked: $checked)";
  }
}
