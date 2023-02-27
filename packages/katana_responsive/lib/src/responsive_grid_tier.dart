part of katana_responsive;

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
    final breakpoints = ResponsiveBreakpoints.value;
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
