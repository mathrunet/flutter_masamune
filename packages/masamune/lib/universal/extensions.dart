part of masamune;

/// Define extension methods for [BuildContext] in Universal UI.
///
/// Universal UIの[BuildContext]用の拡張メソッドを定義します。
extension MasamuneUniversalBuildContextExtensions on BuildContext {
  /// Get [ResponsiveBreakpoint] defined in [UniversalMasamuneAdapter] and return `true` if its width is 100%.
  ///
  /// [UniversalMasamuneAdapter]で定義されている[ResponsiveBreakpoint]を取得して、その横幅が100%の場合に`true`を返します。
  bool get isFullWidth {
    final universal = MasamuneAdapterScope.of<UniversalMasamuneAdapter>(this);
    final mainWidth = universal?.defaultBreakpoint.width(this);
    return mainWidth == double.infinity;
  }
}
