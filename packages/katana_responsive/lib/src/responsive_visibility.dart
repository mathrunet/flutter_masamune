part of katana_responsive;

/// This [Widget] is displayed only when the condition of [visible] is met.
///
/// [visible] is responsive and takes [ResponsiveGridTier] as an argument.
///
/// [ResponsiveGridTier] is one of [ResponsiveGridTier.xs], [ResponsiveGridTier.sm], [ResponsiveGridTier.md], [ResponsiveGridTier.lg], [ ResponsiveGridTier.xl], [ResponsiveGridTier.xxl], and returns `true` based on its value to display [child].
///
/// [visible]の条件に合致する場合にのみ表示される[Widget]です。
///
/// [visible]はレスポンシブに対応しており、[ResponsiveGridTier]を引数に取ります。
///
/// [ResponsiveGridTier]は、[ResponsiveGridTier.xs]、[ResponsiveGridTier.sm]、[ResponsiveGridTier.md]、[ResponsiveGridTier.lg]、[ResponsiveGridTier.xl]、[ResponsiveGridTier.xxl]のいずれかであり、その値を元に`true`を返すことにより[child]を表示します。
///
/// ```dart
/// ResponsiveVisibility(
///   visible: (tier) => tier <= ResponsiveGridTier.xs,
///   child: IconButton(
///     color: Colors.white,
///     icon: const Icon(Icons.add),
///     onPressed: () {},
///   ),
/// )
/// ```
class ResponsiveVisibility extends StatelessWidget {
  /// This [Widget] is displayed only when the condition of [visible] is met.
  ///
  /// [visible] is responsive and takes [ResponsiveGridTier] as an argument.
  ///
  /// [ResponsiveGridTier] is one of [ResponsiveGridTier.xs], [ResponsiveGridTier.sm], [ResponsiveGridTier.md], [ResponsiveGridTier.lg], [ ResponsiveGridTier.xl], [ResponsiveGridTier.xxl], and returns `true` based on its value to display [child].
  ///
  /// [visible]の条件に合致する場合にのみ表示される[Widget]です。
  ///
  /// [visible]はレスポンシブに対応しており、[ResponsiveGridTier]を引数に取ります。
  ///
  /// [ResponsiveGridTier]は、[ResponsiveGridTier.xs]、[ResponsiveGridTier.sm]、[ResponsiveGridTier.md]、[ResponsiveGridTier.lg]、[ResponsiveGridTier.xl]、[ResponsiveGridTier.xxl]のいずれかであり、その値を元に`true`を返すことにより[child]を表示します。
  ///
  /// ```dart
  /// ResponsiveVisibility(
  ///   visible: (tier) => tier <= ResponsiveGridTier.xs,
  ///   child: IconButton(
  ///     color: Colors.white,
  ///     icon: const Icon(Icons.add),
  ///     onPressed: () {},
  ///   ),
  /// )
  /// ```
  const ResponsiveVisibility({
    super.key,
    required this.child,
    required this.visible,
  });

  /// Widget for display.
  ///
  /// 表示する場合のウィジェット。
  final Widget child;

  /// Function to determine whether or not to display [child] by taking [ResponsiveGridTier] as an argument and returning [bool].
  ///
  /// If `true` is returned, [child] will be displayed.
  ///
  /// [ResponsiveGridTier]を引数に取り、[bool]を返すことにより[child]を表示するかどうかを決定する関数。
  ///
  /// `true`を返すと[child]が表示されます。
  final bool Function(ResponsiveGridTier tier) visible;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isVisible =
            visible.call(ResponsiveGridTier._currentSize(context));
        return Visibility(
          visible: isVisible,
          child: child,
        );
      },
    );
  }
}
