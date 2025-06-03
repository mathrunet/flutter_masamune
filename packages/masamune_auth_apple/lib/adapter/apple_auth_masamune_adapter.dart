part of "/masamune_auth_apple.dart";

/// Initialize Apple sign-in [MasamuneAdapter].
///
/// Appleサインインの初期設定を行う[MasamuneAdapter]。
class AppleAuthMasamuneAdapter extends MasamuneAdapter {
  /// Initialize Apple sign-in [MasamuneAdapter].
  ///
  /// Appleサインインの初期設定を行う[MasamuneAdapter]。
  const AppleAuthMasamuneAdapter();

  /// You can retrieve the [AppleAuthMasamuneAdapter] first given by [MasamuneAdapterScope].
  ///
  /// 最初に[MasamuneAdapterScope]で与えた[AppleAuthMasamuneAdapter]を取得することができます。
  static AppleAuthMasamuneAdapter? get primary {
    return _primary!;
  }

  static AppleAuthMasamuneAdapter? _primary;

  @override
  void onInitScope(MasamuneAdapter adapter) {
    super.onInitScope(adapter);
    if (adapter is! AppleAuthMasamuneAdapter) {
      return;
    }
    _primary = adapter;
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<AppleAuthMasamuneAdapter>(
      adapter: this,
      child: app,
    );
  }
}
