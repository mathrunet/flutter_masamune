// ignore_for_file: unused_element

part of masamune_purchase;

final purchaseModelProvider = ChangeNotifierProvider((_) => PurchaseModel());

class PurchaseModel extends ValueModel<List<MobilePurchaseProduct>> {
  PurchaseModel() : super([]);

  Completer<void>? _purchaseCompleter;

  @override
  bool get notifyOnChangeValue => false;

  BuildContext get context => _navigator.context;
  late final NavigatorState _navigator;
  final Map<String, ProductDetails> _productDetailsList = {};

  /// Class for managing billing process.
  ///
  /// Initialize by first executing [initialize()].
  ///
  /// Then purchasing item by executing [purchase()].
  Future<PurchaseModel> initialize(
    BuildContext context, {
    required List<MobilePurchaseProduct> products,
    Future<bool> Function()? onPrepare,
    Future<bool> Function(
      PurchaseDetails purchase,
      MobilePurchaseProduct product,
      PurchaseModel core,
    )?
        onVerify,
    Future<void> Function(
      PurchaseDetails purchase,
      MobilePurchaseProduct product,
      PurchaseModel core,
    )?
        onSubscribe,
    Future<void> Function(
      PurchaseDetails purchase,
      MobilePurchaseProduct product,
      PurchaseModel core,
    )?
        onUnlock,
    Future<void> Function(
      PurchaseDetails purchase,
      MobilePurchaseProduct product,
      PurchaseModel core,
    )?
        onDeliver,
    Future<void> Function(PurchaseModel core)? onCheckSubscription,
    SubscribeOptions subscribeOptions = const SubscribeOptions(),
    Duration timeout = const Duration(seconds: 30),
    bool autoConsumeOnAndroid = true,
    String? androidRefreshToken,
    String? userId,
    String? serverPrefix,
    AndroidVerifierOptions androidVerifierOptions =
        const AndroidVerifierOptions(),
    IOSVerifierOptions iosVerifierOptions = const IOSVerifierOptions(),
    DeliverOptions deliverOptions = const DeliverOptions(),
  }) async {
    if (isInitialized) {
      return this;
    }
    assert(products.isNotEmpty, "The products is empty.");
    _navigator = Navigator.of(context, rootNavigator: true);
    _onVerify = onVerify ?? NonePurchaseDelegate.verify;
    _onDeliver = onDeliver;
    _onSubscribe = onSubscribe;
    _onUnlock = onUnlock;
    _onCheckSubscription = onCheckSubscription;
    _autoConsumeOnAndroid = autoConsumeOnAndroid;
    this.userId = userId ?? "";
    this.androidRefreshToken = androidRefreshToken ?? "";
    this.serverPrefix = serverPrefix ?? "";
    this.subscribeOptions = subscribeOptions;
    this.iosVerifierOptions = iosVerifierOptions;
    this.androidVerifierOptions = androidVerifierOptions;
    value = products.map((e) => MobilePurchaseProduct.from(e)).toList();
    await _initializeProcess(timeout, onPrepare);
    return this;
  }

