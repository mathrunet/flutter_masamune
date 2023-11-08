part of '/masamune_purchase_stripe.dart';

/// [StripeFunctionsAction] to delete a Stripe customer.
///
/// Stripeのカスタマーの削除を行うための[StripeFunctionsAction]。
class StripeDeleteCustomerAction
    extends StripeFunctionsAction<StripeDeleteCustomerActionResponse> {
  /// [StripeFunctionsAction] to delete a Stripe customer.
  ///
  /// Stripeのカスタマーの削除を行うための[StripeFunctionsAction]。
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
  StripeDeleteCustomerActionResponse toResponse(DynamicMap map) {
    return const StripeDeleteCustomerActionResponse();
  }
}

/// [StripeFunctionsActionResponse] to delete a Stripe customer.
///
/// Stripeのカスタマーの削除を行うための[StripeFunctionsActionResponse]。
class StripeDeleteCustomerActionResponse extends StripeFunctionsActionResponse {
  /// [StripeFunctionsActionResponse] to delete a Stripe customer.
  ///
  /// Stripeのカスタマーの削除を行うための[StripeFunctionsActionResponse]。
  const StripeDeleteCustomerActionResponse();
}
