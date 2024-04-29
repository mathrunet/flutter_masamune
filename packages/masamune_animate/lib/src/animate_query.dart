part of '/masamune_animate.dart';

/// Base class for implementing animation.
///
/// This is inherited to implement animation.
///
/// Set the animation duration in [duration].
///
/// アニメーションを実装するためのベースクラス。
///
/// これを継承してアニメーションを実装します。
///
/// [duration]にアニメーションの時間を設定します。
abstract class AnimateQuery {
  /// Base class for implementing animation.
  ///
  /// This is inherited to implement animation.
  ///
  /// Set the animation duration in [duration].
  ///
  /// アニメーションを実装するためのベースクラス。
  ///
  /// これを継承してアニメーションを実装します。
  ///
  /// [duration]にアニメーションの時間を設定します。
  const AnimateQuery({
    required this.duration,
  });

  /// Animation duration.
  ///
  /// アニメーションの時間。
  final Duration duration;

  @protected
  Widget _build(
    BuildContext context,
    Duration elapsedDuration,
    Widget child,
  );

  @override
  operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode => duration.hashCode;

  @override
  String toString() {
    return "$runtimeType(duration: $duration)";
  }
}

/// Base class for implementing effects.
///
/// Inherit this to implement effects.
///
/// Set the animation duration in [duration].
///
/// Set the start value of the animation in [begin].
///
/// Set the end value of the animation in [end].
///
/// Set the animation curve in [curve].
///
/// エフェクトを実装するためのベースクラス。
///
/// これを継承してエフェクトを実装します。
///
/// [duration]にアニメーションの時間を設定します。
///
/// [begin]にアニメーションの開始値を設定します。
///
/// [end]にアニメーションの終了値を設定します。
///
/// [curve]にアニメーションのカーブを設定します。
abstract class EffectQuery<T> extends AnimateQuery {
  /// Base class for implementing effects.
  ///
  /// Inherit this to implement effects.
  ///
  /// Set the animation duration in [duration].
  ///
  /// Set the start value of the animation in [begin].
  ///
  /// Set the end value of the animation in [end].
  ///
  /// Set the animation curve in [curve].
  ///
  /// エフェクトを実装するためのベースクラス。
  ///
  /// これを継承してエフェクトを実装します。
  ///
  /// [duration]にアニメーションの時間を設定します。
  ///
  /// [begin]にアニメーションの開始値を設定します。
  ///
  /// [end]にアニメーションの終了値を設定します。
  ///
  /// [curve]にアニメーションのカーブを設定します。
  const EffectQuery({
    required super.duration,
    this.curve = Curves.linear,
    required this.begin,
    required this.end,
  });

  /// Start value of the animation.
  ///
  /// アニメーションの開始値。
  final T begin;

  /// End value of the animation.
  ///
  ///
  final T end;

  /// Animation curve.
  ///
  /// アニメーションのカーブ。
  final Curve curve;

  /// Method to build the widget.
  ///
  /// The build context is passed to [context].
  ///
  /// The current effect value is passed to [value].
  ///
  /// The child Widget is passed to [child].
  ///
  /// Widgetをビルドするためのメソッド。
  ///
  /// [context]にビルドコンテキストが渡されます。
  ///
  /// [value]に現在のエフェクトの値が渡されます。
  ///
  /// [child]に子Widgetが渡されます。
  Widget build(BuildContext context, T value, Widget child);

  /// Calculate the value of the effect for progression 0-1.
  ///
  /// 進行度0-1に対してエフェクトの値を計算します。
  T transform(double value);

  @override
  @protected
  Widget _build(
    BuildContext context,
    Duration elapsedDuration,
    Widget child,
  ) {
    final value = transform(_ratio(elapsedDuration));
    return build(context, value, child);
  }

  double _ratio(Duration elapsedDuration) {
    final elapsedDurationMicroseconds = elapsedDuration.inMicroseconds;
    final durationMicroseconds = duration.inMicroseconds;
    if (elapsedDurationMicroseconds >= durationMicroseconds) {
      return 1.0;
    }
    return elapsedDurationMicroseconds / durationMicroseconds;
  }

  @override
  operator ==(Object other) => hashCode == other.hashCode;

  @override
  int get hashCode =>
      duration.hashCode ^ curve.hashCode ^ begin.hashCode ^ end.hashCode;

  @override
  String toString() {
    return "$runtimeType(duration: $duration, curve: $curve, begin: $begin, end: $end)";
  }
}
