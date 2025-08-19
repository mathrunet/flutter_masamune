part of "/masamune_purchase.dart";

/// Define consumable billing settings for IOS.
///
/// IOS用の消耗型課金の設定を定義します。
class IOSConsumablePurchaseFunctionsAction extends PurchaseFunctionsAction {
  /// Define consumable billing settings for IOS.
  ///
  /// IOS用の消耗型課金の設定を定義します。
  const IOSConsumablePurchaseFunctionsAction({
    required this.receiptData,
    required this.documentId,
    required this.amount,
    required this.productId,
    required this.storeKitVersion,
    this.transactionId,
    this.collectionPath = "plugins/iap/user",
    this.fieldKey = "value",
  }) : assert(
            storeKitVersion == PurchaseStoreKitVersion.storeKit1 ||
                transactionId != null,
            "Transaction ID is required for StoreKit2 verification.");

  /// StoreKit version.
  ///
  /// StoreKitのバージョン。
  final PurchaseStoreKitVersion storeKitVersion;

  /// Transaction ID.
  ///
  /// トランザクションID。
  final String? transactionId;

  /// Receipt data.
  ///
  /// レシートデータ。
  final String receiptData;

  /// The collection path where the data will be stored.
  ///
  /// データを保存するコレクションパス。
  final String collectionPath;

  /// Document ID where the data will be stored.
  ///
  /// データを保存するドキュメントID。
  final String documentId;

  /// Field key to store data.
  ///
  /// データを保存するフィールドキー。
  final String fieldKey;

  /// Amount of data to be added.
  ///
  /// 加算するデータ量。
  final double amount;

  /// Product ID.
  ///
  /// 商品ID。
  final String productId;

  @override
  String get action => "consumable_verify_ios";

  @override
  DynamicMap? toMap() {
    assert(collectionPath.isNotEmpty, "The collection path must not be empty.");
    assert(documentId.isNotEmpty, "The document id must not be empty.");
    assert(fieldKey.isNotEmpty, "The field key must not be empty.");
    assert(
        storeKitVersion == PurchaseStoreKitVersion.storeKit1 ||
            transactionId.isNotEmpty,
        "Transaction ID is required for StoreKit2 verification.");
    return {
      "receiptData": receiptData,
      "path": "$collectionPath/$documentId/$fieldKey",
      "value": amount,
      "productId": productId,
      "storeKitVersion": storeKitVersion.version,
      if (transactionId != null) "transactionId": transactionId,
    };
  }

  @override
  Future<bool> verify(DynamicMap? response) async {
    if (response == null) {
      return false;
    }
    return response.get<int?>("status", null) == 0;
  }
}
