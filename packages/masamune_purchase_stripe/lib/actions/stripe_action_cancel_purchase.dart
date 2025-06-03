part of "/masamune_purchase_stripe.dart";

/// [StripeFunctionsAction] to cancel a Stripe purchase.
///
/// Stripeの購入キャンセルを行うための[StripeFunctionsAction]。
class StripeCancelPurchaseAction
    extends StripeFunctionsAction<StripeCancelPurchaseActionResponse> {
  /// [StripeFunctionsAction] to cancel a Stripe purchase.
  ///
  /// Stripeの購入キャンセルを行うための[StripeFunctionsAction]。
  const StripeCancelPurchaseAction({
    required this.userId,
    required this.orderId,
  });

  /// User ID for purchase cancellation.
  ///
  /// 購入キャンセルを行うユーザーID。
  final String userId;

  /// Order ID to cancel the purchase.
  ///
  /// 購入キャンセルを行うオーダーID。
  final String orderId;

  @override
  final String mode = "cancel_purchase";

  @override
  DynamicMap? toMap() {
    return {
      "userId": userId,
      "orderId": orderId,
    };
  }

  @override
  StripeCancelPurchaseActionResponse toResponse(DynamicMap map) {
    return const StripeCancelPurchaseActionResponse();
  }
}

/// [StripeFunctionsActionResponse] to cancel a Stripe purchase.
///
/// Stripeの購入キャンセルを行うための[StripeFunctionsActionResponse]。
class StripeCancelPurchaseActionResponse extends StripeFunctionsActionResponse {
  /// [StripeFunctionsActionResponse] to cancel a Stripe purchase.
  ///
  /// Stripeの購入キャンセルを行うための[StripeFunctionsActionResponse]。
  const StripeCancelPurchaseActionResponse();
}
