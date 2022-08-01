part of masamune_purchase_stripe;

@immutable
class StripeMarketPlaceAdapter extends MarketPlaceAdapter<
    StripeMarketPlaceAccountAdapter,
    StripeMarketPlacePaymentMethodAdapter,
    StripeMarketPlacePurchaseAdapter> {
  const StripeMarketPlaceAdapter({
    required this.revenue,
    required this.serverPath,
    required this.callbackUrl,
    required this.supportEmail,
    this.prefix,
    this.view = const StripeDefaultView(),
    this.viewWithoutBack = const StripeDefaultViewWithoutBack(),
    this.currency = StripeCurrency.usd,
    this.debugUserId,
  });

  final String serverPath;
  final String callbackUrl;
  final String? debugUserId;
  final double revenue;
  final StripeCurrency currency;
  final String supportEmail;
  final ValueWidget<Widget> view;
  final ValueWidget<Widget> viewWithoutBack;
  final String? prefix;

  static late final BuildContext _context;

  @override
  Future<void> initialize() async {
    StripeConnectCore.initialize(
      serverPath: serverPath,
      callbackUrl: callbackUrl,
      revenue: revenue,
      supportEmail: supportEmail,
      debugUserId: debugUserId,
      currency: currency,
      userPath: "${prefix.isEmpty ? "" : "$prefix/"}stripe/connect/user",
    );
  }

  @override
  StripeMarketPlaceAccountAdapter get account =>
      StripeMarketPlaceAccountAdapter(this);

  @override
  StripeMarketPlacePaymentMethodAdapter get payment =>
      StripeMarketPlacePaymentMethodAdapter(this);

  @override
  StripeMarketPlacePurchaseAdapter get purchase =>
      StripeMarketPlacePurchaseAdapter(this);

  @override
  Future<void> onInit(BuildContext context) {
    _context = context.navigator.context;
    return super.onInit(context);
  }
}

class StripeDefaultView extends ValueWidget<Widget> {
  const StripeDefaultView();
  @override
  Widget build(BuildContext context, WidgetRef ref, Widget value) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.navigator.pop();
          },
          icon: const Icon(Icons.close),
        ),
      ),
      body: value,
    );
  }
}

class StripeDefaultViewWithoutBack extends ValueWidget<Widget> {
  const StripeDefaultViewWithoutBack();
  @override
  Widget build(BuildContext context, WidgetRef ref, Widget value) {
    return Scaffold(
      body: value,
    );
  }
}

@immutable
class StripeMarketPlaceAccountAdapter
    extends MarketPlaceAccountAdapter<FirestoreDynamicDocumentModel> {
  const StripeMarketPlaceAccountAdapter(this.adapter);
  final StripeMarketPlaceAdapter adapter;
  @override
  bool get exists {
    final stripeAccount = readProvider(stripeConnectAccountModelProvider);
    return stripeAccount.exists;
  }

  @override
  bool get registered {
    final stripeAccount = readProvider(stripeConnectAccountModelProvider);
    return stripeAccount.registered;
  }

  @override
  Future<FirestoreDynamicDocumentModel> registerSeller() async {
    final stripeAccount = readProvider(stripeConnectAccountModelProvider);
    return await stripeAccount.create(
      StripeMarketPlaceAdapter._context,
      popWhenClosedByWebview: true,
      builder: (webView, onSuccess, onCancel) async {
        await UIModal.show(
          StripeMarketPlaceAdapter._context,
          child: ValueProvider(value: webView, child: adapter.view),
        );
      },
    );
  }

  @override
  Future<void> reload() async {
    final stripeAccount = readProvider(stripeConnectAccountModelProvider);
    await stripeAccount.reload();
  }

  @override
  Future<void> dashboard() async {
    final stripeAccount = readProvider(stripeConnectAccountModelProvider);
    await stripeAccount.dashboard(
      StripeMarketPlaceAdapter._context,
      popWhenClosedByWebview: true,
      builder: (webView, onClosed) async {
        await UIModal.show(
          StripeMarketPlaceAdapter._context,
          child: ValueProvider(value: webView, child: adapter.view),
        );
      },
    );
  }

  @override
  ChangeNotifierProvider<FirestoreDynamicDocumentModel> documentProvider(
    String userId,
  ) {
    return stripeConnectAccountDocumentProvider(userId);
  }

  @override
  ChangeNotifierProvider get modelProvider => stripeConnectAccountModelProvider;
}

