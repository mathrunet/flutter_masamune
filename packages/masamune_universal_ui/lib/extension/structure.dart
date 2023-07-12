part of masamune_universal_ui;

/// Extension methods for [Widget].
///
/// [Widget]の拡張メソッドです。
extension UniversalUIWidgetStructureExtensions on Widget {
  /// Move [Widget] to [alignment].
  ///
  /// [Widget]を[alignment]に寄せます。
  Align alignAt(
    Alignment alignment, {
    Key? key,
    double? heightFactor,
    double? widthFactor,
  }) {
    return Align(
      key: key,
      alignment: alignment,
      heightFactor: heightFactor,
      widthFactor: widthFactor,
      child: this,
    );
  }

  /// Center the [Widget].
  ///
  /// [Widget]を中央に寄せます。
  Center centerAt() {
    return Center(child: this);
  }

  /// Give [Expanded] to [Widget].
  ///
  /// [Widget]に[Expanded]を付与します。
  Expanded expanded({int flex = 1}) => Expanded(
        flex: flex,
        child: this,
      );

  /// Give [Flexible] to [Widget].
  ///
  /// [Widget]に[Flexible]を付与します。
  Flexible flexible({int flex = 1}) => Flexible(
        flex: flex,
        child: this,
      );
}
