<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Purchase</h1>
</p>

<p align="center">
  <a href="https://github.com/mathrunet">
    <img src="https://img.shields.io/static/v1?label=GitHub&message=Follow&logo=GitHub&color=333333&link=https://github.com/mathrunet" alt="Follow on GitHub" />
  </a>
  <a href="https://x.com/mathru">
    <img src="https://img.shields.io/static/v1?label=@mathru&message=Follow&logo=X&color=0F1419&link=https://x.com/mathru" alt="Follow on X" />
  </a>
  <a href="https://www.youtube.com/c/mathrunetchannel">
    <img src="https://img.shields.io/static/v1?label=YouTube&message=Follow&logo=YouTube&color=FF0000&link=https://www.youtube.com/c/mathrunetchannel" alt="Follow on YouTube" />
  </a>
  <a href="https://github.com/invertase/melos">
    <img src="https://img.shields.io/static/v1?label=maintained%20with&message=melos&color=FF1493&link=https://github.com/invertase/melos" alt="Maintained with Melos" />
  </a>
</p>

<p align="center">
  <a href="https://github.com/sponsors/mathrunet"><img src="https://img.shields.io/static/v1?label=Sponsor&message=%E2%9D%A4&logo=GitHub&color=ff69b4&link=https://github.com/sponsors/mathrunet" alt="GitHub Sponsor" /></a>
</p>

---

[[GitHub]](https://github.com/mathrunet) | [[YouTube]](https://www.youtube.com/c/mathrunetchannel) | [[Packages]](https://pub.dev/publishers/mathru.net/packages) | [[X]](https://x.com/mathru) | [[LinkedIn]](https://www.linkedin.com/in/mathrunet/) | [[mathru.net]](https://mathru.net)

---

# Masamune Purchase

## Usage

### Installation

Add the packages required for your target platforms.

```bash
# Core purchase models, controllers, and functions actions
flutter pub add masamune_purchase

# Mobile IAP adapter (Google Play / App Store)
flutter pub add masamune_purchase_mobile
```

Run `flutter pub get` after editing `pubspec.yaml` manually.

### Register Adapters

Register the purchase adapters with Masamune. The core package ships the abstract `PurchaseMasamuneAdapter`; the mobile package provides `MobilePurchaseMasamuneAdapter` that integrates with `in_app_purchase`.

```dart
// lib/adapter.dart

/// Masamune adapters used in the application.
final masamuneAdapters = <MasamuneAdapter>[
  const UniversalMasamuneAdapter(),
  const FunctionsMasamuneAdapter(),
  const ModelAdapter(),

  MobilePurchaseMasamuneAdapter(
    products: const [
      PurchaseProduct.subscription(
        productId: "premium_monthly",
        title: LocalizedValue("Premium Monthly"),
        description: LocalizedValue("Unlock all features."),
        period: PurchaseSubscriptionPeriod.month,
      ),
      PurchaseProduct.nonConsumable(
        productId: "lifetime_unlock",
        title: LocalizedValue("Lifetime Unlock"),
      ),
      PurchaseProduct.consumable(
        productId: "coin_pack_100",
        title: LocalizedValue("100 Coins"),
        amount: 100,
      ),
    ],
    onRetrieveUserId: () => authUserIdOrNull,
    functionsAdapter: const FunctionsMasamuneAdapter(),
    modelAdapter: const ModelAdapter(),
    initializeOnBoot: true,
  ),
];
```

Define all billable items in `products`. `onRetrieveUserId` must return the currently authenticated user ID (or `null` for guests).

### Initialize and Listen

Use the `Purchase` controller to initialize IAP, load products, and trigger purchases.

```dart
final purchase = ref.app.controller(Purchase.query());

await purchase.initialize();

// Observe products
final products = purchase.products;

// Find a specific product
final subscription = purchase.findProductById("premium_monthly");

await purchase.purchase(
  product: subscription,
  onDone: () => debugPrint("Purchase completed"),
);

await purchase.restore();
```

`Purchase.products` returns the validated product list populated from the store. Use `purchase.loading` or `purchase.initialized` to gate UI states.

### Backend Validation

The mobile adapter validates purchases through Cloud Functions. Implement the provided Functions actions on your server (`android_*_purchase_functions_action.dart`, `ios_*_purchase_functions_action.dart`). A minimal Dart Functions handler might look like:

```dart
Future<AndroidConsumablePurchaseFunctionsActionResponse> validateAndroidConsumable(
  AndroidConsumablePurchaseFunctionsAction action,
) async {
  final isValid = await googlePlayValidator.verify(
    packageName: action.packageName,
    productId: action.productId,
    purchaseToken: action.purchaseToken,
  );
  if (isValid) {
    await creditUser(action.documentId, action.amount);
  }
  return AndroidConsumablePurchaseFunctionsActionResponse(result: isValid);
}
```

Return `result: true` when the validation succeeds; otherwise the purchase is rejected and an exception is thrown on the client.

### iOS StoreKit 1/2 Support

The mobile adapter automatically detects StoreKit v1/v2 and sends appropriate payloads (`transactionId`, `receiptData`, `storeKitVersion`). Ensure your Functions handlers support both formats when verifying receipts with App Store Server APIs.

### Entitlements and Models

The core package includes Masamune models for persisting purchaser data:

- `Purchase.user` → document storing user-level entitlements
- `Purchase.subscription` → document storing subscription state and renewal dates

Use `ref.app.model(Purchase.user.document(userId))` to query or update entitlements in tandem with validation results.

### Custom Delegates

Provide delegates to hook into lifecycle events:

- `ConsumablePurchaseDelegate`
- `NonConsumablePurchaseDelegate`
- `SubscriptionPurchaseDelegate`

Example:

```dart
class CoinsDelegate extends ConsumablePurchaseDelegate {
  @override
  Future<void> onDelivered({required PurchaseProduct product, required double amount}) async {
    await coinsRepository.addCoins(amount.toInt());
  }
}
```

Pass delegates to `MobilePurchaseMasamuneAdapter` to execute additional business logic after validation succeeds.

### Testing Tips

- **Android**: upload a signed build to Play Console (internal testing) before querying products.
- **iOS**: configure App Store Connect, banking, tax info, and use Sandbox testers or StoreKit test certificates.
- Toggle `automaticallyConsumeOnAndroid` or `iosSandboxTesting` to match your test workflow.
- Use the mock runtime adapter (`RuntimePurchaseMasamuneAdapter`) for widget tests or platforms without native billing.

### Troubleshooting

- Ensure SKU identifiers in the store match `PurchaseProduct.productId`.
- Handle exceptions from `purchase.purchase` and surface user-friendly error messages.
- Verify Firestore/Database security rules if entitlements are stored server-side.
- Collect logs via `loggerAdapters` to audit billing events.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)