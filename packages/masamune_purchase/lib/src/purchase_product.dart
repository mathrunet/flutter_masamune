// ignore_for_file: prefer_initializing_formals

part of '/masamune_purchase.dart';

/// Define chargeable items.
///
/// PurchaseProduct.wallet] to create a wallet type billing item, [PurchaseProduct.unlock] to create a feature unlock type billing item, [PurchaseProduct.subscription] to Create a subscription with [PurchaseProduct.subscription].
///
/// Be sure to match [productId] with the store's ID.
///
/// [price] is overwritten when a charged item is loaded from the store. [title] and [description] can be retrieved from [titleOnStore] and [descriptionOnStore] loaded from the store.
///
/// [expiredPeriod] allows you to specify the duration of the subscription for testing.
///
/// 課金アイテムの定義を行います。
///
/// [PurchaseProduct.wallet]でウォレットタイプの課金アイテムを作成し、[PurchaseProduct.unlock]で機能アンロックタイプの課金アイテムを作成、[PurchaseProduct.subscription]でサブスクリプションを作成します。
///
/// [productId]をストア側のIDと必ず合わせるようにしてください。
///
/// [price]は課金アイテムをストアからロードした際に上書きされます。[title]や[description]は[titleOnStore]や[descriptionOnStore]でストアからロードしたものを取得できます。
///
/// [expiredPeriod]を指定するとテスト用のサブスクリプションの期間を指定することができます。
@immutable
class PurchaseProduct {
  /// Define chargeable items.
  ///
  /// PurchaseProduct.wallet] to create a wallet type billing item, [PurchaseProduct.unlock] to create a feature unlock type billing item, [PurchaseProduct.subscription] to Create a subscription with [PurchaseProduct.subscription].
  ///
  /// Be sure to match [productId] with the store's ID.
  ///
  /// [price] is overwritten when a charged item is loaded from the store. [title] and [description] can be retrieved from [titleOnStore] and [descriptionOnStore] loaded from the store.
  ///
  /// [expiredPeriod] allows you to specify the duration of the subscription for testing.
  ///
  /// 課金アイテムの定義を行います。
  ///
  /// [PurchaseProduct.wallet]でウォレットタイプの課金アイテムを作成し、[PurchaseProduct.unlock]で機能アンロックタイプの課金アイテムを作成、[PurchaseProduct.subscription]でサブスクリプションを作成します。
  ///
  /// [productId]をストア側のIDと必ず合わせるようにしてください。
  ///
  /// [price]は課金アイテムをストアからロードした際に上書きされます。[title]や[description]は[titleOnStore]や[descriptionOnStore]でストアからロードしたものを取得できます。
  ///
  /// [expiredPeriod]を指定するとテスト用のサブスクリプションの期間を指定することができます。
  const PurchaseProduct({
    required this.productId,
    required this.type,
    this.amount,
    String title = "",
    String description = "",
    this.icon,
    required this.price,
    this.expiredPeriod,
    this.subscriptionPeriod = PurchaseSubscriptionPeriod.none,
    String? priceText,
    bool debugConsumeWhenPurchaseCompleted = false,
  })  : _priceText = priceText,
        _title = title,
        _description = description,
        _debugConsumeWhenPurchaseCompleted = debugConsumeWhenPurchaseCompleted,
        assert(
          type != PurchaseProductType.consumable || amount != null,
          "The amount of wallet money (gems) you add when you purchase a charged item is not set.",
        );

