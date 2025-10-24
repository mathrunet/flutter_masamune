part of "/katana_ui.dart";

/// A padded column widget that simplifies vertical layouts with consistent padding.
///
/// This widget combines Padding and Column into a single convenient component,
/// making it easy to create vertically arranged layouts with consistent spacing.
/// Perfect for forms, settings screens, and any vertical list of content.
///
/// Features:
/// - Combines Padding and Column in one widget
/// - Configurable cross-axis alignment
/// - Configurable main-axis alignment
/// - Adjustable main-axis size
/// - Vertical direction control
/// - Cleaner code compared to nested Padding + Column
///
/// Example:
/// ```dart
/// Indent(
///   padding: EdgeInsets.all(16),
///   crossAxisAlignment: CrossAxisAlignment.stretch,
///   children: [
///     Text("First item"),
///     Text("Second item"),
///     ElevatedButton(onPressed: () {}, child: Text("Button")),
///   ],
/// )
/// ```
///
/// [Column]や[ListView]の中で、要素の間にパディングを設定するためのウィジェット。
///
/// このウィジェットはPaddingとColumnを1つの便利なコンポーネントに統合し、
/// 一貫したスペーシングで垂直に配置されたレイアウトを簡単に作成できます。
/// フォーム、設定画面、あらゆる縦方向のコンテンツリストに最適です。
///
/// 特徴:
/// - PaddingとColumnを1つのウィジェットに統合
/// - 設定可能なクロス軸の配置
/// - 設定可能なメイン軸の配置
/// - 調整可能なメイン軸のサイズ
/// - 垂直方向の制御
/// - Padding + Columnのネストよりもクリーンなコード
///
/// 例:
/// ```dart
/// Indent(
///   padding: EdgeInsets.all(16),
///   crossAxisAlignment: CrossAxisAlignment.stretch,
///   children: [
///     Text("最初の項目"),
///     Text("2番目の項目"),
///     ElevatedButton(onPressed: () {}, child: Text("ボタン")),
///   ],
/// )
/// ```
class Indent extends StatelessWidget {
  /// A padded column widget that simplifies vertical layouts with consistent padding.
  ///
  /// This widget combines Padding and Column into a single convenient component,
  /// making it easy to create vertically arranged layouts with consistent spacing.
  /// Perfect for forms, settings screens, and any vertical list of content.
  ///
  /// Features:
  /// - Combines Padding and Column in one widget
  /// - Configurable cross-axis alignment
  /// - Configurable main-axis alignment
  /// - Adjustable main-axis size
  /// - Vertical direction control
  /// - Cleaner code compared to nested Padding + Column
  ///
  /// Example:
  /// ```dart
  /// Indent(
  ///   padding: EdgeInsets.all(16),
  ///   crossAxisAlignment: CrossAxisAlignment.stretch,
  ///   children: [
  ///     Text("First item"),
  ///     Text("Second item"),
  ///     ElevatedButton(onPressed: () {}, child: Text("Button")),
  ///   ],
  /// )
  /// ```
  ///
  /// [Column]や[ListView]の中で、要素の間にパディングを設定するためのウィジェット。
  ///
  /// このウィジェットはPaddingとColumnを1つの便利なコンポーネントに統合し、
  /// 一貫したスペーシングで垂直に配置されたレイアウトを簡単に作成できます。
  /// フォーム、設定画面、あらゆる縦方向のコンテンツリストに最適です。
  ///
  /// 特徴:
  /// - PaddingとColumnを1つのウィジェットに統合
  /// - 設定可能なクロス軸の配置
  /// - 設定可能なメイン軸の配置
  /// - 調整可能なメイン軸のサイズ
  /// - 垂直方向の制御
  /// - Padding + Columnのネストよりもクリーンなコード
  ///
  /// 例:
  /// ```dart
  /// Indent(
  ///   padding: EdgeInsets.all(16),
  ///   crossAxisAlignment: CrossAxisAlignment.stretch,
  ///   children: [
  ///     Text("最初の項目"),
  ///     Text("2番目の項目"),
  ///     ElevatedButton(onPressed: () {}, child: Text("ボタン")),
  ///   ],
  /// )
  /// ```
  const Indent({
    required this.children,
    required this.padding,
    super.key,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.min,
    this.verticalDirection = VerticalDirection.down,
  });

  /// Padding of the entire element.
  ///
  /// 要素全体のパディング。
  final EdgeInsetsGeometry padding;

  /// A list of elements to arrange.
  ///
  /// 並べる要素のリスト。
  final List<Widget> children;

  /// How the children should be placed along the cross axis.
  ///
  /// 子要素をクロス軸方向にどのように配置するか。
  final CrossAxisAlignment crossAxisAlignment;

  /// How the children should be placed along the main axis.
  ///
  /// 子要素をメイン軸方向にどのように配置するか。
  final MainAxisAlignment mainAxisAlignment;

  /// How much space the main axis should take up.
  ///
  /// メイン軸方向にどれだけのスペースを取るか。
  final MainAxisSize mainAxisSize;

  /// The direction to use as the main axis.
  ///
  /// メイン軸方向として使用する方向。
  final VerticalDirection verticalDirection;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment: mainAxisAlignment,
        mainAxisSize: mainAxisSize,
        verticalDirection: verticalDirection,
        children: children,
      ),
    );
  }
}
