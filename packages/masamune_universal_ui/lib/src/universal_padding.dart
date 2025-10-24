part of "/masamune_universal_ui.dart";

/// A widget that adds padding to its child.
///
/// [UniversalPadding] is the `UniversalUI` version of [Padding]. It provides responsive padding with automatic calculation for desktop and mobile.
/// Automatically adjusts padding based on breakpoint and supports center-aligned layouts.
///
/// ## Basic Usage
///
/// ```dart
/// UniversalPadding(
///   padding: const EdgeInsets.all(16),
///   child: const Text("Content"),
/// );
/// ```
///
/// ---
///
/// 子ウィジェットにパディングを追加するウィジェット。
///
/// [UniversalPadding]は[Padding]の`UniversalUI`版です。レスポンシブ対応でデスクトップ・モバイルで適切なパディングを自動計算。
/// ブレークポイントに応じてパディングを調整し、中央寄せレイアウトを実現します。
///
/// ## 基本的な利用方法
///
/// ```dart
/// UniversalPadding(
///   padding: const EdgeInsets.all(16),
///   child: const Text("コンテンツ"),
/// );
/// ```
class UniversalPadding extends StatelessWidget {
  /// A widget that adds padding to its child.
  ///
  /// [UniversalPadding] is the `UniversalUI` version of [Padding]. It provides responsive padding with automatic calculation for desktop and mobile.
  /// Automatically adjusts padding based on breakpoint and supports center-aligned layouts.
  ///
  /// ## Basic Usage
  ///
  /// ```dart
  /// UniversalPadding(
  ///   padding: const EdgeInsets.all(16),
  ///   child: const Text("Content"),
  /// );
  /// ```
  ///
  /// ---
  ///
  /// 子ウィジェットにパディングを追加するウィジェット。
  ///
  /// [UniversalPadding]は[Padding]の`UniversalUI`版です。レスポンシブ対応でデスクトップ・モバイルで適切なパディングを自動計算。
  /// ブレークポイントに応じてパディングを調整し、中央寄せレイアウトを実現します。
  ///
  /// ## 基本的な利用方法
  ///
  /// ```dart
  /// UniversalPadding(
  ///   padding: const EdgeInsets.all(16),
  ///   child: const Text("コンテンツ"),
  /// );
  /// ```
  const UniversalPadding({
    required this.child,
    super.key,
    this.padding,
    this.enableResponsivePadding,
  });

  /// Specify whether to enable responsive padding.
  ///
  /// If `true` or `false` is specified, it is forced to be enabled or disabled.
  ///
  /// [Null] will automatically be `false` if the parent has a [UniversalColumn] or [UniversalContainer]. If not, it will be `true`.
  ///
  /// レスポンシブのパディングを有効にするかどうかを指定します。
  ///
  /// `true`や`false`を指定する場合強制的に有効か無効になります。
  ///
  /// [Null]の場合、親に[UniversalColumn]や[UniversalContainer]がある場合は自動的に`false`になります。ない場合は`true`になります。
  final bool? enableResponsivePadding;

  /// Defines where to place the widget with respect to its parent.
  ///
  /// 親要素に対してウィジェットを配置する位置を定義します。
  final EdgeInsetsGeometry? padding;

  /// Child Widgets.
  ///
  /// 子ウィジェット。
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return _padding(context, child);
  }

  Widget _padding(BuildContext context, Widget child) {
    final universalWidgetScope = UniversalWidgetScope.of(context);
    final width = MediaQuery.of(context).size.width;
    final adapter = MasamuneAdapterScope.of<UniversalMasamuneAdapter>(context);
    final breakpoint = UniversalScaffold.of(context)?.breakpoint;
    final maxWidth = (breakpoint?.width(context) ?? width).limitHigh(width);
    final enablePadding = enableResponsivePadding ??
        adapter?.enableResponsivePadding ??
        universalWidgetScope == null;
    final responsivePadding = enablePadding ? (width - maxWidth) / 2.0 : 0.0;
    final resolvedPadding =
        _effectivePadding(context, breakpoint)?.resolve(TextDirection.ltr);
    final generatedPadding = EdgeInsets.fromLTRB(
      (resolvedPadding?.left ?? 0.0) + responsivePadding,
      resolvedPadding?.top ?? 0.0,
      (resolvedPadding?.right ?? 0.0) + responsivePadding,
      resolvedPadding?.bottom ?? 0.0,
    );

    return Padding(
      padding: generatedPadding,
      child: child,
    );
  }

  EdgeInsetsGeometry? _effectivePadding(
    BuildContext context,
    Breakpoint? breakpoint,
  ) {
    final universal =
        MasamuneAdapterScope.of<UniversalMasamuneAdapter>(context);
    return ResponsiveEdgeInsets._responsive(
      context,
      padding ?? universal?.defaultBodyPadding,
      breakpoint: breakpoint,
    );
  }
}
