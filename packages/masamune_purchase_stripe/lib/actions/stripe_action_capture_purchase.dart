part of masamune_purchase_stripe;

class StripeCapturePurchaseAction
    extends StripeAction<StripeCapturePurchaseActionResponse> {
  const StripeCapturePurchaseAction({
    required this.userId,
    required this.orderId,
    this.priceAmountOverride,
  });
  final String userId;
  final String orderId;
  final double? priceAmountOverride;

  @override
  final String mode = "capture_purchase";

  @override
  DynamicMap? toMap() {
    return {
      "userId": userId,
      "orderId": orderId,
      if (priceAmountOverride != null) "amount": priceAmountOverride,
    };
  }

  @override
  StripeCapturePurchaseActionResponse? toResponse(DynamicMap map) {
    if (map.isEmpty) {
      return null;
    }
    return StripeCapturePurchaseActionResponse(
      purchaseId: map.get("purchaseId", ""),
    );
  }
}

class StripeCapturePurchaseActionResponse extends StripeActionResponse {
  const StripeCapturePurchaseActionResponse({required this.purchaseId});

  final String purchaseId;
}
