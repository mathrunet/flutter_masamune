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

Register the `AppReviewMasamuneAdapter` before launching the application. Provide the store URLs that should open when in-app review dialogs are unavailable.

```dart
// lib/adapter.dart

/// Masamune adapters used by the app.
final masamuneAdapters = <MasamuneAdapter>[
  const UniversalMasamuneAdapter(),

  const AppReviewMasamuneAdapter(
    googlePlayStoreUrl: "https://play.google.com/store/apps/details?id=com.example.app",
    appStoreUrl: "https://apps.apple.com/app/id0000000000",
  ),
];
```

The adapter registers itself in `MasamuneAdapterScope`, allowing access via `AppReviewMasamuneAdapter.primary`.

### Request a Review

Use the `AppReview` controller to trigger in-app review dialogs. If the platform cannot display the native dialog, the controller falls back to launching the store URL.

```dart
final appReview = ref.page.controller(AppReview.query());

await appReview.review();
```

`review()` throws when review is not supported (for example, on web) or when the URL cannot be opened. Handle exceptions if you need custom fallback logic.

### Advanced Usage

- Use `adapter.googlePlayStoreUrl` / `adapter.appStoreUrl` directly when you need to build custom links.
- Combine with analytics or logging by wrapping `review()` in your own service layer.
- Call `InAppReview.instance.isAvailable()` beforehand if you want to show UI prompts explaining the review flow.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)