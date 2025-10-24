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
    this.quote = const MarkdownStyleValue(
      margin: EdgeInsets.symmetric(vertical: 8),
    ),
    this.code = const MarkdownStyleValue(
      margin: EdgeInsets.symmetric(vertical: 8),
    ),
    this.indentWidth = 16,
    this.indentWhiteSpaceCount = 2,
  });

  /// Vertical spacing for paragraph.
  ///
  /// 段落の垂直スペース。
  final MarkdownStyleValue paragraph;

  /// Vertical spacing for h1.
  ///
  /// h1の垂直スペース。
  final MarkdownStyleValue h1;

  /// Vertical spacing for h2.
  ///
  /// h2の垂直スペース。
  final MarkdownStyleValue h2;

  /// Vertical spacing for h3.
  ///
  /// h3の垂直スペース。
  final MarkdownStyleValue h3;

  /// Vertical spacing for h4.
  ///
  /// h4の垂直スペース。
  final MarkdownStyleValue h4;

  /// Vertical spacing for h5.
  ///
  /// h5の垂直スペース。
  final MarkdownStyleValue h5;

  /// Vertical spacing for h6.
  ///
  /// h6の垂直スペース。
  final MarkdownStyleValue h6;

  /// Vertical spacing for list.
  ///
  /// リストの垂直スペース。
  final MarkdownStyleValue list;

  /// Vertical spacing for quote.
  ///
  /// 引用の垂直スペース。
  final MarkdownStyleValue quote;

  /// Vertical spacing for code.
  ///
  /// コードの垂直スペース。
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
}
