part of masamune;

/// This effect is used to change the color to match the widget shape. The color changes from [begin] to [end].
/// ウィジェットの形に合わせて色を変更するためのエフェクトです。[begin]から[end]に向かって色が変化していきます。
///
/// For example:
///
/// ```
/// Shape().animate()
///   .color(begin: Colors.blue, end: Colors.red, duration: 2.seconds)
/// ```
@immutable
class ColorEffect extends Effect<Color?> {
  const ColorEffect({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    required Color begin,
    required Color end,
  }) : super(
          delay: delay,
          duration: duration,
          curve: curve,
          begin: begin,
          end: end,
        );

  @override
  Widget build(
    BuildContext context,
    Widget child,
    AnimationController controller,
    EffectEntry entry,
  ) {
    final animation = entry
        .buildAnimation(controller)
        .drive(ColorTween(begin: begin!, end: end!));
    return getOptimizedBuilder<Color?>(
      animation: animation,
      builder: (_, __) {
        final value = animation.value;
        return ColorFiltered(
          colorFilter: ColorFilter.mode(value!, BlendMode.srcATop),
          child: child,
        );
      },
    );
  }
}

/// Provides extension methods for [AnimateManager].
/// [AnimateManager]の拡張メソッドを提供します。
extension ColorEffectExtensions<T> on AnimateManager<T> {
  /// This effect is used to change the color to match the widget shape. The color changes from [begin] to [end].
  /// ウィジェットの形に合わせて色を変更するためのエフェクトです。[begin]から[end]に向かって色が変化していきます。
  ///
  /// For example:
  ///
  /// ```
  /// Shape().animate()
  ///   .color(begin: Colors.blue, end: Colors.red, duration: 2.seconds)
  /// ```
  T color({
    Duration? delay,
    Duration? duration,
    Curve? curve,
    required Color begin,
    required Color end,
  }) =>
      addEffect(
        ColorEffect(
          delay: delay,
          duration: duration,
          curve: curve,
          begin: begin,
          end: end,
        ),
      );
}
