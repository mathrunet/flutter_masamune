part of masamune_purchase_mobile;

/// The key of the internal wallet when a [PurchaseProductType.consumable] chargeable item is purchased.
///
/// [PurchaseProductType.consumable]な課金アイテムを購入した場合の内部ウォレットのキー。
const kConsumableValueKey = "value";

/// A key used to determine if a [PurchaseProductType.subscription] chargeable item has been purchased and is within the expiration date.
///
/// [PurchaseProductType.subscription]な課金アイテムを購入した場合の有効期限内かどうかを判別するためのキー。
const kSubscriptionExpiredKey = "expired";

/// Defines the type of item being charged for.
///
/// 課金アイテムのタイプを定義します。
enum PurchaseProductType {
  /// Consumption type (wallet type)
  ///
  /// 消費型（ウォレットタイプ）
  consumable,

  /// Non-consumption type (function unlocked type)
  ///
  /// 非消費型（機能アンロックタイプ）
  nonConsumable,

  /// Subscription.
  ///
  /// サブスクリプション。
  subscription,
}

/// Define chargeable items.
///
/// PurchaseProduct.wallet] to create a wallet type billing item, [PurchaseProduct.unlock] to create a feature unlock type billing item, [PurchaseProduct.subscription] to Create a subscription with [PurchaseProduct.subscription].
///
/// Be sure to match [productId] with the store's ID.
///
/// The [title], [description], and [price] are overwritten when the charged item is loaded from the store.
///
/// 課金アイテムの定義を行います。
///
/// [PurchaseProduct.wallet]でウォレットタイプの課金アイテムを作成し、[PurchaseProduct.unlock]で機能アンロックタイプの課金アイテムを作成、[PurchaseProduct.subscription]でサブスクリプションを作成します。
///
/// [productId]をストア側のIDと必ず合わせるようにしてください。
///
/// [title]や[description]、[price]は課金アイテムをストアからロードした際に上書きされます。
@immutable
class PurchaseProduct {
  /// Define chargeable items.
  ///
  /// PurchaseProduct.wallet] to create a wallet type billing item, [PurchaseProduct.unlock] to create a feature unlock type billing item, [PurchaseProduct.subscription] to Create a subscription with [PurchaseProduct.subscription].
  ///
  /// Be sure to match [productId] with the store's ID.
  ///
  /// The [title], [description], and [price] are overwritten when the charged item is loaded from the store.
  ///
  /// 課金アイテムの定義を行います。
  ///
  /// [PurchaseProduct.wallet]でウォレットタイプの課金アイテムを作成し、[PurchaseProduct.unlock]で機能アンロックタイプの課金アイテムを作成、[PurchaseProduct.subscription]でサブスクリプションを作成します。
  ///
  /// [productId]をストア側のIDと必ず合わせるようにしてください。
  ///
  /// [title]や[description]、[price]は課金アイテムをストアからロードした際に上書きされます。
  const PurchaseProduct({
    required this.productId,
    required this.type,
    this.amount,
    this.title = "",
    this.description = "",
    required this.price,
  });

  /// Define chargeable items.
  ///
  /// PurchaseProduct.wallet] to create a wallet type billing item, [PurchaseProduct.unlock] to create a feature unlock type billing item, [PurchaseProduct.subscription] to Create a subscription with [PurchaseProduct.subscription].
  ///
  /// Be sure to match [productId] with the store's ID.
  ///
  /// The [title], [description], and [price] are overwritten when the charged item is loaded from the store.
  ///
  /// 課金アイテムの定義を行います。
  ///
  /// [PurchaseProduct.wallet]でウォレットタイプの課金アイテムを作成し、[PurchaseProduct.unlock]で機能アンロックタイプの課金アイテムを作成、[PurchaseProduct.subscription]でサブスクリプションを作成します。
  ///
  /// [productId]をストア側のIDと必ず合わせるようにしてください。
  ///
  /// [title]や[description]、[price]は課金アイテムをストアからロードした際に上書きされます。
  const PurchaseProduct.wallet({
    required this.productId,
    this.amount,
    this.title = "",
    this.description = "",
    required this.price,
  }) : type = PurchaseProductType.consumable;

