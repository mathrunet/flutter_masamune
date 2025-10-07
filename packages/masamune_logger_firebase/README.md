<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Logger Firebase</h1>
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

Set up `FirebaseLoggerMasamuneAdapter` before running the app. This adapter provides both logging (`FirebaseLoggerAdapter`) and integration with Firebase services.

```dart
// lib/adapter.dart

import 'package:masamune/masamune.dart';
import 'package:masamune_logger_firebase/masamune_logger_firebase.dart';

/// Logger adapters used by the application.
final loggerAdapters = <LoggerAdapter>[
  const FirebaseLoggerAdapter(),  // Add Firebase logger
];

/// Masamune adapters used by the application.
final masamuneAdapters = <MasamuneAdapter>[
  const UniversalMasamuneAdapter(),
  
  const FirebaseLoggerMasamuneAdapter(
    options: DefaultFirebaseOptions.currentPlatform,  // From firebase_options.dart
  ),
];
```

**Key Features**:
- Initializes Firebase automatically
- Attaches Crashlytics error handling to `FlutterError` and `PlatformDispatcher`
- Adds navigation observers for automatic screen tracking
- Exposes `FirebaseAnalytics`, `FirebaseCrashlytics`, and `FirebasePerformance` instances

Access the adapter via `FirebaseLoggerMasamuneAdapter.primary`.

### Logging Events

Use the logger API to send events to Firebase Analytics. The package provides pre-built loggable classes for common events.

**Sign-In Events**:

```dart
// Get the logger from your controller or page
final logger = LoggerAdapter.primary.first;

// Log user sign-in
await logger.send(const FirebaseAnalyticsSignInLoggable(
  userId: "user_123",
  providerId: "google.com",
));

// Log user registration
await logger.send(const FirebaseAnalyticsRegisterLoggable(
  userId: "user_456",
));
```

**Purchase Events**:

```dart
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

**Tutorial Events**:

```dart
// Tutorial started
await logger.send(const FirebaseAnalyticsTutorialStartLoggable());

// Tutorial completed
await logger.send(const FirebaseAnalyticsTutorialEndLoggable());
```

### Performance Monitoring

Use performance traces to measure operation durations:

```dart
final logger = LoggerAdapter.primary.first;

// Start a trace
final trace = logger.trace("load_profile");
await trace.start();

// Execute the operation you want to measure
await loadUserProfile();

// Stop the trace
await trace.stop();
```

### Crashlytics

Crash reports are captured automatically when the adapter is registered. The adapter hooks into `FlutterError.onError` and `PlatformDispatcher.onError`.

**Test Crashlytics Integration**:

```dart
// Force a test crash (only for testing!)
final logger = FirebaseLoggerAdapter.primary;
await logger.crash();
```

**Manual Error Reporting**:

```dart
try {
  // Your code
} catch (e, stackTrace) {
  await FirebaseCrashlytics.instance.recordError(e, stackTrace);
}
```

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)