part of '/masamune_purchase_mobile.dart';

/// Define subscription settings for IOS.
///
/// IOS用のサブスクリプションの設定を定義します。
class IOSSubscriptionPurchaseFunctionsAction extends PurchaseFunctionsAction {
  /// Define subscription settings for IOS.
  ///
  /// IOS用のサブスクリプションの設定を定義します。
  const IOSSubscriptionPurchaseFunctionsAction({
    required this.receiptData,
    required this.productId,
    required this.purchaseId,
    required this.userId,
    this.data,
  });

  /// Receipt data.
  ///
  /// レシートデータ。
  final String receiptData;

  /// Product ID.
  ///
  /// 商品ID。
  final String productId;

  /// Purchase ID.
  ///
  /// 購入ID。
  final String purchaseId;

  /// Purchased user ID.
  ///
  /// 購入したユーザーID。
  final String userId;

  /// Additional data.
  ///
  /// 追加データ。
  final DynamicMap? data;

  @override
  String get action => "subscription_verify_ios";

  @override
  DynamicMap? toMap() {
    assert(userId.isNotEmpty, "The user id must not be empty.");
    return {
      "receiptData": receiptData,
      "productId": productId,
      "data": data ?? <String, dynamic>{},
      "userId": userId,
      "purchaseId": purchaseId,
    };
  }

  @override
  Future<bool> verify(DynamicMap? response) async {
    if (response == null) {
      return false;
    }
    if (response.get<int?>("status", null) != 0) {
      return false;
    }
    final now = DateTime.now();
    final latestReceiptInfo = response
        .getAsList("latest_receipt_info")
        .cast<Map>()
        .map((e) => e.map((key, value) => MapEntry(key.toString(), value)))
        .firstOrNull;
    final startTimeMillis =
        latestReceiptInfo.get<int?>("purchase_date_ms", null) ??
            latestReceiptInfo.get<double?>("purchase_date_ms", null)?.toInt() ??
            int.tryParse(latestReceiptInfo.get("purchase_date_ms", "")) ??
            0;
    final expiresTimeMillis =
        latestReceiptInfo.get<int?>("expires_date_ms", null) ??
            latestReceiptInfo.get<double?>("expires_date_ms", null)?.toInt() ??
            int.tryParse(latestReceiptInfo.get("expires_date_ms", "")) ??
            0;
    if (startTimeMillis <= 0) {
      return false;
    }
    return expiresTimeMillis > now.millisecondsSinceEpoch;
  }
}
