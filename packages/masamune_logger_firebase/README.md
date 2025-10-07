<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Logger</h1>
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

# Masamune Logger Firebase

## Usage

### Installation

Add the package to your project.

```bash
flutter pub add masamune_logger_firebase
```

Run `flutter pub get` after editing `pubspec.yaml` manually.

### Register the Adapter

Set up Masamune adapters before running the app. Provide `FirebaseOptions` per platform if you need to override the default Firebase configuration.

```dart
import 'package:masamune/masamune.dart';
import 'package:masamune_logger_firebase/masamune_logger_firebase.dart';

final masamuneAdapters = <MasamuneAdapter>[
  const UniversalMasamuneAdapter(),
  const FirebaseLoggerMasamuneAdapter(
    options: FirebaseOptions(
      apiKey: "YOUR_API_KEY",
      appId: "YOUR_APP_ID",
      messagingSenderId: "YOUR_SENDER_ID",
      projectId: "YOUR_PROJECT_ID",
    ),
  ),
];
```

`FirebaseLoggerMasamuneAdapter` initializes Firebase, attaches Crashlytics error handling, and exposes analytics/performance instances through `FirebaseLoggerMasamuneAdapter.primary`.

### Logging Events

Use the provided loggable classes or send events via the logger API. The adapter automatically adds navigation observers and routes log events to Firebase Analytics.

```dart
await logger.send(const FirebaseAnalyticsSignInLoggable(
  userId: "user_123",
  providerId: "google.com",
));

await logger.send(const FirebaseAnalyticsPurchasedLoggable(
  transactionId: "order-001",
  currency: "USD",
  price: 9.99,
  products: [
    FirebaseAnalyticsPurchaseProduct(
      id: "sku-1",
      name: "Premium Plan",
      price: 9.99,
      quantity: 1,
    ),
  ],
));
```

Performance traces can also be instrumented via the Masamune logging API:

```dart
final trace = logger.trace("load_profile");
await trace.start();
// Execute the operation you want to measure.
await trace.stop();
```

### Crashlytics

Crash reports are captured automatically when the adapter is registered. To send a test crash, call `FirebaseLoggerAdapter.primary.crash()` after confirming Crashlytics integration.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)