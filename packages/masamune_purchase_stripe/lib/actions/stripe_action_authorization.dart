part of masamune_purchase_stripe;

/// [StripeFunctionsAction] for Stripe authorization.
///
/// Stripeのオーソリを行うための[StripeFunctionsAction]。
class StripeAuthorizationAction
    extends StripeFunctionsAction<StripeAuthorizationActionResponse> {
  /// StripeAction] for Stripe authorization.
  ///
  /// Stripeのオーソリを行うための[StripeFunctionsAction]。
  const StripeAuthorizationAction({
    required this.userId,
    required this.priceAmount,
    this.currency = StripeCurrency.usd,
    this.online = true,
    required this.email,
    required this.returnUrl,
  });

  /// User ID of the subject of the authorization.
  ///
  /// オーソリを行う対象のユーザーID。
  final String userId;

  /// Amount of authorization to be performed.
  ///
  /// オーソリを行う金額。
  final double priceAmount;

  /// Currency of [priceAmount].
  ///
  /// [priceAmount]の通貨。
  final StripeCurrency currency;

  /// If [online] is `false`, 3D Secure authentication will be performed on the e-mail.
  ///
  /// Email information at that time.
  ///
  /// [online]が`false`の場合、3Dセキュア認証がメール上で行われます。
  ///
  /// その際のメール情報。
  final StripeMail email;

  /// If this is `true`, 3D Secure authentication is performed on Webview.
  ///
  /// If `false`, 3D Secure authentication will be performed on the e-mail.
  ///
  /// これが`true`の場合、3Dセキュア認証がWebview上で行われます。
  ///
  /// `false`の場合、3Dセキュア認証がメール上で行われます。
  final bool online;

  /// URL when the authorization is completed.
  ///
  /// オーソリが完了した場合のURL。
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
  StripeAuthorizationActionResponse toResponse(DynamicMap map) {
    if (map.isEmpty) {
      throw Exception("Failed to get response from $mode.");
    }
    return StripeAuthorizationActionResponse(
      authorizedId: map.get("authorizedId", ""),
      nextActionUrl: Uri.tryParse(map.get("url", "")),
      returnUrl: Uri.tryParse(map.get("returnUrl", "")),
    );
  }
}

/// [StripeFunctionsActionResponse] for Stripe authorization.
///
/// Stripeのオーソリを行うための[StripeFunctionsActionResponse]。
class StripeAuthorizationActionResponse extends StripeFunctionsActionResponse {
  /// [StripeFunctionsActionResponse] for Stripe authorization.
  ///
  /// Stripeのオーソリを行うための[StripeFunctionsActionResponse]。
  const StripeAuthorizationActionResponse({
    required this.authorizedId,
    required this.nextActionUrl,
    this.returnUrl,
  });

  /// Purchase ID for authorization.
  ///
  /// オーソリ用の購入ID。
  final String authorizedId;

  /// URL required for next action.
  ///
  /// 次のアクションに必要なURL。
  final Uri? nextActionUrl;

  /// Return URL.
  ///
  /// リターンURL。
  final Uri? returnUrl;
}
