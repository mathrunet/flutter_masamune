part of masamune_purchase_stripe;

class StripeCreateCustomerAndPaymentAction
    extends StripeAction<StripeCreateCustomerAndPaymentActionResponse> {
  const StripeCreateCustomerAndPaymentAction({
    required this.userId,
    required this.successUrl,
    required this.cancelUrl,
  });
  final String userId;
  final Uri successUrl;
  final Uri cancelUrl;

  @override
  final String mode = "create_customer_and_payment";

  @override
  DynamicMap? toMap() {
    return {
      "userId": userId,
      "successUrl": successUrl.toString(),
      "cancelUrl": cancelUrl.toString(),
    };
  }

  @override
  StripeCreateCustomerAndPaymentActionResponse? toResponse(DynamicMap map) {
    if (map.isEmpty) {
      return null;
    }
    return StripeCreateCustomerAndPaymentActionResponse(
      endpoint: Uri.parse(map.get("endpoint", "")),
      customerId: map.get("customerId", ""),
    );
  }
}

class StripeCreateCustomerAndPaymentActionResponse
    extends StripeActionResponse {
  const StripeCreateCustomerAndPaymentActionResponse({
    required this.endpoint,
    required this.customerId,
  });

  final Uri endpoint;
  final String customerId;
}
