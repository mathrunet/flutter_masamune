<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Force Updater</h1>
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

# Masamune Force Updater

## Usage

### Installation

Add the package to your project.

```bash
flutter pub add masamune_force_updater
```

Run `flutter pub get` when editing `pubspec.yaml` manually.

### Register the Adapter

Define the forced update rules in `ForceUpdaterMasamuneAdapter`. Each rule is represented by a `ForceUpdaterItem` that decides whether to show an update dialog and how to handle the action.

```dart
// lib/adapter.dart

/// Masamune adapters used across the app.
final masamuneAdapters = <MasamuneAdapter>[
  const UniversalMasamuneAdapter(),

  ForceUpdaterMasamuneAdapter(
    defaultUpdates: [
      ForceUpdaterItem(
        minimumVersion: "2.0.0",
        targetPlatforms: const [ForceUpdaterPlatform.iOS, ForceUpdaterPlatform.android],
        storeUri: Uri.parse("https://example.com/store"),
      ),
    ],
  ),
];
```

`ForceUpdaterItem` accepts conditions such as minimum version, target platforms, and a custom dialog builder (`onShowUpdateDialog`).

### Check for Updates

Call `checkUpdate` from your UI to evaluate update rules and display dialogs. Typically, call this in your app's initialization or splash screen.

**Basic Usage**:

```dart
class SplashPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final updater = ref.page.controller(ForceUpdater.query());
    
    // Check for updates when page is displayed
    ref.page.on(
      initOrUpdate: () {
        updater.checkUpdate(context);
      },
    );

    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
```

**Custom Update Dialog**:

Pass a custom list of `ForceUpdaterItem`s to override the default adapter configuration:

```dart
await updater.checkUpdate(
  context,
  items: [
    ForceUpdaterItem(
      minimumVersion: "3.0.0",
      targetPlatforms: const [
        ForceUpdaterPlatform.iOS,
        ForceUpdaterPlatform.android,
      ],
      storeUri: Uri.parse("https://apps.apple.com/app/id123456789"),
      onShowUpdateDialog: (context, ref) async {
        final confirmed = await showDialog<bool>(
          context: context,
          barrierDismissible: false,  // Force user to make a choice
          builder: (context) => AlertDialog(
            title: const Text("Update Required"),
            content: const Text(
              "A new version is available. Please update to continue using the app.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Later"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Update Now"),
              ),
            ],
          ),
        );
        
        if (confirmed == true) {
          await ref.update();  // Opens store URL
        } else {
          await ref.quit();    // Exits the app
        }
      },
    ),
  ],
);
```

### ForceUpdaterRef

Inside `onShowUpdateDialog`, use `ForceUpdaterRef` to trigger updates or exit the app:

- `ref.update()` executes the provided `onUpdate` callback (defaults to opening the store URI).
- `ref.quit()` closes the application via `SystemNavigator.pop()`.

### Version Comparison

`ForceUpdaterItem` compares semantic version strings. Ensure the current app version (from `PackageInfo`) matches the format you use in rules.

### Tips

- Combine with remote config or Firestore to download update rules dynamically, then pass them to `checkUpdate`.
- Localize dialog texts using `LocalizedValue<String>` or your app's localization approach.
- Test on all target platforms to confirm store URIs and dialog behavior.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)