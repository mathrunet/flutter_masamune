part of masamune_purchase_stripe;

/// [StripeFunctionsAction] to finalize the Stripe authorization.
///
/// Stripeのオーソリの確定を行うための[StripeFunctionsAction]。
class StripeConfirmAuthorizationAction
    extends StripeFunctionsAction<StripeConfirmAuthorizationActionResponse> {
  /// [StripeFunctionsAction] to finalize the Stripe authorization.
  ///
  /// Stripeのオーソリの確定を行うための[StripeFunctionsAction]。
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
  StripeConfirmAuthorizationActionResponse toResponse(DynamicMap map) {
    return const StripeConfirmAuthorizationActionResponse();
  }
}

/// [StripeFunctionsActionResponse] to finalize the Stripe authorization.
///
/// Stripeのオーソリの確定を行うための[StripeFunctionsActionResponse]。
class StripeConfirmAuthorizationActionResponse
    extends StripeFunctionsActionResponse {
  /// [StripeFunctionsActionResponse] to finalize the Stripe authorization.
  ///
  /// Stripeのオーソリの確定を行うための[StripeFunctionsActionResponse]。
  const StripeConfirmAuthorizationActionResponse();
}