  /// Define chargeable items.
  ///
  /// PurchaseProduct.wallet] to create a wallet type billing item, [PurchaseProduct.unlock] to create a feature unlock type billing item, [PurchaseProduct.subscription] to Create a subscription with [PurchaseProduct.subscription].
  ///
  /// Be sure to match [productId] with the store's ID.
  ///
  /// [price] is overwritten when a charged item is loaded from the store. [title] and [description] can be retrieved from [titleOnStore] and [descriptionOnStore] loaded from the store.
  ///
  /// 課金アイテムの定義を行います。
  ///
  /// [PurchaseProduct.wallet]でウォレットタイプの課金アイテムを作成し、[PurchaseProduct.unlock]で機能アンロックタイプの課金アイテムを作成、[PurchaseProduct.subscription]でサブスクリプションを作成します。
  ///
  /// [productId]をストア側のIDと必ず合わせるようにしてください。
  ///
  /// [price]は課金アイテムをストアからロードした際に上書きされます。[title]や[description]は[titleOnStore]や[descriptionOnStore]でストアからロードしたものを取得できます。
  const PurchaseProduct.wallet({
    required this.productId,
    required double amount,
    String title = "",
    String description = "",
    this.icon,
    required this.price,
    String? priceText,
  })  : type = PurchaseProductType.consumable,
        subscriptionPeriod = PurchaseSubscriptionPeriod.none,
        expiredPeriod = null,
        _priceText = priceText,
        amount = amount,
        _title = title,
        _description = description,
        _debugConsumeWhenPurchaseCompleted = false;

  /// Define chargeable items.
  ///
  /// PurchaseProduct.wallet] to create a wallet type billing item, [PurchaseProduct.unlock] to create a feature unlock type billing item, [PurchaseProduct.subscription] to Create a subscription with [PurchaseProduct.subscription].
  ///
  /// Be sure to match [productId] with the store's ID.
  ///
  /// [price] is overwritten when a charged item is loaded from the store. [title] and [description] can be retrieved from [titleOnStore] and [descriptionOnStore] loaded from the store.
  ///
  /// 課金アイテムの定義を行います。
  ///
  /// [PurchaseProduct.wallet]でウォレットタイプの課金アイテムを作成し、[PurchaseProduct.unlock]で機能アンロックタイプの課金アイテムを作成、[PurchaseProduct.subscription]でサブスクリプションを作成します。
  ///
  /// [productId]をストア側のIDと必ず合わせるようにしてください。
  ///
  /// [price]は課金アイテムをストアからロードした際に上書きされます。[title]や[description]は[titleOnStore]や[descriptionOnStore]でストアからロードしたものを取得できます。
  const PurchaseProduct.unlock({
    required this.productId,
    String title = "",
    String description = "",
    this.icon,
    required this.price,
    String? priceText,
    bool debugConsumeWhenPurchaseCompleted = false,
  })  : type = PurchaseProductType.nonConsumable,
        subscriptionPeriod = PurchaseSubscriptionPeriod.none,
        amount = null,
        expiredPeriod = null,
        _priceText = priceText,
        _title = title,
        _description = description,
        _debugConsumeWhenPurchaseCompleted = debugConsumeWhenPurchaseCompleted;

  /// Define chargeable items.
  ///
  /// PurchaseProduct.wallet] to create a wallet type billing item, [PurchaseProduct.unlock] to create a feature unlock type billing item, [PurchaseProduct.subscription] to Create a subscription with [PurchaseProduct.subscription].
  ///
  /// Be sure to match [productId] with the store's ID.
  ///
  /// [price] is overwritten when a charged item is loaded from the store. [title] and [description] can be retrieved from [titleOnStore] and [descriptionOnStore] loaded from the store.
  ///
  /// [expiredPeriod] allows you to specify the duration of the subscription for testing.
  ///
  /// 課金アイテムの定義を行います。
  ///
  /// [PurchaseProduct.wallet]でウォレットタイプの課金アイテムを作成し、[PurchaseProduct.unlock]で機能アンロックタイプの課金アイテムを作成、[PurchaseProduct.subscription]でサブスクリプションを作成します。
  ///
  /// [productId]をストア側のIDと必ず合わせるようにしてください。
  ///
  /// [price]は課金アイテムをストアからロードした際に上書きされます。[title]や[description]は[titleOnStore]や[descriptionOnStore]でストアからロードしたものを取得できます。
  ///
  /// [expiredPeriod]を指定するとテスト用のサブスクリプションの期間を指定することができます。
  const PurchaseProduct.subscription({
    required this.productId,
    String title = "",
    String description = "",
    required this.price,
    this.icon,
    required Duration expiredPeriod,
    String? priceText,
    this.subscriptionPeriod = PurchaseSubscriptionPeriod.month,
  })  : type = PurchaseProductType.subscription,
        amount = null,
        expiredPeriod = expiredPeriod,
        _priceText = priceText,
        _title = title,
        _description = description,
        _debugConsumeWhenPurchaseCompleted = false;

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

