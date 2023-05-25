part of masamune_purchase_stripe;

class StripeConfirmPurchaseAction
    extends StripeAction<StripeConfirmPurchaseActionResponse> {
  const StripeConfirmPurchaseAction({
    required this.userId,
    required this.orderId,
    required this.successUrl,
    required this.failureUrl,
    required this.returnUrl,
    this.online = true,
  });

  final String userId;
  final String orderId;
  final Uri successUrl;
  final Uri failureUrl;
  final Uri returnUrl;
  final bool online;

  @override
  final String mode = "confirm_purchase";

  @override
  DynamicMap? toMap() {
    return {
      "userId": userId,
      "orderId": orderId,
      "successUrl": successUrl.toString(),
      "failureUrl": failureUrl.toString(),
      "returnUrl": returnUrl.toString(),
      "online": online ? "true" : "false",
    };
  }

  @override
  StripeConfirmPurchaseActionResponse? toResponse(DynamicMap map) {
    if (map.isEmpty) {
      return null;
    }
    return StripeConfirmPurchaseActionResponse(
      purchaseId: map.get("purchaseId", ""),
      nextActionUrl: Uri.tryParse(map.get("url", "")),
      returnUrl: Uri.tryParse(map.get("returnUrl", "")),
    );
  }
}

class StripeConfirmPurchaseActionResponse extends StripeActionResponse {
  const StripeConfirmPurchaseActionResponse({
    required this.purchaseId,
    required this.nextActionUrl,
    this.returnUrl,
  });

  final String purchaseId;
  final Uri? nextActionUrl;
  final Uri? returnUrl;
}
