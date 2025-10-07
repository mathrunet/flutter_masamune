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

Configure Firebase App Check before bootstrapping your Masamune app. Provide Firebase options and choose the activation timing.

```dart
// lib/adapter.dart

/// Masamune adapters used by the application.
final masamuneAdapters = <MasamuneAdapter>[
  const UniversalMasamuneAdapter(),

  FirebaseAppCheckMasamuneAdapter(
    options: const FirebaseOptions(
      apiKey: "YOUR_API_KEY",
      appId: "YOUR_APP_ID",
      messagingSenderId: "YOUR_SENDER_ID",
      projectId: "YOUR_PROJECT_ID",
    ),
    activateTiming: FirebaseAppCheckActivateTiming.onPreRunApp,
    androidProvider: FirebaseAppCheckAndroidProvider.playIntegrity,
    iosProvider: FirebaseAppCheckIOSProvider.deviceCheck,
  ),
];
```

You can supply platform-specific options (`iosOptions`, `androidOptions`, etc.) if the defaults differ across platforms.

### Activation Timing

`activateTiming` controls when `FirebaseAppCheck.activate()` runs:

- `onPreRunApp` (default) activates before `runApp`
- `onBoot` activates during `onMaybeBoot`

Pick the timing that matches your initialization flow. The adapter automatically calls `FirebaseCore.initialize` with the provided options.

### Providers

Select the provider for each platform:

- Android: `debug`, `playIntegrity`, or `platformDependent`
- iOS/macOS: `debug`, `deviceCheck`, `appAttest`, or `platformDependent`

Debug providers fetch a token to register the device automatically when running in debug mode. Customize by setting `androidProvider` / `iosProvider`.

### Accessing the Adapter

Retrieve the adapter instance via `FirebaseAppCheckMasamuneAdapter.primary` when you need to call `appCheck.activate` manually or to access tokens.

```dart
final appCheck = FirebaseAppCheckMasamuneAdapter.primary.appCheck;
final token = await appCheck.getToken();
```

### Troubleshooting

- Ensure Firebase project settings include App Check for each platform.
- When using debug providers, enable debug mode on the device according to Firebase App Check documentation.
- For web, supply `webOptions` and configure reCAPTCHA or other supported provider.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)