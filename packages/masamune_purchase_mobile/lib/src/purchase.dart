part of masamune_purchase_mobile;

class Purchase extends ChangeNotifier {
  Purchase();

  InAppPurchase get iap => InAppPurchase.instance;

  bool get initialized => _initialized;
  bool _initialized = false;

  Completer<void>? _completer;
  // ignore: unused_field
  StreamSubscription<List<PurchaseDetails>>? _purchaseUpdateStreamSubscription;
  final List<PurchaseProduct> _products = [];

  Future<void> initialize({
    required String Function() onRetrieveUserId,
  }) async {
    if (_initialized) {
      return;
    }
    if (_completer != null) {
      return _completer?.future;
    }
    _completer = Completer<void>();
    try {
      final adapter = MobilePurchaseMasamuneAdapter.primary;
      final functions =
          adapter.functionsAdapter ?? const RuntimeFunctionsAdapter();
      final available = await iap.isAvailable();
      if (!available) {
        throw UnsupportedError("Purchasing function is not supported.");
      }
      final productDetailResponse = await iap.queryProductDetails(
        adapter.products
            .mapAndRemoveEmpty((element) => element.productId)
            .toSet(),
      );
      if (productDetailResponse.error != null) {
        throw Exception(
          "Error occurred loading the product: "
          "${productDetailResponse.error?.message}",
        );
      }
      if (productDetailResponse.productDetails.isEmpty) {
        if (UniversalPlatform.isAndroid) {
          debugPrint("The product is empty.");
        } else if (UniversalPlatform.isIOS) {
          debugPrint("The product is empty.");
        } else {
          debugPrint("The product is empty.");
        }
        return;
      }
      _products.clear();
      for (final tmp in productDetailResponse.productDetails) {
        final found = adapter.products
            .firstWhereOrNull((product) => product.productId == tmp.id);
        if (found == null) {
          continue;
        }
        _products.add(
          found._copyWith(
            productDetails: tmp,
            onRetrieveUserId: onRetrieveUserId,
            adapter: adapter.modelAdapter,
          ),
        );
        debugPrint("Adding Product: ${tmp.title} (${tmp.id})");
      }
      _purchaseUpdateStreamSubscription = iap.purchaseStream.listen(
        (purchaseDetailsList) async {
          try {
            var done = false;
            for (final purchase in purchaseDetailsList) {
              try {
                final product = findProductByPurchaseDetails(purchase);
                if (product == null) {
                  throw Exception("Product not found: ${purchase.productID}");
                }
                if (purchase.status != PurchaseStatus.pending) {
                  if (purchase.status == PurchaseStatus.error) {
                    if (purchase.pendingCompletePurchase) {
                      await iap.completePurchase(purchase);
                    }
                    throw Exception(
                      "Purchase completed with error: ${purchase.productID}:${purchase.error.toString()}",
                    );
                  } else if (purchase.status == PurchaseStatus.purchased) {
                    if (UniversalPlatform.isAndroid) {
                      final androidPurchase =
                          purchase as GooglePlayPurchaseDetails;
                      switch (product.type) {
                        case PurchaseProductType.consumable:
                          final storeProduct =
                              product as _StoreConsumablePurchaseProduct;
                          if (!await functions.verifyPurchase(
                            setting: AndroidConsumablePurchaseSettings(
                              packageName: androidPurchase
                                  .billingClientPurchase.packageName,
                              productId: androidPurchase.productID,
                              purchaseToken: androidPurchase
                                  .billingClientPurchase.purchaseToken,
                              documentId: storeProduct.userId,
                              amount: storeProduct.amount ?? 0.0,
                            ),
                          )) {
                            throw Exception("Failed to validate purchase.");
                          }
                          break;
                        case PurchaseProductType.nonConsumable:
                          final storeProduct =
                              product as _StoreNonConsumablePurchaseProduct;
                          if (!await functions.verifyPurchase(
                            setting: AndroidNonConsumablePurchaseSettings(
                              packageName: androidPurchase
                                  .billingClientPurchase.packageName,
                              productId: androidPurchase.productID,
                              purchaseToken: androidPurchase
                                  .billingClientPurchase.purchaseToken,
                              documentId: storeProduct.userId,
                              fieldKey: androidPurchase.productID.toCamelCase(),
                            ),
                          )) {
                            throw Exception("Failed to validate purchase.");
                          }
                          break;
                        case PurchaseProductType.subscription:
                          final storeProduct =
                              product as _StoreSubscriptionPurchaseProduct;
                          if (!await functions.verifyPurchase(
                            setting: AndroidSubscriptionPurchaseSettings(
                              packageName: androidPurchase
                                  .billingClientPurchase.packageName,
                              productId: androidPurchase.productID,
                              purchaseToken: androidPurchase
                                  .billingClientPurchase.purchaseToken,
                              purchaseId: androidPurchase.purchaseID ?? "",
                              userId: storeProduct.userId,
                            ),
                          )) {
                            throw Exception("Failed to validate purchase.");
                          }
                          break;
                      }
                    } else if (UniversalPlatform.isIOS) {
                      final iosPurchase = purchase as AppStorePurchaseDetails;
                      switch (product.type) {
                        case PurchaseProductType.consumable:
                          final storeProduct =
                              product as _StoreConsumablePurchaseProduct;
                          if (!await functions.verifyPurchase(
                            setting: IOSConsumablePurchaseSettings(
                              receiptData: iosPurchase
                                  .verificationData.serverVerificationData,
                              documentId: storeProduct.userId,
                              amount: storeProduct.amount ?? 0.0,
                            ),
                          )) {
                            throw Exception("Failed to validate purchase.");
                          }
                          break;
                        case PurchaseProductType.nonConsumable:
                          final storeProduct =
                              product as _StoreNonConsumablePurchaseProduct;
                          if (!await functions.verifyPurchase(
                            setting: IOSNonConsumablePurchaseSettings(
                              receiptData: iosPurchase
                                  .verificationData.serverVerificationData,
                              documentId: storeProduct.userId,
                              fieldKey: iosPurchase.productID.toCamelCase(),
                            ),
                          )) {
                            throw Exception("Failed to validate purchase.");
                          }
                          break;
                        case PurchaseProductType.subscription:
                          final storeProduct =
                              product as _StoreSubscriptionPurchaseProduct;
                          if (!await functions.verifyPurchase(
                            setting: IOSSubscriptionPurchaseSettings(
                              receiptData: iosPurchase
                                  .verificationData.serverVerificationData,
                              productId: iosPurchase.productID,
                              purchaseId: iosPurchase.purchaseID ?? "",
                              userId: storeProduct.userId,
                            ),
                          )) {
                            throw Exception("Failed to validate purchase.");
                          }
                          break;
                      }
                    }
                  } else if (purchase.status == PurchaseStatus.restored) {
                    if (product.type != PurchaseProductType.consumable) {
                      if (UniversalPlatform.isAndroid) {
                        final androidPurchase =
                            purchase as GooglePlayPurchaseDetails;
                        switch (product.type) {
                          case PurchaseProductType.consumable:
                            final storeProduct =
                                product as _StoreConsumablePurchaseProduct;
                            if (!await functions.verifyPurchase(
                              setting: AndroidConsumablePurchaseSettings(
                                packageName: androidPurchase
                                    .billingClientPurchase.packageName,
                                productId: androidPurchase.productID,
                                purchaseToken: androidPurchase
                                    .billingClientPurchase.purchaseToken,
                                documentId: storeProduct.userId,
                                amount: storeProduct.amount ?? 0.0,
                              ),
                            )) {
                              throw Exception("Failed to validate purchase.");
                            }
                            break;
                          case PurchaseProductType.nonConsumable:
                            final storeProduct =
                                product as _StoreNonConsumablePurchaseProduct;
                            if (!await functions.verifyPurchase(
                              setting: AndroidNonConsumablePurchaseSettings(
                                packageName: androidPurchase
                                    .billingClientPurchase.packageName,
                                productId: androidPurchase.productID,
                                purchaseToken: androidPurchase
                                    .billingClientPurchase.purchaseToken,
                                documentId: storeProduct.userId,
                                fieldKey:
                                    androidPurchase.productID.toCamelCase(),
                              ),
                            )) {
                              throw Exception("Failed to validate purchase.");
                            }
                            break;
                          case PurchaseProductType.subscription:
                            final storeProduct =
                                product as _StoreSubscriptionPurchaseProduct;
                            if (!await functions.verifyPurchase(
                              setting: AndroidSubscriptionPurchaseSettings(
                                packageName: androidPurchase
                                    .billingClientPurchase.packageName,
                                productId: androidPurchase.productID,
                                purchaseToken: androidPurchase
                                    .billingClientPurchase.purchaseToken,
                                purchaseId: androidPurchase.purchaseID ?? "",
                                userId: storeProduct.userId,
                              ),
                            )) {
                              throw Exception("Failed to validate purchase.");
                            }
                            break;
                        }
                      } else if (UniversalPlatform.isIOS) {
                        final iosPurchase = purchase as AppStorePurchaseDetails;
                        switch (product.type) {
                          case PurchaseProductType.consumable:
                            final storeProduct =
                                product as _StoreConsumablePurchaseProduct;
                            if (!await functions.verifyPurchase(
                              setting: IOSConsumablePurchaseSettings(
                                receiptData: iosPurchase
                                    .verificationData.serverVerificationData,
                                documentId: storeProduct.userId,
                                amount: storeProduct.amount ?? 0.0,
                              ),
                            )) {
                              throw Exception("Failed to validate purchase.");
                            }
                            break;
                          case PurchaseProductType.nonConsumable:
                            final storeProduct =
                                product as _StoreNonConsumablePurchaseProduct;
                            if (!await functions.verifyPurchase(
                              setting: IOSNonConsumablePurchaseSettings(
                                receiptData: iosPurchase
                                    .verificationData.serverVerificationData,
                                documentId: storeProduct.userId,
                                fieldKey: iosPurchase.productID.toCamelCase(),
                              ),
                            )) {
                              throw Exception("Failed to validate purchase.");
                            }
                            break;
                          case PurchaseProductType.subscription:
                            final storeProduct =
                                product as _StoreSubscriptionPurchaseProduct;
                            if (!await functions.verifyPurchase(
                              setting: IOSSubscriptionPurchaseSettings(
                                receiptData: iosPurchase
                                    .verificationData.serverVerificationData,
                                productId: iosPurchase.productID,
                                purchaseId: iosPurchase.purchaseID ?? "",
                                userId: storeProduct.userId,
                              ),
                            )) {
                              throw Exception("Failed to validate purchase.");
                            }
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
                  if (UniversalPlatform.isAndroid) {
                    if (!adapter.automaticallyConsumeOnAndroid &&
                        product.type == PurchaseProductType.consumable) {
                      final platform = iap.getPlatformAddition<
                          InAppPurchaseAndroidPlatformAddition>();
                      await platform.consumePurchase(purchase);
                    }
                  }
                  if (purchase.pendingCompletePurchase) {
                    debugPrint("Purchase completed: ${purchase.productID}");
                    await iap.completePurchase(purchase);
                  }
                  done = true;
                }
              } catch (e) {
                if (purchase.pendingCompletePurchase) {
                  debugPrint("Purchase completed: ${purchase.productID}");
                  await iap.completePurchase(purchase);
                }
                throw Exception(
                  "Purchase completed with error: ${purchase.productID}:${e.toString()}:${StackTrace.current.toString()}",
                );
              }
            }
            if (done) {
              _completer?.complete();
              _completer = null;
              notifyListeners();
            }
          } catch (e) {
            _completer?.completeError(e);
            _completer = null;
            throw Exception(
              "Purchase completed with error: ${e.toString()}:${StackTrace.current.toString()}",
            );
          }
        },
        onDone: () {
          _completer?.complete();
          _completer = null;
          dispose();
        },
        onError: (e) {
          _completer?.completeError(e);
          _completer = null;
          throw Exception(
            "Purchase completed with error: ${e.toString()}:${StackTrace.current.toString()}",
          );
        },
      );
      if (UniversalPlatform.isIOS) {
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
      await iap.restorePurchases();
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
      final adapter = MobilePurchaseMasamuneAdapter.primary;
      if (found is _StoreConsumablePurchaseProduct) {
        final purchaseParam = PurchaseParam(
          productDetails: found.productDetails,
          applicationUserName: found.userId,
        );
        if (!await iap.buyConsumable(
          purchaseParam: purchaseParam,
          autoConsume:
              adapter.automaticallyConsumeOnAndroid || UniversalPlatform.isIOS,
        )) {
          throw Exception("Purchase failed or was canceled.");
        }
      } else if (found is _StoreNonConsumablePurchaseProduct) {
        final purchaseParam = PurchaseParam(
          productDetails: found.productDetails,
          applicationUserName: found.userId,
        );
        if (!await iap.buyNonConsumable(purchaseParam: purchaseParam)) {
          throw Exception("Purchase failed or was canceled.");
        }
      } else if (found is _StoreSubscriptionPurchaseProduct) {
        final purchaseParam = PurchaseParam(
          productDetails: found.productDetails,
          applicationUserName: found.userId,
        );
        if (!await iap.buyNonConsumable(purchaseParam: purchaseParam)) {
          throw Exception("Purchase failed or was canceled.");
        }
      } else {
        throw Exception("Product not found: ${product.productId}");
      }
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
  }

  PurchaseProduct? findProductByProduct(PurchaseProduct product) {
    return _products
        .firstWhereOrNull((product) => product.productId == product.productId);
  }

  PurchaseProduct? findProductById(String productId) {
    assert(productId.isNotEmpty, "ID is empty.");
    return _products
        .firstWhereOrNull((product) => product.productId == productId);
  }

  PurchaseProduct? findProductByPurchaseDetails(PurchaseDetails details) {
    return _products
        .firstWhereOrNull((product) => product.productId == details.productID);
  }

  PurchaseProduct? findProductByProductDetails(ProductDetails details) {
    return _products
        .firstWhereOrNull((product) => product.productId == details.id);
  }
}
