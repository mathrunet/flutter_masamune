part of masamune_purchase_stripe;

class StripeRefundPurchaseAction
    extends StripeAction<StripeRefundPurchaseActionResponse> {
  const StripeRefundPurchaseAction({
    required this.userId,
    required this.orderId,
    this.refundAmount,
  });
  final String userId;
  final String orderId;
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

class StripeRefundPurchaseActionResponse extends StripeActionResponse {
  const StripeRefundPurchaseActionResponse();
}
