part of "/masamune_animate.dart";

/// Abstract class of [MasamuneAdapter] for configuring AI functions.
///
/// Inherit this class to set up AI functions.
///
/// AIの機能を設定するための[MasamuneAdapter]の抽象クラス。
///
/// このクラスを継承してAIの機能を設定してください。
class AnimateMasamuneAdapter extends MasamuneAdapter {
  /// Abstract class of [MasamuneAdapter] for configuring AI functions.
  ///
  /// Inherit this class to set up AI functions.
  ///
  /// AIの機能を設定するための[MasamuneAdapter]の抽象クラス。
  ///
  /// このクラスを継承してAIの機能を設定してください。
  const AnimateMasamuneAdapter({
    this.timeoutDurationOnTest = const Duration(milliseconds: 100),
  });

  /// The duration of the timeout for the animation in test mode.
  ///
  /// アニメーションのテストモードでのタイムアウト時間。
  final Duration timeoutDurationOnTest;

  /// You can retrieve the [AnimateMasamuneAdapter] first given by [MasamuneAdapterScope].
  ///
  /// 最初に[MasamuneAdapterScope]で与えた[AnimateMasamuneAdapter]を取得することができます。
  static AnimateMasamuneAdapter get primary {
    assert(
      _primary != null,
      "AnimateMasamuneAdapter is not set. Place [MasamuneAdapterScope] widget closer to the root.",
    );
    return _primary!;
  }

  static AnimateMasamuneAdapter? _primary;

  @override
  void onInitScope(MasamuneAdapter adapter) {
    super.onInitScope(adapter);
    if (adapter is! AnimateMasamuneAdapter) {
      return;
    }
    _primary = adapter;
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<AnimateMasamuneAdapter>(
      adapter: this,
      child: app,
    );
  }
}
