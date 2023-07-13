part of masamune_purchase_mobile;

/// Initialize [MasamuneAdapter] to handle InAppPurchase in the mockup.
///
/// Define all billable items to be used in the app in [products].
///
/// モックアップでのInAppPurchaseを取り扱うための初期設定を行う[MasamuneAdapter]。
///
/// [products]にアプリ内で利用するすべての課金用のアイテムを定義してください。
class RuntimePurchaseMasamuneAdapter extends PurchaseMasamuneAdapter {
  /// Initialize [MasamuneAdapter] to handle InAppPurchase in the mockup.
  ///
  /// Define all billable items to be used in the app in [products].
  ///
  /// モックアップでのInAppPurchaseを取り扱うための初期設定を行う[MasamuneAdapter]。
  ///
  /// [products]にアプリ内で利用するすべての課金用のアイテムを定義してください。
  const RuntimePurchaseMasamuneAdapter({
    super.functionsAdapter,
    super.modelAdapter,
    required super.products,
    required super.onRetrieveUserId,
  });

  @override
  Future<List<PurchaseProduct>> getProducts({
    required String Function() onRetrieveUserId,
  }) async {
    final res = products.map<PurchaseProduct>((e) {
      switch (e.type) {
        case PurchaseProductType.consumable:
          return StoreConsumablePurchaseProduct(
            product: e,
            onRetrieveUserId: onRetrieveUserId,
            adapter: modelAdapter,
          );
        case PurchaseProductType.nonConsumable:
          return StoreNonConsumablePurchaseProduct(
            product: e,
            onRetrieveUserId: onRetrieveUserId,
            adapter: modelAdapter,
          );
        case PurchaseProductType.subscription:
          return StoreSubscriptionPurchaseProduct(
            product: e,
            onRetrieveUserId: onRetrieveUserId,
            adapter: modelAdapter,
          );
      }
    }).toList();
    await Future.wait(res.map((e) => e.load()));
    return res;
  }

  @override
  Future<void> initialize() => Future.value();

  @override
  StreamSubscription? listenPurchase({
    required List<PurchaseProduct> products,
    required VoidCallback onDone,
    required VoidCallback onDisposed,
    required void Function(Object e) onError,
  }) =>
      null;

  @override
  Future<void> purchase({
    required PurchaseProduct product,
    required VoidCallback onDone,
  }) async {
    if (product is StoreConsumablePurchaseProduct) {
      await product._purchaseForRuntime();
    } else if (product is StoreNonConsumablePurchaseProduct) {
      await product._purchaseForRuntime();
    } else if (product is StoreSubscriptionPurchaseProduct) {
      await product._purchaseForRuntime(
        orderId: uuid,
      );
    } else {
      throw Exception("Product not found: ${product.productId}");
    }
    onDone();
  }

  @override
  Future<void> restore(List<PurchaseProduct> products) async {
    await Future.wait(products.map((e) => e.load()));
  }
}
