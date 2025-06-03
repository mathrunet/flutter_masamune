part of "/masamune_auth_google_firebase.dart";

/// Initialize Google sign-in [MasamuneAdapter] on Firebase.
///
/// FirebaseにおけるGoogleサインインの初期設定を行う[MasamuneAdapter]。
class FirebaseGoogleAuthMasamuneAdapter extends MasamuneAdapter {
  /// Initialize Google sign-in [MasamuneAdapter] on Firebase.
  ///
  /// FirebaseにおけるGoogleサインインの初期設定を行う[MasamuneAdapter]。
  const FirebaseGoogleAuthMasamuneAdapter();

  /// You can retrieve the [FirebaseGoogleAuthMasamuneAdapter] first given by [MasamuneAdapterScope].
  ///
  /// 最初に[MasamuneAdapterScope]で与えた[FirebaseGoogleAuthMasamuneAdapter]を取得することができます。
  static FirebaseGoogleAuthMasamuneAdapter? get primary {
    return _primary!;
  }

  static FirebaseGoogleAuthMasamuneAdapter? _primary;

  @override
  void onInitScope(MasamuneAdapter adapter) {
    super.onInitScope(adapter);
    if (adapter is! FirebaseGoogleAuthMasamuneAdapter) {
      return;
    }
    _primary = adapter;
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<FirebaseGoogleAuthMasamuneAdapter>(
      adapter: this,
      child: app,
    );
  }
}
