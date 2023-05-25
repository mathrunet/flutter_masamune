part of masamune_purchase_stripe;

class StripeDeleteSubscriptionAction
    extends StripeAction<StripeDeleteSubscriptionActionResponse> {
  const StripeDeleteSubscriptionAction({
    required this.orderId,
  });

  final String orderId;

  @override
  final String mode = "delete_subscription";

  @override
  DynamicMap? toMap() {
    return {
      "orderId": orderId,
    };
  }

  @override
  StripeDeleteSubscriptionActionResponse? toResponse(DynamicMap map) {
    if (map.isEmpty) {
      return null;
    }
    return const StripeDeleteSubscriptionActionResponse();
  }
}

class StripeDeleteSubscriptionActionResponse extends StripeActionResponse {
  const StripeDeleteSubscriptionActionResponse();
}
