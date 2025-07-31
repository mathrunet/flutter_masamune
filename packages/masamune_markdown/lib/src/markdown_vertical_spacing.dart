part of "/masamune_markdown.dart";

/// Vertical spacing for markdown.
///
/// マークダウンの垂直スペース。
@immutable
class MarkdownVerticalSpacing {
  /// Vertical spacing for markdown.
  ///
  /// マークダウンの垂直スペース。
  const MarkdownVerticalSpacing({
    required this.top,
    required this.bottom,
  });

  /// Top spacing.
  ///
  /// 上のスペース。
  final double top;

  /// Bottom spacing.
  ///
  /// 下のスペース。
  final double bottom;

  VerticalSpacing get _verticalSpacing => VerticalSpacing(top, bottom);
}
