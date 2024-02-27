part of '/masamune_purchase.dart';

/// Actual data for [PurchaseProduct].
///
/// [PurchaseProduct]の実データ。
@immutable
class PurchaseProductValue {
  /// Actual data for [PurchaseProduct].
  ///
  /// [PurchaseProduct]の実データ。
  const PurchaseProductValue({
    this.amount = 0.0,
    this.active = false,
  });

  /// Current wallet value.
  ///
  /// The value is obtained in the billing item of [PurchaseProductType.consumable].
  ///
  /// 現在のウォレットの値。
  ///
  /// [PurchaseProductType.consumable]の課金アイテムにて値が取得されています。
  final double amount;

  /// Returns `true` if the function is currently enabled.
  ///
  /// The [PurchaseProductType.nonConsumable] and [PurchaseProductType.subscription] will tell you if the functionality is unlocked due to billing.
  ///
  /// 現在機能が有効な場合`true`を返します。
  ///
  /// [PurchaseProductType.nonConsumable]や[PurchaseProductType.subscription]で課金により機能がアンロックされてかどうかを知ることができます。
  final bool active;

  @override
  int get hashCode => amount.hashCode ^ active.hashCode;

  @override
  bool operator ==(Object other) => hashCode == other.hashCode;
}
