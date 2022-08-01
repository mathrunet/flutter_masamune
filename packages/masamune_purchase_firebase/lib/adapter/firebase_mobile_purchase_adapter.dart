part of masamune_purchase_firebase;

class FirebaseMobilePurchaseAdapter extends MobilePurchaseAdapter {
  const FirebaseMobilePurchaseAdapter({
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
    bool autoConsumeOnAndroid = true,
    String? androidRefreshToken,
    PurchaseDelegate purchaseDelegate = const FirebasePurchaseDelegate(),
    String? userId,
    required String functionsHostUrl,
    AndroidVerifierOptions androidVerifierOptions =
        const AndroidVerifierOptions(
      consumableVerificationServer: "consumable_verify_android",
      nonconsumableVerificationServer: "nonconsumable_verify_android",
      subscriptionVerificationServer: "subscription_verify_android",
    ),
    IOSVerifierOptions iosVerifierOptions = const IOSVerifierOptions(
      consumableVerificationServer: "consumable_verify_ios",
      nonconsumableVerificationServer: "nonconsumable_verify_ios",
      subscriptionVerificationServer: "subscription_verify_ios",
    ),
    DeliverOptions deliverOptions = const DeliverOptions(),
    bool sandboxTesting = false,
  }) : super(
          products: products,
          onPrepare: onPrepare,
          onVerify: onVerify,
          onSubscribe: onSubscribe,
          onUnlock: onUnlock,
          onDeliver: onDeliver,
          serverPrefix: functionsHostUrl,
          onCheckSubscription: onCheckSubscription,
          subscribeOptions: subscribeOptions,
          autoConsumeOnAndroid: autoConsumeOnAndroid,
          androidRefreshToken: androidRefreshToken,
          userId: userId,
          purchaseDelegate: purchaseDelegate,
          androidVerifierOptions: androidVerifierOptions,
          iosVerifierOptions: iosVerifierOptions,
          deliverOptions: deliverOptions,
          sandboxTesting: sandboxTesting,
        );
}
