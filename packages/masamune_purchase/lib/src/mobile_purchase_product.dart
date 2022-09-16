part of masamune_purchase;

/// Define the billing item.
///
/// Pass this object to [PurchaseCore.initialize()] to
/// get the billing item details from the server.
///
/// By defining [onDeliver], processing at the time of billing can be added.
// ignore: must_be_immutable
@immutable
class MobilePurchaseProduct extends PurchaseProduct {
  /// Define the billing item.
  ///
  /// Pass this object to [PurchaseCore.initialize()] to
  /// get the billing item details from the server.
  ///
  /// By defining [onDeliver], processing at the time of billing can be added.
  const MobilePurchaseProduct({
    required String id,
    ProductType type = ProductType.consumable,
    double value = 0,
    String? target,
    String? defaultName,
    String? defaultText,
    double defaultPrice = 0.0,
    this.subscriptionData,
    this.isRestoreTransaction,
    this.onDeliver,
  }) : super(
          id: id,
          type: type,
          value: value,
          target: target,
          name: defaultName,
          text: defaultText,
          price: defaultPrice,
        );

  MobilePurchaseProduct.from(
    PurchaseProduct product, {
    Future<DynamicMap?> Function(PurchaseDetails purchase, PurchaseModel core)?
        subscriptionData,
    Future<bool> Function(
      PurchaseDetails purchase,
      bool Function(DynamicMap document) subscriptionChecker,
    )?
        isRestoreTransaction,
    Future<void> Function(
      PurchaseDetails purchase,
      PurchaseProduct product,
      PurchaseModel core,
    )?
        onDeliver,
  }) : this(
          id: product.id,
          type: product.type,
          value: product.value,
          target: product.target,
          defaultName: product.name,
          defaultText: product.text,
          defaultPrice: product.price,
          subscriptionData: subscriptionData,
          isRestoreTransaction: isRestoreTransaction,
          onDeliver: onDeliver,
        );

  /// Callback to restore billing.
  ///
  /// True to restore billing.
  ///
  /// [subscriptionChecker] stores the callback that checks by passing the document for subscription.
  final Future<bool> Function(
    PurchaseDetails purchase,
    bool Function(DynamicMap document) subscriptionChecker,
  )? isRestoreTransaction;

  /// Callback for delivering billing items.
  final Future<void> Function(
    PurchaseDetails purchase,
    PurchaseProduct product,
    PurchaseModel core,
  )? onDeliver;

  /// Get the data to be added at the time of subscription.
  final Future<DynamicMap?> Function(
    PurchaseDetails purchase,
    PurchaseModel core,
  )? subscriptionData;

  ProductDetails? get _productDetails {
    return PurchaseCore._findByPurchaseProduct(this);
  }

  /// Product Id.
  @override
  String get productId {
    if (_productDetails?.id.isEmpty ?? true) {
      return id;
    }
    return _productDetails!.id;
  }

  /// The name of the item.
  @override
  String get productName {
    if (_productDetails?.title.isEmpty ?? true) {
      return name ?? "";
    }
    return _productDetails!.title;
  }

  /// Item description.
  @override
  String get productText {
    if (_productDetails?.description.isEmpty ?? true) {
      return text ?? "";
    }
    return _productDetails!.description;
  }

  /// The price of the item.
  @override
  String get productPrice {
    if (_productDetails?.price.isEmpty ?? true) {
      return price.toString();
    }
    return _productDetails!.price;
  }

  @override
  ProviderBase<PurchaseProductValueModel> get valueProvider {
    return _mobilePurchaseProductValueModel(this);
  }
}

final _mobilePurchaseProductValueModel = ChangeNotifierProvider.family<
    MobilePurchaseProductValueModel, MobilePurchaseProduct>(
  (_, product) => MobilePurchaseProductValueModel(product),
);

/// A model of PurchaseProduct's real data.
///
/// By listening to this, the change in value can be read.
class MobilePurchaseProductValueModel extends PurchaseProductValueModel {
  MobilePurchaseProductValueModel(MobilePurchaseProduct product)
      : super(product);

