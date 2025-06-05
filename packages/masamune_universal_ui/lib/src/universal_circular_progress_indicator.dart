part of "/masamune_universal_ui.dart";

/// A Material Design circular progress indicator, which spins to indicate that
/// the application is busy.
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=O-rhXZLtpv0}
///
/// A widget that shows progress along a circle. There are two kinds of circular
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
/// The indicator arc is displayed with [valueColor], an animated value. To
/// specify a constant color use: `AlwaysStoppedAnimation<Color>(color)`.
///
/// {@tool dartpad}
/// This example showcases determinate and indeterminate [CircularProgressIndicator]s.
/// The [CircularProgressIndicator]s will use the ![updated Material 3 Design appearance](https://m3.material.io/components/progress-indicators/overview)
///
/// ** See code in examples/api/lib/material/progress_indicator/circular_progress_indicator.0.dart **
/// {@end-tool}
///
/// {@tool dartpad}
/// This sample shows the creation of a [CircularProgressIndicator] with a changing value.
/// When toggling the switch, [CircularProgressIndicator] uses a determinate value.
/// As described in: https://m3.material.io/components/progress-indicators/overview
///
/// ** See code in examples/api/lib/material/progress_indicator/circular_progress_indicator.1.dart **
/// {@end-tool}
///
/// See also:
///
///  * [LinearProgressIndicator], which displays progress along a line.
///  * [RefreshIndicator], which automatically displays a [CircularProgressIndicator]
///    when the underlying vertical scrollable is overscrolled.
///  * <https://material.io/design/components/progress-indicators.html#circular-progress-indicators>
///
/// アプリケーションがビジー状態であることを示すために回転するMaterial Designの円形プログレスインジケーターです。
///
/// 円に沿って進行状況を表示するウィジェットです。円形プログレスインジケーターには2つの種類があります：
///
///  * _確定的_。確定的プログレスインジケーターは各時点で特定の値を持ち、
///    値は0.0から1.0まで単調に増加し、その時点でインジケーターが完了します。
///    確定的プログレスインジケーターを作成するには、0.0から1.0の間の非null[value]を使用します。
///  * _不確定的_。不確定的プログレスインジケーターは各時点で特定の値を持たず、
///    代わりに残りの進行状況を示すことなく進行中であることを示します。
///    不確定的プログレスインジケーターを作成するには、null[value]を使用します。
///
/// インジケーターの弧は、アニメーション値である[valueColor]で表示されます。
/// 定数色を指定するには：`AlwaysStoppedAnimation<Color>(color)`を使用します。
///
/// 参照：
///
///  * [LinearProgressIndicator]：線に沿って進行状況を表示します。
///  * [RefreshIndicator]：基盤となる垂直スクロール可能領域がオーバースクロールされたときに
///    [CircularProgressIndicator]を自動的に表示します。
///  * <https://material.io/design/components/progress-indicators.html#circular-progress-indicators>
class UniversalCircularProgressIndicator extends CircularProgressIndicator {
  /// A Material Design circular progress indicator, which spins to indicate that
  /// the application is busy.
  ///
  /// {@youtube 560 315 https://www.youtube.com/watch?v=O-rhXZLtpv0}
  ///
  /// A widget that shows progress along a circle. There are two kinds of circular
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
  /// The indicator arc is displayed with [valueColor], an animated value. To
  /// specify a constant color use: `AlwaysStoppedAnimation<Color>(color)`.
  ///
  /// {@tool dartpad}
  /// This example showcases determinate and indeterminate [CircularProgressIndicator]s.
  /// The [CircularProgressIndicator]s will use the ![updated Material 3 Design appearance](https://m3.material.io/components/progress-indicators/overview)
  ///
  /// ** See code in examples/api/lib/material/progress_indicator/circular_progress_indicator.0.dart **
  /// {@end-tool}
  ///
  /// {@tool dartpad}
  /// This sample shows the creation of a [CircularProgressIndicator] with a changing value.
  /// When toggling the switch, [CircularProgressIndicator] uses a determinate value.
  /// As described in: https://m3.material.io/components/progress-indicators/overview
  ///
  /// ** See code in examples/api/lib/material/progress_indicator/circular_progress_indicator.1.dart **
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * [LinearProgressIndicator], which displays progress along a line.
  ///  * [RefreshIndicator], which automatically displays a [CircularProgressIndicator]
  ///    when the underlying vertical scrollable is overscrolled.
  ///  * <https://material.io/design/components/progress-indicators.html#circular-progress-indicators>
  ///
  /// アプリケーションがビジー状態であることを示すために回転するMaterial Designの円形プログレスインジケーターです。
  ///
  /// 円に沿って進行状況を表示するウィジェットです。円形プログレスインジケーターには2つの種類があります：
  ///
  ///  * _確定的_。確定的プログレスインジケーターは各時点で特定の値を持ち、
  ///    値は0.0から1.0まで単調に増加し、その時点でインジケーターが完了します。
  ///    確定的プログレスインジケーターを作成するには、0.0から1.0の間の非null[value]を使用します。
  ///  * _不確定的_。不確定的プログレスインジケーターは各時点で特定の値を持たず、
  ///    代わりに残りの進行状況を示すことなく進行中であることを示します。
  ///    不確定的プログレスインジケーターを作成するには、null[value]を使用します。
  ///
  /// インジケーターの弧は、アニメーション値である[valueColor]で表示されます。
  /// 定数色を指定するには：`AlwaysStoppedAnimation<Color>(color)`を使用します。
  ///
  /// 参照：
  ///
  ///  * [LinearProgressIndicator]：線に沿って進行状況を表示します。
  ///  * [RefreshIndicator]：基盤となる垂直スクロール可能領域がオーバースクロールされたときに
  ///    [CircularProgressIndicator]を自動的に表示します。
  ///  * <https://material.io/design/components/progress-indicators.html#circular-progress-indicators>
  const UniversalCircularProgressIndicator({
    super.key,
    super.value,
    super.backgroundColor,
    super.color,
    super.valueColor,
    super.strokeWidth,
    super.strokeAlign,
    super.semanticsLabel,
    super.semanticsValue,
    super.strokeCap,
    super.constraints,
    super.trackGap,
    super.padding,
  });

