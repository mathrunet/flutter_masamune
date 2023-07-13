part of masamune_purchase_mobile;

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
  /// [expiredPeriod] allows you to specify the duration of the subscription for testing.
  ///
  /// 課金アイテムの定義を行います。
  ///
  /// [PurchaseProduct.wallet]でウォレットタイプの課金アイテムを作成し、[PurchaseProduct.unlock]で機能アンロックタイプの課金アイテムを作成、[PurchaseProduct.subscription]でサブスクリプションを作成します。
  ///
  /// [productId]をストア側のIDと必ず合わせるようにしてください。
  ///
  /// [title]や[description]、[price]は課金アイテムをストアからロードした際に上書きされます。
  ///
  /// [expiredPeriod]を指定するとテスト用のサブスクリプションの期間を指定することができます。
  const PurchaseProduct({
    required this.productId,
    required this.type,
    this.amount,
    this.title = "",
    this.description = "",
    required this.price,
    this.expiredPeriod,
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
  })  : type = PurchaseProductType.consumable,
        expiredPeriod = null;

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
        amount = null,
        expiredPeriod = null;

  /// Define chargeable items.
  ///
  /// PurchaseProduct.wallet] to create a wallet type billing item, [PurchaseProduct.unlock] to create a feature unlock type billing item, [PurchaseProduct.subscription] to Create a subscription with [PurchaseProduct.subscription].
  ///
  /// Be sure to match [productId] with the store's ID.
  ///
  /// The [title], [description], and [price] are overwritten when the charged item is loaded from the store.
  ///
  /// [expiredPeriod] allows you to specify the duration of the subscription for testing.
  ///
  /// 課金アイテムの定義を行います。
  ///
  /// [PurchaseProduct.wallet]でウォレットタイプの課金アイテムを作成し、[PurchaseProduct.unlock]で機能アンロックタイプの課金アイテムを作成、[PurchaseProduct.subscription]でサブスクリプションを作成します。
  ///
  /// [productId]をストア側のIDと必ず合わせるようにしてください。
  ///
  /// [title]や[description]、[price]は課金アイテムをストアからロードした際に上書きされます。
  ///
  /// [expiredPeriod]を指定するとテスト用のサブスクリプションの期間を指定することができます。
  const PurchaseProduct.subscription({
    required this.productId,
    this.title = "",
    this.description = "",
    required this.price,
    this.expiredPeriod,
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

  /// Period of validity.
  ///
  /// 有効期限の期間。
  final Duration? expiredPeriod;

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

/// Define billing items that are [PurchaseProductType.consumable].
///
/// [PurchaseProductType.consumable]な課金アイテムを定義します。
// ignore: must_be_immutable
class StoreConsumablePurchaseProduct extends PurchaseProduct
    with ChangeNotifier {
  /// Define billing items that are [PurchaseProductType.consumable].
  ///
  /// [PurchaseProductType.consumable]な課金アイテムを定義します。
  StoreConsumablePurchaseProduct({
    required PurchaseProduct product,
    required this.onRetrieveUserId,
    this.adapter,
  })  : assert(
          product.type == PurchaseProductType.consumable,
          "[product] does not match [PurchaseProductType.consumable].",
        ),
        super(
          productId: product.productId,
          amount: product.amount,
          type: PurchaseProductType.consumable,
          price: 0.0,
        ) {
    _updateDocument();
  }

  /// Callback to obtain user ID.
  ///
  /// ユーザーIDを取得するためのコールバック。
  final String Function() onRetrieveUserId;

  /// Adapters for models.
  ///
  /// モデル用のアダプター。
  final ModelAdapter? adapter;

  /// User ID.
  ///
  /// ユーザーID。
  String get userId => _userId;
  late String _userId;

  _DynamicPurchaseUserDocumentModel? _document;

  @override
  Future<void> load() async {
    _updateDocument();
    await _document?.load();
  }

  Future<void> _purchaseForRuntime() async {
    await _document?.save({
      kConsumableValueKey:
          (_document?.value.get(kConsumableValueKey, 0.0) ?? 0.0) +
              (amount ?? 0.0),
    });
  }

  @override
  PurchaseProductValue? get value {
    return PurchaseProductValue(
      amount: _document?.value.get(kConsumableValueKey, 0.0) ?? 0.0,
    );
  }

  void _updateDocument() {
    final updated = onRetrieveUserId();
    if (_userId != updated) {
      _userId = updated;
      _document?.removeListener(notifyListeners);
      _document?.dispose();
      _document = _DynamicPurchaseUserDocumentModel(
        _userId,
      );
      _document?.addListener(notifyListeners);
    }
  }
}

/// Define billing items that are [PurchaseProductType.nonConsumable].
///
/// [PurchaseProductType.nonConsumable]な課金アイテムを定義します。
// ignore: must_be_immutable
class StoreNonConsumablePurchaseProduct extends PurchaseProduct
    with ChangeNotifier {
  /// Define billing items that are [PurchaseProductType.nonConsumable].
  ///
  /// [PurchaseProductType.nonConsumable]な課金アイテムを定義します。
  StoreNonConsumablePurchaseProduct({
    required PurchaseProduct product,
    required this.onRetrieveUserId,
    this.adapter,
  })  : assert(
          product.type == PurchaseProductType.nonConsumable,
          "[product] does not match [PurchaseProductType.nonConsumable].",
        ),
        super(
          productId: product.productId,
          type: PurchaseProductType.nonConsumable,
          price: 0.0,
        ) {
    _updateDocument();
  }

  /// Callback to obtain user ID.
  ///
  /// ユーザーIDを取得するためのコールバック。
  final String Function() onRetrieveUserId;

  /// Adapters for models.
  ///
  /// モデル用のアダプター。
  final ModelAdapter? adapter;

  /// User ID.
  ///
  /// ユーザーID。
  String get userId => _userId;
  late String _userId;

  _DynamicPurchaseUserDocumentModel? _document;

  @override
  Future<void> load() async {
    _updateDocument();
    await _document?.load();
  }

  Future<void> _purchaseForRuntime() async {
    await _document?.save({
      productId.toCamelCase(): true,
    });
  }

  @override
  PurchaseProductValue? get value {
    return PurchaseProductValue(
      active: _document?.value.get(productId.toCamelCase(), false) ?? false,
    );
  }

  void _updateDocument() {
    final updated = onRetrieveUserId();
    if (_userId != updated) {
      _userId = updated;
      _document?.removeListener(notifyListeners);
      _document?.dispose();
      _document = _DynamicPurchaseUserDocumentModel(
        _userId,
      );
      _document?.addListener(notifyListeners);
    }
  }
}

/// Define billing items that are [PurchaseProductType.subscription].
///
/// [PurchaseProductType.subscription]な課金アイテムを定義します。
// ignore: must_be_immutable
class StoreSubscriptionPurchaseProduct extends PurchaseProduct
    with ChangeNotifier {
  /// Define billing items that are [PurchaseProductType.subscription].
  ///
  /// [PurchaseProductType.subscription]な課金アイテムを定義します。
  StoreSubscriptionPurchaseProduct({
    required PurchaseProduct product,
    required this.onRetrieveUserId,
    this.adapter,
  })  : assert(
          product.type == PurchaseProductType.subscription,
          "[product] does not match [PurchaseProductType.subscription].",
        ),
        super(
          productId: product.productId,
          type: PurchaseProductType.subscription,
          price: 0.0,
        ) {
    _updateCollection();
  }

  /// Callback to obtain user ID.
  ///
  /// ユーザーIDを取得するためのコールバック。
  final String Function() onRetrieveUserId;

  /// Adapters for models.
  ///
  /// モデル用のアダプター。
  final ModelAdapter? adapter;

  /// User ID.
  ///
  /// ユーザーID。
  String get userId => _userId;
  late String _userId;

  _DynamicPurchaseSubscriptionCollectionModel? _collection;

  @override
  Future<void> load() async {
    _updateCollection();
    await _collection?.load();
  }

  Future<void> _purchaseForRuntime({
    required String orderId,
  }) async {
    assert(expiredPeriod != null, "[expiredPeriod] is not set.");
    final now = DateTime.now();
    final expiredTime = now.add(expiredPeriod!);
    final doc = _collection?.create();
    await doc?.save(
      PurchaseSubscriptionModel(
        userId: _userId,
        orderId: orderId,
        productId: productId,
        expired: now.isAfter(expiredTime),
        expiredTime: expiredTime.millisecondsSinceEpoch,
      ).toJson(),
    );
  }

  @override
  PurchaseProductValue? get value {
    return PurchaseProductValue(
      active: _collection?.any(
            (e) => !e.value.get(kSubscriptionExpiredKey, true),
          ) ??
          false,
    );
  }

  void _updateCollection() {
    final updated = onRetrieveUserId();
    if (_userId != updated) {
      _userId = updated;
      _collection?.removeListener(notifyListeners);
      _collection?.dispose();
      _collection = _DynamicPurchaseSubscriptionCollectionModel(
        userId: updated,
      );
      _collection?.addListener(notifyListeners);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _collection?.removeListener(notifyListeners);
    _collection?.dispose();
  }
}

class _DynamicPurchaseUserDocumentModel extends DocumentBase<DynamicMap> {
  _DynamicPurchaseUserDocumentModel(
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

class _DynamicPurchaseSubscriptionDocumentModel
    extends DocumentBase<DynamicMap> {
  _DynamicPurchaseSubscriptionDocumentModel(
    String subscriptionId, {
    ModelAdapter? adapter,
  }) : super(
          PurchaseSubscriptionModel.document(subscriptionId, adapter: adapter)
              .modelQuery,
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

class _DynamicPurchaseSubscriptionCollectionModel
    extends CollectionBase<_DynamicPurchaseSubscriptionDocumentModel> {
  _DynamicPurchaseSubscriptionCollectionModel({
    required String userId,
    ModelAdapter? adapter,
  }) : super(
          PurchaseSubscriptionModel.collection(adapter: adapter)
              .equal(PurchaseSubscriptionModelCollectionKey.userId, userId)
              .modelQuery,
        );

  @override
  _DynamicPurchaseSubscriptionDocumentModel create([String? id]) {
    return _DynamicPurchaseSubscriptionDocumentModel(
      id ?? uuid,
      adapter: modelQuery.adapter,
    );
  }
}
