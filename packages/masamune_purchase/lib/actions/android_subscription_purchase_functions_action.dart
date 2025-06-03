part of "/masamune_purchase.dart";

/// Define subscription settings for Android.
///
/// Android用のサブスクリプションの設定を定義します。
class AndroidSubscriptionPurchaseFunctionsAction
    extends PurchaseFunctionsAction {
  /// Define subscription settings for Android.
  ///
  /// Android用のサブスクリプションの設定を定義します。
  const AndroidSubscriptionPurchaseFunctionsAction({
    required this.packageName,
    required this.productId,
    required this.purchaseToken,
    required this.purchaseId,
    required this.userId,
    this.data,
  });

  /// Package Name.
  ///
  /// パッケージ名。
  final String packageName;

  /// Product ID.
  ///
  /// 商品ID。
  final String productId;

  /// Purchase ID.
  ///
  /// 購入ID。
  final String purchaseId;

  /// Tokens issued at the time of purchase.
  ///
  /// 購入時発行されたトークン。
  final String purchaseToken;

  /// Purchased user ID.
  ///
  /// 購入したユーザーID。
  final String userId;

  /// Additional data.
  ///
  /// 追加データ。
  final DynamicMap? data;

  @override
  String get action => "subscription_verify_android";

  @override
  DynamicMap? toMap() {
    assert(userId.isNotEmpty, "The user id must not be empty.");
    return {
      "packageName": packageName,
      "productId": productId,
      "purchaseToken": purchaseToken,
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
    final now = DateTime.now();
    final startTimeMillis = response.get<int?>("startTimeMillis", null) ??
        response.get<double?>("startTimeMillis", null)?.toInt() ??
        int.tryParse(response.get("startTimeMillis", "")) ??
        0;
    final expiresTimeMillis = response.get<int?>("expiryTimeMillis", null) ??
        response.get<double?>("expiryTimeMillis", null)?.toInt() ??
        int.tryParse(response.get("expiryTimeMillis", "")) ??
        0;
    if (startTimeMillis <= 0) {
      return false;
    }
    return expiresTimeMillis > now.millisecondsSinceEpoch;
  }
}
