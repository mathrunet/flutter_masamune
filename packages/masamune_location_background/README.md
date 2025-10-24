<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Location Background</h1>
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

# Masamune Location Background

## Overview

`masamune_location_background` enables background location tracking for Masamune apps. Continue receiving location updates even when the app is in the background or terminated.

**Note**: Requires `masamune_location` for core location functionality.

## Usage

### Installation

```bash
flutter pub add masamune_location
flutter pub add masamune_location_background
```

### Register the Adapter

Configure `BackgroundLocationMasamuneAdapter` to enable background tracking.

```dart
// lib/adapter.dart

import 'package:masamune_location_background/masamune_location_background.dart';

/// Masamune adapters used in the application.
final masamuneAdapters = <MasamuneAdapter>[
  const UniversalMasamuneAdapter(),

  BackgroundLocationMasamuneAdapter(
    androidNotificationSettings: BackgroundLocationAndroidNotificationSettings(
      channelId: "location_tracking",
      channelName: "Location Tracking",
      notificationTitle: "Tracking your location",
      notificationText: "Location updates are enabled",
    ),
    requestWhenInUsePermissionOnInit: true,
    locationAccuracy: LocationAccuracy.high,
  ),
];
```

### Start Background Tracking

Use `BackgroundLocation` controller to manage background location updates:

```dart
class TrackingPage extends PageScopedWidget {
  @override
  Widget build(BuildContext context, PageRef ref) {
    final backgroundLocation = ref.app.controller(
      BackgroundLocation.query(),
    );

    return ElevatedButton(
      onPressed: () async {
        // Start background tracking
        await backgroundLocation.start(
          distanceFilter: 100,  // Update every 100 meters
          timeInterval: Duration(minutes: 5),  // Or every 5 minutes
          onLocationUpdate: (position) {
            // Handle location update
            print("Background update: ${position.latitude}, ${position.longitude}");
            
            // Save to database, send to server, etc.
          },
        );
      },
      child: const Text("Start Tracking"),
    );
  }
}
```

### Stop Background Tracking

```dart
await backgroundLocation.stop();
```

### Platform Configuration

**Android**: Background location requires a foreground service notification.

```xml
<!-- AndroidManifest.xml -->
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
<uses-permission android:name="android.permission.FOREGROUND_SERVICE_LOCATION" />
```

**iOS**: Add background modes and location usage descriptions.

```xml
<!-- Info.plist -->
<key>UIBackgroundModes</key>
<array>
    <string>location</string>
</array>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>We need your location for tracking</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>We need your location</string>
```

### Tips

- Request "Always" permission for background tracking
- Be transparent with users about why background tracking is needed
- Minimize battery impact by adjusting distance/time filters
- Consider stopping tracking when battery is low
- Test thoroughly on real devices in various scenarios

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)