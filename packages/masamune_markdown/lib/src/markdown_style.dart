part of "/masamune_markdown.dart";

/// Style for markdown.
///
/// マークダウンのスタイル。
@immutable
class MarkdownStyle {
  /// Style for markdown.
  ///
  /// マークダウンのスタイル。
  const MarkdownStyle({
    this.paragraph = const MarkdownStyleValue(
      margin: EdgeInsets.symmetric(vertical: 8),
    ),
    this.h1 = const MarkdownStyleValue(
      margin: EdgeInsets.symmetric(vertical: 24),
    ),
    this.h2 = const MarkdownStyleValue(
      margin: EdgeInsets.symmetric(vertical: 16),
    ),
    this.h3 = const MarkdownStyleValue(
      margin: EdgeInsets.symmetric(vertical: 16),
    ),
    this.h4 = const MarkdownStyleValue(
      margin: EdgeInsets.symmetric(vertical: 16),
    ),
    this.h5 = const MarkdownStyleValue(
      margin: EdgeInsets.symmetric(vertical: 16),
    ),
    this.h6 = const MarkdownStyleValue(
      margin: EdgeInsets.symmetric(vertical: 16),
    ),
    this.list = const MarkdownStyleValue(
      margin: EdgeInsets.symmetric(vertical: 8),
    ),
    this.toggleList = const MarkdownStyleValue(
      margin: EdgeInsets.symmetric(vertical: 8),
    ),
    this.quote = const MarkdownStyleValue(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.fromLTRB(16, 8, 8, 8),
    ),
    this.code = const MarkdownStyleValue(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
    ),
    this.media = const MarkdownStyleValue(
      margin: EdgeInsets.symmetric(vertical: 8),
    ),
    this.indentWidth = 24,
    this.indentWhiteSpaceCount = 2,
  });

  /// Style for paragraph.
  ///
  /// 段落のスタイル。
  final MarkdownStyleValue paragraph;

  /// Style for h1.
  ///
  /// h1のスタイル。
  final MarkdownStyleValue h1;

  /// Style for h2.
  ///
  /// h2のスタイル。
  final MarkdownStyleValue h2;

  /// Style for h3.
  ///
  /// h3のスタイル。
  final MarkdownStyleValue h3;

  /// Style for h4.
  ///
  /// h4のスタイル。
  final MarkdownStyleValue h4;

  /// Style for h5.
  ///
  /// h5のスタイル。
  final MarkdownStyleValue h5;

  /// Style for h6.
  ///
  /// h6のスタイル。
  final MarkdownStyleValue h6;

  /// Style for list.
  ///
  /// リストのスタイル。
  final MarkdownStyleValue list;

  /// Style for check list.
  ///
  /// チェックリストのスタイル。
  final MarkdownStyleValue toggleList;

  /// Style for media.
  ///
  /// メディアのスタイル。
  final MarkdownStyleValue media;

  /// Style for quote.
  ///
  /// 引用のスタイル。
  final MarkdownStyleValue quote;

  /// Style for code.
  ///
  /// コードのスタイル。
  final MarkdownStyleValue code;

  /// Indent width.
  ///
  /// インデントの幅。
  final double indentWidth;

  /// Indent white space count.
  ///
  /// インデントの空白の数。
  final int indentWhiteSpaceCount;
}

/// Value for markdown style.
///
/// マークダウンのスタイルの値。
class MarkdownStyleValue {
  /// Value for markdown style.
  ///
  /// マークダウンのスタイルの値。
  const MarkdownStyleValue({
    this.padding,
    this.margin,
    this.textStyle,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.border,
  });

  /// Padding of the markdown style.
  ///
  /// マークダウンのスタイルのパディング。
  final EdgeInsetsGeometry? padding;

  /// Margin of the markdown style.
  ///
  /// マークダウンのスタイルのマージン。
  final EdgeInsetsGeometry? margin;

  /// Text style of the markdown style.
  ///
  /// マークダウンのスタイルのテキストスタイル。
  final TextStyle? textStyle;

  /// Background color of the markdown style.
  ///
  /// マークダウンのスタイルの背景色。
  final Color? backgroundColor;

  /// Foreground color of the markdown style.
  ///
  /// マークダウンのスタイルの前景色。
  final Color? foregroundColor;

  /// Border of the markdown style.
  ///
  /// マークダウンのスタイルのボーダー。
  final Border? border;

  /// Border radius of the markdown style.
  ///
  /// マークダウンのスタイルの角の丸み。
  final BorderRadiusGeometry? borderRadius;
}