@immutable
class StripeMarketPlacePaymentMethodAdapter
    extends MarketPlacePaymentMethodAdapter<FirestoreDynamicDocumentModel,
        FirestoreDynamicCollectionModel> {
  const StripeMarketPlacePaymentMethodAdapter(this.adapter);
  final StripeMarketPlaceAdapter adapter;

  @override
  Future<FirestoreDynamicDocumentModel> create() async {
    final stripePayment = readProvider(stripeConnectPaymentModelProvider);
    return await stripePayment.create(
      StripeMarketPlaceAdapter._context,
      popWhenClosedByWebview: true,
      builder: (webView, onSuccess, onCancel) async {
        await UIModal.show(
          StripeMarketPlaceAdapter._context,
          child: ValueProvider(value: webView, child: adapter.view),
        );
      },
    );
  }

  @override
  Future<void> delete(String paymentMethodId) async {
    final stripePayment = readProvider(stripeConnectPaymentModelProvider);
    await stripePayment.delete(paymentMethodId);
  }

  @override
  bool get exists {
    final stripePayment = readProvider(stripeConnectPaymentModelProvider);
    return stripePayment.exists;
  }

  @override
  Future<void> reload() async {
    final stripePayment = readProvider(stripeConnectPaymentModelProvider);
    await stripePayment.reload();
  }

  @override
  Future<void> setDefault(String paymentMethodId) async {
    final stripePayment = readProvider(stripeConnectPaymentModelProvider);
    await stripePayment.setDefault(paymentMethodId);
  }

  @override
  ChangeNotifierProvider<FirestoreDynamicCollectionModel> collectionProvider(
    String userId,
  ) {
    return stripeConnectPaymentCollectionProvider(userId);
  }

  @override
  ChangeNotifierProvider get modelProvider => stripeConnectPaymentModelProvider;
}

@immutable
class StripeMarketPlacePurchaseAdapter extends MarketPlacePurchaseAdapter<
    MarketPlaceProduct,
    FirestoreDynamicDocumentModel,
    FirestoreDynamicCollectionModel> {
  const StripeMarketPlacePurchaseAdapter(this.adapter);
  final StripeMarketPlaceAdapter adapter;

  @override
  Future<void> cancel(String orderId) async {
    final stripePurchase = readProvider(stripeConnectPurchaseModelProvider);
    await stripePurchase.cancel(
      StripeMarketPlaceAdapter._context,
      orderId: orderId,
    );
  }

  @override
  Future<void> capture(
    String orderId, {
    double? price,
    bool online = true,
  }) async {
    final stripePurchase = readProvider(stripeConnectPurchaseModelProvider);
    await stripePurchase.capture(
      StripeMarketPlaceAdapter._context,
      orderId: orderId,
      online: online,
      amount: price,
    );
  }

  @override
  Future<void> confirm(String orderId, {bool online = true}) async {
    final stripePurchase = readProvider(stripeConnectPurchaseModelProvider);
    await stripePurchase.confirm(
      StripeMarketPlaceAdapter._context,
      orderId: orderId,
      online: online,
      popWhenClosedByWebview: true,
      builder: (webView, onClosed) async {
        await UIModal.show(
          StripeMarketPlaceAdapter._context,
          disableBackKey: true,
          child: ValueProvider<Widget>(
            value: webView,
            child: adapter.viewWithoutBack,
          ),
        );
      },
    );
  }

  @override
  Future<FirestoreDynamicDocumentModel> purchase(
    MarketPlaceProduct product,
  ) async {
    final stripePurchase = readProvider(stripeConnectPurchaseModelProvider);
    return await stripePurchase.create(
      StripeMarketPlaceAdapter._context,
      orderId: product.id,
      amount: product.price,
      sourceUserId: product.source,
      targetUserId: product.target,
      description: product.name ?? product.text ?? "",
      locale: product.locale,
    );
  }

  @override
  Future<void> refresh(String orderId) async {
    final stripePurchase = readProvider(stripeConnectPurchaseModelProvider);
    await stripePurchase.refresh(
      StripeMarketPlaceAdapter._context,
      orderId: orderId,
    );
  }

  @override
  Future<void> refund(
    String orderId, {
    double? price,
  }) async {
    final stripePurchase = readProvider(stripeConnectPurchaseModelProvider);
    await stripePurchase.refund(
      StripeMarketPlaceAdapter._context,
      orderId: orderId,
      amount: price,
    );
  }

  @override
  Future<void> reload() async {
    final stripePurchase = readProvider(stripeConnectPurchaseModelProvider);
    await stripePurchase.reload();
  }

  @override
  Future<void> authorization(double amount) async {
    final stripePurchase = readProvider(stripeConnectPurchaseModelProvider);
    await stripePurchase.authorization(
      StripeMarketPlaceAdapter._context,
      amount: amount,
      popWhenClosedByWebview: true,
      builder: (webView, onClosed) async {
        await UIModal.show(
          StripeMarketPlaceAdapter._context,
          disableBackKey: true,
          child: ValueProvider<Widget>(
            value: webView,
            child: adapter.viewWithoutBack,
          ),
        );
      },
    );
  }

  @override
  ChangeNotifierProvider<FirestoreDynamicCollectionModel> collectionProvider(
    String userId,
  ) {
    return stripeConnectPurchaseCollectionProvider(userId);
  }

  @override
  ChangeNotifierProvider get modelProvider =>
      stripeConnectPurchaseModelProvider;
}
