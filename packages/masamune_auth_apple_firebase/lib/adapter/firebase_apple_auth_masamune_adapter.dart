part of "/masamune_auth_apple_firebase.dart";

/// Initialize Apple sign-in [MasamuneAdapter] on Firebase.
///
/// FirebaseにおけるAppleサインインの初期設定を行う[MasamuneAdapter]。
class FirebaseAppleAuthMasamuneAdapter extends MasamuneAdapter {
  /// Initialize Apple sign-in [MasamuneAdapter] on Firebase.
  ///
  /// FirebaseにおけるAppleサインインの初期設定を行う[MasamuneAdapter]。
  const FirebaseAppleAuthMasamuneAdapter();

  /// You can retrieve the [FirebaseAppleAuthMasamuneAdapter] first given by [MasamuneAdapterScope].
  ///
  /// 最初に[MasamuneAdapterScope]で与えた[FirebaseAppleAuthMasamuneAdapter]を取得することができます。
  static FirebaseAppleAuthMasamuneAdapter? get primary {
    return _primary!;
  }

  static FirebaseAppleAuthMasamuneAdapter? _primary;

  @override
  void onInitScope(MasamuneAdapter adapter) {
    super.onInitScope(adapter);
    if (adapter is! FirebaseAppleAuthMasamuneAdapter) {
      return;
    }
    _primary = adapter;
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<FirebaseAppleAuthMasamuneAdapter>(
      adapter: this,
      child: app,
    );
  }
}
