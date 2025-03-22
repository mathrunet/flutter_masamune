part of '/masamune_deeplink.dart';

/// Initial setup for handling Deeplink [MasamuneAdapter].
///
/// Deeplinkを取り扱うための初期設定を行う[MasamuneAdapter]。
class DeeplinkMasamuneAdapter extends MasamuneAdapter {
  /// Initial setup for handling Deeplink [MasamuneAdapter].
  ///
  /// Deeplinkを取り扱うための初期設定を行う[MasamuneAdapter]。
  const DeeplinkMasamuneAdapter({
    this.onLink,
    this.deeplink,
    this.listenOnBoot = false,
  });

  /// `true` if [deeplink] is set to `true` to start monitoring when [onMaybeBoot] is executed.
  ///
  /// [deeplink]が設定されている場合、[onMaybeBoot]を実行した際合わせて監視を開始する場合`true`。
  final bool listenOnBoot;

  /// Callback when the URL is launched.
  ///
  /// URLが起動されたときのコールバック。
  final FutureOr<void> Function(Uri link, bool onOpenedApp)? onLink;

  /// Specify the object of [Deeplink].
  ///
  /// After specifying this, [onMaybeBoot] will automatically start monitoring.
  ///
  /// [Deeplink]のオブジェクトを指定します。
  ///
  /// これを指定した上で[onMaybeBoot]を実行すると自動で監視を開始します。
  final Deeplink? deeplink;

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

  @override
  FutureOr<void> onMaybeBoot(BuildContext context) async {
    await super.onMaybeBoot(context);
    if (listenOnBoot) {
      await deeplink?.listen();
    }
  }
}
