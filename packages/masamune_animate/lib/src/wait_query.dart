part of "/masamune_animate.dart";

/// Extended method for [EffectQuery] to wait.
///
/// 待つための[EffectQuery]用の拡張メソッド。
extension WaitAnimateQueryExtensions on AnimateRunner {
  /// Wait for animation during [duration].
  ///
  /// This function is used to delay animation or to create animation with a certain time delay.
  ///
  /// [duration]の間アニメーションを待ちます。
  ///
  /// アニメーションを遅らせたり一定時間を置いたアニメーションを作成する際に利用します。
  Future<void> wait(Duration duration) {
    return runAnimateQuery(_WaitQuery(duration: duration));
  }
}

class _WaitQuery extends AnimateQuery {
  const _WaitQuery({
    required super.duration,
  });

  @override
  @protected
  Widget _build(
    BuildContext context,
    Duration elapsedDuration,
    Widget child,
  ) {
    return child;
  }
}
