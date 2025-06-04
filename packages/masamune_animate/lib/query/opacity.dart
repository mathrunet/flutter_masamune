part of "query.dart";

/// Extension method for [EffectQuery] for animating transparency.
///
/// 透明度のアニメーションのための[EffectQuery]用の拡張メソッド。
extension OpacityEffectQueryExtensions on AnimateRunner {
  /// Animates transparency.
  ///
  /// Set the starting transparency to [begin].
  ///
  /// Set the transparency at the end to [end].
  ///
  /// Set the animation duration in [duration].
  ///
  /// Set the animation curve to [curve].
  ///
  /// 透明度のアニメーションを行います。
  ///
  /// [begin]に開始時の透明度を設定します。
  ///
  /// [end]に終了時の透明度を設定します。
  ///
  /// [duration]にアニメーションの時間を設定します。
  ///
  /// [curve]にアニメーションのカーブを設定します。
  Future<void> opacity({
    required Duration duration,
    Curve curve = Curves.linear,
    double begin = 0.0,
    double end = 0.0,
  }) {
    return runAnimateQuery(
      _OpacityEffectQuery(
        duration: duration,
        curve: curve,
        begin: begin,
        end: end,
      ),
    );
  }

  /// Fade-in animation.
  ///
  /// Set the animation duration in [duration].
  ///
  /// Set the animation curve to [curve].
  ///
  /// フェードインのアニメーションを行います。
  ///
  /// [duration]にアニメーションの時間を設定します。
  ///
  /// [curve]にアニメーションのカーブを設定します。
  Future<void> fadeIn({
    required Duration duration,
    Curve curve = Curves.linear,
  }) =>
      opacity(
        duration: duration,
        curve: curve,
        begin: 0.0,
        end: 1.0,
      );

  /// Fade-out animation.
  ///
  /// Set the animation duration in [duration].
  ///
  /// Set the animation curve to [curve].
  ///
  /// フェードアウトのアニメーションを行います。
  ///
  /// [duration]にアニメーションの時間を設定します。
  ///
  /// [curve]にアニメーションのカーブを設定します。
  Future<void> fadeOut({
    required Duration duration,
    Curve curve = Curves.linear,
  }) =>
      opacity(
        duration: duration,
        curve: curve,
        begin: 0.0,
        end: 1.0,
      );
}

class _OpacityEffectQuery extends EffectQuery<double> {
  const _OpacityEffectQuery({
    required super.duration,
    super.curve = Curves.linear,
    super.begin = 0.0,
    super.end = 0.0,
  });

  @override
  Widget build(BuildContext context, double value, Widget child) {
    return Opacity(opacity: value, child: child);
  }

  @override
  double transform(double value) {
    return begin + (end - begin) * curve.transform(value);
  }
}
