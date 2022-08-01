part of masamune_purchase;

class MobilePurchaseAdapter extends PurchaseAdapter<MobilePurchaseProduct> {
  const MobilePurchaseAdapter({
    required this.products,
    this.onPrepare,
    this.onVerify,
    this.onSubscribe,
    this.onUnlock,
    this.onDeliver,
    this.onCheckSubscription,
    this.serverPrefix,
    this.subscribeOptions = const SubscribeOptions(),
    this.autoConsumeOnAndroid = true,
    this.androidRefreshToken,
    this.purchaseDelegate = const NonePurchaseDelegate(),
    this.userId,
    this.androidVerifierOptions = const AndroidVerifierOptions(),
    this.iosVerifierOptions = const IOSVerifierOptions(),
    this.deliverOptions = const DeliverOptions(),
    this.sandboxTesting = false,
  });

  final List<MobilePurchaseProduct> products;
  final Future<bool> Function()? onPrepare;
  final Future<bool> Function(
    PurchaseDetails purchase,
    MobilePurchaseProduct product,
    PurchaseModel core,
  )? onVerify;
  final Future<void> Function(
    PurchaseDetails purchase,
    MobilePurchaseProduct product,
    PurchaseModel core,
  )? onSubscribe;
  final Future<void> Function(
    PurchaseDetails purchase,
    MobilePurchaseProduct product,
    PurchaseModel core,
  )? onUnlock;
  final Future<void> Function(
    PurchaseDetails purchase,
    MobilePurchaseProduct product,
    PurchaseModel core,
  )? onDeliver;
  final Future<void> Function(PurchaseModel core)? onCheckSubscription;
  final PurchaseDelegate purchaseDelegate;
  final SubscribeOptions subscribeOptions;
  final bool autoConsumeOnAndroid;
  final String? androidRefreshToken;
  final String? userId;
  final String? serverPrefix;
  final AndroidVerifierOptions androidVerifierOptions;
  final IOSVerifierOptions iosVerifierOptions;
  final DeliverOptions deliverOptions;
  final bool sandboxTesting;

  @override
  Future<void> initialize(BuildContext context) async {
    await PurchaseCore.initialize(
      context,
      products: products.map((e) => MobilePurchaseProduct.from(e)).toList(),
      onPrepare: onPrepare ?? purchaseDelegate.onPrepare,
      onVerify: onVerify ?? purchaseDelegate.onVerify,
      onSubscribe: onSubscribe ?? purchaseDelegate.onSubscribe,
      onUnlock: onUnlock ?? purchaseDelegate.onUnlock,
      onDeliver: onDeliver ?? purchaseDelegate.onDeliver,
      serverPrefix: serverPrefix,
      onCheckSubscription:
          onCheckSubscription ?? purchaseDelegate.onCheckSubscription,
      subscribeOptions: subscribeOptions,
      autoConsumeOnAndroid: autoConsumeOnAndroid,
      androidRefreshToken: androidRefreshToken,
      userId: userId ?? context.model?.userId,
      androidVerifierOptions: androidVerifierOptions,
      iosVerifierOptions: iosVerifierOptions,
      deliverOptions: deliverOptions,
    );
  }

  @override
  Future<void> purchase(MobilePurchaseProduct product, {String? userId}) async {
    await PurchaseCore.purchase(
      product,
      userId: userId,
      sandboxTesting: sandboxTesting,
    );
  }

  @override
  Future<void> restore() async {
    await PurchaseCore.restore();
  }

  @override
  Future<void> consume(MobilePurchaseProduct product) async {
    await PurchaseCore.consume(product: product);
  }

  @override
  List<MobilePurchaseProduct> getRegisteredProducts() {
    return PurchaseCore.getProducts();
  }
}
