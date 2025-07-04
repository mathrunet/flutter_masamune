part of "/masamune_purchase_stripe.dart";

/// [StripeFunctionsAction] for creating Stripe purchase information.
///
/// Stripeの購入情報の作成を行うための[StripeFunctionsAction]。
class StripeCreatePurchaseAction
    extends StripeFunctionsAction<StripeCreatePurchaseActionResponse> {
  /// [StripeFunctionsAction] for creating Stripe purchase information.
  ///
  /// Stripeの購入情報の作成を行うための[StripeFunctionsAction]。
  const StripeCreatePurchaseAction({
    required this.userId,
    required this.priceAmount,
    required this.orderId,
    required this.email,
    this.revenueAmount = 0.0,
    this.currency = StripeCurrency.usd,
    this.targetUserId,
    this.description,
    this.locale = const Locale("en", "US"),
  });

  /// The user ID under which the purchase is made.
  ///
  /// 購入を行うユーザーID。
  final String userId;

  /// Purchase Amount.
  ///
  /// 購入金額。
  final double priceAmount;

  /// Rate collected by the operator.
  ///
  /// 運営側の徴収レート。
  final double revenueAmount;

  /// Currency.
  ///
  /// 通貨。
  final StripeCurrency currency;

  /// Selling user ID in case of user-to-user payment.
  ///
  /// ユーザー間の決済の場合の販売ユーザーID。
  final String? targetUserId;

  /// Order ID.
  ///
  /// オーダーID。
  final String orderId;

  /// Product Description.
  ///
  /// 商品の説明。
  final String? description;

  /// Email settings for 3D Secure.
  ///
  /// 3Dセキュアを行うためのメール設定。
  final StripeMail email;

  /// Purchasing side locale.
  ///
  /// 購入側のロケール。
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
  StripeCreatePurchaseActionResponse toResponse(DynamicMap map) {
    if (map.isEmpty) {
      throw Exception("Failed to get response from $mode.");
    }
    return StripeCreatePurchaseActionResponse(
      purchaseId: map.get("purchaseId", ""),
    );
  }
}

/// [StripeFunctionsActionResponse] for creating Stripe purchase information.
///
/// Stripeの購入情報の作成を行うための[StripeFunctionsActionResponse]。
class StripeCreatePurchaseActionResponse extends StripeFunctionsActionResponse {
  /// [StripeFunctionsActionResponse] for creating Stripe purchase information.
  ///
  /// Stripeの購入情報の作成を行うための[StripeFunctionsActionResponse]。
  const StripeCreatePurchaseActionResponse({required this.purchaseId});

  /// Purchase ID created.
  ///
  /// 作成された購入ID。
  final String purchaseId;
}
