part of masamune_purchase;

@immutable
abstract class PurchaseDelegate {
  const PurchaseDelegate();

  Future<bool> onPrepare() => Future.value(true);
  Future<bool> onVerify(
    PurchaseDetails purchase,
    MobilePurchaseProduct product,
    PurchaseModel core,
  ) =>
      Future.value(true);
  Future<void> onSubscribe(
    PurchaseDetails purchase,
    MobilePurchaseProduct product,
    PurchaseModel core,
  ) =>
      Future.value();
  Future<void> onUnlock(
    PurchaseDetails purchase,
    MobilePurchaseProduct product,
    PurchaseModel core,
  ) =>
      Future.value();
  Future<void> onDeliver(
    PurchaseDetails purchase,
    MobilePurchaseProduct product,
    PurchaseModel core,
  ) =>
      Future.value();
  Future<void> onCheckSubscription(PurchaseModel core) => Future.value();
}
