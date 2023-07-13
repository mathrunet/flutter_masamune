part of masamune_purchase_mobile;

/// Controller for in app purchase.
///
/// Initialization is performed by executing [initialize].
/// If the store side billing setup has not been completed, it will not complete successfully. Please pay attention to the following points while performing the setup.
/// ** Android
/// - Must be set up for store side apps.
/// - The app must be signed and the first build uploaded
/// - Billed items must be set and valid.
///
/// ** IOS
/// - Must be set up for store side apps.
/// - Must have bank account and tax information set up for payments
/// - Billed items must be set and valid.
///
/// If you want to start billing, pass [PurchaseProduct] to [purchase] and execute.
/// [PurchaseProduct] should be obtained through [findProductById] or similar.
///
/// In app purchaseを行うためのコントローラー。
///
/// [initialize]を実行することで初期化を行います。
/// ストア側の課金のセットアップが終わっていない場合は正常に完了しません。以下の点を注意しながらセットアップを行ってください。
/// ** Android
/// - ストア側のアプリの設定を行っていること
/// - アプリの署名を行い最初のビルドをアップロード済みであること
/// - 課金アイテムを設定し有効であること
///
/// ** IOS
/// - ストア側のアプリの設定を行っていること
/// - 支払い用の銀行口座や税務情報をセットアップ済みであること
/// - 課金アイテムを設定し有効であること
///
/// 課金を開始したい場合は[purchase]に[PurchaseProduct]を渡して実行します。
/// [PurchaseProduct]は[findProductById]などを通して取得してください。
class Purchase extends MasamuneControllerBase<void, PurchaseMasamuneAdapter> {
  /// Controller for in app purchase.
  ///
  /// Initialization is performed by executing [initialize].
  /// If the store side billing setup has not been completed, it will not complete successfully. Please pay attention to the following points while performing the setup.
  /// ** Android
  /// - Must be set up for store side apps.
  /// - The app must be signed and the first build uploaded
  /// - Billed items must be set and valid.
  ///
  /// ** IOS
  /// - Must be set up for store side apps.
  /// - Must have bank account and tax information set up for payments
  /// - Billed items must be set and valid.
  ///
  /// If you want to start billing, pass [PurchaseProduct] to [purchase] and execute.
  /// [PurchaseProduct] should be obtained through [findProductById] or similar.
  ///
  /// In app purchaseを行うためのコントローラー。
  ///
  /// [initialize]を実行することで初期化を行います。
  /// ストア側の課金のセットアップが終わっていない場合は正常に完了しません。以下の点を注意しながらセットアップを行ってください。
  /// ** Android
  /// - ストア側のアプリの設定を行っていること
  /// - アプリの署名を行い最初のビルドをアップロード済みであること
  /// - 課金アイテムを設定し有効であること
  ///
  /// ** IOS
  /// - ストア側のアプリの設定を行っていること
  /// - 支払い用の銀行口座や税務情報をセットアップ済みであること
  /// - 課金アイテムを設定し有効であること
  ///
  /// 課金を開始したい場合は[purchase]に[PurchaseProduct]を渡して実行します。
  /// [PurchaseProduct]は[findProductById]などを通して取得してください。
  Purchase();

  /// Query for Purchase.
  ///
  /// ```dart
  /// appRef.conroller(Purchase.query(parameters));   // Get from application scope.
  /// ref.app.conroller(Purchase.query(parameters));  // Watch at application scope.
  /// ref.page.conroller(Purchase.query(parameters)); // Watch at page scope.
  /// ```
  static const query = _$PurchaseQuery();

  @override
  PurchaseMasamuneAdapter get primaryAdapter => PurchaseMasamuneAdapter.primary;

  /// Returns `true` if already initialized.
  ///
  /// すでに初期化されていれば`true`を返します。
  bool get initialized => _initialized;
  bool _initialized = false;

  Completer<void>? _completer;
  // ignore: unused_field
  StreamSubscription? _purchaseUpdateStreamSubscription;

  /// List of valid products.
  ///
  /// 有効なプロダクトの一覧。
  List<PurchaseProduct> get products => _products;
  final List<PurchaseProduct> _products = [];