  Future<void> _initializeProcess(
    Duration timeout,
    Future<bool> Function()? onPrepare,
  ) async {
    try {
      if (onPrepare != null) {
        if (!await onPrepare()) {
          throw Exception("Preparation failed.");
        }
      }
      final isAvailable = await connection.isAvailable().timeout(timeout);
      assert(isAvailable, "Billing function is not supported.");
      final productDetailResponse = await connection
          .queryProductDetails(
            value.mapAndRemoveEmpty((element) => element.productId).toSet(),
          )
          .timeout(timeout);
      if (productDetailResponse.error != null) {
        throw Exception(
          "Error occurred loading the product: "
          "${productDetailResponse.error?.message}",
        );
      }
      if (productDetailResponse.productDetails.isEmpty) {
        debugPrint("The product is empty.");
        return;
      }
      for (final tmp in productDetailResponse.productDetails) {
        final found = value.firstWhereOrNull((product) => product.id == tmp.id);
        if (found == null) {
          continue;
        }
        _productDetailsList[found.id] = tmp;
        debugPrint("Adding Product: ${tmp.title} (${tmp.id})");
      }
      _purchaseUpdateStreamSubscription = connection.purchaseStream.listen(
        (purchaseDetailsList) async {
          try {
            var done = false;
            for (final purchase in purchaseDetailsList) {
              try {
                final product = findByPurchase(purchase);
                if (product == null) {
                  throw Exception("Product not found.");
                }
                if (purchase.status != PurchaseStatus.pending) {
                  if (purchase.status == PurchaseStatus.error) {
                    if (purchase.pendingCompletePurchase) {
                      await connection.completePurchase(purchase);
                    }
                    throw Exception(
                      "Purchase completed with error: ${purchase.productID}",
                    );
                  } else if (purchase.status == PurchaseStatus.purchased) {
                    if (_onVerify != null &&
                        await _onVerify!.call(purchase, product, this)) {
                      switch (product.type) {
                        case ProductType.consumable:
                          await _onDeliver?.call(purchase, product, this);
                          break;
                        case ProductType.nonConsumable:
                          await _onUnlock?.call(purchase, product, this);
                          break;
                        case ProductType.subscription:
                          await _onSubscribe?.call(purchase, product, this);
                          break;
                      }
                    }
                  } else if (purchase.status == PurchaseStatus.restored) {
                    if (product.type != ProductType.consumable) {
                      if (_onVerify != null &&
                          await _onVerify!.call(purchase, product, this)) {
                        switch (product.type) {
                          case ProductType.nonConsumable:
                            await _onUnlock?.call(purchase, product, this);
                            break;
                          case ProductType.subscription:
                            await _onSubscribe?.call(purchase, product, this);
                            break;
                          default:
                            break;
                        }
                      }
                    } else {
                      throw Exception(
                        "There is no method for purchase. Set up a method for purchasing.",
                      );
                    }
                  } else if (purchase.status == PurchaseStatus.canceled) {
                    throw Exception("Your purchase has been canceled.");
                  }
                  if (Config.isAndroid) {
                    if (!_autoConsumeOnAndroid &&
                        product.type == ProductType.consumable) {
                      final platform = connection.getPlatformAddition<
                          InAppPurchaseAndroidPlatformAddition>();
                      await platform.consumePurchase(purchase);
                    }
                  }
                  if (purchase.pendingCompletePurchase) {
                    debugPrint("Purchase completed: ${purchase.productID}");
                    await connection.completePurchase(purchase);
                  }
                  done = true;
                }
              } catch (e) {
                if (purchase.pendingCompletePurchase) {
                  debugPrint("Purchase completed: ${purchase.productID}");
                  await connection.completePurchase(purchase);
                }
                rethrow;
              }
            }
            if (done) {
              _purchaseCompleter?.complete();
              _purchaseCompleter = null;
              notifyListeners();
            }
          } catch (e) {
            _purchaseCompleter?.completeError(e);
            _purchaseCompleter = null;
            rethrow;
          }
        },
        onDone: () {
          _purchaseCompleter?.complete();
          _purchaseCompleter = null;
          dispose();
        },
        onError: (error) {
          _purchaseCompleter?.completeError(error);
          _purchaseCompleter = null;
          throw Exception(error.toString());
        },
      );
      await _onCheckSubscription?.call(this);
      if (Config.isIOS) {
        final paymentWrapper = SKPaymentQueueWrapper();
        final transactions = await paymentWrapper.transactions();
        for (final transaction in transactions) {
          try {
            await paymentWrapper.finishTransaction(transaction);
          } catch (e) {
            debugPrint(e.toString());
          }
        }
      }
      _isInitialized = true;
    } catch (e) {
      rethrow;
    }
  }

  /// Restore purchase.
  ///
  /// Please use it manually or immediately after user registration.
  ///
  /// [timeout]: Timeout settings.
  Future<PurchaseModel> restore({
    Duration timeout = const Duration(seconds: 30),
  }) async {
    if (!isInitialized) {
      debugPrint(
        "It has not been initialized. First, execute [initialize] to initialize.",
      );
      return this;
    }
    await _restoreProcess(timeout);
    return this;
  }

