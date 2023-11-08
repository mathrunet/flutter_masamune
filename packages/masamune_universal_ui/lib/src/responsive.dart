part of '/masamune_universal_ui.dart';

/// Determines which GridTier it belongs to based on the current screen size.
///
/// 現在の画面サイズからどのGridTierに属するかを判定します。
enum ResponsiveGridTier {
  /// GridTier for xs.
  ///
  /// xsのGridTier。
  xs,

  /// GridTier for sm.
  ///
  /// smのGridTier。
  sm,

  /// GridTier for md.
  ///
  /// mdのGridTier。
  md,

  /// GridTier for lg.
  ///
  /// lgのGridTier。
  lg,

  /// GridTier for xl.
  ///
  /// xlのGridTier。
  xl,

  /// GridTier for xxl.
  ///
  /// xxlのGridTier。
  xxl;

  /// Compare with other [ResponsiveGridTier].
  ///
  /// 他の[ResponsiveGridTier]と比較します。
  bool operator >(ResponsiveGridTier other) => index > other.index;

  /// Compare with other [ResponsiveGridTier].
  ///
  /// 他の[ResponsiveGridTier]と比較します。
  bool operator <(ResponsiveGridTier other) => index < other.index;

  /// Compare with other [ResponsiveGridTier].
  ///
  /// 他の[ResponsiveGridTier]と比較します。
  bool operator >=(ResponsiveGridTier other) => index >= other.index;

  /// Compare with other [ResponsiveGridTier].
  ///
  /// 他の[ResponsiveGridTier]と比較します。
  bool operator <=(ResponsiveGridTier other) => index <= other.index;

  static ResponsiveGridTier _currentSize(BuildContext context) {
    final breakpoints = BreakpointSettings.value;
    final mediaQueryData = MediaQuery.of(context);
    final width = mediaQueryData.size.width;

    if (width < breakpoints.xs) {
      return ResponsiveGridTier.xs;
    } else if (width < breakpoints.sm) {
      return ResponsiveGridTier.sm;
    } else if (width < breakpoints.md) {
      return ResponsiveGridTier.md;
    } else if (width < breakpoints.lg) {
      return ResponsiveGridTier.lg;
    } else if (width < breakpoints.xl) {
      return ResponsiveGridTier.xl;
    } else {
      return ResponsiveGridTier.xxl;
    }
  }
}

/// Provides an extension method for [Iterable] that includes [Widget] as an element.
///
/// [Widget]を要素に含んだ[Iterable]の拡張メソッドを提供します。
extension ResponsiveColExtensions on Iterable<Widget> {
  /// Wrap each [Widget] element with [Responsive] and transform.
  ///
  /// Each [Responsive] can be given a size from [xs] to [xxl], all set to the same size.
  ///
  /// You can use [filter] to convert one [Widget] to another [Widget] before conversion.
  ///
  /// 各[Widget]要素を[Responsive]でラップして変換します。
  ///
  /// 各[Responsive]は[xs]〜[xxl]までのサイズを与えることができ、すべて同じサイズで設定されます。
  ///
  /// [filter]を用いることで変換前の[Widget]を別の[Widget]に変換することができます。
  List<Responsive> mapResponsive({
    int xs = 12,
    int? sm,
    int? md,
    int? lg,
    int? xl,
    int? xxl,
    Widget Function(Widget item)? filter,
    EdgeInsetsGeometry? padding,
  }) {
    return map((item) {
      final child = filter?.call(item) ?? item;
      return Responsive(
        xs: xs,
        sm: sm,
        md: md,
        lg: lg,
        xl: xl,
        xxl: xxl,
        padding: padding,
        child: child,
      );
    }).toList();
  }
}

/// Specify responsive columns.
///
/// Be sure to place it under [UniversalColumn] or [UniversalListView].
///
/// You can enter values for [xs], [sm], [md], [lg], [xl], and [xxl], respectively, and the column width will change according to each value.
/// The line is also broken according to the respective breakpoints.
///
/// The maximum value for each value is the value of [UniversalColumn.rowSegments] or [UniversalListView.rowSegments].
///
/// In [child], specify the widget to be placed in the column.
///
/// レスポンシブなカラムを指定します。
///
/// 必ず[UniversalColumn]や[UniversalListView]の配下に設置してください。
///
/// [xs]、[sm]、[md]、[lg]、[xl]、[xxl]にそれぞれ値を入力することができ、それぞれの値に応じてカラムの幅が変化します。
/// また、それぞれのブレークポイントに応じて改行されます。
///
/// 各値の最大値は[UniversalColumn.rowSegments]や[UniversalListView.rowSegments]の値になります。
///
/// [child]には、カラムの中に配置するウィジェットを指定します。
class Responsive extends StatelessWidget {
  /// Specify responsive columns.
  ///
  /// Be sure to place it under [UniversalColumn] or [UniversalListView].
  ///
  /// You can enter values for [xs], [sm], [md], [lg], [xl], and [xxl], respectively, and the column width will change according to each value.
  /// The line is also broken according to the respective breakpoints.
  ///
  /// The maximum value for each value is the value of [UniversalColumn.rowSegments] or [UniversalListView.rowSegments].
  ///
  /// In [child], specify the widget to be placed in the column.
  ///
  /// レスポンシブなカラムを指定します。
  ///
  /// 必ず[UniversalColumn]や[UniversalListView]の配下に設置してください。
  ///
  /// [xs]、[sm]、[md]、[lg]、[xl]、[xxl]にそれぞれ値を入力することができ、それぞれの値に応じてカラムの幅が変化します。
  /// また、それぞれのブレークポイントに応じて改行されます。
  ///
  /// 各値の最大値は[UniversalColumn.rowSegments]や[UniversalListView.rowSegments]の値になります。
  ///
  /// [child]には、カラムの中に配置するウィジェットを指定します。
  const Responsive({
    this.xs = 12,
    this.sm,
    this.md,
    this.lg,
    this.xl,
    this.xxl,
    required this.child,
    this.padding,
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

  /// Defines where to place the widget with respect to its parent.
  ///
  /// [ResponsiveEdgeInsets] allows you to set responsive padding.
  ///
  /// 親要素に対してウィジェットを配置する位置を定義します。
  ///
  /// [ResponsiveEdgeInsets]を利用すると、レスポンシブなパディングを設定することができます。
  final EdgeInsetsGeometry? padding;

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
      child: _buildPadding(context, child),
    );
  }

  Widget _buildPadding(BuildContext context, Widget child) {
    final padding = ResponsiveEdgeInsets._responsive(context, this.padding);
    if (padding != null) {
      return Padding(
        padding: padding,
        child: child,
      );
    }
    return child;
  }
}
