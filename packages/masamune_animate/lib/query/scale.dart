part of "query.dart";

/// Extension method for [EffectQuery] for scale animation.
///
/// スケールアニメーションのための[EffectQuery]用の拡張メソッド。
extension ScaleEffectQueryExtensions on AnimateRunner {
  /// Scale animation.
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
  /// スケールアニメーションを行います。
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
  Future<void> scale({
    required Duration duration,
    Curve curve = Curves.linear,
    Offset begin = const Offset(0, 0),
    Offset end = const Offset(0, 0),
    Alignment? alignment,
  }) {
    return runAnimateQuery(
      _ScaleEffectQuery(
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

class _ScaleEffectQuery extends EffectQuery<Offset> {
  _ScaleEffectQuery({
    required super.duration,
    super.curve = Curves.linear,
    super.begin = const Offset(0.0, 0.0),
    super.end = const Offset(0.0, 0.0),
    this.alignment,
  });

  final Alignment? alignment;

  static const double _minScale = 0.000001;

  @override
  Widget build(BuildContext context, Offset value, Widget child) {
    return Transform.scale(
      scaleX: _normalizeScale(value.dx),
      scaleY: _normalizeScale(value.dy),
      alignment: alignment ?? Alignment.center,
      child: child,
    );
  }

  @override
  Offset transform(double value) {
    return begin + (end - begin) * curve.transform(value);
  }

  double _normalizeScale(double scale) {
    return scale < _minScale ? _minScale : scale;
  }
}
