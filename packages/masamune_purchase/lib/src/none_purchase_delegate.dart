part of masamune_purchase;

/// Class for managing billing process.
///
/// Initialize by first executing initialize().
///
/// Then purchasing item by executing purchase().
@immutable
class NonePurchaseDelegate extends PurchaseDelegate {
  const NonePurchaseDelegate();

  /// [PurchaseCore] is used as a callback for [onVerify] of [PurchaseCore].
  ///
  /// The signature is verified and the receipt is verified locally.
  static Future<bool> verify(
    PurchaseDetails purchase,
    MobilePurchaseProduct product,
    PurchaseModel core,
  ) async =>
      true;

  @override
  Future<bool> onVerify(
    PurchaseDetails purchase,
    MobilePurchaseProduct product,
    PurchaseModel core,
  ) =>
      verify(purchase, product, core);
}