  /// Title of the charged item (as loaded from the store).
  ///
  /// 課金アイテムのタイトル（ストアから読み込まれたもの）。
  String get titleOnStore => _title;

  /// Title of the charged item (as set up).
  ///
  /// 課金アイテムのタイトル（設定したもの）。
  String get title => _title;

  final String _title;

  /// Description of the charged items (tentative).
  ///
  /// 課金アイテムの説明（仮）。
  String get descriptionOnStore => _description;

  /// Description of the charged items (as set up).
  ///
  /// 課金アイテムの説明（設定したもの）。
  String get description => _description;

  final String _description;

  /// Icons of charged items.
  ///
  /// 課金アイテムのアイコン。
  final Widget? icon;

  /// Price of items charged (tentative).
  ///
  /// 課金アイテムの値段（仮）。
  final double price;

  /// Period of validity.
  ///
  /// 有効期限の期間。
  final Duration? expiredPeriod;

  /// Subscription expiration period.
  ///
  /// サブスクリプションの有効期限の期間。
  final PurchaseSubscriptionPeriod? subscriptionPeriod;

  /// Text with the currency mark of the item charged.
  ///
  /// 課金アイテムの通貨マークを付与したテキスト。
  String get priceText => _priceText ?? price.toString();
  final String? _priceText;

  /// If [type] is [PurchaseProductType.nonConsumable], returns `true` if the product is automatically consumed when the purchase is completed.
  ///
  /// Please use for debugging purposes.
  ///
  /// [type]が[PurchaseProductType.nonConsumable]の場合、購入完了時に自動的に消費する場合`true`を返します。
  ///
  /// デバッグ用でご利用ください。
  bool get debugConsumeWhenPurchaseCompleted =>
      _debugConsumeWhenPurchaseCompleted;
  final bool _debugConsumeWhenPurchaseCompleted;

  /// List of sub-billed items included in this billed item.
  ///
  /// この課金アイテムに含まれるサブ課金アイテムのリスト。
  List<PurchaseProduct> get subProducts => [];

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

