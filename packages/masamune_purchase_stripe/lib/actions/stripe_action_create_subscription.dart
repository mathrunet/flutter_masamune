part of masamune_purchase_stripe;

/// [StripeAction] for creating a Stripe subscription.
///
/// Stripeのサブスクリプションの作成を行うための[StripeAction]。
class StripeCreateSubscriptionAction
    extends StripeAction<StripeCreateSubscriptionActionResponse> {
  /// [StripeAction] for creating a Stripe subscription.
  ///
  /// Stripeのサブスクリプションの作成を行うための[StripeAction]。
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
  StripeCreateSubscriptionActionResponse? toResponse(DynamicMap map) {
    if (map.isEmpty) {
      return null;
    }
    return StripeCreateSubscriptionActionResponse(
      endpoint: Uri.parse(map.get("endpoint", "")),
    );
  }
}

/// [StripeActionResponse] for creating a Stripe subscription.
///
/// Stripeのサブスクリプションの作成を行うための[StripeActionResponse]。
class StripeCreateSubscriptionActionResponse extends StripeActionResponse {
  /// [StripeActionResponse] for creating a Stripe subscription.
  ///
  /// Stripeのサブスクリプションの作成を行うための[StripeActionResponse]。
  const StripeCreateSubscriptionActionResponse({required this.endpoint});

  /// An endpoint for entering purchase information.
  ///
  /// 購入情報を入力するエンドポイント。
  final Uri endpoint;
}
