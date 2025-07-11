part of "/masamune_auth_github_firebase.dart";

/// Initialize GitHub sign-in [MasamuneAdapter] on Firebase.
///
/// FirebaseにおけるGitHubサインインの初期設定を行う[MasamuneAdapter]。
class FirebaseGithubAuthMasamuneAdapter extends MasamuneAdapter {
  /// Initialize GitHub sign-in [MasamuneAdapter] on Firebase.
  ///
  /// FirebaseにおけるGitHubサインインの初期設定を行う[MasamuneAdapter]。
  const FirebaseGithubAuthMasamuneAdapter({
    this.keepGithubAccessToken = false,
  });

  /// Whether to keep the GitHub access token.
  ///
  /// GitHubのアクセストークンを保持するかどうか。
  final bool keepGithubAccessToken;

  /// You can retrieve the [FirebaseGithubAuthMasamuneAdapter] first given by [MasamuneAdapterScope].
  ///
  /// 最初に[MasamuneAdapterScope]で与えた[FirebaseGithubAuthMasamuneAdapter]を取得することができます。
  static FirebaseGithubAuthMasamuneAdapter? get primary {
    return _primary!;
  }

  static FirebaseGithubAuthMasamuneAdapter? _primary;

  @override
  void onInitScope(MasamuneAdapter adapter) {
    super.onInitScope(adapter);
    if (adapter is! FirebaseGithubAuthMasamuneAdapter) {
      return;
    }
    _primary = adapter;
    Authentication.registerAuthAction(const GithubAuthAction());
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<FirebaseGithubAuthMasamuneAdapter>(
      adapter: this,
      child: app,
    );
  }
}
