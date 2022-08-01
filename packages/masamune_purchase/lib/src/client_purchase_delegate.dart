part of masamune_purchase;

/// Class for managing billing process.
///
/// Initialize by first executing initialize().
///
/// Then purchasing item by executing purchase().
@immutable
class ClientPurchaseDelegate extends PurchaseDelegate {
  const ClientPurchaseDelegate();

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

  @override
  Future<bool> onPrepare() => Future.value(true);

  @override
  Future<void> onSubscribe(
    PurchaseDetails purchase,
    MobilePurchaseProduct product,
    PurchaseModel core,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<void> onUnlock(
    PurchaseDetails purchase,
    MobilePurchaseProduct product,
    PurchaseModel core,
  ) async {
    if (product.target.isEmpty) {
      throw Exception("Target path is not set.");
    }
    final documentPath = product.target!.parentPath();
    final key = product.target!.last();
    final document = core.context.model!.loadDocument(
      readProvider(
        core.context.model!.documentProvider(documentPath),
      ),
    );
    await document.loading;
    document[key] = true;
    await core.context.model!.saveDocument(document);
  }

  @override
  Future<void> onDeliver(
    PurchaseDetails purchase,
    MobilePurchaseProduct product,
    PurchaseModel core,
  ) async {
    if (product.target.isEmpty) {
      throw Exception("Target path is not set.");
    }
    final documentPath = product.target!.parentPath();
    final key = product.target!.last();
    final value = product.value;
    final document = core.context.model!.loadDocument(
      readProvider(
        core.context.model!.documentProvider(documentPath),
      ),
    );
    await document.loading;
    document.increment(key, value);
    await core.context.model!.saveDocument(document);
  }

  @override
  Future<void> onCheckSubscription(PurchaseModel core) => Future.value();
}
