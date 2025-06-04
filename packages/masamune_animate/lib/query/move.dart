part of "query.dart";

/// Extension method for [EffectQuery] for movement animations.
///
/// 移動のアニメーションのための[EffectQuery]用の拡張メソッド。
extension MoveEffectQueryExtensions on AnimateRunner {
  /// Movement animation is performed.
  ///
  /// Set the start offset to [begin].
  ///
  /// Set the end offset to [end].
  ///
  /// Set the animation duration in [duration].
  ///
  /// Set the animation curve to [curve].
  ///
  /// 移動アニメーションを行います。
  ///
  /// [begin]に開始時のオフセットを設定します。
  ///
  /// [end]に終了時のオフセットを設定します。
  ///
  /// [duration]にアニメーションの時間を設定します。
  ///
  /// [curve]にアニメーションのカーブを設定します。
  Future<void> move({
    required Duration duration,
    Curve curve = Curves.linear,
    Offset begin = const Offset(0, 0),
    Offset end = const Offset(0, 0),
  }) {
    return runAnimateQuery(
      _MoveEffectQuery(
        duration: duration,
        curve: curve,
        begin: begin,
        end: end,
      ),
    );
  }

  /// X-axis movement animation.
  ///
  /// Set the X-axis offset at the start to [begin].
  ///
  /// Set the X-axis offset at the end to [end].
  ///
  /// Set the animation duration in [duration].
  ///
  /// Set the animation curve to [curve].
  ///
  /// X軸移動アニメーションを行います。
  ///
  /// [begin]に開始時のX軸オフセットを設定します。
  ///
  /// [end]に終了時のX軸オフセットを設定します。
  ///
  /// [duration]にアニメーションの時間を設定します。
  ///
  /// [curve]にアニメーションのカーブを設定します。
  Future<void> moveX({
    required Duration duration,
    Curve curve = Curves.linear,
    double begin = 0.0,
    double end = 0.0,
  }) =>
      move(
        duration: duration,
        curve: curve,
        begin: Offset(begin, 0.0),
        end: Offset(end, 0.0),
      );

  /// Y-axis movement animation.
  ///
  /// Set the Y-axis offset at the start to [begin].
  ///
  /// Set the Y-axis offset at the end to [end].
  ///
  /// Set the animation duration in [duration].
  ///
  /// Set the animation curve to [curve].
  ///
  /// Y軸移動アニメーションを行います。
  ///
  /// [begin]に開始時のY軸オフセットを設定します。
  ///
  /// [end]に終了時のY軸オフセットを設定します。
  ///
  /// [duration]にアニメーションの時間を設定します。
  ///
  /// [curve]にアニメーションのカーブを設定します。
  Future<void> moveY({
    required Duration duration,
    Curve curve = Curves.linear,
    double begin = 0.0,
    double end = 0.0,
  }) =>
      move(
        duration: duration,
        curve: curve,
        begin: Offset(0.0, begin),
        end: Offset(0.0, end),
      );
}

class _MoveEffectQuery extends EffectQuery<Offset> {
  const _MoveEffectQuery(
      {required super.duration,
      super.curve = Curves.linear,
      super.begin = const Offset(0, 0),
      super.end = const Offset(0, 0)});

  @override
  Widget build(BuildContext context, Offset value, Widget child) {
    return Transform.translate(
      offset: value,
      child: child,
    );
  }

  @override
  Offset transform(double value) {
    return begin + (end - begin) * curve.transform(value);
  }
}
