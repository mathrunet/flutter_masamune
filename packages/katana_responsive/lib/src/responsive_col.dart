part of katana_responsive;

/// Provides an extension method for [Iterable] that includes [Widget] as an element.
///
/// [Widget]を要素に含んだ[Iterable]の拡張メソッドを提供します。
extension ResponsiveColExtensions on Iterable<Widget> {
  /// Wrap each [Widget] element with [ResponsiveCol] and transform.
  ///
  /// Each [ResponsiveCol] can be given a size from [xs] to [xxl], all set to the same size.
  ///
  /// You can use [filter] to convert one [Widget] to another [Widget] before conversion.
  ///
  /// 各[Widget]要素を[ResponsiveCol]でラップして変換します。
  ///
  /// 各[ResponsiveCol]は[xs]〜[xxl]までのサイズを与えることができ、すべて同じサイズで設定されます。
  ///
  /// [filter]を用いることで変換前の[Widget]を別の[Widget]に変換することができます。
  List<ResponsiveCol> mapResponsiveCol({
    int xs = 12,
    int? sm,
    int? md,
    int? lg,
    int? xl,
    int? xxl,
    Widget Function(Widget item)? filter,
  }) {
    return map((item) {
      final child = filter?.call(item) ?? item;
      return ResponsiveCol(
        xs: xs,
        sm: sm,
        md: md,
        lg: lg,
        xl: xl,
        xxl: xxl,
        child: child,
      );
    }).toList();
  }
}

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
class ResponsiveCol extends StatelessWidget {
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

  /// Get the value for the current size.
  ///
  /// 現在のサイズに応じた値を取得します。
  int? currentConfig(BuildContext context) {
    return _updateConfig()[ResponsiveGridTier._currentSize(context)];
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: currentConfig(context) ?? 1,
      child: child,
    );
  }
}
