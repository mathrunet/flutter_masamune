part of "others.dart";

extension on PurchaseProduct {
  PurchaseProduct _copyWith({
    required ProductDetails productDetails,
    required String? Function() onRetrieveUserId,
    ModelAdapter? modelAdapter,
    required MobilePurchaseMasamuneAdapter purchaseAdapter,
  }) {
    final product = this;
    switch (type) {
      case PurchaseProductType.consumable:
        if (product is StoreConsumablePurchaseProduct) {
          return _StoreConsumablePurchaseProduct(
            product: product,
            onRetrieveUserId: onRetrieveUserId,
            productDetails: productDetails,
            onRetrieveDocument: product.onRetrieveDocument,
            onRetrieveValue: product.onRetrieveValue,
            onSaveDocument: product.onSaveDocument,
            adapter: modelAdapter,
          );
        } else {
          return _StoreConsumablePurchaseProduct(
            product: product,
            onRetrieveUserId: onRetrieveUserId,
            productDetails: productDetails,
            onRetrieveDocument: purchaseAdapter
                    .consumablePurchaseDelegate?.onRetrieveDocument ??
                StoreConsumablePurchaseProduct.defaultOnRetrieveDocument,
            onRetrieveValue:
                purchaseAdapter.consumablePurchaseDelegate?.onRetrieveValue ??
                    StoreConsumablePurchaseProduct.defaultOnRetrieveValue,
            onSaveDocument:
                purchaseAdapter.consumablePurchaseDelegate?.onSaveDocument ??
                    StoreConsumablePurchaseProduct.defaultOnSaveDocument,
            adapter: modelAdapter,
          );
        }
      case PurchaseProductType.nonConsumable:
        if (product is StoreNonConsumablePurchaseProduct) {
          return _StoreNonConsumablePurchaseProduct(
            product: product,
            onRetrieveUserId: onRetrieveUserId,
            productDetails: productDetails,
            onRetrieveDocument: product.onRetrieveDocument,
            onRetrieveValue: product.onRetrieveValue,
            onSaveDocument: product.onSaveDocument,
            adapter: modelAdapter,
          );
        } else {
          return _StoreNonConsumablePurchaseProduct(
            product: product,
            onRetrieveUserId: onRetrieveUserId,
            productDetails: productDetails,
            onRetrieveDocument: purchaseAdapter
                    .nonConsumablePurchaseDelegate?.onRetrieveDocument ??
                StoreNonConsumablePurchaseProduct.defaultOnRetrieveDocument,
            onRetrieveValue: purchaseAdapter
                    .nonConsumablePurchaseDelegate?.onRetrieveValue ??
                StoreNonConsumablePurchaseProduct.defaultOnRetrieveValue,
            onSaveDocument:
                purchaseAdapter.nonConsumablePurchaseDelegate?.onSaveDocument ??
                    StoreNonConsumablePurchaseProduct.defaultOnSaveDocument,
            adapter: modelAdapter,
          );
        }
      case PurchaseProductType.subscription:
        if (product is StoreSubscriptionPurchaseProduct) {
          return _StoreSubscriptionPurchaseProduct(
            product: product,
            onRetrieveUserId: onRetrieveUserId,
            productDetails: productDetails,
            onRetrieveCollection: product.onRetrieveCollection,
            onRetrieveValue: product.onRetrieveValue,
            onSaveDocument: product.onSaveDocument,
            onRevokeDocument: product.onRevokeDocument,
            adapter: modelAdapter,
          );
        } else {
          return _StoreSubscriptionPurchaseProduct(
            product: product,
            onRetrieveUserId: onRetrieveUserId,
            productDetails: productDetails,
            onRetrieveCollection: purchaseAdapter
                    .subscriptionPurchaseDelegate?.onRetrieveCollection ??
                StoreSubscriptionPurchaseProduct.defaultOnRetrieveCollection,
            onRetrieveValue:
                purchaseAdapter.subscriptionPurchaseDelegate?.onRetrieveValue ??
                    StoreSubscriptionPurchaseProduct.defaultOnRetrieveValue,
            onSaveDocument:
                purchaseAdapter.subscriptionPurchaseDelegate?.onSaveDocument ??
                    StoreSubscriptionPurchaseProduct.defaultOnSaveDocument,
            onRevokeDocument: purchaseAdapter
                    .subscriptionPurchaseDelegate?.onRevokeDocument ??
                StoreSubscriptionPurchaseProduct.defaultOnRevokeDocument,
            adapter: modelAdapter,
          );
        }
      case PurchaseProductType.subscriptionOffer:
        throw UnimplementedError();
    }
  }
}

// ignore: must_be_immutable
class _StoreConsumablePurchaseProduct extends StoreConsumablePurchaseProduct {
  _StoreConsumablePurchaseProduct({
    required super.product,
    required super.onRetrieveUserId,
    required this.productDetails,
    required super.onRetrieveDocument,
    required super.onRetrieveValue,
    required super.onSaveDocument,
    super.adapter,
  });

  final ProductDetails productDetails;

  @override
  String get titleOnStore => productDetails.title;

  @override
  String get descriptionOnStore => productDetails.description;

  @override
  double get price => productDetails.rawPrice;

  @override
  String get priceText => productDetails.price;
}

// ignore: must_be_immutable
class _StoreNonConsumablePurchaseProduct
    extends StoreNonConsumablePurchaseProduct {
  _StoreNonConsumablePurchaseProduct({
    required super.product,
    required super.onRetrieveUserId,
    required this.productDetails,
    required super.onRetrieveDocument,
    required super.onRetrieveValue,
    required super.onSaveDocument,
    super.adapter,
  });

  final ProductDetails productDetails;

  @override
  String get titleOnStore => productDetails.title;

  @override
  String get descriptionOnStore => productDetails.description;

  @override
  double get price => productDetails.rawPrice;

  @override
  String get priceText => productDetails.price;
}

// ignore: must_be_immutable
class _StoreSubscriptionPurchaseProduct
    extends StoreSubscriptionPurchaseProduct {
  _StoreSubscriptionPurchaseProduct({
    required super.product,
    required super.onRetrieveUserId,
    required this.productDetails,
    required super.onRetrieveCollection,
    required super.onRetrieveValue,
    required super.onSaveDocument,
    required super.onRevokeDocument,
    super.adapter,
  });

  final ProductDetails productDetails;

  @override
  String get titleOnStore => productDetails.title;

  @override
  String get descriptionOnStore => productDetails.description;

  @override
  double get price => productDetails.rawPrice;

  @override
  String get priceText => productDetails.price;

  @override
  List<PurchaseProduct> get subProducts {
    final productDetails = this.productDetails;
    if (productDetails is GooglePlayProductDetails) {
      return productDetails.productDetails.subscriptionOfferDetails
              ?.mapAndRemoveEmpty(
            (e) {
              if (e.pricingPhases.isEmpty) {
                return null;
              }
              final pricingPhase = e.pricingPhases.first;
              return PurchaseProduct(
                productId: e.offerId ?? "",
                type: PurchaseProductType.subscriptionOffer,
                price: pricingPhase.priceAmountMicros / 100000,
                priceText: pricingPhase.formattedPrice,
              );
            },
          ) ??
          [];
    }
    return [];
  }
}
