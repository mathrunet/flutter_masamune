part of masamune_purchase_stripe;

class StripePurchaseMasamuneAdapter extends MasamuneAdapter {
  const StripePurchaseMasamuneAdapter({
    required this.publicAPIKey,
    this.functionsAdapter,
    required this.callbackHost,
    required this.supportEmail,
    this.hostingEndpoint,
    this.revenueRatio = 0.3,
    this.currency = StripeCurrency.usd,
    this.threeDSecureOptions = const StripeThreeDSecureOptions(),
  });

  final String publicAPIKey;
  final FunctionsAdapter? functionsAdapter;
  final Uri callbackHost;
  final String Function(String languageCode)? hostingEndpoint;
  final String supportEmail;
  final double revenueRatio;
  final StripeCurrency currency;
  final StripeThreeDSecureOptions threeDSecureOptions;

  /// You can retrieve the [StripePurchaseMasamuneAdapter] first given by [MasamuneAdapterScope].
  ///
  /// 最初に[MasamuneAdapterScope]で与えた[StripePurchaseMasamuneAdapter]を取得することができます。
  static StripePurchaseMasamuneAdapter get primary {
    assert(
      _primary != null,
      "StripePurchaseMasamuneAdapter is not set. Place [MasamuneAdapterScope] widget closer to the root.",
    );
    return _primary!;
  }

  static StripePurchaseMasamuneAdapter? _primary;

  @override
  void onInitScope(MasamuneAdapter adapter) {
    super.onInitScope(adapter);
    if (adapter is! StripePurchaseMasamuneAdapter) {
      return;
    }
    _primary = adapter;
  }

  @override
  Widget onBuildApp(BuildContext context, Widget app) {
    return MasamuneAdapterScope<StripePurchaseMasamuneAdapter>(
      adapter: this,
      onInit: onInitScope,
      child: app,
    );
  }
}
