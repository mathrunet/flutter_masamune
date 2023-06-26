part of masamune_purchase_stripe;

/// [StripeAction] to display the Stripe account dashboard.
///
/// Stripeのアカウントダッシュボードの表示を行うための[StripeAction]。
class StripeDashboardAccountAction
    extends StripeAction<StripeDashboardAccountActionResponse> {
  /// [StripeAction] to display the Stripe account dashboard.
  ///
  /// Stripeのアカウントダッシュボードの表示を行うための[StripeAction]。
  const StripeDashboardAccountAction({
    required this.userId,
  });

  /// ID of the user who opens the account dashboard.
  ///
  /// アカウントダッシュボードを開くユーザーのID。
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

/// [StripeActionResponse] to display the Stripe account dashboard.
///
/// Stripeのアカウントダッシュボードの表示を行うための[StripeActionResponse]。
class StripeDashboardAccountActionResponse extends StripeActionResponse {
  const StripeDashboardAccountActionResponse({required this.endpoint});

  /// Account dashboard endpoints.
  ///
  /// アカウントダッシュボードのエンドポイント。
  final Uri endpoint;
}