  Future<void> _restoreProcess(Duration timeout) async {
    try {
      await connection.restorePurchases();
      _isRestored = true;
      notifyListeners();

      //   final purchaseResponse =
      //       .timeout(timeout);
      //   if (purchaseResponse.error != null) {
      //     throw Exception(
      //         "Failed to load past purchases: ${purchaseResponse.error?.message}");
      //   }
      //   await Future.forEach<PurchaseDetails>(purchaseResponse.pastPurchases,
      //       (purchase) async {
      //     final product = findByPurchase(purchase);
      //     if (product == null || purchase.purchaseID.isEmpty) {
      //       return;
      //     }
      //     if (purchase.status == PurchaseStatus.pending ||
      //         product.type == ProductType.consumable ||
      //         product.isRestoreTransaction == null ||
      //         (subscribeOptions.purchaseIDKey.isNotEmpty &&
      //             !await product.isRestoreTransaction!.call(
      //               purchase,
      //               (document) => _subscriptionCheckerOnPurchase(
      //                   purchase.purchaseID!, document),
      //             ))) {
      //       return;
      //     }
      //     debugPrint(
      //         "Restore transaction: ${purchase.productID}/${purchase.purchaseID}");
      //     if (_onVerify != null &&
      //         !await _onVerify!.call(purchase, product, this).timeout(timeout)) {
      //       return;
      //     }
      //     switch (product.type) {
      //       case ProductType.consumable:
      //         await _onDeliver?.call(purchase, product, this);
      //         break;
      //       case ProductType.nonConsumable:
      //         await _onUnlock?.call(purchase, product, this);
      //         break;
      //       case ProductType.subscription:
      //         await _onSubscribe?.call(purchase, product, this);
      //         break;
      //     }
      //     debugPrint("Restored transaction: ${purchase.productID}");
      //   });
      //   _isRestored = true;
      //   notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /// Consume all purchased items.
  ///
  /// Please use it manually or immediately after user registration.
  Future<PurchaseModel> consume({
    required MobilePurchaseProduct product,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    if (!isInitialized) {
      debugPrint(
        "It has not been initialized. First, execute [initialize] to initialize.",
      );
      return this;
    }
    await _consumeProcess(product.id, timeout);
    return this;
  }

  Future<void> _consumeProcess(String productId, Duration timeout) async {
    try {
      await connection.restorePurchases();
      // _isRestored = true;
      // notifyListeners();
      // final purchaseResponse =
      //     await connection.queryProductDetails(identifiers).queryPastPurchases().timeout(timeout);
      // if (purchaseResponse.error != null) {
      //   throw Exception(
      //       "Failed to load past purchases: ${purchaseResponse.error?.message}");
      // }
      // for (final purchase in purchaseResponse.pastPurchases) {
      //   final product = findByPurchase(purchase);
      //   if (product == null) {
      //     continue;
      //   }
      //   if (product.type == ProductType.consumable) {
      //     continue;
      //   }
      //   if (productId.isNotEmpty && product.id != productId) {
      //     continue;
      //   }
      //   await connection.consumePurchase(purchase);
      //   debugPrint(
      //       "Consumed transaction: ${purchase.productID}/${purchase.purchaseID}");
      // }
      // notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  /// Process the purchase.
  ///
  /// You specify the product data in [product], the billing process will start.
  Future<PurchaseModel> purchase(
    MobilePurchaseProduct product, {
    String? userId,
    bool sandboxTesting = false,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    if (!isInitialized) {
      debugPrint(
        "It has not been initialized. First, execute [initialize] to initialize.",
      );
      return this;
    }
    final id = product.id;
    assert(id.isNotEmpty, "The id is empty.");
    final found = value.firstWhereOrNull((product) => product.id == id);
    if (found == null || found._productDetails == null) {
      throw Exception("Product not found: $id");
    }
    if (userId.isNotEmpty) {
      this.userId = userId!;
    }
    assert(this.userId.isNotEmpty, "The user is empty.");
    await _purchaseProcess(
      id: id,
      product: found,
      userId: userId,
      sandboxTesting: sandboxTesting,
      timeout: timeout,
    );
    return this;
  }

  Future<void> _purchaseProcess({
    required String id,
    required MobilePurchaseProduct product,
    String? userId,
    bool sandboxTesting = false,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    try {
      final purchaseParam = PurchaseParam(
        productDetails: product._productDetails!,
        applicationUserName: userId,
      );
      _purchaseCompleter = Completer<void>();
      if (product.type == ProductType.consumable) {
        final success = await connection
            .buyConsumable(
              purchaseParam: purchaseParam,
              autoConsume: _autoConsumeOnAndroid || Config.isIOS,
            )
            .timeout(timeout);
        if (!success) {
          throw Exception("Purchase failed or was canceled.");
        }
      } else {
        final success = await connection
            .buyNonConsumable(purchaseParam: purchaseParam)
            .timeout(timeout);
        if (!success) {
          throw Exception("Purchase failed or was canceled.");
        }
      }
      await _purchaseCompleter?.future;
      _purchaseCompleter?.complete();
      _purchaseCompleter = null;
    } catch (e) {
      _purchaseCompleter?.completeError(e);
      _purchaseCompleter = null;
      rethrow;
    } finally {
      _purchaseCompleter?.complete();
      _purchaseCompleter = null;
    }
  }

  bool _subscriptionCheckerOnPurchase(String purchaseId, DynamicMap data) {
    if (subscribeOptions.purchaseIDKey.isEmpty) {
      return false;
    }
    return data.get(subscribeOptions.purchaseIDKey, "") == purchaseId;
  }

  bool _subscriptionCheckerOnCheckingEnabled(
    String productId,
    DynamicMap data,
  ) {
    if (subscribeOptions.productIDKey.isEmpty ||
        subscribeOptions.expiredKey.isEmpty) {
      return false;
    }
    return data.get(subscribeOptions.productIDKey, "") == productId &&
        !data.get(subscribeOptions.expiredKey, false);
  }

  /// Find the [MobilePurchaseProduct] from [productId].
  MobilePurchaseProduct? getProduct(String productId) {
    if (!isInitialized) {
      debugPrint(
        "It has not been initialized. First, execute [initialize] to initialize.",
      );
      return null;
    }
    return findById(productId);
  }

  @override
  void dispose() {
    super.dispose();
    _purchaseUpdateStreamSubscription?.cancel();
  }

  late final Future<bool> Function(
    PurchaseDetails purchase,
    MobilePurchaseProduct product,
    PurchaseModel core,
  )? _onVerify;
  late final Future Function(
    PurchaseDetails purchase,
    MobilePurchaseProduct product,
    PurchaseModel core,
  )? _onDeliver;
  late final Future Function(
    PurchaseDetails purchase,
    MobilePurchaseProduct product,
    PurchaseModel core,
  )? _onSubscribe;
  late final Future Function(
    PurchaseDetails purchase,
    MobilePurchaseProduct product,
    PurchaseModel core,
  )? _onUnlock;
  late final Future Function(PurchaseModel core)? _onCheckSubscription;
  late final bool _autoConsumeOnAndroid;

  late final String serverPrefix;

  /// User ID.
  late String userId;

  /// Refresh token for Android.
  late final String androidRefreshToken;

  /// Options for subscription.
  late final SubscribeOptions subscribeOptions;

  /// Validation option for Android.
  late final AndroidVerifierOptions androidVerifierOptions;

  /// Validation option for IOS.
  late final IOSVerifierOptions iosVerifierOptions;

  /// Options for distributing billing items.
  late final DeliverOptions deliverOptions;

  StreamSubscription<List<PurchaseDetails>>? _purchaseUpdateStreamSubscription;

  InAppPurchase get connection {
    return InAppPurchase.instance;
  }

  /// True if the billing system has been initialized.
  bool get isInitialized => _isInitialized;
  bool _isInitialized = false;

  /// True if restored.
  bool get isRestored => _isRestored;
  bool _isRestored = false;

  ProductDetails? _findByPurchaseProduct(MobilePurchaseProduct product) {
    return _productDetailsList.get<ProductDetails?>(product.id, null);
  }

  /// Find the [MobilePurchaseProduct] from [productId].
  ///
  /// [productId]: Product Id.
  MobilePurchaseProduct? findById(String productId) {
    assert(productId.isNotEmpty, "ID is empty.");
    return value.firstWhereOrNull((product) => product.id == productId);
  }

  /// Find the [MobilePurchaseProduct] from [PurchaseDetails].
  ///
  /// [details]: PurchaseDetails.
  MobilePurchaseProduct? findByPurchase(PurchaseDetails details) {
    return value.firstWhereOrNull((product) => product.id == details.productID);
  }

  /// Find the [MobilePurchaseProduct] from [ProductDetails].
  ///
  /// [details]: ProductDetails.
  MobilePurchaseProduct? findByProduct(ProductDetails details) {
    return value.firstWhereOrNull((product) => product.id == details.id);
  }

  /// Get the Authorization Code for Google OAuth.
  Future<void> getAuthorizationCode() async {
    if (!Config.isAndroid) {
      return;
    }
    if (androidVerifierOptions.clientId.isEmpty) {
      return;
    }
    await openURL(
      "https://accounts.google.com/o/oauth2/auth"
      "?scope=https://www.googleapis.com/auth/androidpublisher"
      "&response_type=code&access_type=offline"
      "&redirect_uri=urn:ietf:wg:oauth:2.0:oob"
      "&client_id=${androidVerifierOptions.clientId}",
    );
  }

  /// Get Refresh Token for Google OAuth.
  ///
  /// Please get the authorization code first.
  Future<String?> getAndroidRefreshToken(String authorizationCode) async {
    if (!Config.isAndroid) {
      return null;
    }
    if (androidVerifierOptions.clientId.isEmpty ||
        androidVerifierOptions.clientSecret.isEmpty ||
        authorizationCode.isEmpty) {
      return null;
    }
    final response = await Api.post(
      "https://accounts.google.com/o/oauth2/token",
      headers: {"content-type": "application/x-www-form-urlencoded"},
      body: {
        "grant_type": "authorization_code",
        "client_id": androidVerifierOptions.clientId,
        "client_secret": androidVerifierOptions.clientSecret,
        "redirect_uri": "urn:ietf:wg:oauth:2.0:oob",
        "access_type": "offline",
        "code": authorizationCode
      },
    );
    if (response.statusCode != 200) {
      throw Exception(
        "Server Error: ${response.request?.url ?? ""} ${response.statusCode} ${response.body}",
      );
    }
    final map = jsonDecodeAsMap(response.body);
    if (map.isEmpty) {
      throw Exception(
        "Response is empty: ${response.request?.url ?? ""} ${response.statusCode} ${response.body}",
      );
    }
    return androidRefreshToken = map.get("refresh_token", "");
  }
}
