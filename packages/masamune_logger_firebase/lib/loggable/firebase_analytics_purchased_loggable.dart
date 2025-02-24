part of '/masamune_logger_firebase.dart';

/// Loggable for Firebase Analytics Purchased.
///
/// Firebase Analytics 購入用の Loggable。
class FirebaseAnalyticsPurchasedLoggable extends Loggable {
  /// Loggable for Firebase Analytics Purchase.
  ///
  /// Firebase Analytics 購入用の Loggable。
  const FirebaseAnalyticsPurchasedLoggable({
    required this.products,
    this.totalPrice,
    this.currency,
    this.transactionId,
  });

  /// Products.
  ///
  /// 商品。
  final List<FirebaseAnalyticsPurchasedProduct> products;

  /// Total expenses.
  ///
  /// 費用合計。
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
  String get name => FirebaseAnalyticsLoggerEvent.purchased.toString();

  @override
  Map<String, dynamic> toJson() {
    return {
      FirebaseAnalyticsLoggerEvent.productsKey: products,
      if (totalPrice != null) FirebaseAnalyticsLoggerEvent.priceKey: totalPrice,
      if (currency != null) FirebaseAnalyticsLoggerEvent.currencyKey: currency,
      if (transactionId != null)
        FirebaseAnalyticsLoggerEvent.transactionIdKey: transactionId,
    };
  }
}

/// Loggable for Firebase Analytics Purchased Product.
///
/// Firebase Analytics 購入商品用の Loggable。
class FirebaseAnalyticsPurchasedProduct {
  /// Loggable for Firebase Analytics Purchased Product.
  ///
  /// Firebase Analytics 購入商品用の Loggable。
  const FirebaseAnalyticsPurchasedProduct({
    required this.productId,
    this.name,
    this.category,
    required this.price,
    this.quantity = 1,
  });

  /// Product ID.
  ///
  /// 商品ID。
  final String productId;

  /// Name.
  ///
  /// 商品名。
  final String? name;

  /// Category.
  ///
  /// カテゴリ。
  final String? category;

  /// Price.
  ///
  /// 価格。
  final double price;

  /// Quantity.
  ///
  /// 数量。
  final int quantity;

  Map<String, dynamic> toJson() {
    return {
      FirebaseAnalyticsLoggerEvent.idKey: productId,
      FirebaseAnalyticsLoggerEvent.priceKey: price,
      FirebaseAnalyticsLoggerEvent.quantityKey: quantity,
      if (name != null) FirebaseAnalyticsLoggerEvent.nameKey: name,
      if (category != null) FirebaseAnalyticsLoggerEvent.categoryKey: category,
    };
  }
}
