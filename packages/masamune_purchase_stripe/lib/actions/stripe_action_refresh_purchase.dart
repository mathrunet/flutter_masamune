part of masamune_purchase_stripe;

/// [StripeAction] to update payment information for Stripe purchases.
///
/// Stripeの購入の支払い情報の更新を行うための[StripeAction]。
class StripeRefreshPurchaseAction
    extends StripeAction<StripeRefreshPurchaseActionResponse> {
  /// [StripeAction] to update payment information for Stripe purchases.
  ///
  /// Stripeの購入の支払い情報の更新を行うための[StripeAction]。
  const StripeRefreshPurchaseAction({
    required this.userId,
    required this.orderId,
  });

  /// Purchased user ID.
  ///
  /// 購入したユーザーID。
  final String userId;

  /// Order ID.
  ///
  /// オーダーID。
  final String orderId;

  @override
  final String mode = "refresh_purchase";

  @override
  DynamicMap? toMap() {
    return {
      "userId": userId,
      "orderId": orderId,
    };
  }

  @override
  StripeRefreshPurchaseActionResponse? toResponse(DynamicMap map) {
    if (map.isEmpty) {
      return null;
    }
    return const StripeRefreshPurchaseActionResponse();
  }
}

/// [StripeActionResponse] to update payment information for Stripe purchases.
///
/// Stripeの購入の支払い情報の更新を行うための[StripeActionResponse]。
class StripeRefreshPurchaseActionResponse extends StripeActionResponse {
  /// [StripeActionResponse] to update payment information for Stripe purchases.
  ///
  /// Stripeの購入の支払い情報の更新を行うための[StripeActionResponse]。
  const StripeRefreshPurchaseActionResponse();
}
