part of "/masamune_animate.dart";

/// A runner to set up the animation in the scenario.
///
/// アニメーションをシナリオ内で設定するためのランナー。
abstract class AnimateRunner {
  /// Register [AnimateQuery] to play the animation.
  ///
  /// Wait for animation playback to complete before exiting.
  ///
  /// [AnimateQuery]を登録してアニメーションを再生します。
  ///
  /// アニメーションの再生が完了するまで終了を待機します。
  Future<void> runAnimateQuery(AnimateQuery query);

  /// Whether the animation is running in test mode.
  ///
  /// アニメーションがテストモードで実行されているかどうか。
  bool get isTest;
}
