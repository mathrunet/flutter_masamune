part of '/masamune_purchase_stripe.dart';

/// [StripeFunctionsAction] to refund a Stripe purchase.
///
/// Stripeの購入の返金を行うための[StripeFunctionsAction]。
class StripeRefundPurchaseAction
    extends StripeFunctionsAction<StripeRefundPurchaseActionResponse> {
  /// [StripeFunctionsAction] to refund a Stripe purchase.
  ///
  /// Stripeの購入の返金を行うための[StripeFunctionsAction]。
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
  StripeRefundPurchaseActionResponse toResponse(DynamicMap map) {
    return const StripeRefundPurchaseActionResponse();
  }
}

/// [StripeFunctionsActionResponse] to refund a Stripe purchase.
///
/// Stripeの購入の返金を行うための[StripeFunctionsActionResponse]。
class StripeRefundPurchaseActionResponse extends StripeFunctionsActionResponse {
  /// [StripeFunctionsActionResponse] to refund a Stripe purchase.
  ///
  /// Stripeの購入の返金を行うための[StripeFunctionsActionResponse]。
  const StripeRefundPurchaseActionResponse();
}
