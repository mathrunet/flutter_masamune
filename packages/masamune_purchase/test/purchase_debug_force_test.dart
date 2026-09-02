// Flutter imports:
import "package:flutter/foundation.dart";

// Package imports:
import "package:masamune_purchase/masamune_purchase.dart";
import "package:test/test.dart";

void main() {
  group("Purchase debug force state", () {
    late bool nonConsumableActive;
    late bool subscriptionActive;
    late int nonConsumableSaveCount;
    late int subscriptionSaveCount;
    late int subscriptionRevokeCount;
    late List<PurchaseProduct> products;
    late RuntimePurchaseMasamuneAdapter adapter;

    setUp(() {
      nonConsumableActive = false;
      subscriptionActive = true;
      nonConsumableSaveCount = 0;
      subscriptionSaveCount = 0;
      subscriptionRevokeCount = 0;
      products = [
        const PurchaseProduct.unlock(
          productId: "unlock",
          price: 100,
        ),
        const PurchaseProduct.subscription(
          productId: "subscription",
          price: 500,
          expiredPeriod: Duration(days: 30),
        ),
        const PurchaseProduct.wallet(
          productId: "wallet",
          amount: 10,
          price: 100,
        ),
      ];
      adapter = RuntimePurchaseMasamuneAdapter(
        products: products,
        onRetrieveUserId: () => "user",
        consumablePurchaseDelegate: ConsumablePurchaseDelegate(
          onRetrieveDocument: (product, userId) => null,
          onRetrieveValue: (document, product, userId) => 0,
          onSaveDocument: (document, product, userId) async {},
        ),
        nonConsumablePurchaseDelegate: NonConsumablePurchaseDelegate(
          onRetrieveDocument: (product, userId) => null,
          onRetrieveValue: (document, product, userId) => nonConsumableActive,
          onSaveDocument: (document, product, userId) async {
            nonConsumableSaveCount++;
          },
        ),
        subscriptionPurchaseDelegate: SubscriptionPurchaseDelegate(
          onRetrieveCollection: (product, userId) => null,
          onRetrieveValue: (collection, product, userId) => subscriptionActive,
          onSaveDocument:
              (document, product, userId, orderId, expiredTime) async {
            subscriptionSaveCount++;
          },
          onRevokeDocument: (document, product, userId) async {
            subscriptionRevokeCount++;
          },
        ),
      );
    });

    test("forces non-consumable and subscription values in memory", () async {
      final purchase = Purchase(adapter: adapter);
      await purchase.initialize();
      final unlock = purchase.findProductById("unlock")!;
      final subscription = purchase.findProductById("subscription")!;

      expect(unlock.value?.active, isFalse);
      expect(subscription.value?.active, isTrue);

      purchase.debugForcePurchase(products[0]);
      purchase.debugForceUnpurchase(products[1]);

      expect(unlock.value?.active, isTrue);
      expect(subscription.value?.active, isFalse);
      expect(nonConsumableSaveCount, isZero);
      expect(subscriptionSaveCount, isZero);
      expect(subscriptionRevokeCount, isZero);
    });

    test("keeps forced values after reload and clears them on recreation",
        () async {
      final purchase = Purchase(adapter: adapter);
      await purchase.initialize();
      purchase.debugForcePurchase(products[0]);
      purchase.debugForceUnpurchase(products[1]);

      nonConsumableActive = false;
      subscriptionActive = true;
      await purchase.reload();

      expect(purchase.findProductById("unlock")?.value?.active, isTrue);
      expect(purchase.findProductById("subscription")?.value?.active, isFalse);

      final recreated = Purchase(adapter: adapter);
      await recreated.initialize();

      expect(recreated.findProductById("unlock")?.value?.active, isFalse);
      expect(recreated.findProductById("subscription")?.value?.active, isTrue);
    });

    test("notifies the managed product and Purchase", () async {
      final purchase = Purchase(adapter: adapter);
      await purchase.initialize();
      final unlock = purchase.findProductById("unlock")! as Listenable;
      var productNotifications = 0;
      var purchaseNotifications = 0;
      unlock.addListener(() => productNotifications++);
      purchase.addListener(() => purchaseNotifications++);

      purchase.debugForcePurchase(products[0]);

      expect(productNotifications, 1);
      expect(purchaseNotifications, 1);
    });

    test("runtime override takes priority over debugForcePurchased", () async {
      const forcedProduct = PurchaseProduct.unlock(
        productId: "forced_unlock",
        price: 100,
        debugForcePurchased: true,
      );
      final forcedAdapter = RuntimePurchaseMasamuneAdapter(
        products: [forcedProduct],
        onRetrieveUserId: () => "user",
        nonConsumablePurchaseDelegate: NonConsumablePurchaseDelegate(
          onRetrieveDocument: (product, userId) => null,
          onRetrieveValue: (document, product, userId) => false,
          onSaveDocument: (document, product, userId) async {},
        ),
      );
      final purchase = Purchase(adapter: forcedAdapter);
      await purchase.initialize();

      expect(purchase.findProductById("forced_unlock")?.value?.active, isTrue);

      purchase.debugForceUnpurchase(forcedProduct);

      expect(purchase.findProductById("forced_unlock")?.value?.active, isFalse);
    });

    test("rejects calls before initialization and unsupported products",
        () async {
      final purchase = Purchase(adapter: adapter);

      expect(
        () => purchase.debugForcePurchase(products[0]),
        throwsStateError,
      );

      await purchase.initialize();

      expect(
        () => purchase.debugForcePurchase(products[2]),
        throwsArgumentError,
      );
      expect(
        () => purchase.debugForcePurchase(
          const PurchaseProduct.unlock(
            productId: "unknown",
            price: 100,
          ),
        ),
        throwsArgumentError,
      );
    });
  });
}
