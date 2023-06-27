part of masamune_purchase_stripe;

/// [StripeFunctionsAction] to change Stripe's default payment method.
///
/// Stripeのデフォルトの支払い方法の変更を行うための[StripeFunctionsAction]。
class StripeSetCustomerDefaultPaymentAction extends StripeFunctionsAction<
    StripeSetCustomerDefaultPaymentActionResponse> {
  /// [StripeFunctionsAction] to change Stripe's default payment method.
  ///
  /// Stripeのデフォルトの支払い方法の変更を行うための[StripeFunctionsAction]。
  const StripeSetCustomerDefaultPaymentAction({
    required this.userId,
    required this.paymentId,
  });

  /// User ID for which the payment method is set up.
  ///
  /// 支払い方法を設定しているユーザーID。
  final String userId;

  /// Payment information ID.
  ///
  /// 支払い情報のID。
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
  StripeSetCustomerDefaultPaymentActionResponse toResponse(DynamicMap map) {
    return const StripeSetCustomerDefaultPaymentActionResponse();
  }
}

/// [StripeFunctionsActionResponse] to change Stripe's default payment method.
///
/// Stripeのデフォルトの支払い方法の変更を行うための[StripeFunctionsActionResponse]。
class StripeSetCustomerDefaultPaymentActionResponse
    extends StripeFunctionsActionResponse {
  /// [StripeFunctionsActionResponse] to change Stripe's default payment method.
  ///
  /// Stripeのデフォルトの支払い方法の変更を行うための[StripeFunctionsActionResponse]。
  const StripeSetCustomerDefaultPaymentActionResponse();
}
