part of masamune_purchase_stripe;

/// [StripeAction] to finalize the Stripe authorization.
///
/// Stripeのオーソリの確定を行うための[StripeAction]。
class StripeConfirmAuthorizationAction
    extends StripeAction<StripeConfirmAuthorizationActionResponse> {
  /// [StripeAction] to finalize the Stripe authorization.
  ///
  /// Stripeのオーソリの確定を行うための[StripeAction]。
  const StripeConfirmAuthorizationAction({
    required this.authorizedId,
  });

  /// Purchase ID for authorization.
  ///
  /// オーソリのための購入ID。
  final String authorizedId;

  @override
  final String mode = "confirm_authorization";

  @override
  DynamicMap? toMap() {
    return {
      "authorizedId": authorizedId,
    };
  }

  @override
  StripeConfirmAuthorizationActionResponse? toResponse(DynamicMap map) {
    if (map.isEmpty) {
      return null;
    }
    return const StripeConfirmAuthorizationActionResponse();
  }
}

/// [StripeActionResponse] to finalize the Stripe authorization.
///
/// Stripeのオーソリの確定を行うための[StripeActionResponse]。
class StripeConfirmAuthorizationActionResponse extends StripeActionResponse {
  /// [StripeActionResponse] to finalize the Stripe authorization.
  ///
  /// Stripeのオーソリの確定を行うための[StripeActionResponse]。
  const StripeConfirmAuthorizationActionResponse();
}
