part of masamune_purchase_stripe;

/// [StripeAction] to delete a Stripe subscription.
///
/// Stripeのサブスクリプションの削除を行うための[StripeAction]。
class StripeDeleteSubscriptionAction
    extends StripeAction<StripeDeleteSubscriptionActionResponse> {
  /// [StripeAction] to delete a Stripe subscription.
  ///
  /// Stripeのサブスクリプションの削除を行うための[StripeAction]。
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
  StripeDeleteSubscriptionActionResponse? toResponse(DynamicMap map) {
    if (map.isEmpty) {
      return null;
    }
    return const StripeDeleteSubscriptionActionResponse();
  }
}

/// [StripeActionResponse] to delete a Stripe subscription.
///
/// Stripeのサブスクリプションの削除を行うための[StripeActionResponse]。
class StripeDeleteSubscriptionActionResponse extends StripeActionResponse {
  /// [StripeActionResponse] to delete a Stripe subscription.
  ///
  /// Stripeのサブスクリプションの削除を行うための[StripeActionResponse]。
  const StripeDeleteSubscriptionActionResponse();
}
