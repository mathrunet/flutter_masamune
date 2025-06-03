part of "/masamune_auth_facebook.dart";

/// Initialize Facebook sign-in [MasamuneAdapter].
///
/// Facebookサインインの初期設定を行う[MasamuneAdapter]。
class FacebookAuthMasamuneAdapter extends MasamuneAdapter {
  /// Initialize Facebook sign-in [MasamuneAdapter].
  ///
  /// Facebookサインインの初期設定を行う[MasamuneAdapter]。
  const FacebookAuthMasamuneAdapter({
    this.facebookAppId,
  });

  /// Facebook App ID. used for web only.
  ///
  /// Facebook App ID. Webのみで利用します。
  final String? facebookAppId;

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
  FutureOr<void> onPreRunApp(WidgetsBinding binding) async {
    if (kIsWeb && facebookAppId.isNotEmpty) {
      await FacebookAuth.i.webAndDesktopInitialize(
        appId: facebookAppId!,
        cookie: true,
        xfbml: true,
        version: "v14.0",
      );
    }
    return super.onPreRunApp(binding);
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<FacebookAuthMasamuneAdapter>(
      adapter: this,
      child: app,
    );
  }
}
