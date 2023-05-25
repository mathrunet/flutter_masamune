part of masamune_purchase_stripe;

class StripeDeleteAccountAction
    extends StripeAction<StripeDeleteAccountActionResponse> {
  const StripeDeleteAccountAction({
    required this.userId,
  });
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

class StripeDeleteAccountActionResponse extends StripeActionResponse {
  const StripeDeleteAccountActionResponse();
}
