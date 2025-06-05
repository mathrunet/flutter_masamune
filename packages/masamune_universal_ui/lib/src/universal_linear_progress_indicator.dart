part of "/masamune_universal_ui.dart";

/// A Material Design linear progress indicator, also known as a progress bar.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=O-rhXZLtpv0}
///
/// A widget that shows progress along a line. There are two kinds of linear
/// progress indicators:
///
///  * _Determinate_. Determinate progress indicators have a specific value at
///    each point in time, and the value should increase monotonically from 0.0
///    to 1.0, at which time the indicator is complete. To create a determinate
///    progress indicator, use a non-null [value] between 0.0 and 1.0.
///  * _Indeterminate_. Indeterminate progress indicators do not have a specific
///    value at each point in time and instead indicate that progress is being
///    made without indicating how much progress remains. To create an
///    indeterminate progress indicator, use a null [value].
///
/// The indicator line is displayed with [valueColor], an animated value. To
/// specify a constant color value use: `AlwaysStoppedAnimation<Color>(color)`.
///
/// The minimum height of the indicator can be specified using [minHeight].
/// The indicator can be made taller by wrapping the widget with a [SizedBox].
///
/// {@tool dartpad}
/// This example showcases determinate and indeterminate [LinearProgressIndicator]s.
/// The [LinearProgressIndicator]s will use the ![updated Material 3 Design appearance](https://m3.material.io/components/progress-indicators/overview)
///
/// ** See code in examples/api/lib/material/progress_indicator/linear_progress_indicator.0.dart **
/// {@end-tool}
///
/// {@tool dartpad}
/// This sample shows the creation of a [LinearProgressIndicator] with a changing value.
/// When toggling the switch, [LinearProgressIndicator] uses a determinate value.
/// As described in: https://m3.material.io/components/progress-indicators/overview
///
/// ** See code in examples/api/lib/material/progress_indicator/linear_progress_indicator.1.dart **
/// {@end-tool}
///
/// See also:
///
///  * [CircularProgressIndicator], which shows progress along a circular arc.
///  * [RefreshIndicator], which automatically displays a [CircularProgressIndicator]
///    when the underlying vertical scrollable is overscrolled.
///  * <https://material.io/design/components/progress-indicators.html#linear-progress-indicators>
///
/// プログレスバーとしても知られるMaterial Designのリニアプログレスインジケーターです。
///
/// 線に沿って進行状況を表示するウィジェットです。リニアプログレスインジケーターには2つの種類があります：
///
///  * _確定的_。確定的プログレスインジケーターは各時点で特定の値を持ち、
///    値は0.0から1.0まで単調に増加し、その時点でインジケーターが完了します。
///    確定的プログレスインジケーターを作成するには、0.0から1.0の間の非null[value]を使用します。
///  * _不確定的_。不確定的プログレスインジケーターは各時点で特定の値を持たず、
///    代わりに残りの進行状況を示すことなく進行中であることを示します。
///    不確定的プログレスインジケーターを作成するには、null[value]を使用します。
///
/// インジケーターの線は、アニメーション値である[valueColor]で表示されます。
/// 定数色を指定するには：`AlwaysStoppedAnimation<Color>(color)`を使用します。
///
/// インジケーターの最小の高さは[minHeight]を使用して指定できます。
/// インジケーターをより高くするには、ウィジェットを[SizedBox]でラップします。
///
/// 参照：
///
///  * [CircularProgressIndicator]：円弧に沿って進行状況を表示します。
///  * [RefreshIndicator]：基盤となる垂直スクロール可能領域がオーバースクロールされたときに
///    [CircularProgressIndicator]を自動的に表示します。
///  * <https://material.io/design/components/progress-indicators.html#linear-progress-indicators>
class UniversalLinearProgressIndicator extends LinearProgressIndicator {
  /// A Material Design linear progress indicator, also known as a progress bar.
  ///
  /// {@youtube 560 315 https://www.youtube.com/watch?v=O-rhXZLtpv0}
  ///
  /// A widget that shows progress along a line. There are two kinds of linear
  /// progress indicators:
  ///
  ///  * _Determinate_. Determinate progress indicators have a specific value at
  ///    each point in time, and the value should increase monotonically from 0.0
  ///    to 1.0, at which time the indicator is complete. To create a determinate
  ///    progress indicator, use a non-null [value] between 0.0 and 1.0.
  ///  * _Indeterminate_. Indeterminate progress indicators do not have a specific
  ///    value at each point in time and instead indicate that progress is being
  ///    made without indicating how much progress remains. To create an
  ///    indeterminate progress indicator, use a null [value].
  ///
  /// The indicator line is displayed with [valueColor], an animated value. To
  /// specify a constant color value use: `AlwaysStoppedAnimation<Color>(color)`.
  ///
  /// The minimum height of the indicator can be specified using [minHeight].
  /// The indicator can be made taller by wrapping the widget with a [SizedBox].
  ///
  /// {@tool dartpad}
  /// This example showcases determinate and indeterminate [LinearProgressIndicator]s.
  /// The [LinearProgressIndicator]s will use the ![updated Material 3 Design appearance](https://m3.material.io/components/progress-indicators/overview)
  ///
  /// ** See code in examples/api/lib/material/progress_indicator/linear_progress_indicator.0.dart **
  /// {@end-tool}
  ///
  /// {@tool dartpad}
  /// This sample shows the creation of a [LinearProgressIndicator] with a changing value.
  /// When toggling the switch, [LinearProgressIndicator] uses a determinate value.
  /// As described in: https://m3.material.io/components/progress-indicators/overview
  ///
  /// ** See code in examples/api/lib/material/progress_indicator/linear_progress_indicator.1.dart **
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * [CircularProgressIndicator], which shows progress along a circular arc.
  ///  * [RefreshIndicator], which automatically displays a [CircularProgressIndicator]
  ///    when the underlying vertical scrollable is overscrolled.
  ///  * <https://material.io/design/components/progress-indicators.html#linear-progress-indicators>
  ///
  /// プログレスバーとしても知られるMaterial Designのリニアプログレスインジケーターです。
  ///
  /// 線に沿って進行状況を表示するウィジェットです。リニアプログレスインジケーターには2つの種類があります：
  ///
  ///  * _確定的_。確定的プログレスインジケーターは各時点で特定の値を持ち、
  ///    値は0.0から1.0まで単調に増加し、その時点でインジケーターが完了します。
  ///    確定的プログレスインジケーターを作成するには、0.0から1.0の間の非null[value]を使用します。
  ///  * _不確定的_。不確定的プログレスインジケーターは各時点で特定の値を持たず、
  ///    代わりに残りの進行状況を示すことなく進行中であることを示します。
  ///    不確定的プログレスインジケーターを作成するには、null[value]を使用します。
  ///
  /// インジケーターの線は、アニメーション値である[valueColor]で表示されます。
  /// 定数色を指定するには：`AlwaysStoppedAnimation<Color>(color)`を使用します。
  ///
  /// インジケーターの最小の高さは[minHeight]を使用して指定できます。
  /// インジケーターをより高くするには、ウィジェットを[SizedBox]でラップします。
  ///
  /// 参照：
  ///
  ///  * [CircularProgressIndicator]：円弧に沿って進行状況を表示します。
  ///  * [RefreshIndicator]：基盤となる垂直スクロール可能領域がオーバースクロールされたときに
  ///    [CircularProgressIndicator]を自動的に表示します。
  ///  * <https://material.io/design/components/progress-indicators.html#linear-progress-indicators>
  const UniversalLinearProgressIndicator({
    super.key,
    super.value,
    super.backgroundColor,
    super.color,
    super.valueColor,
    super.minHeight,
    super.semanticsLabel,
    super.semanticsValue,
    super.borderRadius,
    super.stopIndicatorColor,
    super.stopIndicatorRadius,
    super.trackGap,
  });

  @override
  double? get value {
    if (UniversalMasamuneAdapter.primary.isTest) {
      return 0.0;
    }
    return super.value;
  }
}
