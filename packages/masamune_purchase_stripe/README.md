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

1. Add the package to your project.

```bash
flutter pub add masamune_purchase_stripe
```

Run `flutter pub get` after editing `pubspec.yaml` manually.

2. Register the Stripe purchase adapter in your Masamune configuration. Provide the Functions adapter for server-side integration, a model adapter for persisting Stripe models, the callback URL scheme/host, and a support email.

```dart
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
    callbackURLSchemeOrHost: Uri.parse('yourapp://stripe'),
    supportEmail: 'support@example.com',
    functionsAdapter: functionsAdapter,
    modelAdapter: modelAdapter,
  ),
];
```

3. Create Stripe actions to onboard accounts, store customer payment methods, and initiate purchases. These actions call your configured Firebase Functions.

```dart
final ref = StripePurchaseMasamuneAdapter.primary.appRef;

// Create or update Stripe customer and default payment method.
await ref.functions.execute(
  StripeActionCreateCustomerAndPayment(
    email: 'user@example.com',
    paymentMethodId: 'pm_xxx',
  ),
);

// Start a purchase flow.
final purchase = await ref.functions.execute(
  StripeActionCreatePurchase(
    amount: 1200,
    currency: StripeCurrency.jpy,
    description: 'Monthly subscription',
  ),
);
```

4. Use the generated models (`StripeUserModel`, `StripePurchaseModel`, `StripePaymentModel`) with your configured model adapter to track subscription state, payment status, and invoices inside your application.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)