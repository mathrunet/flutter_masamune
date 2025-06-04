part of "query.dart";

/// Extension method for [EffectQuery] for custom animations.
///
/// カスタムアニメーションのための[EffectQuery]用の拡張メソッド。
extension CustomEffectQueryExtensions on AnimateRunner {
  /// Perform custom animation.
  ///
  /// The [transformer] is given a value to which [curve], which varies between 0.0 and 1.0, is applied, so convert it to any value of type [T].
  ///
  /// Set up a function that takes a converted [T] value in [builder] and returns the widget to be animated.
  ///
  /// Set the animation duration in [duration].
  ///
  /// Set the animation curve to [curve].
  ///
  /// カスタムアニメーションを行います。
  ///
  /// [transformer]に0.0から1.0の間で変化する[curve]を適用した値が渡されるので[T]型の好きな値に変換してください。
  ///
  /// [builder]に変換済みの[T]の値を受け取り、アニメーションの対象となるウィジェットを返す関数を設定します。
  ///
  /// [duration]にアニメーションの時間を設定します。
  ///
  /// [curve]にアニメーションのカーブを設定します。
  Future<void> custom<T>({
    required Duration duration,
    required Widget Function(BuildContext context, T value, Widget child)
        builder,
    required T Function(double value) transformer,
    Curve curve = Curves.linear,
  }) {
    return runAnimateQuery(
      _CustomEffectQuery(
        duration: duration,
        curve: curve,
        builder: builder,
        transformer: transformer,
      ),
    );
  }
}

class _CustomEffectQuery<T> extends EffectQuery<double> {
  const _CustomEffectQuery({
    required super.duration,
    required this.builder,
    required this.transformer,
    super.curve = Curves.linear,
    super.begin = 0.0,
    super.end = 1.0,
  });

  final Widget Function(BuildContext context, T value, Widget child) builder;
  final T Function(double value) transformer;

  @override
  Widget build(BuildContext context, double value, Widget child) {
    return builder.call(context, transformer.call(value), child);
  }

  @override
  double transform(double value) {
    return curve.transform(value);
  }
}
