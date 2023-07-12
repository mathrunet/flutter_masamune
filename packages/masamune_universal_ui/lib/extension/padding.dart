part of masamune_universal_ui;

/// Extension methods for [Widget].
///
/// [Widget]の拡張メソッドです。
extension UniversalUIPaddingExtensions on Widget {
  /// Set [Widget] padding to [padding].
  ///
  /// [Widget]のパディングを[padding]に設定します。
  Padding padding(EdgeInsetsGeometry padding) => Padding(
        padding: padding,
        child: this,
      );

  /// Set the padding of [Widget] based on [left], [top], [right], and [bottom].
  ///
  /// [Widget]のパディングを[left]、[top]、[right]、[bottom]を元に設定します。
  Padding paddingLTRB(
    double left,
    double top,
    double right,
    double bottom,
  ) =>
      Padding(
        padding: EdgeInsets.fromLTRB(left, top, right, bottom),
        child: this,
      );
}
