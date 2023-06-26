part of masamune_purchase_stripe;

/// [StripeAction] to refund a Stripe purchase.
///
/// Stripeの購入の返金を行うための[StripeAction]。
class StripeRefundPurchaseAction
    extends StripeAction<StripeRefundPurchaseActionResponse> {
  /// [StripeAction] to refund a Stripe purchase.
  ///
  /// Stripeの購入の返金を行うための[StripeAction]。
  const StripeRefundPurchaseAction({
    required this.userId,
    required this.orderId,
    this.refundAmount,
  });

  /// ID of the user who made the purchase.
  ///
  /// 購入を行ったユーザーのID。
  final String userId;

  /// Order ID.
  ///
  /// オーダーID。
  final String orderId;

  /// Amount of refund.
  ///
  /// 返金の金額。
  final double? refundAmount;

  @override
  final String mode = "refund_purchase";

  @override
  DynamicMap? toMap() {
    return {
      "userId": userId,
      "orderId": orderId,
      if (refundAmount != null) "refundAmount": refundAmount,
    };
  }

  @override
  StripeRefundPurchaseActionResponse? toResponse(DynamicMap map) {
    if (map.isEmpty) {
      return null;
    }
    return const StripeRefundPurchaseActionResponse();
  }
}

/// [StripeActionResponse] to refund a Stripe purchase.
///
/// Stripeの購入の返金を行うための[StripeActionResponse]。
class StripeRefundPurchaseActionResponse extends StripeActionResponse {
  /// [StripeActionResponse] to refund a Stripe purchase.
  ///
  /// Stripeの購入の返金を行うための[StripeActionResponse]。
  const StripeRefundPurchaseActionResponse();
}
