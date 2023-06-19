part of masamune_auth_facebook;

/// Initialize Facebook sign-in [MasamuneAdapter].
///
/// Facebookサインインの初期設定を行う[MasamuneAdapter]。
class FacebookAuthMasamuneAdapter extends MasamuneAdapter {
  /// Initialize Facebook sign-in [MasamuneAdapter].
  ///
  /// Facebookサインインの初期設定を行う[MasamuneAdapter]。
  const FacebookAuthMasamuneAdapter();

  /// You can retrieve the [FacebookAuthMasamuneAdapter] first given by [MasamuneAdapterScope].
  ///
  /// 最初に[MasamuneAdapterScope]で与えた[FacebookAuthMasamuneAdapter]を取得することができます。
  static FacebookAuthMasamuneAdapter? get primary {
    return _primary!;
  }

  static FacebookAuthMasamuneAdapter? _primary;

  @override
  void onInitScope(MasamuneAdapter adapter) {
    super.onInitScope(adapter);
    if (adapter is! FacebookAuthMasamuneAdapter) {
      return;
    }
    _primary = adapter;
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<FacebookAuthMasamuneAdapter>(
      adapter: this,
      child: app,
    );
  }
}
