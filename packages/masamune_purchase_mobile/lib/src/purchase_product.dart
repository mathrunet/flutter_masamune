part of masamune_purchase_mobile;

const kConsumableValueKey = "value";
const kSubscriptionExpiredKey = "expired";

enum PurchaseProductType {
  consumable,
  nonConsumable,
  subscription,
}

@immutable
class PurchaseProduct {
  const PurchaseProduct({
    required this.productId,
    required this.type,
    this.amount,
    this.title = "",
    this.description = "",
    required this.price,
  });

  const PurchaseProduct.wallet({
    required this.productId,
    this.amount,
    this.title = "",
    this.description = "",
    required this.price,
  }) : type = PurchaseProductType.consumable;

  const PurchaseProduct.unlock({
    required this.productId,
    this.title = "",
    this.description = "",
    required this.price,
  })  : type = PurchaseProductType.nonConsumable,
        amount = null;

  const PurchaseProduct.subscription({
    required this.productId,
    this.title = "",
    this.description = "",
    required this.price,
  })  : type = PurchaseProductType.subscription,
        amount = null;

  final String productId;

  final PurchaseProductType type;

  final double? amount;

  final String title;

  final String description;

  final double price;

  String get priceText => price.toString();

  @override
  int get hashCode =>
      productId.hashCode ^
      amount.hashCode ^
      title.hashCode ^
      description.hashCode ^
      price.hashCode;

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;

  Future<void> load() => Future.value();

  PurchaseProductValue? get value => null;

  PurchaseProduct _copyWith({
    required ProductDetails productDetails,
    required String Function() onRetrieveUserId,
    ModelAdapter? adapter,
  }) {
    switch (type) {
      case PurchaseProductType.consumable:
        return _StoreConsumablePurchaseProduct(
          productId: productId,
          amount: amount,
          onRetrieveUserId: onRetrieveUserId,
          productDetails: productDetails,
          adapter: adapter,
        );
      case PurchaseProductType.nonConsumable:
        return _StoreNonConsumablePurchaseProduct(
          productId: productId,
          onRetrieveUserId: onRetrieveUserId,
          productDetails: productDetails,
          adapter: adapter,
        );
      case PurchaseProductType.subscription:
        return _StoreSubscriptionPurchaseProduct(
          productId: productId,
          onRetrieveUserId: onRetrieveUserId,
          productDetails: productDetails,
          adapter: adapter,
        );
    }
  }
}

class PurchaseProductValue {
  PurchaseProductValue({
    this.amount = 0.0,
    this.active = false,
  });

  final double amount;

  final bool active;

  @override
  int get hashCode => amount.hashCode ^ active.hashCode;

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;
}

// ignore: must_be_immutable
class _StoreConsumablePurchaseProduct extends PurchaseProduct {
  _StoreConsumablePurchaseProduct({
    required super.productId,
    super.amount,
    required this.onRetrieveUserId,
    required this.productDetails,
    this.adapter,
  }) : super(type: PurchaseProductType.consumable, price: 0.0) {
    _updateDocument();
  }

  final ProductDetails productDetails;
  final String Function() onRetrieveUserId;
  final ModelAdapter? adapter;

  @override
  String get title => productDetails.title;

  @override
  String get description => productDetails.description;

  @override
  double get price => productDetails.rawPrice;

  @override
  String get priceText => productDetails.price;

  late String userId;
  late _DynamicPurchaseUserModel document;

  @override
  Future<void> load() async {
    _updateDocument();
    await document.load();
  }

  @override
  PurchaseProductValue? get value {
    _updateDocument();
    return PurchaseProductValue(
      amount: document.value.get(kConsumableValueKey, 0.0),
    );
  }

  void _updateDocument() {
    final updated = onRetrieveUserId();
    if (userId != updated) {
      document = _DynamicPurchaseUserModel(
        userId,
      );
    }
  }
}

// ignore: must_be_immutable
class _StoreNonConsumablePurchaseProduct extends PurchaseProduct {
  _StoreNonConsumablePurchaseProduct({
    required super.productId,
    required this.onRetrieveUserId,
    required this.productDetails,
    this.adapter,
  }) : super(type: PurchaseProductType.nonConsumable, price: 0.0) {
    _updateDocument();
  }

  final ProductDetails productDetails;
  final String Function() onRetrieveUserId;
  final ModelAdapter? adapter;

  @override
  String get title => productDetails.title;

  @override
  String get description => productDetails.description;

  @override
  double get price => productDetails.rawPrice;

  @override
  String get priceText => productDetails.price;

  late String userId;
  late _DynamicPurchaseUserModel document;

  @override
  Future<void> load() async {
    _updateDocument();
    await document.load();
  }

  @override
  PurchaseProductValue? get value {
    _updateDocument();
    return PurchaseProductValue(
      active: document.value.get(productId.toCamelCase(), false),
    );
  }

  void _updateDocument() {
    final updated = onRetrieveUserId();
    if (userId != updated) {
      document = _DynamicPurchaseUserModel(
        userId,
      );
    }
  }
}

// ignore: must_be_immutable
class _StoreSubscriptionPurchaseProduct extends PurchaseProduct {
  _StoreSubscriptionPurchaseProduct({
    required super.productId,
    required this.onRetrieveUserId,
    required this.productDetails,
    this.adapter,
  }) : super(type: PurchaseProductType.subscription, price: 0.0) {
    _updateDocument();
  }

  final ProductDetails productDetails;
  final String Function() onRetrieveUserId;
  final ModelAdapter? adapter;

  @override
  String get title => productDetails.title;

  @override
  String get description => productDetails.description;

  @override
  double get price => productDetails.rawPrice;

  @override
  String get priceText => productDetails.price;

  late String userId;
  late _DynamicPurchaseUserModel document;

  @override
  Future<void> load() async {
    _updateDocument();
    await document.load();
  }

  @override
  PurchaseProductValue? get value {
    _updateDocument();
    return PurchaseProductValue(
      active: document.value.get(kSubscriptionExpiredKey, false),
    );
  }

  void _updateDocument() {
    final updated = onRetrieveUserId();
    if (userId != updated) {
      document = _DynamicPurchaseUserModel(
        userId,
      );
    }
  }
}

class _DynamicPurchaseUserModel extends DocumentBase<DynamicMap> {
  _DynamicPurchaseUserModel(
    String userId, {
    ModelAdapter? adapter,
  }) : super(
          PurchaseUserModel.document(userId, adapter: adapter).modelQuery,
        );

  @override
  DynamicMap fromMap(DynamicMap map) {
    return ModelFieldValue.fromMap(map);
  }

  @override
  DynamicMap toMap(DynamicMap value) {
    return ModelFieldValue.toMap(value);
  }
}
