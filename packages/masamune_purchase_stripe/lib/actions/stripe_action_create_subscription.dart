part of masamune_purchase_stripe;

/// [StripeFunctionsAction] for creating a Stripe subscription.
///
/// Stripeのサブスクリプションの作成を行うための[StripeFunctionsAction]。
class StripeCreateSubscriptionAction
    extends StripeFunctionsAction<StripeCreateSubscriptionActionResponse> {
  /// [StripeFunctionsAction] for creating a Stripe subscription.
  ///
  /// Stripeのサブスクリプションの作成を行うための[StripeFunctionsAction]。
  const StripeCreateSubscriptionAction({
    required this.userId,
    required this.productId,
    required this.orderId,
    this.count = 1,
    required this.successUrl,
    required this.cancelUrl,
  });

  /// User ID to purchase.
  ///
  /// 購入するユーザーID。
  final String userId;

  /// Subscription product ID.
  ///
  /// サブスクリプションの商品ID。
  final String productId;

  /// Order ID.
  ///
  /// オーダーID。
  final String orderId;

  /// Specify the number of subscriptions.
  ///
  /// サブスクリプションの購読個数を指定します。
  final int count;

  /// Specify the callback URL for a successful purchase.
  ///
  /// 購入に成功した際のコールバックURLを指定します。
  final Uri successUrl;

  /// Specify the callback URL when the purchase is canceled.
  ///
  /// 購入がキャンセルされた際のコールバックURLを指定します。
  final Uri cancelUrl;

  @override
  final String mode = "create_subscription";

  @override
  DynamicMap? toMap() {
    return {
      "userId": userId,
      "productId": productId,
      "orderId": orderId,
      "count": count,
      "successUrl": successUrl.toString(),
      "cancelUrl": cancelUrl.toString(),
    };
  }

  @override
  StripeCreateSubscriptionActionResponse toResponse(DynamicMap map) {
    if (map.isEmpty) {
      throw Exception("Failed to get response from $mode.");
    }
    return StripeCreateSubscriptionActionResponse(
      endpoint: Uri.parse(map.get("endpoint", "")),
    );
  }
}

/// [StripeFunctionsActionResponse] for creating a Stripe subscription.
///
/// Stripeのサブスクリプションの作成を行うための[StripeFunctionsActionResponse]。
class StripeCreateSubscriptionActionResponse
    extends StripeFunctionsActionResponse {
  /// [StripeFunctionsActionResponse] for creating a Stripe subscription.
  ///
  /// Stripeのサブスクリプションの作成を行うための[StripeFunctionsActionResponse]。
  const StripeCreateSubscriptionActionResponse({required this.endpoint});

  /// An endpoint for entering purchase information.
  ///
  /// 購入情報を入力するエンドポイント。
  final Uri endpoint;
}
