part of masamune_purchase_stripe;

class StripeCreateSubscriptionAction
    extends StripeAction<StripeCreateSubscriptionActionResponse> {
  const StripeCreateSubscriptionAction({
    required this.userId,
    required this.productId,
    required this.orderId,
    this.count = 1,
    required this.successUrl,
    required this.cancelUrl,
  });

  final String userId;
  final String productId;
  final String orderId;
  final int count;
  final Uri successUrl;
  final Uri cancelUrl;

  @override
  final String mode = "create_subscription";

  @override
  DynamicMap? toMap() {
    return {
      "userId": userId,
      "productId": productId,
      "orderId": orderId,
      "count": count,
      "successUrl": successUrl.toString(),
      "cancelUrl": cancelUrl.toString(),
    };
  }

  @override
  StripeCreateSubscriptionActionResponse? toResponse(DynamicMap map) {
    if (map.isEmpty) {
      return null;
    }
    return StripeCreateSubscriptionActionResponse(
      endpoint: Uri.parse(map.get("endpoint", "")),
    );
  }
}

class StripeCreateSubscriptionActionResponse extends StripeActionResponse {
  const StripeCreateSubscriptionActionResponse({required this.endpoint});

  final Uri endpoint;
}
