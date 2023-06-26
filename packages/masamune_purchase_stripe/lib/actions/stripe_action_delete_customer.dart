part of masamune_purchase_stripe;

/// [StripeAction] to delete a Stripe customer.
///
/// Stripeのカスタマーの削除を行うための[StripeAction]。
class StripeDeleteCustomerAction
    extends StripeAction<StripeDeleteCustomerActionResponse> {
  /// [StripeAction] to delete a Stripe customer.
  ///
  /// Stripeのカスタマーの削除を行うための[StripeAction]。
  const StripeDeleteCustomerAction({
    required this.userId,
  });

  /// User ID for deleting a customer.
  ///
  /// カスタマーの削除を行うユーザーID。
  final String userId;

  @override
  final String mode = "delete_customer";

  @override
  DynamicMap? toMap() {
    return {
      "userId": userId,
    };
  }

  @override
  StripeDeleteCustomerActionResponse? toResponse(DynamicMap map) {
    if (map.isEmpty) {
      return null;
    }
    return const StripeDeleteCustomerActionResponse();
  }
}

/// [StripeActionResponse] to delete a Stripe customer.
///
/// Stripeのカスタマーの削除を行うための[StripeActionResponse]。
class StripeDeleteCustomerActionResponse extends StripeActionResponse {
  /// [StripeActionResponse] to delete a Stripe customer.
  ///
  /// Stripeのカスタマーの削除を行うための[StripeActionResponse]。
  const StripeDeleteCustomerActionResponse();
}
