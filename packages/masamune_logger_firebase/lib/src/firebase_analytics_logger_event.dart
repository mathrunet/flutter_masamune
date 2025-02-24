part of '/masamune_logger_firebase.dart';

/// FirebaseAnalytics events for logging.
///
/// FirebaseAnalytics用のログイベント。
enum FirebaseAnalyticsLoggerEvent {
  /// Ad shown.
  ///
  /// 広告表示。
  adShown,

  /// Purchased.
  ///
  /// 購入。
  purchased,

  /// Refund.
  ///
  /// 返金。
  refund,

  /// Tutorial start.
  ///
  /// チュートリアル開始。
  tutorialStart,

  /// Tutorial end.
  ///
  /// チュートリアル終了。
  tutorialEnd;

  /// Platform key.
  ///
  /// プラットフォームのキー。
  static const platformKey = "platform";

  /// Quantity key.
  ///
  /// 数量のキー。
  static const quantityKey = "quantity";

  /// Source key.
  ///
  /// ソースのキー。
  static const sourceKey = "source";

  /// Format key.
  ///
  /// フォーマットのキー。
  static const formatKey = "format";

  /// ID key.
  ///
  /// IDのキー。
  static const idKey = "id";

  /// Product name key.
  ///
  /// 商品名のキー。
  static const nameKey = "name";

  /// Product category key.
  ///
  /// 商品カテゴリのキー。
  static const categoryKey = "category";

  /// Price key.
  ///
  /// 価格のキー。
  static const priceKey = "price";

  /// Products key.
  ///
  /// 商品のキー。
  static const productsKey = "products";

  /// Value key.
  ///
  /// 値のキー。
  static const valueKey = "value";

  /// Currency key.
  ///
  /// 通貨のキー。
  static const currencyKey = "currency";

  /// Transaction ID key.
  ///
  /// トランザクションIDのキー。
  static const transactionIdKey = "transactionId";
}
