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

## Overview

`masamune_purchase` is the base package for in-app purchase functionality in Masamune apps. It provides:
- Abstract purchase controllers and adapters
- Purchase product definitions
- Functions actions for backend validation
- Purchase models for persisting user entitlements
- Delegate interfaces for purchase lifecycle events

**Note**: This is the base package. You'll also need concrete implementations:
- `masamune_purchase_mobile` for Google Play / App Store (in-app purchases)
- `masamune_purchase_stripe` for Stripe-based web payments

## Usage

### Installation

```bash
flutter pub add masamune_purchase
flutter pub add masamune_purchase_mobile  # For mobile IAP
```

### Concrete Implementations

This base package provides the interfaces. Use concrete implementations:

**Mobile IAP** (`masamune_purchase_mobile`)
- Provides `MobilePurchaseMasamuneAdapter`
- Integrates with Google Play Billing and App Store
- Supports consumable, non-consumable, and subscription products
- See `masamune_purchase_mobile` package for setup

**Stripe Payments** (`masamune_purchase_stripe`)
- Provides `StripePurchaseMasamuneAdapter`
- Web-based payment flows
- See `masamune_purchase_stripe` package for setup

**Runtime Adapter** (Testing)
- `RuntimePurchaseMasamuneAdapter` - Mock purchases for testing

### Purchase Product Definitions

Define your products using `PurchaseProduct`:

**Subscription**:
```dart
PurchaseProduct.subscription(
  productId: "premium_monthly",
  title: LocalizedValue("Premium Monthly"),
  description: LocalizedValue("Unlock all features"),
  period: PurchaseSubscriptionPeriod.month,
)
```

**Non-Consumable** (one-time purchase):
```dart
PurchaseProduct.nonConsumable(
  productId: "lifetime_unlock",
  title: LocalizedValue("Lifetime Access"),
  description: LocalizedValue("Permanent access to all features"),
)
```

**Consumable** (coins, credits, etc.):
```dart
PurchaseProduct.consumable(
  productId: "coin_pack_100",
  title: LocalizedValue("100 Coins"),
  description: LocalizedValue("Get 100 coins"),
  amount: 100,
)
```

### Purchase Models

The package includes Masamune models for persisting purchase data:

**PurchaseUserModel**: Store user-level entitlements

```dart
final purchaseUser = ref.app.model(
  PurchaseUserModel.document(userId: currentUserId),
)..load();

// Check if user has premium access
final hasPremium = purchaseUser.value?.hasPremiumAccess ?? false;
```

**PurchaseSubscriptionModel**: Store subscription state

```dart
final subscription = ref.app.model(
  PurchaseSubscriptionModel.document(
    userId: currentUserId,
    subscriptionId: "premium_monthly",
  ),
)..load();

// Check subscription status
final isActive = subscription.value?.isActive ?? false;
final expiresAt = subscription.value?.expiresAt;
```

### Functions Actions

The package provides Functions actions for backend validation:

**Android**:
- `AndroidConsumablePurchaseFunctionsAction`
- `AndroidNonConsumablePurchaseFunctionsAction`
- `AndroidSubscriptionPurchaseFunctionsAction`

**iOS**:
- `IosConsumablePurchaseFunctionsAction`
- `IosNonConsumablePurchaseFunctionsAction`
- `IosSubscriptionPurchaseFunctionsAction`

These actions send purchase receipts to your backend for validation.

### Purchase Delegates

Define custom logic for purchase lifecycle events:

**ConsumablePurchaseDelegate**:
```dart
class CoinsDelegate extends ConsumablePurchaseDelegate {
  @override
  Future<void> onDelivered({
    required PurchaseProduct product,
    required double amount,
  }) async {
    // Credit coins to user account
    await userRepository.addCoins(userId, amount.toInt());
  }
}
```

**SubscriptionPurchaseDelegate**:
```dart
class PremiumDelegate extends SubscriptionPurchaseDelegate {
  @override
  Future<void> onActivated({required PurchaseProduct product}) async {
    // Grant premium access
    await userRepository.setPremiumStatus(userId, true);
  }
  
  @override
  Future<void> onExpired({required PurchaseProduct product}) async {
    // Revoke premium access
    await userRepository.setPremiumStatus(userId, false);
  }
}
```

### For Implementation Details

See the implementation-specific packages:
- `masamune_purchase_mobile` - Mobile IAP (Google Play / App Store) setup and usage
- `masamune_purchase_stripe` - Stripe payment integration

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)