  /// Reloads real data from the database. Execute when you want to update data that has already been loaded.
  ///
  /// If [PurchaseProduct] is not obtained from [Purchase], nothing will happen.
  /// Get [PurchaseProduct] from [Purchase.findProductById], etc.
  ///
  /// 実データをデータベースからリロードします。すでに読み込まれたデータを更新したい場合に実行してください。
  ///
  /// [Purchase]から[PurchaseProduct]が取得されていない場合は何も起きません。
  /// [Purchase.findProductById]などから[PurchaseProduct]を取得してください。
  Future<void> reload() {
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
      price.hashCode ^
      expiredPeriod.hashCode ^
      subscriptionPeriod.hashCode;

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
    required this.onRetrieveDocument,
    required this.onRetrieveValue,
    required this.onSaveDocument,
    this.adapter,
  })  : assert(
          product.type == PurchaseProductType.consumable,
          "[product] does not match [PurchaseProductType.consumable].",
        ),
        super(
          productId: product.productId,
          priceText: product._priceText,
          title: product.title,
          description: product.description,
          price: product.price,
          icon: product.icon,
          amount: product.amount,
          expiredPeriod: product.expiredPeriod,
          debugConsumeWhenPurchaseCompleted:
              product.debugConsumeWhenPurchaseCompleted,
          type: PurchaseProductType.consumable,
        ) {
    _updateDocument();
  }

  /// Callback to obtain user ID.
  ///
  /// ユーザーIDを取得するためのコールバック。
  final String? Function() onRetrieveUserId;

  /// Callback to retrieve the document.
  ///
  /// ドキュメントを取得するためのコールバック。
  final DocumentBase? Function(PurchaseProduct product, String userId)
      onRetrieveDocument;

  /// Callback to retrieve the value.
  ///
  /// 値を取得するためのコールバック。
  final double Function(
          DocumentBase? document, PurchaseProduct product, String userId)
      onRetrieveValue;

  /// Callback to save the document.
  ///
  /// ドキュメントを保存するためのコールバック。
  final Future<void> Function(
          DocumentBase? document, PurchaseProduct product, String userId)
      onSaveDocument;

  /// Default document retrieval method.
  ///
  /// デフォルトのドキュメント取得方法。
  static DocumentBase? defaultOnRetrieveDocument(
      PurchaseProduct product, String userId) {
    return _DynamicPurchaseUserDocumentModel(
      userId,
    );
  }

  /// Default value retrieval method.
  ///
  /// デフォルトの値取得方法。
  static double defaultOnRetrieveValue(
      DocumentBase? document, PurchaseProduct product, String userId) {
    return document?.value?[kConsumableValueKey] ?? 0.0;
  }

  /// Default document saving method.
  ///
  /// デフォルトのドキュメント保存方法。
  static Future<void> defaultOnSaveDocument(
      DocumentBase? document, PurchaseProduct product, String userId) async {
    await document?.save({
      kConsumableValueKey: (document.value?[kConsumableValueKey] ?? 0.0) +
          (product.amount ?? 0.0),
    });
  }

  /// Adapters for models.
  ///
  /// モデル用のアダプター。
  final ModelAdapter? adapter;

  /// User ID.
  ///
  /// ユーザーID。
  String get userId => _userId;
  String _userId = "";

  DocumentBase? _document;

  @override
  Future<void> load() async {
    _updateDocument();
    await _document?.load();
  }

  @override
  Future<void> reload() async {
    _updateDocument();
    await _document?.reload();
  }

  Future<void> _purchaseForRuntime() async {
    await _document?.reload();
    await onSaveDocument.call(_document, this, _userId);
  }

  @override
  PurchaseProductValue? get value {
    return PurchaseProductValue(
      amount: onRetrieveValue.call(_document, this, _userId),
    );
  }

  void _updateDocument() {
    final updated = onRetrieveUserId();
    if (updated.isNotEmpty && _userId != updated) {
      _userId = updated!;
      _document?.removeListener(notifyListeners);
      _document?.dispose();
      _document = onRetrieveDocument.call(this, _userId);
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
    required this.onRetrieveDocument,
    required this.onRetrieveValue,
    required this.onSaveDocument,
    this.adapter,
  })  : assert(
          product.type == PurchaseProductType.nonConsumable,
          "[product] does not match [PurchaseProductType.nonConsumable].",
        ),
        super(
          productId: product.productId,
          priceText: product._priceText,
          title: product.title,
          description: product.description,
          icon: product.icon,
          price: product.price,
          expiredPeriod: product.expiredPeriod,
          debugConsumeWhenPurchaseCompleted:
              product.debugConsumeWhenPurchaseCompleted,
          type: PurchaseProductType.nonConsumable,
        ) {
    _updateDocument();
  }

  /// Callback to obtain user ID.
  ///
  /// ユーザーIDを取得するためのコールバック。
  final String? Function() onRetrieveUserId;

  /// Callback to retrieve the document.
  ///
  /// ドキュメントを取得するためのコールバック。
  final DocumentBase? Function(PurchaseProduct product, String userId)
      onRetrieveDocument;

  /// Callback to retrieve the value.
  ///
  /// 値を取得するためのコールバック。
  final bool Function(
          DocumentBase? document, PurchaseProduct product, String userId)
      onRetrieveValue;

  /// Callback to save the document.
  ///
  /// ドキュメントを保存するためのコールバック。
  final Future<void> Function(
          DocumentBase? document, PurchaseProduct product, String userId)
      onSaveDocument;

  /// Default document retrieval method.
  ///
  /// デフォルトのドキュメント取得方法。
  static DocumentBase? defaultOnRetrieveDocument(
      PurchaseProduct product, String userId) {
    return _DynamicPurchaseUserDocumentModel(
      userId,
    );
  }

  /// Default value retrieval method.
  ///
  /// デフォルトの値取得方法。
  static bool defaultOnRetrieveValue(
      DocumentBase? document, PurchaseProduct product, String userId) {
    return document?.value?[product.productId.toCamelCase()] ?? false;
  }

  /// Default document saving method.
  ///
  /// デフォルトのドキュメント保存方法。
  static Future<void> defaultOnSaveDocument(
      DocumentBase? document, PurchaseProduct product, String userId) async {
    await document?.save({
      product.productId.toCamelCase(): true,
    });
  }

  /// Adapters for models.
  ///
  /// モデル用のアダプター。
  final ModelAdapter? adapter;

  /// User ID.
  ///
  /// ユーザーID。
  String get userId => _userId;
  String _userId = "";

  DocumentBase? _document;

  @override
  Future<void> load() async {
    _updateDocument();
    await _document?.load();
  }

  @override
  Future<void> reload() async {
    _updateDocument();
    await _document?.reload();
  }

  Future<void> _purchaseForRuntime() async {
    await _document?.reload();
    await onSaveDocument.call(_document, this, _userId);
  }

  @override
  PurchaseProductValue? get value {
    return PurchaseProductValue(
      active: onRetrieveValue.call(_document, this, _userId),
    );
  }

  void _updateDocument() {
    final updated = onRetrieveUserId();
    if (updated.isNotEmpty && _userId != updated) {
      _userId = updated!;
      _document?.removeListener(notifyListeners);
      _document?.dispose();
      _document = onRetrieveDocument.call(this, _userId);
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
    required this.onRetrieveCollection,
    required this.onRetrieveValue,
    required this.onSaveDocument,
    required this.onRevokeDocument,
    this.adapter,
  })  : assert(
          product.type == PurchaseProductType.subscription,
          "[product] does not match [PurchaseProductType.subscription].",
        ),
        super(
          productId: product.productId,
          priceText: product._priceText,
          title: product.title,
          description: product.description,
          icon: product.icon,
          price: product.price,
          expiredPeriod: product.expiredPeriod,
          debugConsumeWhenPurchaseCompleted:
              product.debugConsumeWhenPurchaseCompleted,
          type: PurchaseProductType.subscription,
          subscriptionPeriod: product.subscriptionPeriod,
        ) {
    _updateCollection();
  }

  /// Callback to retrieve user ID. Return [Null] if the user is not logged in.
  ///
  /// ユーザーIDを取得するためのコールバック。ログインしていない場合は[Null]を返してください。
  final String? Function() onRetrieveUserId;

  /// Callback to retrieve the collection.
  ///
  /// コレクションを取得するためのコールバック。
  final CollectionBase? Function(PurchaseProduct product, String userId)
      onRetrieveCollection;

  /// Callback to retrieve the value.
  ///
  /// 値を取得するためのコールバック。
  final bool Function(
          CollectionBase? collection, PurchaseProduct product, String userId)
      onRetrieveValue;

  /// Callback to save the document.
  ///
  /// ドキュメントを保存するためのコールバック。
  final Future<void> Function(
    DocumentBase? document,
    PurchaseProduct product,
    String userId,
    String orderId,
    DateTime expiredTime,
  ) onSaveDocument;

  /// Callback to revoke the document.
  ///
  /// ドキュメントを削除するためのコールバック。
  final Future<void> Function(
    DocumentBase? document,
    PurchaseProduct product,
    String userId,
  ) onRevokeDocument;

  /// Default collection retrieval method.
  ///
  /// デフォルトのコレクション取得方法。
  static CollectionBase? defaultOnRetrieveCollection(
      PurchaseProduct product, String userId) {
    return _DynamicPurchaseSubscriptionCollectionModel(
      userId: userId,
    );
  }

  /// Default value retrieval method.
  ///
  /// デフォルトの値取得方法。
  static bool defaultOnRetrieveValue(
      CollectionBase? collection, PurchaseProduct product, String userId) {
    return collection
            ?.where((e) => (e.value?[kProductIdKey] ?? "") == product.productId)
            .any(
              (e) => !(e.value?[kSubscriptionExpiredKey] ?? true),
            ) ??
        false;
  }

  /// Default document saving method.
  ///
  /// デフォルトのドキュメント保存方法。
  static Future<void> defaultOnSaveDocument(
    DocumentBase? document,
    PurchaseProduct product,
    String userId,
    String orderId,
    DateTime expiredTime,
  ) async {
    final now = DateTime.now();
    await document?.save(
      PurchaseSubscriptionModel(
        userId: userId,
        orderId: orderId,
        productId: product.productId,
        expired: now.isAfter(expiredTime),
        expiredTime: expiredTime.millisecondsSinceEpoch,
      ).toJson(),
    );
  }

  /// Default document revoking method.
  ///
  /// デフォルトのドキュメント削除方法。
  static Future<void> defaultOnRevokeDocument(
    DocumentBase? document,
    PurchaseProduct product,
    String userId,
  ) async {
    await document?.save({
      "expired": false,
      "expiredTime": DateTime.now().millisecondsSinceEpoch,
    });
  }

  /// Adapters for models.
  ///
  /// モデル用のアダプター。
  final ModelAdapter? adapter;

  /// User ID.
  ///
  /// ユーザーID。
  String get userId => _userId;
  String _userId = "";

  CollectionBase? _collection;

  @override
  Future<void> load() async {
    _updateCollection();
    await _collection?.load();
  }

  @override
  Future<void> reload() async {
    _updateCollection();
    await _collection?.reload();
  }

  Future<void> _purchaseForRuntime({
    required String orderId,
    PurchaseProduct? replacedProduct,
  }) async {
    assert(expiredPeriod != null, "[expiredPeriod] is not set.");
    await _collection?.reload();
    await _revokeForRuntime(replacedProduct: replacedProduct);
    final now = DateTime.now();
    final expiredTime = now.add(expiredPeriod!);
    final doc = _collection?.create();
    await onSaveDocument.call(doc, this, _userId, orderId, expiredTime);
  }

  Future<void> _revokeForRuntime({
    PurchaseProduct? replacedProduct,
  }) async {
    if (replacedProduct == null) {
      return;
    }
    assert(expiredPeriod != null, "[expiredPeriod] is not set.");
    await _collection?.reload();
    final targets = _collection?.where((element) =>
        (element.value?[kSubscriptionExpiredKey] ?? false) &&
        (element.value?[kProductIdKey] ?? "") == productId);
    if (targets.isEmpty) {
      return;
    }
    await wait(
      targets?.map(
            (e) => onRevokeDocument.call(e, this, _userId),
          ) ??
          [],
    );
  }

  @override
  PurchaseProductValue? get value {
    return PurchaseProductValue(
      active: onRetrieveValue.call(_collection, this, _userId),
    );
  }

  void _updateCollection() {
    final updated = onRetrieveUserId();
    if (updated.isNotEmpty && _userId != updated) {
      _userId = updated!;
      _collection?.removeListener(notifyListeners);
      _collection?.dispose();
      _collection = onRetrieveCollection.call(this, _userId);

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
              .userId
              .equal(userId)
              .modelQuery,
        );

  @override
  _DynamicPurchaseSubscriptionDocumentModel create([String? id]) {
    return _DynamicPurchaseSubscriptionDocumentModel(
      id ?? uuid(),
      adapter: modelQuery.adapter,
    );
  }
}
