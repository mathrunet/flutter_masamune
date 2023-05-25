part of masamune_purchase_stripe;

class StripeConfirmAuthorizationAction
    extends StripeAction<StripeConfirmAuthorizationActionResponse> {
  const StripeConfirmAuthorizationAction({
    required this.authorizedId,
  });
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

class StripeConfirmAuthorizationActionResponse extends StripeActionResponse {
  const StripeConfirmAuthorizationActionResponse();
}
