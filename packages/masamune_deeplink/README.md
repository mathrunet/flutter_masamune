<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Deeplink</h1>
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

# Masamune Deeplink

## Usage

### Installation

Add the package to your project.

```bash
flutter pub add masamune_deeplink
```

Run `flutter pub get` when editing `pubspec.yaml` manually.

### Register the Adapter

Add `DeepLinkMasamuneAdapter` to your adapter list. Configure supported URI schemes in your platform projects (iOS `Info.plist`, Android `AndroidManifest.xml`).

```dart
// lib/adapter.dart

/// Masamune adapters used by the application.
final masamuneAdapters = <MasamuneAdapter>[
  const UniversalMasamuneAdapter(),

  DeepLinkMasamuneAdapter(
    enableLogging: true,
    loggerAdapters: [FirebaseLoggerAdapter()],
  ),
];
```

### Handle Deep Links

Use the `DeepLink` controller to listen for incoming URIs and route users accordingly.

```dart
final deepLink = ref.app.controller(DeepLink.query());

deepLink.addListener(() {
  final uri = deepLink.value;
  if (uri == null) {
    return;
  }
  router.pushNamed(uri.path, queryParams: uri.queryParameters);
});

await deepLink.initialize();
```

### Initial Link vs. Stream

- `deepLink.value` holds the latest URI.
- `deepLink.initialLink` returns the URI used to launch the app.
- `deepLink.uriStream` emits new links while the app is running.

### Logging

Enable logging (`enableLogging: true`) and supply `loggerAdapters` to capture `DeepLinkLoggerEvent`s for analytics.

### Tips

- Configure universal links/app links to support both custom schemes and HTTPS URLs.
- Validate incoming URIs to avoid navigating to unexpected destinations.
- Combine with Masamune Router to generate strongly typed routes.
- Test deep links on both cold start and warm state scenarios.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)