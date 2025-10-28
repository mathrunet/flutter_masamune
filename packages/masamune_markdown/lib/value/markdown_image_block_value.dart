part of "/masamune_markdown.dart";

/// A class for storing markdown headline 1 block value.
///
/// マークダウンの見出し1ブロックの値を格納するクラス。
@immutable
class MarkdownImageBlockValue extends MarkdownSingleChildBlockValue<Uri> {
  /// A class for storing markdown headline 1 block value.
  ///
  /// マークダウンの見出し1ブロックの値を格納するクラス。
  const MarkdownImageBlockValue({
    required super.id,
    required super.child,
    super.indent = 0,
  });

  /// Create a [MarkdownImageBlockValue] from a [DynamicMap].
  ///
  /// [DynamicMap]から[MarkdownImageBlockValue]を作成します。
  factory MarkdownImageBlockValue.fromJson(DynamicMap json) {
    final uriString = json.get(uriKey, "");
    return MarkdownImageBlockValue(
      id: json.get(MarkdownValue.idKey, ""),
      indent: json.get(MarkdownValue.indentKey, 0),
      child: uriString.isNotEmpty ? Uri.tryParse(uriString) : null,
    );
  }

  /// Create a [MarkdownImageBlockValue] from a markdown string.
  ///
  /// [markdown]から[MarkdownImageBlockValue]を作成します。
  factory MarkdownImageBlockValue.fromMarkdown(String markdown) {
    // Extract image URL from "![<alt text>](<uri>)" format
    final match = RegExp(r"^!\[.*?\]\((.*?)\)").firstMatch(markdown);
    if (match == null) {
      throw Exception("Invalid markdown image format: $markdown");
    }
    final uriString = match.group(1) ?? "";
    return MarkdownImageBlockValue(
      id: uuid(),
      child: Uri.tryParse(uriString),
    );
  }

  /// Create a new [MarkdownImageBlockValue] with an empty child.
  ///
  /// 新しい[MarkdownImageBlockValue]を作成します。
  factory MarkdownImageBlockValue.createEmpty({
    String? initialText,
    Uri? uri,
    int indent = 0,
  }) {
    return MarkdownImageBlockValue(
      id: uuid(),
      indent: indent,
      child: uri,
    );
  }

  /// The key for the image URI.
  ///
  /// 画像URIのキー。
  static const String uriKey = "uri";

  @override
  String get type => "__markdown_block_image__";

  @override
  bool get canIndent => true;

  @override
  bool get maintainIndentOnNewLine => false;

  @override
  bool get maintainTypeOnNewLine => false;

  @override
  String toMarkdown() {
    return "![${child.toString()}](${child.toString()})";
  }

  @override
  EdgeInsetsGeometry padding(
    BuildContext context,
    MarkdownController controller,
  ) {
    return controller.style.h1.padding ?? EdgeInsets.zero;
  }

  @override
  EdgeInsetsGeometry margin(
    BuildContext context,
    MarkdownController controller,
  ) {
    return controller.style.h1.margin ?? EdgeInsets.zero;
  }

  @override
  TextStyle textStyle(
    BuildContext context,
    MarkdownController controller,
  ) {
    final theme = Theme.of(context);
    return (controller.style.h1.textStyle ??
            theme.textTheme.headlineLarge ??
            const TextStyle())
        .copyWith(
      color: controller.style.h1.foregroundColor,
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
    // 画像ブロックはテキストを含まないため、空のテキストペインターを作成
    final painter = TextPainter(
      text: const TextSpan(text: ""),
      textAlign: context.textAlign,
      textDirection: context.textDirection,
      textWidthBasis: context.textWidthBasis,
      textHeightBehavior: context.textHeightBehavior,
      strutStyle: context.strutStyle,
    );

    final padding = (controller.style.h1.padding ?? EdgeInsets.zero) as EdgeInsets;
    final margin = (controller.style.h1.margin ?? EdgeInsets.zero) as EdgeInsets;

    return BlockLayout(
      block: this,
      painter: painter,
      textOffset: textOffset,
      textLength: 0, // 画像ブロックはテキスト長さ0
      padding: padding,
      margin: margin,
      spans: const [], // 画像ブロックはスパンを持たない
    );
  }

  @override
  DynamicMap toJson() {
    return {
      MarkdownValue.idKey: id,
      MarkdownValue.typeKey: type,
      MarkdownValue.indentKey: indent,
      uriKey: child?.toString() ?? "",
    };
  }

  @override
  DynamicMap toDebug() {
    return {
      MarkdownValue.typeKey: type,
      MarkdownValue.indentKey: indent,
      uriKey: child?.toString() ?? "",
    };
  }

  @override
  MarkdownImageBlockValue copyWith({
    String? id,
    int? indent,
    Uri? child,
  }) {
    return MarkdownImageBlockValue(
      id: id ?? this.id,
      indent: indent ?? this.indent,
      child: child ?? this.child,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is MarkdownImageBlockValue &&
        other.id == id &&
        other.type == type &&
        other.child == child &&
        other.indent == indent;
  }

  @override
  int get hashCode {
    var hash = super.hashCode;
    hash = hash ^ child.hashCode;
    return hash;
  }

  @override
  String toString() {
    return "MarkdownImageBlockValue(child: $child, indent: $indent)";
  }

  @override
  StringBuffer _textBuilder(StringBuffer buffer, {bool indent = true}) {
    // plainTextには[Image]タグを追加、rawTextには何も表示しない
    if (indent) {
      buffer.write("[Image]");
    }
    return buffer;
  }
}
