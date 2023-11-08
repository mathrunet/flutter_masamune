part of '/katana_ui.dart';

/// A widget for setting padding between elements in a [Column] or [ListView].
///
/// As is, multiple elements can be included with [children], which improves the overall look.
///
/// You can set the padding with [padding].
///
/// You can set how to place the child elements along the cross axis with [crossAxisAlignment].
///
/// You can set how to place the child elements along the main axis with [mainAxisAlignment].
///
/// You can set how much space to take along the main axis with [mainAxisSize].
///
/// You can set the direction along the main axis to use with [verticalDirection].
///
/// [Column]や[ListView]の中で、要素の間にパディングを設定するためのウィジェット。
///
/// そのまま、[children]で複数の要素を含めることができるので、全体的な見栄えがよくなります。
///
/// [padding]でパディングを設定できます。
///
/// [crossAxisAlignment]で、子要素をクロス軸方向にどのように配置するかを設定できます。
///
/// [mainAxisAlignment]で、子要素をメイン軸方向にどのように配置するかを設定できます。
///
/// [mainAxisSize]で、メイン軸方向にどれだけのスペースを取るかを設定できます。
///
/// [verticalDirection]で、メイン軸方向として使用する方向を設定できます。
class Indent extends StatelessWidget {
  /// A widget for setting padding between elements in a [Column] or [ListView].
  ///
  /// As is, multiple elements can be included with [children], which improves the overall look.
  ///
  /// You can set the padding with [padding].
  ///
  /// You can set how to place the child elements along the cross axis with [crossAxisAlignment].
  ///
  /// You can set how to place the child elements along the main axis with [mainAxisAlignment].
  ///
  /// You can set how much space to take along the main axis with [mainAxisSize].
  ///
  /// You can set the direction along the main axis to use with [verticalDirection].
  ///
  /// [Column]や[ListView]の中で、要素の間にパディングを設定するためのウィジェット。
  ///
  /// そのまま、[children]で複数の要素を含めることができるので、全体的な見栄えがよくなります。
  ///
  /// [padding]でパディングを設定できます。
  ///
  /// [crossAxisAlignment]で、子要素をクロス軸方向にどのように配置するかを設定できます。
  ///
  /// [mainAxisAlignment]で、子要素をメイン軸方向にどのように配置するかを設定できます。
  ///
  /// [mainAxisSize]で、メイン軸方向にどれだけのスペースを取るかを設定できます。
  ///
  /// [verticalDirection]で、メイン軸方向として使用する方向を設定できます。
  const Indent({
    super.key,
    required this.padding,
    required this.children,
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
