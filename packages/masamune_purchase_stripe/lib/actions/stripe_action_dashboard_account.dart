part of masamune_purchase_stripe;

class StripeDashboardAccountAction
    extends StripeAction<StripeDashboardAccountActionResponse> {
  const StripeDashboardAccountAction({
    required this.userId,
  });
  final String userId;

  @override
  final String mode = "dashboard_account";

  @override
  DynamicMap? toMap() {
    return {
      "userId": userId,
    };
  }

  @override
  StripeDashboardAccountActionResponse? toResponse(DynamicMap map) {
    if (map.isEmpty) {
      return null;
    }
    return StripeDashboardAccountActionResponse(
      endpoint: Uri.parse(map.get("endpoint", "")),
    );
  }
}

class StripeDashboardAccountActionResponse extends StripeActionResponse {
  const StripeDashboardAccountActionResponse({required this.endpoint});

  final Uri endpoint;
}
