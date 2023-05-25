part of masamune_purchase_stripe;

class StripeDeletePaymentAction
    extends StripeAction<StripeDeletePaymentActionResponse> {
  const StripeDeletePaymentAction({
    required this.userId,
    required this.paymentId,
  });
  final String userId;
  final String paymentId;

  @override
  final String mode = "delete_payment";

  @override
  DynamicMap? toMap() {
    return {
      "userId": userId,
      "paymentId": paymentId,
    };
  }

  @override
  StripeDeletePaymentActionResponse? toResponse(DynamicMap map) {
    if (map.isEmpty) {
      return null;
    }
    return const StripeDeletePaymentActionResponse();
  }
}

class StripeDeletePaymentActionResponse extends StripeActionResponse {
  const StripeDeletePaymentActionResponse();
}
