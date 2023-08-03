part of masamune_point_ecosystem;

@immutable
class PointEcosystemMasamuneAdapter extends MasamuneAdapter {
  const PointEcosystemMasamuneAdapter({
    required MobilePurchaseMasamuneAdapter purchaseAdapter,
    required this.adsAdapter,
    this.functionsAdapter,
    this.modelAdapter,
    this.rewardedAdUnitId,
    this.dailyBonusEarnAmount,
    this.rewardBonusEarnAmount,
  }) : _purchaseAdapter = purchaseAdapter;

  /// You can retrieve the [PointEcosystemMasamuneAdapter] first given by [MasamuneAdapterScope].
  ///
  /// 最初に[MasamuneAdapterScope]で与えた[PointEcosystemMasamuneAdapter]を取得することができます。
  static PointEcosystemMasamuneAdapter get primary {
    assert(
      _primary != null,
      "PointEcosystemMasamuneAdapter is not set. Place [MasamuneAdapterScope] widget closer to the root.",
    );
    return _primary!;
  }

  static PointEcosystemMasamuneAdapter? _primary;

  final MobilePurchaseMasamuneAdapter _purchaseAdapter;
  final GoogleAdsMasamuneAdapter adsAdapter;

  final FunctionsAdapter? functionsAdapter;
  final ModelAdapter? modelAdapter;

  final String? rewardedAdUnitId;

  final double? dailyBonusEarnAmount;
  final double? rewardBonusEarnAmount;

  MobilePurchaseMasamuneAdapter get purchaseAdapter {
    return MobilePurchaseMasamuneAdapter(
      products: _purchaseAdapter.products,
      functionsAdapter: functionsAdapter,
      modelAdapter: modelAdapter,
      automaticallyConsumeOnAndroid:
          _purchaseAdapter.automaticallyConsumeOnAndroid,
      iosSandboxTesting: _purchaseAdapter.iosSandboxTesting,
      onRetrieveUserId: _purchaseAdapter.onRetrieveUserId,
    );
  }

  @override
  bool get runZonedGuarded =>
      purchaseAdapter.runZonedGuarded || adsAdapter.runZonedGuarded;

  @override
  List<NavigatorObserver> get navigatorObservers => [
        ...purchaseAdapter.navigatorObservers,
        ...adsAdapter.navigatorObservers,
      ];

  @override
  List<LoggerAdapter> get loggerAdapters => [
        ...purchaseAdapter.loggerAdapters,
        ...adsAdapter.loggerAdapters,
      ];

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<PointEcosystemMasamuneAdapter>(
      adapter: this,
      child: purchaseAdapter.onBuildApp(
        context,
        adsAdapter.onBuildApp(context, app),
      ),
    );
  }

  @override
  void onInitScope(MasamuneAdapter adapter) {
    super.onInitScope(adapter);
    purchaseAdapter.onInitScope(adapter);
    adsAdapter.onInitScope(adapter);
    if (adapter is! PointEcosystemMasamuneAdapter) {
      return;
    }
    _primary = adapter;
  }

  @override
  FutureOr<void> onPreRunApp() async {
    await purchaseAdapter.onPreRunApp();
    await adsAdapter.onPreRunApp();
    await onPreRunApp();
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    purchaseAdapter.onError(error, stackTrace);
    adsAdapter.onError(error, stackTrace);
    super.onError(error, stackTrace);
  }
}
