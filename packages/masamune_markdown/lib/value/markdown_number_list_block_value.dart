part of "../masamune_markdown.dart";

const _kNumberListType = "__markdown_block_number_list__";

/// A class for storing markdown numbered list block value.
///
/// マークダウンの番号付きリストブロックの値を格納するクラス。
@immutable
class MarkdownNumberListBlockValue extends MarkdownMultiLineBlockValue {
  /// A class for storing markdown numbered list block value.
  ///
  /// マークダウンの番号付きリストブロックの値を格納するクラス。
  const MarkdownNumberListBlockValue({
    required super.id,
    required super.children,
    super.indent = 0,
    this.lineIndex = 0,
  });

  /// The index of the current line in the list (for numbering).
  ///
  /// リスト内の現在の行のインデックス（番号付けのため）。
  final int lineIndex;

  /// Create a [MarkdownNumberListBlockValue] from a [DynamicMap].
  ///
  /// [DynamicMap]から[MarkdownNumberListBlockValue]を作成します。
  factory MarkdownNumberListBlockValue.fromJson(DynamicMap json) {
    return MarkdownNumberListBlockValue(
      id: json.get(MarkdownValue.idKey, ""),
      indent: json.get(MarkdownValue.indentKey, 0),
      lineIndex: json.get("lineIndex", 0),
      children: json
          .getAsList<DynamicMap>(MarkdownValue.childrenKey, [])
          .map(MarkdownLineValue.fromJson)
          .toList(),
    );
  }

  /// Create a [MarkdownNumberListBlockValue] from a markdown string.
  ///
  /// [markdown]から[MarkdownNumberListBlockValue]を作成します。
  factory MarkdownNumberListBlockValue.fromMarkdown(String markdown) {
    // 先頭の数字と "." または ")" マーカーを削除
    final cleanedMarkdown = markdown.replaceFirst(RegExp(r"^\d+[.)]?\s+"), "");
    return MarkdownNumberListBlockValue(
      id: uuid(),
      children: [
        ...cleanedMarkdown.split("\n").map(MarkdownLineValue.fromMarkdown),
      ],
    );
  }

  /// Create a new [MarkdownNumberListBlockValue] with an empty child.
  ///
  /// 新しい[MarkdownNumberListBlockValue]を作成します。
  factory MarkdownNumberListBlockValue.createEmpty({
    String? initialText,
    List<MarkdownLineValue>? children,
    int indent = 0,
    int lineIndex = 0,
  }) {
    return MarkdownNumberListBlockValue(
      id: uuid(),
      indent: indent,
      lineIndex: lineIndex,
      children: children ??
          [
            MarkdownLineValue.createEmpty(initialText: initialText),
          ],
    );
  }

  @override
  String get type => _kNumberListType;

  @override
  bool get canIndent => true;

  @override
  bool get maintainIndentOnNewLine => true;

  @override
  bool get maintainTypeOnNewLine => true;

  @override
  String toMarkdown() {
    final marker = getMarkerForIndent(indent, lineIndex);
    return children.map((e) => "$marker ${e.toMarkdown()}").join("\n");
  }

  @override
  DynamicMap toJson() {
    return {
      MarkdownValue.typeKey: type,
      MarkdownValue.idKey: id,
      MarkdownValue.indentKey: indent,
      "lineIndex": lineIndex,
      MarkdownValue.childrenKey: children.map((e) => e.toJson()).toList(),
    };
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

  /// Get the marker string for the given indent level and line index.
  ///
  /// 指定されたインデントレベルと行インデックスに対するマーカー文字列を取得します。
  String getMarkerForIndent(int indent, int lineIndex) {
    final level = indent % 3; // 0, 1, 2でループ
    final number = lineIndex + 1;

    switch (level) {
      case 0:
        // 1階層: 1, 2, 3...
        return "$number.";
      case 1:
        // 2階層: a, b, c...
        return "${toAlphabet(number)}.";
      case 2:
        // 3階層: i, ii, iii...
        return "${toRoman(number)}.";
      default:
        return "$number.";
    }
  }

  /// Convert a number to lowercase alphabet (a, b, c, ..., z, aa, ab, ...).
  ///
  /// 数字を小文字アルファベットに変換します（a, b, c, ..., z, aa, ab, ...）。
  String toAlphabet(int number) {
    if (number <= 0) {
      return "";
    }

    var result = "";
    int n = number - 1; // 0-indexed for calculation

    while (n >= 0) {
      result = String.fromCharCode(97 + (n % 26)) + result;
      n = (n ~/ 26) - 1;
      if (n < 0) {
        break;
      }
    }

    return result;
  }

  /// Convert a number to lowercase roman numeral.
  ///
  /// 数字を小文字のローマ数字に変換します。
  String toRoman(int number) {
    if (number <= 0 || number > 3999) {
      return number.toString();
    }

    final values = [1000, 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1];
    final symbols = [
      "m",
      "cm",
      "d",
      "cd",
      "c",
      "xc",
      "l",
      "xl",
      "x",
      "ix",
      "v",
      "iv",
      "i"
    ];

    var result = "";
    var n = number;

    for (var i = 0; i < values.length; i++) {
      while (n >= values[i]) {
        result += symbols[i];
        n -= values[i];
      }
    }

    return result;
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

    // マーカーのテキストを取得
    final markerText = getMarkerForIndent(indent, lineIndex);

    // マーカーの幅を計算（マーカーテキスト + スペース）
    final markerStyle = controller.style.list.textStyle ?? context.style;
    final markerPainter = TextPainter(
      text: TextSpan(text: "$markerText ", style: markerStyle),
      textDirection: context.textDirection,
    );
    markerPainter.layout();
    final markerWidth = markerPainter.width;

    padding = padding.copyWith(
        left: padding.left + indentWidth + markerWidth + 4); // 4 for spacing

    // ベーステキストスタイルを構築
    final foregroundColor = controller.style.list.foregroundColor ??
        context.theme.colorScheme.onSurface;
    final baseStyle = controller.style.list.textStyle ?? context.style;
    final baseTextStyle = baseStyle.copyWith(
      color: foregroundColor,
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

        totalLength += span.value.length.toInt();
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

    // マーカー情報を作成（テキストベースのマーカー）
    // offsetは垂直方向に中央揃え（preferredLineHeight / 2が加算されている）
    // TextPainterは左上から描画するため、マーカーの高さの半分を引いて調整
    final markerInfo = MarkerInfo(
      markerBuilder: (canvas, offset) {
        markerPainter.paint(
          canvas,
          Offset(offset.dx - markerWidth, offset.dy - markerPainter.height / 2),
        );
      },
      width: markerWidth,
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
  MarkdownNumberListBlockValue copyWith({
    String? id,
    int? indent,
    List<MarkdownLineValue>? children,
    int? lineIndex,
  }) {
    return MarkdownNumberListBlockValue(
      id: id ?? this.id,
      indent: indent ?? this.indent,
      children: children ?? this.children,
      lineIndex: lineIndex ?? this.lineIndex,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is MarkdownNumberListBlockValue &&
        other.id == id &&
        other.type == type &&
        children.equalsTo(other.children) &&
        other.indent == indent &&
        other.lineIndex == lineIndex;
  }

  @override
  int get hashCode {
    var hash = super.hashCode;
    for (final child in children) {
      hash = hash ^ child.hashCode;
    }
    hash = hash ^ lineIndex.hashCode;
    return hash;
  }

  @override
  String toString() {
    return "MarkdownNumberListBlockValue(children: $children, indent: $indent, lineIndex: $lineIndex)";
  }
}
