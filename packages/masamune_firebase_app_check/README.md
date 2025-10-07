<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Firebase App Check</h1>
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

# Masamune Firebase App Check

## Usage

### Installation

Add the package to your project.

```bash
flutter pub add masamune_firebase_app_check
```

Run `flutter pub get` after editing `pubspec.yaml` manually.

### Register the Adapter

Configure Firebase App Check before bootstrapping your Masamune app. Provide Firebase options and choose the activation timing and providers.

```dart
// lib/adapter.dart

import 'package:masamune_firebase_app_check/masamune_firebase_app_check.dart';

/// Masamune adapters used by the application.
final masamuneAdapters = <MasamuneAdapter>[
  const UniversalMasamuneAdapter(),

  FirebaseAppCheckMasamuneAdapter(
    options: DefaultFirebaseOptions.currentPlatform,  // From firebase_options.dart
    activateTiming: FirebaseAppCheckActivateTiming.onPreRunApp,  // When to activate
    androidProvider: FirebaseAppCheckAndroidProvider.playIntegrity,  // Android provider
    iosProvider: FirebaseAppCheckIOSProvider.deviceCheck,           // iOS provider
  ),
];
```

**Platform-Specific Options**: Supply `iosOptions`, `androidOptions`, `webOptions`, etc. if defaults differ per platform:

```dart
FirebaseAppCheckMasamuneAdapter(
  options: DefaultFirebaseOptions.currentPlatform,
  iosOptions: DefaultFirebaseOptions.ios,      // iOS-specific config
  androidOptions: DefaultFirebaseOptions.android,  // Android-specific config
  androidProvider: FirebaseAppCheckAndroidProvider.playIntegrity,
  iosProvider: FirebaseAppCheckIOSProvider.appAttest,  // Or deviceCheck
)
```

### Activation Timing

The `activateTiming` parameter controls when `FirebaseAppCheck.activate()` runs:

| Timing | Description |
|--------|-------------|
| `onPreRunApp` (default) | Activates before `runApp()` is called |
| `onBoot` | Activates during `onMaybeBoot()` lifecycle |

```dart
FirebaseAppCheckMasamuneAdapter(
  options: DefaultFirebaseOptions.currentPlatform,
  activateTiming: FirebaseAppCheckActivateTiming.onPreRunApp,  // Recommended
)
```

The adapter automatically calls `Firebase.initializeApp` with the provided options before activating App Check.

### Providers

Choose the appropriate provider for each platform based on your app's requirements:

**Android Providers**:
- `playIntegrity` (recommended): Google Play Integrity API for production
- `debug`: For development and testing
- `platformDependent`: Automatically selects based on build mode

**iOS/macOS Providers**:
- `deviceCheck` (recommended): Apple's DeviceCheck API
- `appAttest`: More advanced attestation (iOS 14+)
- `debug`: For development and testing
- `platformDependent`: Automatically selects based on build mode

```dart
FirebaseAppCheckMasamuneAdapter(
  options: DefaultFirebaseOptions.currentPlatform,
  // Production setup
  androidProvider: FirebaseAppCheckAndroidProvider.playIntegrity,
  iosProvider: FirebaseAppCheckIOSProvider.deviceCheck,
  
  // Or use debug providers during development
  // androidProvider: FirebaseAppCheckAndroidProvider.debug,
  // iosProvider: FirebaseAppCheckIOSProvider.debug,
)
```

### Accessing the Adapter

Retrieve the adapter instance to access App Check functionality manually:

```dart
final adapter = FirebaseAppCheckMasamuneAdapter.primary;

// Access the FirebaseAppCheck instance
final appCheck = adapter.appCheck;

// Get the current App Check token
final token = await appCheck.getToken();
print("App Check token: $token");

// Get a limited-use token
final limitedUseToken = await appCheck.getLimitedUseToken();
```

### Troubleshooting

**Firebase Console Setup**:
1. Enable App Check in your Firebase project
2. Register your app for each platform (iOS, Android, Web)
3. Configure the appropriate provider for each platform

**Debug Mode**:

When using debug providers during development:

```dart
// Use debug providers in development
FirebaseAppCheckMasamuneAdapter(
  options: DefaultFirebaseOptions.currentPlatform,
  androidProvider: FirebaseAppCheckAndroidProvider.debug,
  iosProvider: FirebaseAppCheckIOSProvider.debug,
)
```

Then register your debug token in the Firebase Console:
- Run your app in debug mode
- Copy the debug token from the logs
- Add it to Firebase Console → App Check → Apps → Debug tokens

**Web Configuration**:

For web support, supply `webOptions` and configure reCAPTCHA v3:

```dart
FirebaseAppCheckMasamuneAdapter(
  options: DefaultFirebaseOptions.currentPlatform,
  webOptions: DefaultFirebaseOptions.web,
  webRecaptchaSiteKey: "YOUR_RECAPTCHA_SITE_KEY",
)
```

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)