  /// Initialize InAppPurchase.
  ///
  /// Specify a callback in [onRetrieveUserId] that returns the unique ID of the user.
  ///
  /// InAppPurchaseを初期化します。
  ///
  /// [onRetrieveUserId]にユーザーの一意のIDを返すコールバックを指定してください。
  Future<void> initialize() async {
    if (_initialized) {
      return;
    }
    if (_completer != null) {
      return _completer?.future;
    }
    _completer = Completer<void>();
    try {
      _products.clear();
      _products.addAll(
        await adapter.getProducts(
          onRetrieveUserId: adapter.onRetrieveUserId,
        ),
      );
      for (final product in _products) {
        if (product is Listenable) {
          (product as Listenable).addListener(notifyListeners);
        }
      }
      _purchaseUpdateStreamSubscription = adapter.listenPurchase(
        products: _products,
        onDone: () {
          _completer?.complete();
          _completer = null;
          notifyListeners();
        },
        onDisposed: () {
          _completer?.complete();
          _completer = null;
          dispose();
        },
        onError: (e) {
          _completer?.completeError(e);
          _completer = null;
        },
      );
      await adapter.initialize();
      _initialized = true;
      _completer?.complete();
      _completer = null;
      notifyListeners();
    } catch (e) {
      _completer?.completeError(e);
      _completer = null;
      throw Exception(
        "Purchase completed with error: ${e.toString()}:${StackTrace.current.toString()}",
      );
    } finally {
      _completer?.complete();
      _completer = null;
    }
  }

  /// This function is used to restore billing information when a device is initialized or when a device model is changed.
  ///
  /// Please use this function if you need to install a restore button in IOS, as it is also automatically executed by [INITIALIZE].
  ///
  /// 端末の初期化時や機種変更時などに課金情報を復元する際に実行します。
  ///
  /// [initialize]でも自動実行されるのでIOSでリストアボタンを設置する必要がある場合にご利用ください。
  Future<void> restore() async {
    if (!initialized) {
      throw Exception(
        "It has not been initialized. First, execute [initialize] to initialize.",
      );
    }
    if (_completer != null) {
      return _completer?.future;
    }
    _completer = Completer<void>();
    try {
      await adapter.restore(_products);
      _completer?.complete();
      _completer = null;
      notifyListeners();
    } catch (e) {
      _completer?.completeError(e);
      _completer = null;
      rethrow;
    } finally {
      _completer?.complete();
      _completer = null;
    }
  }

  /// The billing is based on the items in [product].
  ///
  /// [product]のアイテムを元に課金を行います。
  Future<void> purchase(PurchaseProduct product) async {
    if (!initialized) {
      throw Exception(
        "It has not been initialized. First, execute [initialize] to initialize.",
      );
    }
    if (_completer != null) {
      return _completer?.future;
    }
    final found = _products.firstWhereOrNull(
      (p) => p.productId == product.productId,
    );
    if (found == null) {
      throw Exception("Product not found: ${product.productId}");
    }
    _completer = Completer<void>();
    try {
      await adapter.purchase(
        product: found,
        onDone: () {
          _completer?.complete();
          _completer = null;
        },
      );
      await _completer?.future;
      _completer?.complete();
      _completer = null;
      notifyListeners();
    } catch (e) {
      _completer?.completeError(e);
      _completer = null;
      rethrow;
    } finally {
      _completer?.complete();
      _completer = null;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _purchaseUpdateStreamSubscription?.cancel();
    for (final product in _products) {
      if (product is Listenable) {
        (product as Listenable).removeListener(notifyListeners);
      }
      if (product is ChangeNotifier) {
        (product as ChangeNotifier).dispose();
      }
    }
  }

  /// Returns **Internally Managed** [PurchaseProduct] based on the specified [product].
  ///
  /// It is recommended to obtain the internally managed [PurchaseProduct], which is assigned an object that includes monitoring of actual data, etc.
  ///
  /// 指定された[product]を元に**内部で管理している**[PurchaseProduct]を返します。
  ///
  /// 内部で管理している[PurchaseProduct]は実データの監視等も含めたオブジェクトが割り当てられているのでそれを取得することを推奨します。
  PurchaseProduct? findProductByProduct(PurchaseProduct product) {
    return _products
        .firstWhereOrNull((product) => product.productId == product.productId);
  }

  /// Returns Applications Users Volumes cores etc home opt private usr var which is **managed internally** based on [productId].
  ///
  /// [productId]を元に**内部で管理している**[PurchaseProduct]を返します。
  PurchaseProduct? findProductById(String productId) {
    assert(productId.isNotEmpty, "ID is empty.");
    return _products
        .firstWhereOrNull((product) => product.productId == productId);
  }
}

@immutable
class _$PurchaseQuery {
  const _$PurchaseQuery();

  @useResult
  _$_PurchaseQuery call() => _$_PurchaseQuery(
        hashCode.toString(),
      );
}

@immutable
class _$_PurchaseQuery extends ControllerQueryBase<Purchase> {
  const _$_PurchaseQuery(
    this._name,
  );

  final String _name;

  @override
  Purchase Function() call(Ref ref) {
    return () => Purchase();
  }

  @override
  String get name => _name;
  @override
  bool get autoDisposeWhenUnreferenced => false;
}
