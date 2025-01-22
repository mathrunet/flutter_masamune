part of "others.dart";

/// Initial setup for handling InAppPurchase on mobile [MasamuneAdapter].
///
/// Define all billable items to be used in the app in [products].
///
/// モバイルでのInAppPurchaseを取り扱うための初期設定を行う[MasamuneAdapter]。
///
/// [products]にアプリ内で利用するすべての課金用のアイテムを定義してください。
class MobilePurchaseMasamuneAdapter extends PurchaseMasamuneAdapter {
  /// Initial setup for handling InAppPurchase on mobile [MasamuneAdapter].
  ///
  /// Define all billable items to be used in the app in [products].
  ///
  /// モバイルでのInAppPurchaseを取り扱うための初期設定を行う[MasamuneAdapter]。
  ///
  /// [products]にアプリ内で利用するすべての課金用のアイテムを定義してください。
  const MobilePurchaseMasamuneAdapter({
    super.functionsAdapter,
    super.modelAdapter,
    required super.products,
    this.automaticallyConsumeOnAndroid = true,
    this.iosSandboxTesting = false,
    required super.onRetrieveUserId,
    super.purchase,
    super.consumablePurchaseDelegate,
    super.nonConsumablePurchaseDelegate,
    super.subscriptionPurchaseDelegate,
  });

  InAppPurchase get _iap => InAppPurchase.instance;

  /// If you are using an Android device, set to `true` to automatically consume charged items.
  ///
  /// Android端末を利用している場合、課金アイテムを自動的に消費する場合`true`に設定します。
  final bool automaticallyConsumeOnAndroid;

  /// Set to `true` if you want to debug with SandboxTesting if you are using an IOS terminal.
  ///
  /// IOS端末を利用している場合SandboxTestingでデバッグをしたい場合`true`を設定します。
  final bool iosSandboxTesting;

  @override
  Future<List<PurchaseProduct>> getProducts({
    required String? Function() onRetrieveUserId,
  }) async {
    final available = await _iap.isAvailable();
    if (!available) {
      throw UnsupportedError("Purchasing function is not supported.");
    }
    final productDetailResponse = await _iap.queryProductDetails(
      products.mapAndRemoveEmpty((element) => element.productId).toSet(),
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
      return [];
    }
    final res = <PurchaseProduct>[];
    for (final tmp in productDetailResponse.productDetails) {
      final found =
          products.firstWhereOrNull((product) => product.productId == tmp.id);
      if (found == null) {
        continue;
      }
      res.add(
        found._copyWith(
          productDetails: tmp,
          onRetrieveUserId: onRetrieveUserId,
          modelAdapter: modelAdapter,
          purchaseAdapter: this,
        ),
      );
      debugPrint("Adding Product: ${tmp.title} (${tmp.id})");
    }
    await Future.wait(res.map((e) => e.load()));
    return res;
  }

