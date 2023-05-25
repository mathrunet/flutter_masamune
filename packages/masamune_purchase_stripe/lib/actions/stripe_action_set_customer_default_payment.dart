part of masamune_purchase_stripe;

class StripeSetCustomerDefaultPaymentAction
    extends StripeAction<StripeSetCustomerDefaultPaymentActionResponse> {
  const StripeSetCustomerDefaultPaymentAction({
    required this.userId,
    required this.paymentId,
  });
  final String userId;
  final String paymentId;

  @override
  final String mode = "set_customer_default_payment";

  @override
  DynamicMap? toMap() {
    return {
      "userId": userId,
      "paymentId": paymentId,
    };
  }

  @override
  StripeSetCustomerDefaultPaymentActionResponse? toResponse(DynamicMap map) {
    if (map.isEmpty) {
      return null;
    }
    return const StripeSetCustomerDefaultPaymentActionResponse();
  }
}

class StripeSetCustomerDefaultPaymentActionResponse
    extends StripeActionResponse {
  const StripeSetCustomerDefaultPaymentActionResponse();
}
