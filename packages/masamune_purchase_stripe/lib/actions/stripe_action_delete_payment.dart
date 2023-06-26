part of masamune_purchase_stripe;

/// [StripeAction] to delete a Stripe payment method.
///
/// Stripeの支払い方法の削除を行うための[StripeAction]。
class StripeDeletePaymentAction
    extends StripeAction<StripeDeletePaymentActionResponse> {
  /// [StripeAction] to delete a Stripe payment method.
  ///
  /// Stripeの支払い方法の削除を行うための[StripeAction]。
  const StripeDeletePaymentAction({
    required this.userId,
    required this.paymentId,
  });

  /// ID of the user who has the payment method.
  ///
  /// 支払い方法を持っているユーザーのID。
  final String userId;

  /// Payment Method ID.
  ///
  /// 支払い方法のID。
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

/// [StripeActionResponse] to delete a Stripe payment method.
///
/// Stripeの支払い方法の削除を行うための[StripeActionResponse]。
class StripeDeletePaymentActionResponse extends StripeActionResponse {
  /// [StripeActionResponse] to delete a Stripe payment method.
  ///
  /// Stripeの支払い方法の削除を行うための[StripeActionResponse]。
  const StripeDeletePaymentActionResponse();
}
