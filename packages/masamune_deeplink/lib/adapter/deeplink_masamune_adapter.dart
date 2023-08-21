part of masamune_deeplink;

/// Initial setup for handling Deeplink [MasamuneAdapter].
///
/// Deeplinkを取り扱うための初期設定を行う[MasamuneAdapter]。
class DeeplinkMasamuneAdapter extends MasamuneAdapter {
  /// Initial setup for handling Deeplink [MasamuneAdapter].
  ///
  /// Deeplinkを取り扱うための初期設定を行う[MasamuneAdapter]。
  const DeeplinkMasamuneAdapter({this.onLink});

  /// Callback when the URL is launched.
  ///
  /// URLが起動されたときのコールバック。
  final Future<void> Function(Uri link)? onLink;

  /// You can retrieve the [DeeplinkMasamuneAdapter] first given by [MasamuneAdapterScope].
  ///
  /// 最初に[MasamuneAdapterScope]で与えた[DeeplinkMasamuneAdapter]を取得することができます。
  static DeeplinkMasamuneAdapter get primary {
    assert(
      _primary != null,
      "DeeplinkMasamuneAdapter is not set. Place [MasamuneAdapterScope] widget closer to the root.",
    );
    return _primary!;
  }

  static DeeplinkMasamuneAdapter? _primary;

  @override
  void onInitScope(MasamuneAdapter adapter) {
    super.onInitScope(adapter);
    if (adapter is! DeeplinkMasamuneAdapter) {
      return;
    }
    _primary = adapter;
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<DeeplinkMasamuneAdapter>(
      adapter: this,
      child: app,
    );
  }
}
