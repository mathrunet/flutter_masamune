part of "/masamune_model_github.dart";

/// [MasamuneAdapter] for utilizing GitHub models.
///
/// Please specify the GitHub model adapter for [modelAdapter].
///
/// Githubのモデルを利用するための[MasamuneAdapter]。
///
/// [modelAdapter]にGithubのモデルアダプターを指定してください。
class GithubModelMasamuneAdapter extends MasamuneAdapter {
  /// [MasamuneAdapter] for utilizing GitHub models.
  ///
  /// Please specify the GitHub model adapter for [modelAdapter].
  ///
  /// Githubのモデルを利用するための[MasamuneAdapter]。
  ///
  /// [modelAdapter]にGithubのモデルアダプターを指定してください。
  const GithubModelMasamuneAdapter({
    required this.modelAdapter,
    required this.appRef,
    this.debugAuthDapter,
  });

  /// Application reference.
  ///
  /// アプリケーションの参照。
  final AppRef appRef;

  /// Github model adapter.
  ///
  /// Githubのモデルアダプター。
  final ModelAdapter modelAdapter;

  /// Debug auth adapter.
  ///
  /// デバッグ用の認証アダプター。
  final AuthAdapter? debugAuthDapter;

  /// You can retrieve the [GithubModelMasamuneAdapter] first given by [MasamuneAdapterScope].
  ///
  /// 最初に[MasamuneAdapterScope]で与えた[GithubModelMasamuneAdapter]を取得することができます。
  static GithubModelMasamuneAdapter get primary {
    assert(
      _primary != null,
      "GithubModelMasamuneAdapter is not set. Place [MasamuneAdapterScope] widget closer to the root.",
    );
    return _primary!;
  }

  static GithubModelMasamuneAdapter? _primary;

  @override
  void onInitScope(MasamuneAdapter adapter) {
    super.onInitScope(adapter);
    if (adapter is! GithubModelMasamuneAdapter) {
      return;
    }
    _primary = adapter;
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<GithubModelMasamuneAdapter>(
      adapter: this,
      child: app,
    );
  }

  @override
  FutureOr<void> onRestarted() async {
    await modelAdapter.clearCache();
  }
}
