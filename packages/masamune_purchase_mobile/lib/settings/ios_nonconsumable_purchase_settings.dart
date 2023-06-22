part of masamune_purchase_mobile;

/// Define the settings for non-consumable billing for IOS.
///
/// IOS用の非消耗型課金の設定を定義します。
class IOSNonConsumablePurchaseSettings extends PurchaseSettings {
  /// Define the settings for non-consumable billing for IOS.
  ///
  /// IOS用の非消耗型課金の設定を定義します。
  const IOSNonConsumablePurchaseSettings({
    required this.receiptData,
    this.collectionPath = "plugins/iap/user",
    required this.fieldKey,
    required this.documentId,
  });

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

  @override
  String get action => "nonconsumable_verify_ios";

  @override
  DynamicMap? toMap() {
    assert(collectionPath.isNotEmpty, "The collection path must not be empty.");
    assert(documentId.isNotEmpty, "The document id must not be empty.");
    assert(fieldKey.isNotEmpty, "The field key must not be empty.");
    return {
      "receiptData": receiptData,
      "path": "$collectionPath/$documentId/$fieldKey",
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
