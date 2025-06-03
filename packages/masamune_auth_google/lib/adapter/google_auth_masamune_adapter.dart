part of "/masamune_auth_google.dart";

/// Initialize Google sign-in [MasamuneAdapter].
///
/// Googleサインインの初期設定を行う[MasamuneAdapter]。
class GoogleAuthMasamuneAdapter extends MasamuneAdapter {
  /// Initialize Google sign-in [MasamuneAdapter].
  ///
  /// Googleサインインの初期設定を行う[MasamuneAdapter]。
  const GoogleAuthMasamuneAdapter();

  /// You can retrieve the [GoogleAuthMasamuneAdapter] first given by [MasamuneAdapterScope].
  ///
  /// 最初に[MasamuneAdapterScope]で与えた[GoogleAuthMasamuneAdapter]を取得することができます。
  static GoogleAuthMasamuneAdapter? get primary {
    return _primary!;
  }

  static GoogleAuthMasamuneAdapter? _primary;

  @override
  void onInitScope(MasamuneAdapter adapter) {
    super.onInitScope(adapter);
    if (adapter is! GoogleAuthMasamuneAdapter) {
      return;
    }
    _primary = adapter;
    Authentication.registerAuthAction(const GoogleAuthAction());
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<GoogleAuthMasamuneAdapter>(
      adapter: this,
      child: app,
    );
  }
}