  @override
  StreamSubscription? listenPurchase({
    required List<PurchaseProduct> products,
    required VoidCallback onDone,
    required VoidCallback onDisposed,
    required void Function(Object e, StackTrace? stacktrace) onError,
  }) {
    final functions = functionsAdapter ?? FunctionsAdapter.primary;
    return _iap.purchaseStream.listen(
      (purchaseDetailsList) async {
        try {
          final userId = onRetrieveUserId.call();
          var done = false;
          for (final purchase in purchaseDetailsList) {
            try {
              final product = products.firstWhereOrNull(
                (product) => product.productId == purchase.productID,
              );
              if (product == null) {
                throw Exception("Product not found: ${purchase.productID}");
              }
              if (purchase.status != PurchaseStatus.pending) {
                if (purchase.status == PurchaseStatus.error) {
                  if (purchase.pendingCompletePurchase) {
                    await _iap.completePurchase(purchase);
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
                        if (!(await functions.execute(
                          AndroidConsumablePurchaseFunctionsAction(
                            packageName: androidPurchase
                                .billingClientPurchase.packageName,
                            productId: androidPurchase.productID,
                            purchaseToken: androidPurchase
                                .billingClientPurchase.purchaseToken,
                            documentId: userId ?? storeProduct.userId,
                            amount: storeProduct.amount ?? 0.0,
                          ),
                        ))
                            .result) {
                          throw Exception("Failed to validate purchase.");
                        }
                        break;
                      case PurchaseProductType.nonConsumable:
                        final storeProduct =
                            product as _StoreNonConsumablePurchaseProduct;
                        if (!(await functions.execute(
                          AndroidNonConsumablePurchaseFunctionsAction(
                            packageName: androidPurchase
                                .billingClientPurchase.packageName,
                            productId: androidPurchase.productID,
                            purchaseToken: androidPurchase
                                .billingClientPurchase.purchaseToken,
                            documentId: userId ?? storeProduct.userId,
                            fieldKey: androidPurchase.productID.toCamelCase(),
                          ),
                        ))
                            .result) {
                          throw Exception("Failed to validate purchase.");
                        }
                        break;
                      case PurchaseProductType.subscription:
                        final storeProduct =
                            product as _StoreSubscriptionPurchaseProduct;
                        if (!(await functions.execute(
                          AndroidSubscriptionPurchaseFunctionsAction(
                            packageName: androidPurchase
                                .billingClientPurchase.packageName,
                            productId: androidPurchase.productID,
                            purchaseToken: androidPurchase
                                .billingClientPurchase.purchaseToken,
                            purchaseId: androidPurchase.purchaseID ?? "",
                            userId: userId ?? storeProduct.userId,
                          ),
                        ))
                            .result) {
                          throw Exception("Failed to validate purchase.");
                        }
                        break;
                      case PurchaseProductType.subscriptionOffer:
                        break;
                    }
                  } else if (UniversalPlatform.isIOS) {
                    final iosPurchase = purchase as AppStorePurchaseDetails;
                    switch (product.type) {
                      case PurchaseProductType.consumable:
                        final storeProduct =
                            product as _StoreConsumablePurchaseProduct;
                        if (!(await functions.execute(
                          IOSConsumablePurchaseFunctionsAction(
                            receiptData: iosPurchase
                                .verificationData.serverVerificationData,
                            documentId: userId ?? storeProduct.userId,
                            amount: storeProduct.amount ?? 0.0,
                            productId: iosPurchase.productID,
                          ),
                        ))
                            .result) {
                          throw Exception("Failed to validate purchase.");
                        }
                        break;
                      case PurchaseProductType.nonConsumable:
                        final storeProduct =
                            product as _StoreNonConsumablePurchaseProduct;
                        if (!(await functions.execute(
                          IOSNonConsumablePurchaseFunctionsAction(
                            receiptData: iosPurchase
                                .verificationData.serverVerificationData,
                            productId: iosPurchase.productID,
                            documentId: userId ?? storeProduct.userId,
                            fieldKey: iosPurchase.productID.toCamelCase(),
                          ),
                        ))
                            .result) {
                          throw Exception("Failed to validate purchase.");
                        }
                        break;
                      case PurchaseProductType.subscription:
                        final storeProduct =
                            product as _StoreSubscriptionPurchaseProduct;
                        if (!(await functions.execute(
                          IOSSubscriptionPurchaseFunctionsAction(
                            receiptData: iosPurchase
                                .verificationData.serverVerificationData,
                            productId: iosPurchase.productID,
                            purchaseId: iosPurchase.purchaseID ?? "",
                            userId: userId ?? storeProduct.userId,
                          ),
                        ))
                            .result) {
                          throw Exception("Failed to validate purchase.");
                        }
                        break;
                      case PurchaseProductType.subscriptionOffer:
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
                          if (!(await functions.execute(
                            AndroidConsumablePurchaseFunctionsAction(
                              packageName: androidPurchase
                                  .billingClientPurchase.packageName,
                              productId: androidPurchase.productID,
                              purchaseToken: androidPurchase
                                  .billingClientPurchase.purchaseToken,
                              documentId: userId ?? storeProduct.userId,
                              amount: storeProduct.amount ?? 0.0,
                            ),
                          ))
                              .result) {
                            throw Exception("Failed to validate purchase.");
                          }
                          break;
                        case PurchaseProductType.nonConsumable:
                          final storeProduct =
                              product as _StoreNonConsumablePurchaseProduct;
                          if (!(await functions.execute(
                            AndroidNonConsumablePurchaseFunctionsAction(
                              packageName: androidPurchase
                                  .billingClientPurchase.packageName,
                              productId: androidPurchase.productID,
                              purchaseToken: androidPurchase
                                  .billingClientPurchase.purchaseToken,
                              documentId: userId ?? storeProduct.userId,
                              fieldKey: androidPurchase.productID.toCamelCase(),
                            ),
                          ))
                              .result) {
                            throw Exception("Failed to validate purchase.");
                          }
                          break;
                        case PurchaseProductType.subscription:
                          final storeProduct =
                              product as _StoreSubscriptionPurchaseProduct;
                          if (!(await functions.execute(
                            AndroidSubscriptionPurchaseFunctionsAction(
                              packageName: androidPurchase
                                  .billingClientPurchase.packageName,
                              productId: androidPurchase.productID,
                              purchaseToken: androidPurchase
                                  .billingClientPurchase.purchaseToken,
                              purchaseId: androidPurchase.purchaseID ?? "",
                              userId: userId ?? storeProduct.userId,
                            ),
                          ))
                              .result) {
                            throw Exception("Failed to validate purchase.");
                          }
                          break;
                        case PurchaseProductType.subscriptionOffer:
                          break;
                      }
                    } else if (UniversalPlatform.isIOS) {
                      final iosPurchase = purchase as AppStorePurchaseDetails;
                      switch (product.type) {
                        case PurchaseProductType.consumable:
                          final storeProduct =
                              product as _StoreConsumablePurchaseProduct;
                          if (!(await functions.execute(
                            IOSConsumablePurchaseFunctionsAction(
                              receiptData: iosPurchase
                                  .verificationData.serverVerificationData,
                              documentId: userId ?? storeProduct.userId,
                              amount: storeProduct.amount ?? 0.0,
                              productId: iosPurchase.productID,
                            ),
                          ))
                              .result) {
                            throw Exception("Failed to validate purchase.");
                          }
                          break;
                        case PurchaseProductType.nonConsumable:
                          final storeProduct =
                              product as _StoreNonConsumablePurchaseProduct;
                          if (!(await functions.execute(
                            IOSNonConsumablePurchaseFunctionsAction(
                              receiptData: iosPurchase
                                  .verificationData.serverVerificationData,
                              documentId: userId ?? storeProduct.userId,
                              productId: iosPurchase.productID,
                              fieldKey: iosPurchase.productID.toCamelCase(),
                            ),
                          ))
                              .result) {
                            throw Exception("Failed to validate purchase.");
                          }
                          break;
                        case PurchaseProductType.subscription:
                          final storeProduct =
                              product as _StoreSubscriptionPurchaseProduct;
                          if (!(await functions.execute(
                            IOSSubscriptionPurchaseFunctionsAction(
                              receiptData: iosPurchase
                                  .verificationData.serverVerificationData,
                              productId: iosPurchase.productID,
                              purchaseId: iosPurchase.purchaseID ?? "",
                              userId: userId ?? storeProduct.userId,
                            ),
                          ))
                              .result) {
                            throw Exception("Failed to validate purchase.");
                          }
                          break;
                        case PurchaseProductType.subscriptionOffer:
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
                  if ((!automaticallyConsumeOnAndroid &&
                          product.type == PurchaseProductType.consumable) ||
                      product.debugConsumeWhenPurchaseCompleted) {
                    final platform = _iap.getPlatformAddition<
                        InAppPurchaseAndroidPlatformAddition>();
                    await platform.consumePurchase(purchase);
                  }
                }
                if (purchase.pendingCompletePurchase) {
                  debugPrint("Purchase completed: ${purchase.productID}");
                  await _iap.completePurchase(purchase);
                }
                done = true;
              }
            } catch (e, stacktrace) {
              if (purchase.pendingCompletePurchase) {
                debugPrint("Purchase completed: ${purchase.productID}");
                await _iap.completePurchase(purchase);
              }
              throw Exception(
                "Purchase completed with error: ${purchase.productID}:${e.toString()}:$stacktrace.toString()}",
              );
            }
          }
          if (done) {
            onDone();
          }
        } catch (e, stacktrace) {
          onError(e, stacktrace);
          throw Exception(
            "Purchase completed with error: ${e.toString()}:${stacktrace.toString()}",
          );
        }
      },
      onDone: onDisposed,
      onError: (e, stacktrace) {
        onError(e, stacktrace);
        throw Exception(
          "Purchase completed with error: ${e.toString()}:${stacktrace.toString()}",
        );
      },
    );
  }

  @override
  Future<void> initialize() async {
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
  }

  @override
  Future<void> restore(List<PurchaseProduct> products) async {
    await _iap.restorePurchases();
  }

  @override
  Future<void> purchase({
    required PurchaseProduct product,
    required VoidCallback onDone,
    PurchaseProduct? replacedProduct,
  }) async {
    final userId = onRetrieveUserId.call();
    if (product is _StoreConsumablePurchaseProduct) {
      final purchaseParam = PurchaseParam(
        productDetails: product.productDetails,
        applicationUserName: userId ?? product.userId,
      );
      if (!await _iap.buyConsumable(
        purchaseParam: purchaseParam,
        autoConsume: automaticallyConsumeOnAndroid || UniversalPlatform.isIOS,
      )) {
        throw Exception("Purchase failed or was canceled.");
      }
    } else if (product is _StoreNonConsumablePurchaseProduct) {
      final purchaseParam = PurchaseParam(
        productDetails: product.productDetails,
        applicationUserName: userId ?? product.userId,
      );
      if (!await _iap.buyNonConsumable(purchaseParam: purchaseParam)) {
        throw Exception("Purchase failed or was canceled.");
      }
    } else if (product is _StoreSubscriptionPurchaseProduct) {
      final changeSubscription =
          await _getReplacedPurchaseDetails(replacedProduct: replacedProduct);

      final purchaseParam = UniversalPlatform.isAndroid
          ? GooglePlayPurchaseParam(
              productDetails: product.productDetails,
              applicationUserName: userId ?? product.userId,
              changeSubscriptionParam: changeSubscription != null
                  ? ChangeSubscriptionParam(
                      oldPurchaseDetails: changeSubscription,
                      replacementMode: ReplacementMode.withTimeProration,
                      // prorationMode: ProrationMode.immediateWithTimeProration,
                    )
                  : null,
            )
          : PurchaseParam(
              productDetails: product.productDetails,
              applicationUserName: userId ?? product.userId,
            );
      if (!await _iap.buyNonConsumable(purchaseParam: purchaseParam)) {
        throw Exception("Purchase failed or was canceled.");
      }
    } else {
      throw Exception("Product not found: ${product.productId}");
    }
  }

  Future<GooglePlayPurchaseDetails?> _getReplacedPurchaseDetails(
      {PurchaseProduct? replacedProduct}) async {
    if (!UniversalPlatform.isAndroid) {
      return null;
    }
    if (replacedProduct == null) {
      return null;
    }
    final addition = InAppPurchase.instance
        .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
    final purchases = await addition.queryPastPurchases();
    return purchases.pastPurchases
        .sortTo(
          (a, b) => b.billingClientPurchase.purchaseTime
              .compareTo(a.billingClientPurchase.purchaseTime),
        )
        .where((element) =>
            element.status == PurchaseStatus.purchased &&
            element.productID == replacedProduct.productId)
        .firstOrNull;
  }
}