  final Map<String, ChangeNotifier> _collectionListener = {};
  final Map<String, ChangeNotifier> _documentListener = {};

  @override
  void initState() {
    super.initState();
    final core = PurchaseCore._purchase;
    switch (product.type) {
      case ProductType.consumable:
        value = true;
        break;
      case ProductType.nonConsumable:
        if (product.target.isEmpty) {
          return;
        }
        final documentPath = product.target!.parentPath();
        if (documentPath.isEmpty) {
          return;
        }
        final _doc = readProvider(
          core.context.model!.documentProvider(
            documentPath,
            disposable: false,
          ),
        )..fetch();
        _documentListener[documentPath] = _doc;
        break;
      case ProductType.subscription:
        final options = core.subscribeOptions;
        final userId = core.userId;
        if (userId.isEmpty) {
          return;
        }
        final _col = readProvider(
          core.context.model!.collectionProvider(
            ModelQuery(
              options.subscriptionCollectionPath,
              key: options.userIDKey,
              isEqualTo: userId,
            ).value,
            disposable: false,
          ),
        )..fetch();
        _collectionListener[options.subscriptionCollectionPath] = _col;
        _col.forEach(
          (_doc) => _documentListener[
              "${options.subscriptionCollectionPath}/${_doc.uid}"] = _doc,
        );
        break;
    }
    _documentListener.values
        .forEach((l) => l.addListener(_handledOnDocumentUpdate));
    _collectionListener.values
        .forEach((l) => l.addListener(_handledOnCollectionUpdate));
  }

  void _handledOnCollectionUpdate() {
    if (_collectionListener.isEmpty) {
      return;
    }
    for (final tmp in _collectionListener.entries) {
      final listener = tmp.value;
      if (listener is! DynamicCollectionModel) {
        continue;
      }
      for (final doc in listener) {
        final path = "${tmp.key}/${doc.uid}";
        if (_documentListener.containsKey(path)) {
          continue;
        }
        doc.addListener(_handledOnDocumentUpdate);
        _documentListener[path] = doc;
      }
    }
    _handledOnDocumentUpdate();
  }

  void _handledOnDocumentUpdate() {
    if (_documentListener.isEmpty) {
      return;
    }
    final core = PurchaseCore._purchase;
    switch (product.type) {
      case ProductType.consumable:
        value = true;
        break;
      case ProductType.nonConsumable:
        if (product.target.isEmpty) {
          return;
        }
        final documentPath = product.target!.parentPath();
        final listener = _documentListener[documentPath];
        if (listener is! DynamicDocumentModel) {
          return;
        }

        final key = product.target!.last();
        if (key.isEmpty) {
          return;
        }
        value = listener.get(key, false);
        break;
      case ProductType.subscription:
        final userId = core.userId;
        final options = core.subscribeOptions;
        final listener =
            _collectionListener[options.subscriptionCollectionPath];
        if (userId.isEmpty || listener is! DynamicCollectionModel) {
          return;
        }
        value = listener.any((data) {
          return core._subscriptionCheckerOnCheckingEnabled(product.id, data);
        });
        break;
    }
  }

  /// Check out if non-consumption items and subscriptions are valid.
  ///
  /// If true, billing is enabled.
  @override
  bool get enabled => value;

  @override
  Future<void>? get loading async {
    await wait([
      ..._documentListener.values.mapAndRemoveEmpty((listener) {
        if (listener is DynamicDocumentModel) {
          return listener.loading;
        } else if (listener is DynamicCollectionModel) {
          return listener.loading;
        }
        return null;
      }),
      ..._collectionListener.values.mapAndRemoveEmpty((listener) {
        if (listener is DynamicDocumentModel) {
          return listener.loading;
        } else if (listener is DynamicCollectionModel) {
          return listener.loading;
        }
        return null;
      }),
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    _documentListener.values.forEach((l) {
      l.removeListener(_handledOnDocumentUpdate);
      l.dispose();
    });
    _collectionListener.values.forEach((l) {
      l.removeListener(_handledOnCollectionUpdate);
      l.dispose();
    });
    _documentListener.clear();
    _collectionListener.clear();
  }
}
