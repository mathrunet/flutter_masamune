part of masamune_purchase_stripe;

class StripeCancelPurchaseAction
    extends StripeAction<StripeCancelPurchaseActionResponse> {
  const StripeCancelPurchaseAction({
    required this.userId,
    required this.orderId,
  });
  final String userId;
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

class StripeCancelPurchaseActionResponse extends StripeActionResponse {
  const StripeCancelPurchaseActionResponse();
}
