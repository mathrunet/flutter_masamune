part of masamune_purchase_stripe;

class StripeRefreshPurchaseAction
    extends StripeAction<StripeRefreshPurchaseActionResponse> {
  const StripeRefreshPurchaseAction({
    required this.userId,
    required this.orderId,
  });
  final String userId;
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

class StripeRefreshPurchaseActionResponse extends StripeActionResponse {
  const StripeRefreshPurchaseActionResponse();
}
