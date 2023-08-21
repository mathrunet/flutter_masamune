part of masamune_deeplink_firebase;

/// Initial setup for handling Deeplink [MasamuneAdapter].
///
/// Deeplinkを取り扱うための初期設定を行う[MasamuneAdapter]。
class FirebaseDeeplinkMasamuneAdapter extends MasamuneAdapter {
  /// Initial setup for handling Deeplink [MasamuneAdapter].
  ///
  /// Deeplinkを取り扱うための初期設定を行う[MasamuneAdapter]。
  const FirebaseDeeplinkMasamuneAdapter({
    this.onLink,
    required this.options,
    this.deeplink,
  });

  /// Callback when the URL is launched.
  ///
  /// URLが起動されたときのコールバック。
  final FutureOr<void> Function(Uri link)? onLink;

  /// Options for handling Deeplink.
  ///
  /// Deeplinkを取り扱うためのオプション。
  final FirebaseDeepLinkOptions options;

  /// Specify the object of [Deeplink].
  ///
  /// After specifying this, [onMaybeBoot] will automatically start monitoring.
  ///
  /// [Deeplink]のオブジェクトを指定します。
  ///
  /// これを指定した上で[onMaybeBoot]を実行すると自動で監視を開始します。
  final Deeplink? deeplink;

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

  @override
  FutureOr<void> onMaybeBoot() async {
    await super.onMaybeBoot();
    await deeplink?.listen();
  }
}
