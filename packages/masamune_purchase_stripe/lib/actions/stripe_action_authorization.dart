part of masamune_purchase_stripe;

class StripeAuthorizationAction
    extends StripeAction<StripeAuthorizationActionResponse> {
  const StripeAuthorizationAction({
    required this.userId,
    required this.priceAmount,
    this.currency = StripeCurrency.usd,
    this.online = true,
    required this.email,
    required this.returnUrl,
  });

  final String userId;
  final double priceAmount;
  final StripeCurrency currency;
  final StripeMail email;
  final bool online;
  final Uri returnUrl;

  @override
  final String mode = "authorization";

  @override
  DynamicMap? toMap() {
    return {
      "userId": userId,
      "amount": priceAmount,
      "currency": currency.name,
      "returnUrl": returnUrl.toString(),
      "online": online ? "true" : "false",
      "emailFrom": email.from,
      "emailTitle": email.title,
      "emailContent": email.content,
    };
  }

  @override
  StripeAuthorizationActionResponse? toResponse(DynamicMap map) {
    if (map.isEmpty) {
      return null;
    }
    return StripeAuthorizationActionResponse(
      authorizedId: map.get("authorizedId", ""),
      nextActionUrl: Uri.tryParse(map.get("url", "")),
      returnUrl: Uri.tryParse(map.get("returnUrl", "")),
    );
  }
}

class StripeAuthorizationActionResponse extends StripeActionResponse {
  const StripeAuthorizationActionResponse({
    required this.authorizedId,
    required this.nextActionUrl,
    this.returnUrl,
  });

  final String authorizedId;
  final Uri? nextActionUrl;
  final Uri? returnUrl;
}
