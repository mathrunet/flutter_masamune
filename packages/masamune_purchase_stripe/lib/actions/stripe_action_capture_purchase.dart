part of masamune_purchase_stripe;

/// [StripeAction] for capturing Stripe purchases.
///
/// Stripeの購入のキャプチャを行うための[StripeAction]。
class StripeCapturePurchaseAction
    extends StripeAction<StripeCapturePurchaseActionResponse> {
  /// [StripeAction] for capturing Stripe purchases.
  ///
  /// Stripeの購入のキャプチャを行うための[StripeAction]。
  const StripeCapturePurchaseAction({
    required this.userId,
    required this.orderId,
    this.priceAmountOverride,
  });

  /// User ID for purchase capture.
  ///
  /// 購入キャプチャを行うユーザーID。
  final String userId;

  /// Order ID for purchase capture.
  ///
  /// 購入キャプチャを行うオーダーID。
  final String orderId;

  /// Specify the amount you want to override when performing the capture.
  ///
  /// キャプチャを行う際に金額を上書きする場合、その金額を指定します。
  final double? priceAmountOverride;

  @override
  final String mode = "capture_purchase";

  @override
  DynamicMap? toMap() {
    return {
      "userId": userId,
      "orderId": orderId,
      if (priceAmountOverride != null) "amount": priceAmountOverride,
    };
  }

  @override
  StripeCapturePurchaseActionResponse? toResponse(DynamicMap map) {
    if (map.isEmpty) {
      return null;
    }
    return StripeCapturePurchaseActionResponse(
      purchaseId: map.get("purchaseId", ""),
    );
  }
}

/// [StripeActionResponse] for Stripe purchase capture.
///
/// Stripeの購入キャプチャを行うための[StripeActionResponse]。
class StripeCapturePurchaseActionResponse extends StripeActionResponse {
  /// [StripeActionResponse] for Stripe purchase capture.
  ///
  /// Stripeの購入キャプチャを行うための[StripeActionResponse]。
  const StripeCapturePurchaseActionResponse({required this.purchaseId});

  /// Purchase ID.
  ///
  /// 購入ID。
  final String purchaseId;
}
