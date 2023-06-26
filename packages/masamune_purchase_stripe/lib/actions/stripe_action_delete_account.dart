part of masamune_purchase_stripe;

/// [StripeAction] to delete a Stripe account.
///
/// Stripeのアカウントの削除を行うための[StripeAction]。
class StripeDeleteAccountAction
    extends StripeAction<StripeDeleteAccountActionResponse> {
  /// [StripeAction] to delete a Stripe account.
  ///
  /// Stripeのアカウントの削除を行うための[StripeAction]。
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
  StripeDeleteAccountActionResponse? toResponse(DynamicMap map) {
    if (map.isEmpty) {
      return null;
    }
    return const StripeDeleteAccountActionResponse();
  }
}

/// [StripeActionResponse] to delete a Stripe account.
///
/// Stripeのアカウントの削除を行うための[StripeActionResponse]。
class StripeDeleteAccountActionResponse extends StripeActionResponse {
  /// [StripeActionResponse] to delete a Stripe account.
  ///
  /// Stripeのアカウントの削除を行うための[StripeActionResponse]。
  const StripeDeleteAccountActionResponse();
}
