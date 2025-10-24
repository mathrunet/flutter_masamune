<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune App Review</h1>
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

# Masamune App Review

## Usage

### Installation

Add the package to your project.

```bash
flutter pub add masamune_app_review
```

Run `flutter pub get` if you edited `pubspec.yaml` manually.

### Register the Adapter

Register `AppReviewMasamuneAdapter` before launching the application. Provide the store URLs that open as fallback when in-app review dialogs are unavailable.

```dart
// lib/adapter.dart

/// Masamune adapters used by the app.
final masamuneAdapters = <MasamuneAdapter>[
  const UniversalMasamuneAdapter(),

  const AppReviewMasamuneAdapter(
    // Android: Google Play Store URL (required for Android fallback)
    googlePlayStoreUrl: "https://play.google.com/store/apps/details?id=com.example.app",
    
    // iOS: App Store URL (required for iOS fallback)
    appStoreUrl: "https://apps.apple.com/app/id0000000000",
  ),
];
```

3. Use in your `main.dart`:

```dart
void main() {
  runMasamuneApp(
    appRef: appRef,
    masamuneAdapters: masamuneAdapters,
    (appRef, _) => MasamuneApp(
      appRef: appRef,
      home: HomePage(),
    ),
  );
}
```

The adapter registers itself in `MasamuneAdapterScope`, allowing access via `AppReviewMasamuneAdapter.primary`.

### Request a Review

Use the `AppReview` controller to trigger in-app review dialogs. If the platform cannot display the native dialog, the controller automatically falls back to launching the configured store URL.

**Basic Usage**:

```dart
class MyPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final appReview = ref.page.controller(AppReview.query());

    return ElevatedButton(
      onPressed: () async {
        await appReview.review();
      },
      child: const Text("Review this app"),
    );
  }
}
```

**Error Handling**:

`review()` throws exceptions when:
- Review is not supported on the platform (e.g., web)
- The store URL cannot be opened

Handle exceptions for custom fallback logic:

```dart
try {
  await appReview.review();
} catch (e) {
  debugPrint("Review failed: $e");
  // Show custom message to user
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Could not open review dialog")),
  );
}
```

### Advanced Usage

**Check Availability**: Check if native review is available before prompting:

```dart
import 'package:in_app_review/in_app_review.dart';

if (await InAppReview.instance.isAvailable()) {
  // Show review prompt UI
  showDialog(...);
} else {
  // Direct to store URL
  await appReview.review();
}
```

**Direct Store URLs**: Access store URLs directly for custom link building:

```dart
final adapter = AppReviewMasamuneAdapter.primary;
final iosUrl = adapter.appStoreUrl;
final androidUrl = adapter.googlePlayStoreUrl;

// Use in your custom UI or share dialog
```

**Analytics Integration**: Wrap review calls for tracking:

```dart
await appReview.review();
analytics.logEvent(name: "app_review_requested");
```

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)