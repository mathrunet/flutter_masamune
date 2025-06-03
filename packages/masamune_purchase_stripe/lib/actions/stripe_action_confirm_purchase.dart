part of "/masamune_purchase_stripe.dart";

/// [StripeFunctionsAction] to finalize a Stripe purchase.
///
/// Stripeの購入の確定を行うための[StripeFunctionsAction]。
class StripeConfirmPurchaseAction
    extends StripeFunctionsAction<StripeConfirmPurchaseActionResponse> {
  /// [StripeFunctionsAction] to finalize a Stripe purchase.
  ///
  /// Stripeの購入の確定を行うための[StripeFunctionsAction]。
  const StripeConfirmPurchaseAction({
    required this.userId,
    required this.orderId,
    required this.successUrl,
    required this.failureUrl,
    required this.returnUrl,
    this.online = true,
  });

  /// User ID to finalize the purchase.
  ///
  /// 購入の確定を行うユーザーID。
  final String userId;

  /// Order ID that confirms the purchase.
  ///
  /// 購入の確定を行うオーダーID。
  final String orderId;

  /// The URL of the successful confirmation of the purchase.
  ///
  /// 購入の確定が成功した際のURL。
  final Uri successUrl;

  /// URL when purchase confirmation fails.
  ///
  /// 購入の確定が失敗した際のURL。
  final Uri failureUrl;

  /// Other return URLs.
  ///
  /// その他のリターンURL。
  final Uri returnUrl;

  /// If this is `true`, 3D Secure authentication is performed on Webview.
  ///
  /// If `false`, 3D Secure authentication will be performed on the e-mail.
  ///
  /// これが`true`の場合、3Dセキュア認証がWebview上で行われます。
  ///
  /// `false`の場合、3Dセキュア認証がメール上で行われます。
  final bool online;

  @override
  final String mode = "confirm_purchase";

  @override
  DynamicMap? toMap() {
    return {
      "userId": userId,
      "orderId": orderId,
      "successUrl": successUrl.toString(),
      "failureUrl": failureUrl.toString(),
      "returnUrl": returnUrl.toString(),
      "online": online ? "true" : "false",
    };
  }

  @override
  StripeConfirmPurchaseActionResponse toResponse(DynamicMap map) {
    if (map.isEmpty) {
      throw Exception("Failed to get response from $mode.");
    }
    return StripeConfirmPurchaseActionResponse(
      purchaseId: map.get("purchaseId", ""),
      nextActionUrl: Uri.tryParse(map.get("url", "")),
      returnUrl: Uri.tryParse(map.get("returnUrl", "")),
    );
  }
}

/// [StripeFunctionsActionResponse] to finalize a Stripe purchase.
///
/// Stripeの購入の確定を行うための[StripeFunctionsActionResponse]。
class StripeConfirmPurchaseActionResponse
    extends StripeFunctionsActionResponse {
  /// [StripeFunctionsActionResponse] to finalize a Stripe purchase.
  ///
  /// Stripeの購入の確定を行うための[StripeFunctionsActionResponse]。
  const StripeConfirmPurchaseActionResponse({
    required this.purchaseId,
    required this.nextActionUrl,
    this.returnUrl,
  });

  /// Purchase ID.
  ///
  /// 購入ID。
  final String purchaseId;

  /// URL required for next action.
  ///
  /// 次のアクションに必要なURL。
  final Uri? nextActionUrl;

  /// Return URL.
  ///
  /// リターンURL。
  final Uri? returnUrl;
}
