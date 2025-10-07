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

Use the `Deeplink` controller to listen for incoming URIs and route users accordingly.

```dart
final deeplink = ref.app.controller(Deeplink.query());

deeplink.addListener(() {
  final uri = deeplink.value;
  if (uri == null) {
    return;
  }
  // Navigate to the appropriate page based on the URI
  router.pushNamed(uri.path, queryParameters: uri.queryParameters);
});

// Start listening for deep links
await deeplink.listen();
```

### Initial Link vs. Stream

- `deeplink.value` holds the latest URI received.
- The initial link (used to launch the app) is automatically handled when you call `listen()`.
- New links received while the app is running trigger the `addListener` callback automatically.

### Logging

Enable logging to track deep link events for analytics:

```dart
DeeplinkMasamuneAdapter(
  enableLogging: true,
  loggerAdapters: [FirebaseLoggerAdapter()],  // Or your custom logger
)
```

The adapter captures `DeeplinkLoggerEvent` with details about received links.

### Advanced Usage

**Custom Link Handling**:

```dart
await deeplink.listen(
  onLink: (uri, onOpenedApp) async {
    if (onOpenedApp) {
      // Link was used to open the app (cold start)
      print("App opened with: $uri");
    } else {
      // Link received while app was running
      print("Received while running: $uri");
    }
    // Perform custom routing or validation
    await handleCustomRoute(uri);
  },
);
```

### Platform Configuration

**iOS (Info.plist)**:

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>myapp</string>
    </array>
  </dict>
</array>
```

**Android (AndroidManifest.xml)**:

```xml
<intent-filter>
  <action android:name="android.intent.action.VIEW" />
  <category android:name="android.intent.category.DEFAULT" />
  <category android:name="android.intent.category.BROWSABLE" />
  <data android:scheme="myapp" />
</intent-filter>
```

### Tips

- Configure universal links (iOS) / app links (Android) to support both custom schemes and HTTPS URLs.
- Always validate incoming URIs before navigation to prevent security issues.
- Combine with Masamune Router for type-safe route generation.
- Test deep links on both cold start (app not running) and warm state (app in background) scenarios.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)