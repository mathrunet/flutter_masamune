part of masamune_purchase;

/// Options for subscription.
@immutable
class SubscribeOptions {
  /// Options for subscription.
  const SubscribeOptions({
    this.data = const [],
    // this.task,
    // this.existOrderId,
    this.userIDKey = "user",
    this.expiryDateKey = "expiredTime",
    this.renewDuration = const Duration(hours: 2),
    this.purchaseIDKey = "purchaseId",
    this.tokenKey = "token",
    this.expiredKey = "expired",
    this.productIDKey = "productId",
    this.packageNameKey = "packageName",
    this.orderIDKey = "orderId",
    this.platformKey = "platform",
    this.subscriptionCollectionPath = "subscription",
  });

  /// Collection that stores log data for subscriptions.
  final List<DynamicMap> data;

  // /// Asynchronous data for the collection that contains the subscription log data.
  // final Future<List<DynamicMap>>? task;

  // /// Expiration date key.
  final String expiryDateKey;

  /// The time to start the update.
  final Duration renewDuration;

  /// User ID key
  final String userIDKey;

  /// Token key.
  final String tokenKey;

  /// Package name key.
  final String packageNameKey;

  /// Order ID key.
  final String orderIDKey;

  /// Product ID key.
  final String productIDKey;

  /// Platform key.
  final String platformKey;

  /// Purchase ID key.
  final String purchaseIDKey;

  /// Subscription collection path.
  final String subscriptionCollectionPath;

  /// Callback that returns True if the order id exists.
  // final Future<bool> Function(String orderId)? existOrderId;

  /// Expiration key.
  final String expiredKey;
}
