part of katana_responsive;

/// Specify responsive columns.
///
/// Be sure to place it under [ResponsiveRow].
///
/// You can enter values for [xs], [sm], [md], [lg], [xl], and [xxl], respectively, and the column width will change according to each value.
/// The line is also broken according to the respective breakpoints.
///
/// The maximum value for each value is the value of [ResponsiveRow.rowSegments].
///
/// In [child], specify the widget to be placed in the column.
///
/// レスポンシブなカラムを指定します。
///
/// 必ず[ResponsiveRow]の配下に設置してください。
///
/// [xs]、[sm]、[md]、[lg]、[xl]、[xxl]にそれぞれ値を入力することができ、それぞれの値に応じてカラムの幅が変化します。
/// また、それぞれのブレークポイントに応じて改行されます。
///
/// 各値の最大値は[ResponsiveRow.rowSegments]の値になります。
///
/// [child]には、カラムの中に配置するウィジェットを指定します。
class ResponsiveCol extends StatefulWidget {
  /// Specify responsive columns.
  ///
  /// Be sure to place it under [ResponsiveRow].
  ///
  /// You can enter values for [xs], [sm], [md], [lg], [xl], and [xxl], respectively, and the column width will change according to each value.
  /// The line is also broken according to the respective breakpoints.
  ///
  /// The maximum value for each value is the value of [ResponsiveRow.rowSegments].
  ///
  /// In [child], specify the widget to be placed in the column.
  ///
  /// レスポンシブなカラムを指定します。
  ///
  /// 必ず[ResponsiveRow]の配下に設置してください。
  ///
  /// [xs]、[sm]、[md]、[lg]、[xl]、[xxl]にそれぞれ値を入力することができ、それぞれの値に応じてカラムの幅が変化します。
  /// また、それぞれのブレークポイントに応じて改行されます。
  ///
  /// 各値の最大値は[ResponsiveRow.rowSegments]の値になります。
  ///
  /// [child]には、カラムの中に配置するウィジェットを指定します。
  const ResponsiveCol({
    this.xs = 12,
    this.sm,
    this.md,
    this.lg,
    this.xl,
    this.xxl,
    required this.child,
    super.key,
  });

  /// Width of column at xs breakpoints.
  ///
  /// xsのブレークポイントにおけるカラムの幅。
  final int xs;

  /// Width of column at sm breakpoints.
  ///
  /// smのブレークポイントにおけるカラムの幅。
  final int? sm;

  /// Width of column at md breakpoints.
  ///
  /// mdのブレークポイントにおけるカラムの幅。
  final int? md;

  /// Width of column at lg breakpoints.
  ///
  /// lgのブレークポイントにおけるカラムの幅。
  final int? lg;

  /// Width of column at xl breakpoints.
  ///
  /// xlのブレークポイントにおけるカラムの幅。
  final int? xl;

  /// Width of column at xxl breakpoints.
  ///
  /// xxlのブレークポイントにおけるカラムの幅。
  final int? xxl;

  /// Widget under the control of.
  ///
  /// 配下のウィジェット。
  final Widget child;

  Map<ResponsiveGridTier, int?> _updateConfig() {
    final config = <ResponsiveGridTier, int?>{};
    config[ResponsiveGridTier.xs] = xs;
    config[ResponsiveGridTier.sm] = sm ?? config[ResponsiveGridTier.xs];
    config[ResponsiveGridTier.md] = md ?? config[ResponsiveGridTier.sm];
    config[ResponsiveGridTier.lg] = lg ?? config[ResponsiveGridTier.md];
    config[ResponsiveGridTier.xl] = xl ?? config[ResponsiveGridTier.lg];
    config[ResponsiveGridTier.xxl] = xxl ?? config[ResponsiveGridTier.xl];
    return config;
  }

  int? _currentConfig(BuildContext context) {
    return _updateConfig()[ResponsiveGridTier._currentSize(context)];
  }

  @override
  State<StatefulWidget> createState() => _ResponsiveColState();
}

class _ResponsiveColState extends State<ResponsiveCol> {
  @override
  void didUpdateWidget(covariant ResponsiveCol oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.xs != oldWidget.xs ||
        widget.sm != oldWidget.sm ||
        widget.md != oldWidget.md ||
        widget.lg != oldWidget.lg ||
        widget.xl != oldWidget.xl ||
        widget.xxl != oldWidget.xxl) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final flex = widget._currentConfig(context) ?? 1;
    return Expanded(
      flex: flex,
      child: widget.child,
    );
  }
}
