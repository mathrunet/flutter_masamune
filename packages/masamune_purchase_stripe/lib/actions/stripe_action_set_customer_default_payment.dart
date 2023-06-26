part of masamune_purchase_stripe;

/// [StripeAction] to change Stripe's default payment method.
///
/// Stripeのデフォルトの支払い方法の変更を行うための[StripeAction]。
class StripeSetCustomerDefaultPaymentAction
    extends StripeAction<StripeSetCustomerDefaultPaymentActionResponse> {
  /// [StripeAction] to change Stripe's default payment method.
  ///
  /// Stripeのデフォルトの支払い方法の変更を行うための[StripeAction]。
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
  StripeSetCustomerDefaultPaymentActionResponse? toResponse(DynamicMap map) {
    if (map.isEmpty) {
      return null;
    }
    return const StripeSetCustomerDefaultPaymentActionResponse();
  }
}

/// [StripeActionResponse] to change Stripe's default payment method.
///
/// Stripeのデフォルトの支払い方法の変更を行うための[StripeActionResponse]。
class StripeSetCustomerDefaultPaymentActionResponse
    extends StripeActionResponse {
  /// [StripeActionResponse] to change Stripe's default payment method.
  ///
  /// Stripeのデフォルトの支払い方法の変更を行うための[StripeActionResponse]。
  const StripeSetCustomerDefaultPaymentActionResponse();
}
