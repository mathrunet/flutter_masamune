part of '/masamune_purchase.dart';

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
    super.purchase,
    super.consumablePurchaseDelegate,
    super.nonConsumablePurchaseDelegate,
    super.subscriptionPurchaseDelegate,
  });

  @override
  Future<List<PurchaseProduct>> getProducts({
    required String? Function() onRetrieveUserId,
  }) async {
    final res = products.mapAndRemoveEmpty<PurchaseProduct>((e) {
      switch (e.type) {
        case PurchaseProductType.consumable:
          return StoreConsumablePurchaseProduct(
            product: e,
            onRetrieveUserId: consumablePurchaseDelegate?.onRetrieveUserId ??
                onRetrieveUserId,
            onRetrieveDocument:
                consumablePurchaseDelegate?.onRetrieveDocument ??
                    StoreConsumablePurchaseProduct.defaultOnRetrieveDocument,
            onRetrieveValue: consumablePurchaseDelegate?.onRetrieveValue ??
                StoreConsumablePurchaseProduct.defaultOnRetrieveValue,
            onSaveDocument: consumablePurchaseDelegate?.onSaveDocument ??
                StoreConsumablePurchaseProduct.defaultOnSaveDocument,
            adapter: modelAdapter,
          );
        case PurchaseProductType.nonConsumable:
          return StoreNonConsumablePurchaseProduct(
            product: e,
            onRetrieveUserId: nonConsumablePurchaseDelegate?.onRetrieveUserId ??
                onRetrieveUserId,
            onRetrieveDocument:
                nonConsumablePurchaseDelegate?.onRetrieveDocument ??
                    StoreNonConsumablePurchaseProduct.defaultOnRetrieveDocument,
            onRetrieveValue: nonConsumablePurchaseDelegate?.onRetrieveValue ??
                StoreNonConsumablePurchaseProduct.defaultOnRetrieveValue,
            onSaveDocument: nonConsumablePurchaseDelegate?.onSaveDocument ??
                StoreNonConsumablePurchaseProduct.defaultOnSaveDocument,
            adapter: modelAdapter,
          );
        case PurchaseProductType.subscription:
          return StoreSubscriptionPurchaseProduct(
            product: e,
            onRetrieveUserId: subscriptionPurchaseDelegate?.onRetrieveUserId ??
                onRetrieveUserId,
            onRetrieveCollection: subscriptionPurchaseDelegate
                    ?.onRetrieveCollection ??
                StoreSubscriptionPurchaseProduct.defaultOnRetrieveCollection,
            onRetrieveValue: subscriptionPurchaseDelegate?.onRetrieveValue ??
                StoreSubscriptionPurchaseProduct.defaultOnRetrieveValue,
            onSaveDocument: subscriptionPurchaseDelegate?.onSaveDocument ??
                StoreSubscriptionPurchaseProduct.defaultOnSaveDocument,
            onRevokeDocument: subscriptionPurchaseDelegate?.onRevokeDocument ??
                StoreSubscriptionPurchaseProduct.defaultOnRevokeDocument,
            adapter: modelAdapter,
          );
        case PurchaseProductType.subscriptionOffer:
          return null;
      }
    });
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
    required void Function(Object e, StackTrace? stacktrace) onError,
  }) =>
      null;

  @override
  Future<void> purchase({
    required PurchaseProduct product,
    required VoidCallback onDone,
    PurchaseProduct? replacedProduct,
  }) async {
    if (product is StoreConsumablePurchaseProduct) {
      await product._purchaseForRuntime();
    } else if (product is StoreNonConsumablePurchaseProduct) {
      await product._purchaseForRuntime();
    } else if (product is StoreSubscriptionPurchaseProduct) {
      await product._purchaseForRuntime(
        orderId: uuid(),
        replacedProduct: replacedProduct,
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
