part of "/masamune_animate.dart";

/// [MasamuneAdapter] for configuring animation features.
///
/// Register this adapter to enable scenario-based animations in the Masamune framework.
///
/// アニメーション機能を設定するための[MasamuneAdapter]。
///
/// このアダプターを登録することで、Masamuneフレームワークでシナリオベースのアニメーションを有効にします。
class AnimateMasamuneAdapter extends MasamuneAdapter {
  /// [MasamuneAdapter] for configuring animation features.
  ///
  /// Register this adapter to enable scenario-based animations in the Masamune framework.
  ///
  /// アニメーション機能を設定するための[MasamuneAdapter]。
  ///
  /// このアダプターを登録することで、Masamuneフレームワークでシナリオベースのアニメーションを有効にします。
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