  /// Creates an adaptive progress indicator that is a
  /// [CupertinoActivityIndicator] on [TargetPlatform.iOS] &
  /// [TargetPlatform.macOS] and a [CircularProgressIndicator] in material
  /// theme/non-Apple platforms.
  ///
  /// The [valueColor], [strokeWidth], [strokeAlign], [strokeCap],
  /// [semanticsLabel], [semanticsValue], [trackGap] will be
  /// ignored on iOS & macOS.
  ///
  /// {@macro flutter.material.ProgressIndicator.ProgressIndicator}
  ///
  /// [TargetPlatform.iOS]と[TargetPlatform.macOS]では[CupertinoActivityIndicator]、
  /// Material テーマ/非Appleプラットフォームでは[CircularProgressIndicator]となる
  /// アダプティブなプログレスインジケーターを作成します。
  ///
  /// [valueColor]、[strokeWidth]、[strokeAlign]、[strokeCap]、
  /// [semanticsLabel]、[semanticsValue]、[trackGap]は
  /// iOS と macOS では無視されます。
  const UniversalCircularProgressIndicator.adaptive({
    super.key,
    super.value,
    super.backgroundColor,
    super.valueColor,
    super.strokeWidth = 4.0,
    super.semanticsLabel,
    super.semanticsValue,
    super.strokeCap,
    super.strokeAlign,
    super.constraints,
    super.trackGap,
    super.padding,
  });

  @override
  double? get value {
    if (UniversalMasamuneAdapter.primary.isTest) {
      return 0.0;
    }
    return super.value;
  }
}
