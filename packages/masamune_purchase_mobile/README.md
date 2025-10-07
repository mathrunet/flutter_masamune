<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Purchase Mobile</h1>
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

### Register the Adapter

Configure `MobilePurchaseMasamuneAdapter` with your products and backend integration.

```dart
// lib/adapter.dart

import 'package:masamune_purchase_mobile/masamune_purchase_mobile.dart';
import 'package:katana_functions_firebase/katana_functions_firebase.dart';
import 'package:katana_model_firestore/katana_model_firestore.dart';

final functionsAdapter = FirebaseFunctionsAdapter(
  options: DefaultFirebaseOptions.currentPlatform,
  region: FirebaseRegion.asiaNortheast1,
);

final modelAdapter = FirestoreModelAdapter(
  options: DefaultFirebaseOptions.currentPlatform,
);

/// Masamune adapters used in the application.
final masamuneAdapters = <MasamuneAdapter>[
  const UniversalMasamuneAdapter(),

  MobilePurchaseMasamuneAdapter(
    products: const [
      // Subscription product
      PurchaseProduct.subscription(
        productId: "premium_monthly",          // Must match App Store/Play Console
        title: LocalizedValue("Premium Monthly"),
        description: LocalizedValue("Unlock all features"),
        period: PurchaseSubscriptionPeriod.month,
      ),
      
      // Non-consumable (one-time purchase)
      PurchaseProduct.nonConsumable(
        productId: "lifetime_unlock",
        title: LocalizedValue("Lifetime Access"),
      ),
      
      // Consumable (coins, credits)
      PurchaseProduct.consumable(
        productId: "coin_pack_100",
        title: LocalizedValue("100 Coins"),
        amount: 100,
      ),
    ],
    onRetrieveUserId: () => currentUserId,    // Current authenticated user ID
    functionsAdapter: functionsAdapter,       // For backend validation
    modelAdapter: modelAdapter,               // For storing purchases
    initializeOnBoot: true,                   // Auto-initialize on app start
  ),
];
```

**Important**: Product IDs must match exactly with those configured in Google Play Console and App Store Connect.

### Display Products and Purchase

Use the `Purchase` controller to load and display available products:

```dart
class StorePage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final purchase = ref.app.controller(Purchase.query());

    // Initialize on page load
    ref.page.on(
      initOrUpdate: () {
        purchase.initialize();
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text("Store")),
      body: purchase.initialized
          ? ListView.builder(
              itemCount: purchase.products.length,
              itemBuilder: (context, index) {
                final product = purchase.products[index];
                
                return ListTile(
                  title: Text(product.title.value),
                  subtitle: Text(product.description.value),
                  trailing: ElevatedButton(
                    onPressed: () async {
                      try {
                        await purchase.purchase(
                          product: product,
                          onDone: () {
                            print("Purchase completed!");
                            // Show success dialog
                          },
                        );
                      } catch (e) {
                        print("Purchase failed: $e");
                        // Show error dialog
                      }
                    },
                    child: Text(product.price ?? "Buy"),
                  ),
                );
              },
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
```

### Restore Purchases

Allow users to restore previous purchases:

```dart
ElevatedButton(
  onPressed: () async {
    await purchase.restore();
    print("Purchases restored");
  },
  child: const Text("Restore Purchases"),
)
```

### Backend Validation

Your Cloud Functions must validate purchase receipts with Google Play or App Store:

**Android Validation (TypeScript)**:

```typescript
// Cloud Functions
import { google } from 'googleapis';

export const validateAndroidPurchase = functions.https.onCall(async (data, context) => {
  const { packageName, productId, purchaseToken } = data;
  
  // Verify with Google Play Billing API
  const androidPublisher = google.androidpublisher('v3');
  const response = await androidPublisher.purchases.products.get({
    packageName,
    productId,
    token: purchaseToken,
    auth: googleAuth,
  });
  
  const isValid = response.data.purchaseState === 0;  // 0 = purchased
  
  if (isValid) {
    // Grant entitlement to user
    await grantPurchase(data.userId, productId);
  }
  
  return { result: isValid };
});
```

**iOS Validation (TypeScript)**:

```typescript
// Cloud Functions
export const validateIosPurchase = functions.https.onCall(async (data, context) => {
  const { receiptData, productId } = data;
  
  // Verify with App Store Server API
  const response = await axios.post(
    'https://buy.itunes.apple.com/verifyReceipt',  // or sandbox URL for testing
    {
      'receipt-data': receiptData,
      'password': process.env.APP_STORE_SHARED_SECRET,
    }
  );
  
  const isValid = response.data.status === 0;
  
  if (isValid) {
    await grantPurchase(data.userId, productId);
  }
  
  return { result: isValid };
});
```

**StoreKit 2 Support**: The adapter automatically detects StoreKit v1/v2 and sends appropriate payloads (`transactionId`, `receiptData`, `storeKitVersion`).

### Check User Entitlements

Query purchase models to check user access:

```dart
class PremiumFeaturePage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final purchaseUser = ref.app.model(
      PurchaseUserModel.document(userId: currentUserId),
    )..load();

    final hasPremium = purchaseUser.value?.hasPremiumAccess ?? false;

    return hasPremium
        ? PremiumContent()
        : UpgradePrompt();
  }
}
```

### Custom Delegates

Provide delegates for purchase lifecycle events:

```dart
// Consumable purchases (coins, credits)
class CoinsDelegate extends ConsumablePurchaseDelegate {
  @override
  Future<void> onDelivered({
    required PurchaseProduct product,
    required double amount,
  }) async {
    await userRepository.addCoins(currentUserId, amount.toInt());
  }
}

// Subscription purchases
class PremiumDelegate extends SubscriptionPurchaseDelegate {
  @override
  Future<void> onActivated({required PurchaseProduct product}) async {
    await userRepository.setPremiumStatus(currentUserId, true);
  }
  
  @override
  Future<void> onExpired({required PurchaseProduct product}) async {
    await userRepository.setPremiumStatus(currentUserId, false);
  }
}
```

Pass delegates to the adapter:

```dart
MobilePurchaseMasamuneAdapter(
  products: [...],
  consumableDelegate: CoinsDelegate(),
  subscriptionDelegate: PremiumDelegate(),
  ...
)
```

### Platform Setup

**Google Play Console**:
1. Create in-app products in Play Console
2. Note the product IDs
3. Set up a service account for API access
4. Upload a signed build to internal testing track

**App Store Connect**:
1. Create in-app purchases in App Store Connect
2. Note the product IDs
3. Set up banking and tax information
4. Create sandbox tester accounts for testing

### Testing

**Android**: Use internal testing track in Play Console

```dart
MobilePurchaseMasamuneAdapter(
  products: [...],
  automaticallyConsumeOnAndroid: true,  // Auto-consume for testing
)
```

**iOS**: Use sandbox testers or StoreKit Configuration files

```dart
MobilePurchaseMasamuneAdapter(
  products: [...],
  iosSandboxTesting: true,  // Enable sandbox mode
)
```

### Troubleshooting

- Ensure product IDs match exactly between code and store configurations
- Check that products are in "Active" state in store consoles
- Verify backend Functions are deployed and accessible
- Test restore functionality for subscription recovery
- Handle purchase exceptions gracefully with user-friendly error messages

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)