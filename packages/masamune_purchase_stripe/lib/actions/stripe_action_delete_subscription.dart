part of '/masamune_purchase_stripe.dart';

/// [StripeFunctionsAction] to delete a Stripe subscription.
///
/// Stripeのサブスクリプションの削除を行うための[StripeFunctionsAction]。
class StripeDeleteSubscriptionAction
    extends StripeFunctionsAction<StripeDeleteSubscriptionActionResponse> {
  /// [StripeFunctionsAction] to delete a Stripe subscription.
  ///
  /// Stripeのサブスクリプションの削除を行うための[StripeFunctionsAction]。
  const StripeDeleteSubscriptionAction({
    required this.orderId,
  });

  /// Subscription Order ID.
  ///
  /// サブスクリプションのオーダーID。
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
  StripeDeleteSubscriptionActionResponse toResponse(DynamicMap map) {
    return const StripeDeleteSubscriptionActionResponse();
  }
}

/// [StripeFunctionsActionResponse] to delete a Stripe subscription.
///
/// Stripeのサブスクリプションの削除を行うための[StripeFunctionsActionResponse]。
class StripeDeleteSubscriptionActionResponse
    extends StripeFunctionsActionResponse {
  /// [StripeFunctionsActionResponse] to delete a Stripe subscription.
  ///
  /// Stripeのサブスクリプションの削除を行うための[StripeFunctionsActionResponse]。
  const StripeDeleteSubscriptionActionResponse();
}
