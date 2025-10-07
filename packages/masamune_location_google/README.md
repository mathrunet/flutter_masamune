<p align="center">
  <a href="https://mathru.net">
    <img width="240px" src="https://raw.githubusercontent.com/mathrunet/flutter_masamune/master/.github/images/icon.png" alt="Masamune logo" style="border-radius: 32px"s><br/>
  </a>
  <h1 align="center">Masamune Location Google</h1>
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

# Masamune Location Google

## Usage

These packages provide a unified location stack:

- `masamune_location` – core abstractions, controllers, and runtime adapters
- `masamune_location_geocoding` – geocoding/ reverse geocoding via Cloud Functions
- `masamune_location_google` – Google Maps integration helpers

Install the packages you need.

```bash
flutter pub add masamune_location
flutter pub add masamune_location_geocoding
flutter pub add masamune_location_google
```

Run `flutter pub get` after editing `pubspec.yaml` manually.

### Register Adapters

Configure the adapters in your Masamune setup. The example below adds a mobile location adapter and geocoding adapter (which delegates to Cloud Functions).

```dart
// lib/adapter.dart

/// Masamune adapters used in the application.
final masamuneAdapters = <MasamuneAdapter>[
  const UniversalMasamuneAdapter(),
  const FunctionsMasamuneAdapter(),

  MobileLocationMasamuneAdapter(
    requestWhenInUsePermissionOnInit: true,
    locationAccuracy: LocationAccuracy.high,
  ),

  GeocodingMasamuneAdapter(
    functionsAdapter: const FunctionsMasamuneAdapter(),
  ),
];
```

`MobileLocationMasamuneAdapter` provides real device GPS access, while `GeocodingMasamuneAdapter` calls server-side geocoding endpoints.

### Request Permissions and Fetch Location

Use the `Location` controller to fetch the current position or listen for updates.

```dart
final location = ref.app.controller(Location.query());

await location.initialize();

final position = await location.getCurrentPosition();
debugPrint("Location: ${position.latitude}, ${position.longitude}");

location.addListener(() {
  final latest = location.value;
  if (latest != null) {
    debugPrint("Updated: ${latest.latitude}, ${latest.longitude}");
  }
});

await location.startListening(
  distanceFilter: 50,
  timeInterval: const Duration(seconds: 30),
);
```

`startListening` streams continuous updates; call `stopListening()` when no longer needed.

### Handle Permissions

Use the adapter helpers to request permissions and open app settings when required.

```dart
final permissionStatus = await location.requestPermission();
if (!permissionStatus.granted) {
  await openAppSettings();
}
```

### Geocoding

`GeocodingMasamuneAdapter` exposes Functions actions to convert between coordinates and addresses.

```dart
final geocoding = GeocodingMasamuneAdapter.primary;

final address = await geocoding.fromLatLng(
  latitude: position.latitude,
  longitude: position.longitude,
);

final coordinates = await geocoding.fromAddress("Tokyo Station");
```

Implement the corresponding Firebase Function (or REST endpoint) to call external geocoding APIs such as Google Maps Geocoding.

### Google Maps Helpers

`masamune_location_google` provides utilities to integrate with Google Maps SDKs, such as map controllers, markers, and place lookups. Register adapters from that package if you need Google-specific features.

### Mocking and Testing

- Use `MockLocationMasamuneAdapter` for widget tests or environments without GPS access.
- Inject mock adapters during development to simulate location updates or geocoding responses.

### Tips

- Handle platform permissions carefully: Android 12+ requires approximate/precise location toggles, iOS may need `NSLocationAlwaysUsageDescription` strings.
- Cache last known locations to reduce sensor usage and provide instant UI feedback.
- Respect user privacy by communicating why location data is collected and storing it securely.
- Combine with `masamune_scheduler` to trigger location-based reminders or geofencing workflows.

# GitHub Sponsors

Sponsors are always welcome. Thank you for your support!

[https://github.com/sponsors/mathrunet](https://github.com/sponsors/mathrunet)