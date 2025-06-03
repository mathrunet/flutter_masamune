part of "/katana_form.dart";

/// Class that defines the design for suggestions.
///
/// サジェスト用のデザインを定義するクラス。
@immutable
class SuggestionStyle {
  /// Class that defines the design for suggestions.
  ///
  /// サジェスト用のデザインを定義するクラス。
  const SuggestionStyle({
    this.offset = const Offset(0, 20),
    this.elevation = 8.0,
    this.backgroundColor,
    this.color,
    this.maxHeight = 260,
    this.borderRadius,
    this.border,
  });

  /// Offset at which to place the suggestion overlay.
  ///
  /// Specifies the offset from the form position.
  ///
  /// サジェストのオーバーレイを配置するオフセット。
  ///
  /// フォームの位置からのオフセットを指定します。
  final Offset offset;

  /// Suggestions window height.
  ///
  /// サジェストのウインドウの高さ。
  final double elevation;

  /// Background color of the Suggestions window.
  ///
  /// サジェストのウインドウの背景色。
  final Color? backgroundColor;

  /// Text color of the Suggestions window.
  ///
  /// サジェストのウインドウの文字色。
  final Color? color;

  /// Maximum height of the suggestion window.
  ///
  /// サジェストのウインドウの最大高さ。
  final double maxHeight;

  /// Border radius of the suggestion window.
  ///
  /// サジェストのウインドウの角の半径。
  final BorderRadius? borderRadius;

  /// Border of the suggestion window.
  ///
  /// サジェストのウインドウの枠線。
  final BorderSide? border;
}
