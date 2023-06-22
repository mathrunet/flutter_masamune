part of masamune_purchase_mobile;

class MobilePurchaseMasamuneAdapter extends MasamuneAdapter {
  const MobilePurchaseMasamuneAdapter({
    this.functionsAdapter,
    this.modelAdapter,
    required this.products,
    this.automaticallyConsumeOnAndroid = true,
    this.iosSandboxTesting = false,
  });

  final FunctionsAdapter? functionsAdapter;
  final ModelAdapter? modelAdapter;
  final List<PurchaseProduct> products;
  final bool automaticallyConsumeOnAndroid;
  final bool iosSandboxTesting;

  /// You can retrieve the [MobilePurchaseMasamuneAdapter] first given by [MasamuneAdapterScope].
  ///
  /// 最初に[MasamuneAdapterScope]で与えた[MobilePurchaseMasamuneAdapter]を取得することができます。
  static MobilePurchaseMasamuneAdapter get primary {
    assert(
      _primary != null,
      "MobilePurchaseMasamuneAdapter is not set. Place [MasamuneAdapterScope] widget closer to the root.",
    );
    return _primary!;
  }

  static MobilePurchaseMasamuneAdapter? _primary;

  @override
  void onInitScope(MasamuneAdapter adapter) {
    super.onInitScope(adapter);
    if (adapter is! MobilePurchaseMasamuneAdapter) {
      return;
    }
    _primary = adapter;
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<MobilePurchaseMasamuneAdapter>(
      adapter: this,
      onInit: onInitScope,
      child: app,
    );
  }
}
