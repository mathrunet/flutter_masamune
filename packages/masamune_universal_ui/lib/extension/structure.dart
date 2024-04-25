part of '/masamune_universal_ui.dart';

/// Extension methods for [Widget].
///
/// [Widget]の拡張メソッドです。
extension UniversalUIWidgetStructureExtensions on Widget {
  /// Move [Widget] to [alignment].
  ///
  /// [Widget]を[alignment]に寄せます。
  @Deprecated(
    "This Extension is no longer available; please use a Widget to describe it. このExtensionは使えなくなります。Widgetで記述してください。",
  )
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
  @Deprecated(
    "This Extension is no longer available; please use a Widget to describe it. このExtensionは使えなくなります。Widgetで記述してください。",
  )
  Center centerAt() {
    return Center(child: this);
  }

  /// Give [Expanded] to [Widget].
  ///
  /// [Widget]に[Expanded]を付与します。
  @Deprecated(
    "This Extension is no longer available; please use a Widget to describe it. このExtensionは使えなくなります。Widgetで記述してください。",
  )
  Expanded expanded({int flex = 1}) => Expanded(
        flex: flex,
        child: this,
      );

  /// Give [Flexible] to [Widget].
  ///
  /// [Widget]に[Flexible]を付与します。
  @Deprecated(
    "This Extension is no longer available; please use a Widget to describe it. このExtensionは使えなくなります。Widgetで記述してください。",
  )
  Flexible flexible({int flex = 1}) => Flexible(
        flex: flex,
        child: this,
      );
}
