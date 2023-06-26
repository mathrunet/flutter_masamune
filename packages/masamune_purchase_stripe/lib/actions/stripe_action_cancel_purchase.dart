part of masamune_purchase_stripe;

/// [StripeAction] to cancel a Stripe purchase.
///
/// Stripeの購入キャンセルを行うための[StripeAction]。
class StripeCancelPurchaseAction
    extends StripeAction<StripeCancelPurchaseActionResponse> {
  /// [StripeAction] to cancel a Stripe purchase.
  ///
  /// Stripeの購入キャンセルを行うための[StripeAction]。
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
  StripeCancelPurchaseActionResponse? toResponse(DynamicMap map) {
    if (map.isEmpty) {
      return null;
    }
    return const StripeCancelPurchaseActionResponse();
  }
}

/// [StripeActionResponse] to cancel a Stripe purchase.
///
/// Stripeの購入キャンセルを行うための[StripeActionResponse]。
class StripeCancelPurchaseActionResponse extends StripeActionResponse {
  /// [StripeActionResponse] to cancel a Stripe purchase.
  ///
  /// Stripeの購入キャンセルを行うための[StripeActionResponse]。
  const StripeCancelPurchaseActionResponse();
}
