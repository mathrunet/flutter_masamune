part of '/masamune_purchase_stripe.dart';

/// [StripeFunctionsAction] for capturing Stripe purchases.
///
/// Stripeの購入のキャプチャを行うための[StripeFunctionsAction]。
class StripeCapturePurchaseAction
    extends StripeFunctionsAction<StripeCapturePurchaseActionResponse> {
  /// [StripeFunctionsAction] for capturing Stripe purchases.
  ///
  /// Stripeの購入のキャプチャを行うための[StripeFunctionsAction]。
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
  StripeCapturePurchaseActionResponse toResponse(DynamicMap map) {
    if (map.isEmpty) {
      throw Exception("Failed to get response from $mode.");
    }
    return StripeCapturePurchaseActionResponse(
      purchaseId: map.get("purchaseId", ""),
    );
  }
}

/// [StripeFunctionsActionResponse] for Stripe purchase capture.
///
/// Stripeの購入キャプチャを行うための[StripeFunctionsActionResponse]。
class StripeCapturePurchaseActionResponse
    extends StripeFunctionsActionResponse {
  /// [StripeFunctionsActionResponse] for Stripe purchase capture.
  ///
  /// Stripeの購入キャプチャを行うための[StripeFunctionsActionResponse]。
  const StripeCapturePurchaseActionResponse({required this.purchaseId});

  /// Purchase ID.
  ///
  /// 購入ID。
  final String purchaseId;
}
