part of '/masamune_purchase.dart';

/// Define the settings for non-disposable billing for Android.
///
/// Android用の非消耗型課金の設定を定義します。
class AndroidNonConsumablePurchaseFunctionsAction
    extends PurchaseFunctionsAction {
  /// Define the settings for non-disposable billing for Android.
  ///
  /// Android用の非消耗型課金の設定を定義します。
  const AndroidNonConsumablePurchaseFunctionsAction({
    required this.packageName,
    required this.productId,
    required this.purchaseToken,
    this.collectionPath = "plugins/iap/user",
    required this.fieldKey,
    required this.documentId,
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

  @override
  String get action => "nonconsumable_verify_android";

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
