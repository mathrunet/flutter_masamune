part of masamune_purchase_mobile.others;

extension on PurchaseProduct {
  PurchaseProduct _copyWith({
    required ProductDetails productDetails,
    required String Function() onRetrieveUserId,
    ModelAdapter? adapter,
  }) {
    switch (type) {
      case PurchaseProductType.consumable:
        return _StoreConsumablePurchaseProduct(
          product: this,
          onRetrieveUserId: onRetrieveUserId,
          productDetails: productDetails,
          adapter: adapter,
        );
      case PurchaseProductType.nonConsumable:
        return _StoreNonConsumablePurchaseProduct(
          product: this,
          onRetrieveUserId: onRetrieveUserId,
          productDetails: productDetails,
          adapter: adapter,
        );
      case PurchaseProductType.subscription:
        return _StoreSubscriptionPurchaseProduct(
          product: this,
          onRetrieveUserId: onRetrieveUserId,
          productDetails: productDetails,
          adapter: adapter,
        );
    }
  }
}

// ignore: must_be_immutable
class _StoreConsumablePurchaseProduct extends StoreConsumablePurchaseProduct {
  _StoreConsumablePurchaseProduct({
    required super.product,
    required super.onRetrieveUserId,
    required this.productDetails,
    super.adapter,
  });

  final ProductDetails productDetails;

  @override
  String get title => productDetails.title;

  @override
  String get description => productDetails.description;

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
    super.adapter,
  });

  final ProductDetails productDetails;

  @override
  String get title => productDetails.title;

  @override
  String get description => productDetails.description;

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
    super.adapter,
  });

  final ProductDetails productDetails;

  @override
  String get title => productDetails.title;

  @override
  String get description => productDetails.description;

  @override
  double get price => productDetails.rawPrice;

  @override
  String get priceText => productDetails.price;
}
