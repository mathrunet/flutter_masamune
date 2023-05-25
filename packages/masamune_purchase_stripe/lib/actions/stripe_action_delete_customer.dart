part of masamune_purchase_stripe;

class StripeDeleteCustomerAction
    extends StripeAction<StripeDeleteCustomerActionResponse> {
  const StripeDeleteCustomerAction({
    required this.userId,
  });
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

class StripeDeleteCustomerActionResponse extends StripeActionResponse {
  const StripeDeleteCustomerActionResponse();
}
