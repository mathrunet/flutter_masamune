part of '/masamune_purchase_stripe.dart';

/// [StripeFunctionsAction] to update payment information for Stripe purchases.
///
/// Stripeの購入の支払い情報の更新を行うための[StripeFunctionsAction]。
class StripeRefreshPurchaseAction
    extends StripeFunctionsAction<StripeRefreshPurchaseActionResponse> {
  /// [StripeFunctionsAction] to update payment information for Stripe purchases.
  ///
  /// Stripeの購入の支払い情報の更新を行うための[StripeFunctionsAction]。
  const StripeRefreshPurchaseAction({
    required this.userId,
    required this.orderId,
  });

  /// Purchased user ID.
  ///
  /// 購入したユーザーID。
  final String userId;

  /// Order ID.
  ///
  /// オーダーID。
  final String orderId;

  @override
  final String mode = "refresh_purchase";

  @override
  DynamicMap? toMap() {
    return {
      "userId": userId,
      "orderId": orderId,
    };
  }

  @override
  StripeRefreshPurchaseActionResponse toResponse(DynamicMap map) {
    return const StripeRefreshPurchaseActionResponse();
  }
}

/// [StripeFunctionsActionResponse] to update payment information for Stripe purchases.
///
/// Stripeの購入の支払い情報の更新を行うための[StripeFunctionsActionResponse]。
class StripeRefreshPurchaseActionResponse
    extends StripeFunctionsActionResponse {
  /// [StripeFunctionsActionResponse] to update payment information for Stripe purchases.
  ///
  /// Stripeの購入の支払い情報の更新を行うための[StripeFunctionsActionResponse]。
  const StripeRefreshPurchaseActionResponse();
}
