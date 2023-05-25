part of masamune_purchase_stripe;

class StripeCreatePurchaseAction
    extends StripeAction<StripeCreatePurchaseActionResponse> {
  const StripeCreatePurchaseAction({
    required this.userId,
    required this.priceAmount,
    this.revenueAmount = 0.0,
    this.currency = StripeCurrency.usd,
    this.targetUserId,
    required this.orderId,
    this.description,
    required this.email,
    this.locale = const Locale("en", "US"),
  });

  final String userId;
  final double priceAmount;
  final double revenueAmount;
  final StripeCurrency currency;
  final String? targetUserId;
  final String orderId;
  final String? description;
  final StripeMail email;
  final Locale locale;

  @override
  final String mode = "create_purchase";

  @override
  DynamicMap? toMap() {
    return {
      "userId": userId,
      "amount": priceAmount,
      "revenue": revenueAmount,
      "currency": currency.name,
      if (targetUserId != null) "targetUserId": targetUserId,
      "orderId": orderId,
      if (description != null) "description": description,
      "emailFrom": email.from,
      "emailTitle": email.title,
      "emailContent": email.content,
      "locale": "${locale.languageCode}_${locale.countryCode}",
    };
  }

  @override
  StripeCreatePurchaseActionResponse? toResponse(DynamicMap map) {
    if (map.isEmpty) {
      return null;
    }
    return StripeCreatePurchaseActionResponse(
      purchaseId: map.get("purchaseId", ""),
    );
  }
}

class StripeCreatePurchaseActionResponse extends StripeActionResponse {
  const StripeCreatePurchaseActionResponse({required this.purchaseId});

  final String purchaseId;
}
