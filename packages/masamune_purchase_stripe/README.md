<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Purchase Stripe</h1>
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

# Masamune Purchase Stripe

## Usage

### Installation

1. Add the package to your project.

```bash
flutter pub add masamune_purchase_stripe
```

### Setup

2. Register the Stripe purchase adapter in your Masamune configuration.

```dart
// lib/main.dart

import 'package:masamune_purchase_stripe/masamune_purchase_stripe.dart';
import 'package:katana_functions_firebase/katana_functions_firebase.dart';
import 'package:katana_model_firestore/katana_model_firestore.dart';

final functionsAdapter = FirebaseFunctionsAdapter(
  options: DefaultFirebaseOptions.currentPlatform,
  region: FirebaseRegion.asiaNortheast1,
);

final modelAdapter = const FirestoreModelAdapter(
  options: DefaultFirebaseOptions.currentPlatform,
);

final masamuneAdapters = <MasamuneAdapter>[
  StripePurchaseMasamuneAdapter(
    callbackURLSchemeOrHost: Uri.parse('yourapp://stripe'),  // For 3D Secure redirects
    supportEmail: 'support@example.com',                     // Customer support email
    functionsAdapter: functionsAdapter,                      // Backend integration
    modelAdapter: modelAdapter,                              // Data persistence
  ),
];

void main() {
  runMasamuneApp(
    appRef: appRef,
    modelAdapter: modelAdapter,
    masamuneAdapters: masamuneAdapters,
    (appRef, _) => MasamuneApp(
      appRef: appRef,
      home: HomePage(),
    ),
  );
}
```

### Create Stripe Customer

3. Create or update a Stripe customer with payment method:

```dart
class PaymentSetupPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final functions = ref.app.functions();

    return ElevatedButton(
      onPressed: () async {
        try {
          // Create/update Stripe customer and payment method
          await functions.execute(
            StripeActionCreateCustomerAndPayment(
              email: 'user@example.com',
              paymentMethodId: 'pm_xxx',  // From Stripe.js or mobile SDK
            ),
          );
          print("Payment method saved!");
        } catch (e) {
          print("Failed to save payment: $e");
        }
      },
      child: const Text("Save Payment Method"),
    );
  }
}
```

### Process a Purchase

4. Initiate a purchase or subscription:

```dart
Future<void> purchasePremium() async {
  final functions = ref.app.functions();
  
  try {
    final result = await functions.execute(
      StripeActionCreatePurchase(
        amount: 1200,                           // Amount in smallest currency unit (e.g., cents)
        currency: StripeCurrency.jpy,          // Currency
        description: 'Premium Plan - Monthly', // Purchase description
        metadata: {                             // Optional metadata
          'plan': 'premium',
          'period': 'monthly',
        },
      ),
    );
    
    print("Purchase successful: ${result.purchaseId}");
    // Navigate to success page
  } on StripePaymentException catch (e) {
    print("Payment failed: ${e.message}");
    // Show error dialog
  }
}
```

### Track Purchase State

5. Use the generated models to track purchases and payment status:

```dart
class PurchaseHistoryPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    // Load user's purchases
    final purchases = ref.app.model(
      StripePurchaseModel.collection(userId: currentUserId),
    )..load();

    return ListView.builder(
      itemCount: purchases.length,
      itemBuilder: (context, index) {
        final purchase = purchases[index].value;
        return ListTile(
          title: Text(purchase?.description ?? ''),
          subtitle: Text('${purchase?.amount} ${purchase?.currency}'),
          trailing: Text(purchase?.status ?? ''),
        );
      },
    );
  }
}
```

### Backend Implementation

Your Cloud Functions must implement Stripe integration:

```typescript
// Cloud Functions
export const stripe = functions.https.onCall(async (data, context) => {
  const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY);
  
  switch (data.action) {
    case "create_customer_and_payment":
      // Create Stripe customer and attach payment method
      const customer = await stripe.customers.create({
        email: data.email,
      });
      await stripe.paymentMethods.attach(data.paymentMethodId, {
        customer: customer.id,
      });
      return { customerId: customer.id };
      
    case "create_purchase":
      // Create payment intent
      const paymentIntent = await stripe.paymentIntents.create({
        amount: data.amount,
        currency: data.currency,
        description: data.description,
        metadata: data.metadata,
      });
      return { purchaseId: paymentIntent.id };
  }
});
```

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)