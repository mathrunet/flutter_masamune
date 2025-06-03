part of "/masamune_purchase_stripe.dart";

/// [StripeFunctionsAction] for creating Stripe customer and payment information.
///
/// Stripeのカスタマー及び支払い情報の作成を行うための[StripeFunctionsAction]。
class StripeCreateCustomerAndPaymentAction extends StripeFunctionsAction<
    StripeCreateCustomerAndPaymentActionResponse> {
  /// [StripeFunctionsAction] for creating Stripe customer and payment information.
  ///
  /// Stripeのカスタマー及び支払い情報の作成を行うための[StripeFunctionsAction]。
  const StripeCreateCustomerAndPaymentAction({
    required this.userId,
    required this.successUrl,
    required this.cancelUrl,
  });

  /// User ID of the customer to be created.
  ///
  /// 作成するカスタマーのユーザーID。
  final String userId;

  /// Return URL on success.
  ///
  /// 成功時のリターンURL。
  final Uri successUrl;

  /// Return URL in case of cancellation.
  ///
  /// キャンセル時のリターンURL。
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
  StripeCreateCustomerAndPaymentActionResponse toResponse(DynamicMap map) {
    if (map.isEmpty) {
      throw Exception("Failed to get response from $mode.");
    }
    return StripeCreateCustomerAndPaymentActionResponse(
      endpoint: Uri.parse(map.get("endpoint", "")),
      customerId: map.get("customerId", ""),
    );
  }
}

/// [StripeFunctionsActionResponse] for creating Stripe customer and payment information.
///
/// Stripeのカスタマー及び支払い情報の作成を行うための[StripeFunctionsActionResponse]。
class StripeCreateCustomerAndPaymentActionResponse
    extends StripeFunctionsActionResponse {
  /// [StripeFunctionsActionResponse] for creating Stripe customer and payment information.
  ///
  /// Stripeのカスタマー及び支払い情報の作成を行うための[StripeFunctionsActionResponse]。
  const StripeCreateCustomerAndPaymentActionResponse({
    required this.endpoint,
    required this.customerId,
  });

  /// Endpoints for creating payment information.
  ///
  /// 支払い情報作成のためのエンドポイント。
  final Uri endpoint;

  /// Customer ID created.
  ///
  /// 作成されたカスタマーID。
  final String customerId;
}
