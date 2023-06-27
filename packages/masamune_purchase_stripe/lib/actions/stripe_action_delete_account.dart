part of masamune_purchase_stripe;

/// [StripeFunctionsAction] to delete a Stripe account.
///
/// Stripeのアカウントの削除を行うための[StripeFunctionsAction]。
class StripeDeleteAccountAction
    extends StripeFunctionsAction<StripeDeleteAccountActionResponse> {
  /// [StripeFunctionsAction] to delete a Stripe account.
  ///
  /// Stripeのアカウントの削除を行うための[StripeFunctionsAction]。
  const StripeDeleteAccountAction({
    required this.userId,
  });

  /// User ID for account deletion.
  ///
  /// アカウントの削除を行うユーザーID。
  final String userId;

  @override
  final String mode = "delete_account";

  @override
  DynamicMap? toMap() {
    return {
      "userId": userId,
    };
  }

  @override
  StripeDeleteAccountActionResponse toResponse(DynamicMap map) {
    return const StripeDeleteAccountActionResponse();
  }
}

/// [StripeFunctionsActionResponse] to delete a Stripe account.
///
/// Stripeのアカウントの削除を行うための[StripeFunctionsActionResponse]。
class StripeDeleteAccountActionResponse extends StripeFunctionsActionResponse {
  /// [StripeFunctionsActionResponse] to delete a Stripe account.
  ///
  /// Stripeのアカウントの削除を行うための[StripeFunctionsActionResponse]。
  const StripeDeleteAccountActionResponse();
}
