part of "/masamune_purchase.dart";

/// Define consumable billing settings for Android.
///
/// Android用の消耗型課金の設定を定義します。
class AndroidConsumablePurchaseFunctionsAction extends PurchaseFunctionsAction {
  /// Define consumable billing settings for Android.
  ///
  /// Android用の消耗型課金の設定を定義します。
  const AndroidConsumablePurchaseFunctionsAction({
    required this.packageName,
    required this.productId,
    required this.purchaseToken,
    required this.documentId,
    required this.amount,
    this.collectionPath = "plugins/iap/user",
    this.fieldKey = "value",
  });

  /// Package Name.
  ///
  /// パッケージ名。
  final String packageName;

  /// Product ID.
  ///
  /// 商品ID。
  final String productId;

  /// Tokens issued at the time of purchase.
  ///
  /// 購入時発行されたトークン。
  final String purchaseToken;

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

  @override
  String get action => "consumable_verify_android";

  @override
  DynamicMap? toMap() {
    assert(collectionPath.isNotEmpty, "The collection path must not be empty.");
    assert(documentId.isNotEmpty, "The document id must not be empty.");
    assert(fieldKey.isNotEmpty, "The field key must not be empty.");
    return {
      "packageName": packageName,
      "productId": productId,
      "purchaseToken": purchaseToken,
      "path": "$collectionPath/$documentId/$fieldKey",
      "value": amount,
    };
  }

  @override
  Future<bool> verify(DynamicMap? response) async {
    if (response == null) {
      return false;
    }
    return response.get<int?>("purchaseState", null) == 0;
  }
}
