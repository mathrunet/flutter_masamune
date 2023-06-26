part of masamune_purchase_stripe;

/// Initialize [MasamuneAdapter] to handle Stripe payments.
///
/// Specify a [supportEmail] to support payment and a [callbackURLSchemeOrHost] URL scheme (mobile) or hostname (web) to return from the webview.
///
/// Stripeでの決済を取り扱うための初期設定を行う[MasamuneAdapter]。
///
/// 決済をサポートするための[supportEmail]とWebviewから戻るためのURLスキーム（モバイル）もしくはホスト名（web）を[callbackURLSchemeOrHost]に指定してください。
class StripePurchaseMasamuneAdapter extends MasamuneAdapter {
  /// Initialize [MasamuneAdapter] to handle Stripe payments.
  ///
  /// Specify a [supportEmail] to support payment and a [callbackURLSchemeOrHost] URL scheme (mobile) or hostname (web) to return from the webview.
  ///
  /// Stripeでの決済を取り扱うための初期設定を行う[MasamuneAdapter]。
  ///
  /// 決済をサポートするための[supportEmail]とWebviewから戻るためのURLスキーム（モバイル）もしくはホスト名（web）を[callbackURLSchemeOrHost]に指定してください。
  const StripePurchaseMasamuneAdapter({
    this.functionsAdapter,
    this.modelAdapter,
    required this.callbackURLSchemeOrHost,
    required this.supportEmail,
    this.hostingEndpoint,
    this.revenueRatio = 0.3,
    this.currency = StripeCurrency.usd,
    this.threeDSecureOptions = const StripeThreeDSecureOptions(),
    this.returnPathOptions = const StripeReturnPathOptions(),
  });

  /// Specify [FunctionsAdapter] to make the payment.
  ///
  /// 決済を行うための[FunctionsAdapter]を指定します。
  final FunctionsAdapter? functionsAdapter;

  /// Default [ModelAdapter] for using [StripePaymentModel], [StripePurchaseModel], and [StripeUserModel].
  ///
  /// [StripePaymentModel]や[StripePurchaseModel]、[StripeUserModel]を利用するためのデフォルトの[ModelAdapter]。
  final ModelAdapter? modelAdapter;

  /// URL scheme (mobile) or hostname (web) to return from webview
  ///
  /// Webviewから戻るためのURLスキーム（モバイル）もしくはホスト名（web）
  final Uri callbackURLSchemeOrHost;

  /// The web host name given by [languageCode] to transition to the 3D Secure return URL.
  ///
  /// [languageCode]が与えられ、3DセキュアのリターンURLに遷移するためのWebホスト名。
  final String Function(String languageCode)? hostingEndpoint;

  /// Support email address for payment.
  ///
  /// 決済を行うためのサポートメールアドレス。
  final String supportEmail;

  /// Percentage of the amount collected by the operator for user-to-user payments. (0.0-1.0)
  ///
  /// ユーザー間決済を行う際に運営者側が徴収する金額の割合。（0.0-1.0）
  final double revenueRatio;

  /// Currency used for payment.
  ///
  /// 決済に利用する通貨。
  final StripeCurrency currency;

  /// Setup for 3D Secure email authentication.
  ///
  /// 3Dセキュアのメール認証を行うための設定。
  final StripeThreeDSecureOptions threeDSecureOptions;

  /// Set the return URL for the webview.
  ///
  /// WebviewのリターンURLの設定。
  final StripeReturnPathOptions returnPathOptions;

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
