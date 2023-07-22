part of masamune_purchase_mobile;

/// The key of the internal wallet when a [PurchaseProductType.consumable] chargeable item is purchased.
///
/// [PurchaseProductType.consumable]な課金アイテムを購入した場合の内部ウォレットのキー。
const kConsumableValueKey = "value";

/// A key used to determine if a [PurchaseProductType.subscription] chargeable item has been purchased and is within the expiration date.
///
/// [PurchaseProductType.subscription]な課金アイテムを購入した場合の有効期限内かどうかを判別するためのキー。
const kSubscriptionExpiredKey = "expired";

/// A key to identify the product ID.
///
/// プロダクトIDを判別するためのキー。
const kProductIdKey = "productId";

/// Defines the type of item being charged for.
///
/// 課金アイテムのタイプを定義します。
enum PurchaseProductType {
  /// Consumption type (wallet type)
  ///
  /// 消費型（ウォレットタイプ）
  consumable,

  /// Non-consumption type (function unlocked type)
  ///
  /// 非消費型（機能アンロックタイプ）
  nonConsumable,

  /// Subscription.
  ///
  /// サブスクリプション。
  subscription,
}
