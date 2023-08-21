part of masamune_deeplink_firebase;

/// Initial setup for handling Deeplink [MasamuneAdapter].
///
/// Deeplinkを取り扱うための初期設定を行う[MasamuneAdapter]。
class FirebaseDeeplinkMasamuneAdapter extends MasamuneAdapter {
  /// Initial setup for handling Deeplink [MasamuneAdapter].
  ///
  /// Deeplinkを取り扱うための初期設定を行う[MasamuneAdapter]。
  const FirebaseDeeplinkMasamuneAdapter({this.onLink});

  /// Callback when the URL is launched.
  ///
  /// URLが起動されたときのコールバック。
  final Future<void> Function(Uri link)? onLink;

  /// You can retrieve the [FirebaseDeeplinkMasamuneAdapter] first given by [MasamuneAdapterScope].
  ///
  /// 最初に[MasamuneAdapterScope]で与えた[FirebaseDeeplinkMasamuneAdapter]を取得することができます。
  static FirebaseDeeplinkMasamuneAdapter get primary {
    assert(
      _primary != null,
      "FirebaseDeeplinkMasamuneAdapter is not set. Place [MasamuneAdapterScope] widget closer to the root.",
    );
    return _primary!;
  }

  static FirebaseDeeplinkMasamuneAdapter? _primary;

  @override
  void onInitScope(MasamuneAdapter adapter) {
    super.onInitScope(adapter);
    if (adapter is! FirebaseDeeplinkMasamuneAdapter) {
      return;
    }
    _primary = adapter;
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<FirebaseDeeplinkMasamuneAdapter>(
      adapter: this,
      child: app,
    );
  }
}
