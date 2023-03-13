part of masamune_universal_ui;

/// Sets breakpoints for the grid.
///
/// Defaults to the same breakpoints as bootstrap.
///
/// You can set your own breakpoints by updating [value].
///
/// グリッドのブレークポイントを設定します。
///
/// デフォルトはbootstrapと同じブレークポイントになります。
///
/// [value]を更新することで独自のブレークポイントを設定することが可能です。
///
/// ```dart
/// BreakpointSettings.value = BreakpointSettings(
///   xs: 600,
///   sm: 800,
///   md: 1000,
///   lg: 1200,
///   xl: 1400,
///   xxl: double.infinity,
/// );
/// ```
///
/// See also:
///   * https://getbootstrap.jp/docs/5.0/layout/breakpoints/
class BreakpointSettings {
  /// Sets breakpoints for the grid.
  ///
  /// Defaults to the same breakpoints as bootstrap.
  ///
  /// You can set your own breakpoints by updating [value].
  ///
  /// グリッドのブレークポイントを設定します。
  ///
  /// デフォルトはbootstrapと同じブレークポイントになります。
  ///
  /// [value]を更新することで独自のブレークポイントを設定することが可能です。
  ///
  /// ```dart
  /// BreakpointSettings.value = BreakpointSettings(
  ///   xs: 600,
  ///   sm: 800,
  ///   md: 1000,
  ///   lg: 1200,
  ///   xl: 1400,
  ///   xxl: double.infinity,
  /// );
  /// ```
  ///
  /// See also:
  ///   * https://getbootstrap.jp/docs/5.0/layout/breakpoints/
  BreakpointSettings({
    this.xs = 576,
    this.sm = 768,
    this.md = 992,
    this.lg = 1200,
    this.xl = 1400,
    this.xxl = double.infinity,
    this.xsContainerWidth = 540,
    this.smContainerWidth = 720,
    this.mdContainerWidth = 960,
    this.lgContainerWidth = 1140,
    this.xlContainerWidth = 1320,
    this.xxlContainerWidth = 1500,
  });

  /// xs size breakpoints.
  ///
  /// xsサイズのブレークポイント。
  final double xs;

  /// sm size breakpoints.
  ///
  /// smサイズのブレークポイント。
  final double sm;

  /// md size breakpoints.
  ///
  /// mdサイズのブレークポイント。
  final double md;

  /// lg size breakpoints.
  ///
  /// lgサイズのブレークポイント。
  final double lg;

  /// xl size breakpoints.
  ///
  /// xlサイズのブレークポイント。
  final double xl;

  /// xxl size breakpoints.
  ///
  /// xxlサイズのブレークポイント。
  final double xxl;

  /// Container width at xs size.
  ///
  /// xsサイズ時のコンテナの幅。
  final double xsContainerWidth;

  /// Container width at sm size.
  ///
  /// smサイズ時のコンテナの幅。
  final double smContainerWidth;

  /// Container width at md size.
  ///
  /// mdサイズ時のコンテナの幅。
  final double mdContainerWidth;

  /// Container width at lg size.
  ///
  /// lgサイズ時のコンテナの幅。
  final double lgContainerWidth;

  /// Container width at xl size.
  ///
  /// xlサイズ時のコンテナの幅。
  final double xlContainerWidth;

  /// Container width at xxl size.
  ///
  /// xxlサイズ時のコンテナの幅。
  final double xxlContainerWidth;

  /// New breakpoints can be set by updating this value.
  ///
  /// この値を更新することで新しいブレークポイントを設定することが可能です。
  static BreakpointSettings value = BreakpointSettings();
}
