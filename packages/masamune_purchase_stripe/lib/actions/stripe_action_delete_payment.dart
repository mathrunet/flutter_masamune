part of '/masamune_purchase_stripe.dart';

/// [StripeFunctionsAction] to delete a Stripe payment method.
///
/// Stripeの支払い方法の削除を行うための[StripeFunctionsAction]。
class StripeDeletePaymentAction
    extends StripeFunctionsAction<StripeDeletePaymentActionResponse> {
  /// [StripeFunctionsAction] to delete a Stripe payment method.
  ///
  /// Stripeの支払い方法の削除を行うための[StripeFunctionsAction]。
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
  StripeDeletePaymentActionResponse toResponse(DynamicMap map) {
    return const StripeDeletePaymentActionResponse();
  }
}

/// [StripeFunctionsActionResponse] to delete a Stripe payment method.
///
/// Stripeの支払い方法の削除を行うための[StripeFunctionsActionResponse]。
class StripeDeletePaymentActionResponse extends StripeFunctionsActionResponse {
  /// [StripeFunctionsActionResponse] to delete a Stripe payment method.
  ///
  /// Stripeの支払い方法の削除を行うための[StripeFunctionsActionResponse]。
  const StripeDeletePaymentActionResponse();
}
