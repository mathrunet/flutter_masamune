part of '/masamune_purchase_stripe.dart';

/// [StripeFunctionsAction] to display the Stripe account dashboard.
///
/// Stripeのアカウントダッシュボードの表示を行うための[StripeFunctionsAction]。
class StripeDashboardAccountAction
    extends StripeFunctionsAction<StripeDashboardAccountActionResponse> {
  /// [StripeFunctionsAction] to display the Stripe account dashboard.
  ///
  /// Stripeのアカウントダッシュボードの表示を行うための[StripeFunctionsAction]。
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
  StripeDashboardAccountActionResponse toResponse(DynamicMap map) {
    if (map.isEmpty) {
      throw Exception("Failed to get response from $mode.");
    }
    return StripeDashboardAccountActionResponse(
      endpoint: Uri.parse(map.get("endpoint", "")),
    );
  }
}

/// [StripeFunctionsActionResponse] to display the Stripe account dashboard.
///
/// Stripeのアカウントダッシュボードの表示を行うための[StripeFunctionsActionResponse]。
class StripeDashboardAccountActionResponse
    extends StripeFunctionsActionResponse {
  const StripeDashboardAccountActionResponse({required this.endpoint});

  /// Account dashboard endpoints.
  ///
  /// アカウントダッシュボードのエンドポイント。
  final Uri endpoint;
}
