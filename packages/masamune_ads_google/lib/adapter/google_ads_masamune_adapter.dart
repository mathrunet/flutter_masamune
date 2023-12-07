part of '/masamune_ads_google.dart';

/// [MasamuneAdapter] for displaying mobile ads.
///
/// モバイル広告を表示するための[MasamuneAdapter]。
class GoogleAdsMasamuneAdapter extends MasamuneAdapter {
  /// [MasamuneAdapter] for displaying mobile ads.
  ///
  /// モバイル広告を表示するための[MasamuneAdapter]。
  const GoogleAdsMasamuneAdapter({
    required this.defaultAdUnitId,
  });

  /// Default ad ID.
  ///
  /// デフォルトの広告ID。
  final String defaultAdUnitId;

  /// You can retrieve the [GoogleAdsMasamuneAdapter] first given by [MasamuneAdapterScope].
  ///
  /// 最初に[MasamuneAdapterScope]で与えた[GoogleAdsMasamuneAdapter]を取得することができます。
  static GoogleAdsMasamuneAdapter get primary {
    assert(
      _primary != null,
      "GoogleAdsMasamuneAdapter is not set. Place [MasamuneAdapterScope] widget closer to the root.",
    );
    return _primary!;
  }

  static GoogleAdsMasamuneAdapter? _primary;

  @override
  Future<void> onPreRunApp() async {
    await GoogleAdsCore.initialize();
    return super.onPreRunApp();
  }

  @override
  void onInitScope(MasamuneAdapter adapter) {
    super.onInitScope(adapter);
    if (adapter is! GoogleAdsMasamuneAdapter) {
      return;
    }
    _primary = adapter;
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<GoogleAdsMasamuneAdapter>(
      adapter: this,
      child: app,
    );
  }
}
