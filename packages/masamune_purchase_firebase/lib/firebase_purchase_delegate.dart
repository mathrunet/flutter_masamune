part of masamune_purchase_firebase;

/// [PurchaseCore] is used as a callback for [onVerify] of [PurchaseCore].
///
/// The signature is verified and the receipt is verified by firebase.
@immutable
class FirebasePurchaseDelegate extends PurchaseDelegate {
  const FirebasePurchaseDelegate();

  /// [PurchaseCore] is used as a callback for [onVerify] of [PurchaseCore].
  ///
  /// The signature is verified and the receipt is verified by firebase.
  ///
  /// [purchase]: PurchaseDetails.
  /// [product]: The purchased product.
  /// [core]: Purchase Core instance.
  static Future<bool> verifyAndDeliver(
    PurchaseDetails purchase,
    MobilePurchaseProduct product,
    PurchaseModel core,
  ) async {
    final prefix = core.serverPrefix.isEmpty
        ? ""
        : "${core.serverPrefix.trimString("/")}/";
    if (Config.isAndroid) {
      switch (product.type) {
        case ProductType.consumable:
          final functions = readProvider(
            functionsProvider(
              "$prefix${core.androidVerifierOptions.consumableVerificationServer ?? ""}",
            ),
          );
          final purchaseForGoogle = purchase as GooglePlayPurchaseDetails;
          final data = await functions.call(
            parameters: {
              "purchaseId": purchase.purchaseID,
              "packageName":
                  purchaseForGoogle.billingClientPurchase.packageName,
              "productId": purchase.productID,
              "purchaseToken":
                  purchaseForGoogle.billingClientPurchase.purchaseToken,
              "path": product.target,
              "value": product.value,
              "user": core.userId
            },
          );
          if (data is! Map) {
            return false;
          }
          if (!data.containsKey("purchaseState") ||
              data["purchaseState"] != 0) {
            return false;
          }
          break;
        case ProductType.nonConsumable:
          final functions = readProvider(
            functionsProvider(
              "$prefix${core.androidVerifierOptions.nonconsumableVerificationServer ?? ""}",
            ),
          );
          final purchaseForGoogle = purchase as GooglePlayPurchaseDetails;
          final data = await functions.call(
            parameters: {
              "purchaseId": purchase.purchaseID,
              "packageName":
                  purchaseForGoogle.billingClientPurchase.packageName,
              "productId": purchase.productID,
              "purchaseToken":
                  purchaseForGoogle.billingClientPurchase.purchaseToken,
              "path": product.target,
              "user": core.userId
            },
          );
          if (data is! Map) {
            return false;
          }
          if (!data.containsKey("purchaseState") ||
              data["purchaseState"] != 0) {
            return false;
          }
          break;
        case ProductType.subscription:
          // final params =
          //     (await product.subscriptionData?.call(purchase, core)) ?? {};
          final functions = readProvider(
            functionsProvider(
              "$prefix${core.androidVerifierOptions.subscriptionVerificationServer ?? ""}",
            ),
          );
          final purchaseForGoogle = purchase as GooglePlayPurchaseDetails;
          final data = await functions.call(
            parameters: {
              "purchaseId": purchase.purchaseID,
              "packageName":
                  purchaseForGoogle.billingClientPurchase.packageName,
              "productId": purchase.productID,
              "purchaseToken":
                  purchaseForGoogle.billingClientPurchase.purchaseToken,
              "path": product.target,
              "user": core.userId,
              // "data": params,
            },
          );
          if (data is! Map) {
            return false;
          }
          final now = DateTime.now();
          final startTimeMillis = data.containsKey("startTimeMillis")
              ? int.tryParse(data["startTimeMillis"]).def(0)
              : 0;
          final expiresTimeMillis = data.containsKey("expiryTimeMillis")
              ? int.tryParse(data["expiryTimeMillis"]).def(0)
              : 0;
          if (startTimeMillis <= 0) {
            return false;
          }
          if (expiresTimeMillis <= now.millisecondsSinceEpoch) {
            return false;
          }
          break;
      }
    } else if (Config.isIOS) {
      // if (core.iosVerifierOptions == null ||
      //     isEmpty(core.iosVerifierOptions.sharedSecret)) return false;
      switch (product.type) {
        case ProductType.consumable:
          final functions = readProvider(
            functionsProvider(
              "$prefix${core.iosVerifierOptions.consumableVerificationServer ?? ""}",
            ),
          );
          final data = await functions.call(
            parameters: {
              "receiptData": purchase.verificationData.serverVerificationData,
              "purchaseId": purchase.purchaseID,
              "productId": purchase.productID,
              "path": product.target,
              "value": product.value,
              "user": core.userId
            },
          );
          if (data is! Map) {
            return false;
          }
          if (!data.containsKey("status") || data["status"] != 0) {
            return false;
          }
          break;
        case ProductType.nonConsumable:
          final functions = readProvider(
            functionsProvider(
              "$prefix${core.iosVerifierOptions.nonconsumableVerificationServer ?? ""}",
            ),
          );
          final data = await functions.call(
            parameters: {
              "receiptData": purchase.verificationData.serverVerificationData,
              "purchaseId": purchase.purchaseID,
              "productId": purchase.productID,
              "path": product.target,
              "user": core.userId
            },
          );
          if (data is! Map) {
            return false;
          }
          if (!data.containsKey("status") || data["status"] != 0) {
            return false;
          }
          break;
        case ProductType.subscription:
          // final params =
          //     (await product.subscriptionData?.call(purchase, core)) ?? {};
          final functions = readProvider(
            functionsProvider(
              "$prefix${core.iosVerifierOptions.subscriptionVerificationServer ?? ""}",
            ),
          );
          final data = await functions.call(
            parameters: {
              "receiptData": purchase.verificationData.serverVerificationData,
              "purchaseId": purchase.purchaseID,
              "productId": purchase.productID,
              "path": product.target,
              "user": core.userId,
              // "data": params,
            },
          );
          if (data is! Map) {
            return false;
          }
          if (!data.containsKey("status") || data["status"] != 0) {
            return false;
          }
          final now = DateTime.now();
          final latestReceiptInfo = data.containsKey("latest_receipt_info")
              ? (data["latest_receipt_info"] as List)
                  .cast<Map>()
                  .first
                  .cast<String, dynamic>()
              : const <String, dynamic>{};
          final startTimeMillis =
              int.tryParse(latestReceiptInfo.get("purchase_date_ms", "0"))
                  .def(0);
          final expiresTimeMillis =
              int.tryParse(latestReceiptInfo.get("expires_date_ms", "0"))
                  .def(0);
          if (startTimeMillis <= 0) {
            return false;
          }
          if (expiresTimeMillis <= now.millisecondsSinceEpoch) {
            return false;
          }
          break;
      }
    }
    return true;
  }

  @override
  Future<bool> onVerify(
    PurchaseDetails purchase,
    MobilePurchaseProduct product,
    PurchaseModel core,
  ) =>
      verifyAndDeliver(purchase, product, core);
}
