part of "/masamune_universal_ui.dart";

/// Define extension methods for [BuildContext] in Universal UI.
///
/// Universal UIの[BuildContext]用の拡張メソッドを定義します。
extension MasamuneUniversalBuildContextExtensions on BuildContext {
  /// Get [Breakpoint] defined in [UniversalMasamuneAdapter] and return `true` if its width is 100%.
  ///
  /// [UniversalMasamuneAdapter]で定義されている[Breakpoint]を取得して、その横幅が100%の場合に`true`を返します。
  bool get isFullWidth {
    final universal = MasamuneAdapterScope.of<UniversalMasamuneAdapter>(this);
    final mainWidth = universal?.defaultBreakpoint.width(this);
    return mainWidth == double.infinity;
  }
}

/// Define extension methods for [EdgeInsets] in Universal UI.
///
/// Universal UIの[EdgeInsets]用の拡張メソッドを定義します。
extension MasamuneResponsiveEdgeInsetsExtensions on EdgeInsets {
  /// Convert [EdgeInsets] to [ResponsiveEdgeInsets].
  ///
  /// [EdgeInsets]を[ResponsiveEdgeInsets]に変換します。
  ResponsiveEdgeInsets toResponsive(
    EdgeInsets greaterThanBreakpoint, {
    Breakpoint? breakpoint,
  }) {
    return ResponsiveEdgeInsets(
      this,
      breakpoint: breakpoint,
      greaterThanBreakpoint: greaterThanBreakpoint,
    );
  }
}
