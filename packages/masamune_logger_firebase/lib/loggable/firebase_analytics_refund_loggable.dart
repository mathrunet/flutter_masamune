part of "/masamune_logger_firebase.dart";

/// Loggable for Firebase Analytics Refund.
///
/// Firebase Analytics 返品用の Loggable。
class FirebaseAnalyticsRefundLoggable extends Loggable {
  /// Loggable for Firebase Analytics Refund.
  ///
  /// Firebase Analytics 返品用の Loggable。
  const FirebaseAnalyticsRefundLoggable({
    required this.products,
    this.totalPrice,
    this.currency,
    this.transactionId,
  });

  /// Products.
  ///
  /// 商品。
  final List<FirebaseAnalyticsPurchasedProduct> products;

  /// Total Refund Amount.
  ///
  /// 返金額合計。
  final double? totalPrice;

  /// Currency.
  ///
  /// 通貨。
  final String? currency;

  /// Transaction ID.
  ///
  /// トランザクションID。
  final String? transactionId;

  @override
  String get name => FirebaseAnalyticsLoggerEvent.refund.toString();

  @override
  Map<String, dynamic> toJson() {
    return {
      FirebaseAnalyticsLoggerEvent.productsKey:
          products.map((e) => e.toJson()).toList(),
      if (totalPrice != null) FirebaseAnalyticsLoggerEvent.priceKey: totalPrice,
      if (currency != null) FirebaseAnalyticsLoggerEvent.currencyKey: currency,
      if (transactionId != null)
        FirebaseAnalyticsLoggerEvent.transactionIdKey: transactionId,
    };
  }
}
