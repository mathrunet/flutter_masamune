part of 'query.dart';

/// Extension method for [EffectQuery] for rotational animation.
///
/// 回転アニメーションのための[EffectQuery]用の拡張メソッド。
extension RotateEffectQueryExtensions on AnimateRunner {
  /// Performs rotational animation.
  ///
  /// Set the starting rotation speed at [begin]. 1.0 is 360 degrees (2π).
  ///
  /// Set the number of rotations at the end to [end]. 1.0 is 360 degrees (2π).
  ///
  /// The center of rotation can be changed by setting [alignment].
  ///
  /// Set the animation duration in [duration].
  ///
  /// Set the animation curve to [curve].
  ///
  /// 回転アニメーションを行います。
  ///
  /// [begin]に開始時の回転数を設定します。1.0で360度（2π）です。
  ///
  /// [end]に終了時の回転数を設定します。1.0で360度（2π）です。
  ///
  /// [alignment]を設定すると回転の中心を変更できます。
  ///
  /// [duration]にアニメーションの時間を設定します。
  ///
  /// [curve]にアニメーションのカーブを設定します。
  Future<void> rotate({
    required Duration duration,
    Curve curve = Curves.linear,
    double begin = 0.0,
    double end = 1.0,
    Alignment? alignment,
  }) {
    return runAnimateQuery(
      _RotateEffectQuery(
        duration: duration,
        curve: curve,
        begin: begin,
        end: end,
        alignment: alignment,
      ),
    );
  }

  /// X-axis scale animation.
  ///
  /// Set the X-axis scale at the start to [begin].
  ///
  /// Set the X-axis scale at the end to [end].
  ///
  /// The center of the size change can be changed by setting [alignment].
  ///
  /// Set the animation duration in [duration].
  ///
  /// Set the animation curve to [curve].
  ///
  /// X軸スケールアニメーションを行います。
  ///
  /// [begin]に開始時のX軸スケールを設定します。
  ///
  /// [end]に終了時のX軸スケールを設定します。
  ///
  /// [alignment]を設定すると大きさの変更の中心を変更できます。
  ///
  /// [duration]にアニメーションの時間を設定します。
  ///
  /// [curve]にアニメーションのカーブを設定します。
  Future<void> scaleX({
    required Duration duration,
    Curve curve = Curves.linear,
    double begin = 0.0,
    double end = 0.0,
    Alignment? alignment,
  }) =>
      scale(
        duration: duration,
        curve: curve,
        begin: Offset(begin, 0.0),
        end: Offset(end, 0.0),
        alignment: alignment,
      );

  /// Y-axis scale animation.
  ///
  /// Set the Y-axis scale at the start to [begin].
  ///
  /// Set the Y-axis scale at the end to [end].
  ///
  /// The center of the size change can be changed by setting [alignment].
  ///
  /// Set the animation duration in [duration].
  ///
  /// Set the animation curve to [curve].
  ///
  /// Y軸スケールアニメーションを行います。
  ///
  /// [begin]に開始時のY軸スケールを設定します。
  ///
  /// [end]に終了時のY軸スケールを設定します。
  ///
  /// [alignment]を設定すると大きさの変更の中心を変更できます。
  ///
  /// [duration]にアニメーションの時間を設定します。
  ///
  /// [curve]にアニメーションのカーブを設定します。
  Future<void> scaleY({
    required Duration duration,
    Curve curve = Curves.linear,
    double begin = 0.0,
    double end = 0.0,
    Alignment? alignment,
  }) =>
      scale(
        duration: duration,
        curve: curve,
        begin: Offset(0.0, begin),
        end: Offset(0.0, end),
        alignment: alignment,
      );

  /// Scale animation that specifies equal magnitudes on the XY axis.
  ///
  /// Set the starting scale in [begin].
  ///
  /// Set the end scale to [end].
  ///
  /// The center of the size change can be changed by setting [alignment].
  ///
  /// Set the animation duration in [duration].
  ///
  /// Set the animation curve to [curve].
  ///
  /// XY軸で等しい大きさを指定するスケールアニメーションを行います。
  ///
  /// [begin]に開始時のスケールを設定します。
  ///
  /// [end]に終了時のスケールを設定します。
  ///
  /// [alignment]を設定すると大きさの変更の中心を変更できます。
  ///
  /// [duration]にアニメーションの時間を設定します。
  ///
  /// [curve]にアニメーションのカーブを設定します。
  Future<void> scaleXY({
    required Duration duration,
    Curve curve = Curves.linear,
    double begin = 0.0,
    double end = 0.0,
    Alignment? alignment,
  }) =>
      scale(
        duration: duration,
        curve: curve,
        begin: Offset(begin, begin),
        end: Offset(end, end),
        alignment: alignment,
      );
}

class _RotateEffectQuery extends EffectQuery<double> {
  _RotateEffectQuery({
    required super.duration,
    super.curve = Curves.linear,
    super.begin = 0.0,
    super.end = 0.0,
    this.alignment,
  });

  final Alignment? alignment;

  @override
  Widget build(BuildContext context, double value, Widget child) {
    return Transform.rotate(
      angle: value * 2 * pi,
      alignment: alignment ?? Alignment.center,
      child: child,
    );
  }

  @override
  double transform(double value) {
    return begin + (end - begin) * curve.transform(value);
  }
}