  /// Define chargeable items.
  ///
  /// PurchaseProduct.wallet] to create a wallet type billing item, [PurchaseProduct.unlock] to create a feature unlock type billing item, [PurchaseProduct.subscription] to Create a subscription with [PurchaseProduct.subscription].
  ///
  /// Be sure to match [productId] with the store's ID.
  ///
  /// The [title], [description], and [price] are overwritten when the charged item is loaded from the store.
  ///
  /// 課金アイテムの定義を行います。
  ///
  /// [PurchaseProduct.wallet]でウォレットタイプの課金アイテムを作成し、[PurchaseProduct.unlock]で機能アンロックタイプの課金アイテムを作成、[PurchaseProduct.subscription]でサブスクリプションを作成します。
  ///
  /// [productId]をストア側のIDと必ず合わせるようにしてください。
  ///
  /// [title]や[description]、[price]は課金アイテムをストアからロードした際に上書きされます。
  const PurchaseProduct.unlock({
    required this.productId,
    this.title = "",
    this.description = "",
    required this.price,
  })  : type = PurchaseProductType.nonConsumable,
        amount = null;

  /// Define chargeable items.
  ///
  /// PurchaseProduct.wallet] to create a wallet type billing item, [PurchaseProduct.unlock] to create a feature unlock type billing item, [PurchaseProduct.subscription] to Create a subscription with [PurchaseProduct.subscription].
  ///
  /// Be sure to match [productId] with the store's ID.
  ///
  /// The [title], [description], and [price] are overwritten when the charged item is loaded from the store.
  ///
  /// 課金アイテムの定義を行います。
  ///
  /// [PurchaseProduct.wallet]でウォレットタイプの課金アイテムを作成し、[PurchaseProduct.unlock]で機能アンロックタイプの課金アイテムを作成、[PurchaseProduct.subscription]でサブスクリプションを作成します。
  ///
  /// [productId]をストア側のIDと必ず合わせるようにしてください。
  ///
  /// [title]や[description]、[price]は課金アイテムをストアからロードした際に上書きされます。
  const PurchaseProduct.subscription({
    required this.productId,
    this.title = "",
    this.description = "",
    required this.price,
  })  : type = PurchaseProductType.subscription,
        amount = null;

  /// Product ID.
  ///
  /// Be sure to match the ID on the store side.
  ///
  /// プロダクトID。
  ///
  /// ストア側のIDと必ず合わせるようにしてください。
  final String productId;

  /// Type of item charged.
  ///
  /// 課金アイテムのタイプ。
  final PurchaseProductType type;

  /// The amount of wallet money (gems) you add when you purchase a charged item.
  ///
  /// 課金アイテムを購入した際に追加するウォレットマネー（ジェム）の量。
  final double? amount;

  /// Tentative title of the charged item.
  ///
  /// 課金アイテムのタイトル（仮）。
  final String title;

  /// Description of the charged items (tentative).
  ///
  /// 課金アイテムの説明（仮）。
  final String description;

  /// Price of items charged (tentative).
  ///
  /// 課金アイテムの値段（仮）。
  final double price;

  /// Text with the currency mark of the item charged.
  ///
  /// 課金アイテムの通貨マークを付与したテキスト。
  String get priceText => price.toString();

  /// Load real data from the database.
  ///
  /// If [PurchaseProduct] is not obtained from [Purchase], nothing will happen.
  /// Get [PurchaseProduct] from [Purchase.findProductById], etc.
  ///
  /// 実データをデータベースからロードします。
  ///
  /// [Purchase]から[PurchaseProduct]が取得されていない場合は何も起きません。
  /// [Purchase.findProductById]などから[PurchaseProduct]を取得してください。
  Future<void> load() {
    throw Exception(
      "If [PurchaseProduct] is not obtained from [Purchase], nothing will happen. Get [PurchaseProduct] from [Purchase.findProductById], etc.",
    );
  }

  /// After executing [load], if the load is successful, the actual data can be obtained from here.
  ///
  /// [load]を実行した後ロードに成功していれば、実データをここから取得することができます。
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

  @override
  int get hashCode =>
      productId.hashCode ^
      amount.hashCode ^
      title.hashCode ^
      description.hashCode ^
      price.hashCode;

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;
}

/// Actual data for [PurchaseProduct].
///
/// [PurchaseProduct]の実データ。
@immutable
class PurchaseProductValue {
  /// Actual data for [PurchaseProduct].
  ///
  /// [PurchaseProduct]の実データ。
  const PurchaseProductValue({
    this.amount = 0.0,
    this.active = false,
  });

  /// Current wallet value.
  ///
  /// The value is obtained in the billing item of [PurchaseProductType.consumable].
  ///
  /// 現在のウォレットの値。
  ///
  /// [PurchaseProductType.consumable]の課金アイテムにて値が取得されています。
  final double amount;

  /// Returns `true` if the function is currently enabled.
  ///
  /// The [PurchaseProductType.nonConsumable] and [PurchaseProductType.subscription] will tell you if the functionality is unlocked due to billing.
  ///
  /// 現在機能が有効な場合`true`を返します。
  ///
  /// [PurchaseProductType.nonConsumable]や[PurchaseProductType.subscription]で課金により機能がアンロックされてかどうかを知ることができます。
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
