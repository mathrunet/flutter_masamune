part of masamune_purchase;

class PurchaseCore {
  const PurchaseCore._();

  static PurchaseModel get _purchase {
    return readProvider(purchaseModelProvider);
  }

  /// Class for managing billing process.
  ///
  /// Initialize by first executing [initialize()].
  ///
  /// Then purchasing item by executing [purchase()].
  static Future<PurchaseModel> initialize(
    BuildContext context, {
    required List<MobilePurchaseProduct> products,
    Future<bool> Function()? onPrepare,
    Future<bool> Function(
      PurchaseDetails purchase,
      MobilePurchaseProduct product,
      PurchaseModel core,
    )?
        onVerify,
    Future<void> Function(
      PurchaseDetails purchase,
      MobilePurchaseProduct product,
      PurchaseModel core,
    )?
        onSubscribe,
    Future<void> Function(
      PurchaseDetails purchase,
      MobilePurchaseProduct product,
      PurchaseModel core,
    )?
        onUnlock,
    Future<void> Function(
      PurchaseDetails purchase,
      MobilePurchaseProduct product,
      PurchaseModel core,
    )?
        onDeliver,
    Future<void> Function(PurchaseModel core)? onCheckSubscription,
    SubscribeOptions subscribeOptions = const SubscribeOptions(),
    Duration timeout = const Duration(seconds: 30),
    bool autoConsumeOnAndroid = true,
    String? androidRefreshToken,
    String? userId,
    String? serverPrefix,
    AndroidVerifierOptions androidVerifierOptions =
        const AndroidVerifierOptions(),
    IOSVerifierOptions iosVerifierOptions = const IOSVerifierOptions(),
    DeliverOptions deliverOptions = const DeliverOptions(),
  }) =>
      _purchase.initialize(
        context,
        products: products,
        onPrepare: onPrepare,
        serverPrefix: serverPrefix,
        onVerify: onVerify,
        onSubscribe: onSubscribe,
        onUnlock: onUnlock,
        onDeliver: onDeliver,
        onCheckSubscription: onCheckSubscription,
        subscribeOptions: subscribeOptions,
        timeout: timeout,
        autoConsumeOnAndroid: autoConsumeOnAndroid,
        androidRefreshToken: androidRefreshToken,
        userId: userId,
        androidVerifierOptions: androidVerifierOptions,
        iosVerifierOptions: iosVerifierOptions,
        deliverOptions: deliverOptions,
      );

  /// Restore purchase.
  ///
  /// Please use it manually or immediately after user registration.
  ///
  /// [timeout]: Timeout settings.
  static Future<PurchaseModel> restore({
    Duration timeout = const Duration(seconds: 30),
  }) =>
      _purchase.restore(timeout: timeout);

  /// Consume all purchased items.
  ///
  /// Please use it manually or immediately after user registration.
  static Future<PurchaseModel> consume({
    required MobilePurchaseProduct product,
    Duration timeout = const Duration(seconds: 30),
  }) =>
      _purchase.consume(
        product: product,
        timeout: timeout,
      );

  /// Process the purchase.
  ///
  /// You specify the product data in [product], the billing process will start.
  static Future<PurchaseModel> purchase(
    MobilePurchaseProduct product, {
    String? userId,
    bool sandboxTesting = false,
    Duration timeout = const Duration(seconds: 30),
  }) =>
      _purchase.purchase(
        product,
        userId: userId,
        timeout: timeout,
        sandboxTesting: sandboxTesting,
      );

  /// Get the [MobilePurchaseProduct] list.
  static List<MobilePurchaseProduct> getProducts() => _purchase.value;

  /// Find the [MobilePurchaseProduct] from [productId].
  static MobilePurchaseProduct? getProduct(String productId) =>
      _purchase.getProduct(productId);

  /// Run in the main() method before executing with [initialize].
  static void enablePendingPurchases() {
    // InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  }

  /// True if the billing system has been initialized.
  static bool get isInitialized => _purchase._isInitialized;

  /// True if restored.
  static bool get isRestored => _purchase.isRestored;

  static ProductDetails? _findByPurchaseProduct(
    MobilePurchaseProduct product,
  ) {
    return _purchase._findByPurchaseProduct(product);
  }

  /// Find the [MobilePurchaseProduct] from [productId].
  static MobilePurchaseProduct? findById(String productId) =>
      _purchase.findById(productId);

  /// Find the [MobilePurchaseProduct] from [PurchaseDetails].
  static MobilePurchaseProduct? findByPurchase(PurchaseDetails details) =>
      _purchase.findByPurchase(details);

  /// Find the [MobilePurchaseProduct] from [ProductDetails].
  static MobilePurchaseProduct? findByProduct(ProductDetails details) =>
      _purchase.findByProduct(details);

  /// Get the Authorization Code for Google OAuth.
  static Future<void> getAuthorizationCode() =>
      _purchase.getAuthorizationCode();

  /// Get Refresh Token for Google OAuth.
  ///
  /// Please get the authorization code first.
  static Future<String?> getAndroidRefreshToken(String authorizationCode) =>
      _purchase.getAndroidRefreshToken(authorizationCode);
}
